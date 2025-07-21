import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let imageName: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
}

struct GamePlayView: View {
    @State private var cards: [Card] = []
    @State private var flippedCards: [Card] = []
    @State private var gameStarted: Bool = false
    @State private var timeElapsed: Int = 0
    @State private var timer: Timer?
    @State private var matchedPairs: Int = 0
    @State private var movesCount: Int = 0
    @State private var showGameOver: Bool = false
    @State private var showResults: Bool = false
    @State private var gameScore: Int = 0
    @State private var bestScore: Int = 0
    @State private var bestPairs: Int = 0
    @State private var bestMoves: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    private let cardImages = ["eggCard1", "eggCard2", "eggCard3", "eggCard4", "eggCard5", "eggCard6"]
    
    var body: some View {
        ZStack {
            // Main game view
            if !showResults {
                ZStack {
                    Image(.backImg)
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        // Timer
                        VStack(spacing: 5) {
                            Text(timeString(from: timeElapsed))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.appBrown)
                        }
                        .padding(.top, 30)
                        
                        // Game Grid with brown background
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                            ForEach(cards) { card in
                                CardView(card: card, gameStarted: gameStarted) {
                                    cardTapped(card)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.appBrownGame)

                        )
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Score counters
                        VStack(spacing: 10) {
                            HStack(spacing: 8) {
                                Image(.eggScore)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("\(matchedPairs)")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(.yellow)
                            }
                            
                            HStack(spacing: 8) {
                                Image(.moveScore)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("\(movesCount)")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(.white)

                            }
                        }
                        
                        Spacer()
                        
                        // Start Button
                        if !gameStarted {
                            Button(action: startGame) {
                                Text("START")
                                    .font(FontFamily.PlayfairDisplay.bold.swiftUIFont(size: 24))
                                    .foregroundColor(.appBrown)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.appLight)
                                    .cornerRadius(40)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                    }
                    
                    // Game Over overlay
                    if showGameOver {
                        Text("GAME OVER")
                            .font(FontFamily.PlayfairDisplay.bold.swiftUIFont(size: 32))
                            .foregroundColor(.yellow)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 30)
                            .background(.black)
                            .cornerRadius(30)
                    }
                }
            } else {
                // Results Screen (full screen)
                ZStack {
                    Image(.backImg)
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack(spacing: 10) {
                        Text("YOU SCORED")
                            .font(.custom("PlayfairDisplay-Bold", size: 36))
                            .foregroundColor(.appBrown)
                            .padding(.top, 80)
                        
                        Text("\(gameScore)/3")
                            .font(.custom("PlayfairDisplay-Bold", size: 64))
                            .foregroundColor(.appBrown)
                            .padding()
                            .frame(width: 180)
                            .background(
                                Capsule()
                                    .fill(.appLight)
                            )
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("RECORD:")
                                .font(.custom("PlayfairDisplay-Bold", size: 24))
                                .foregroundColor(.appBrown)
                            
                            Text("Pairs: \(matchedPairs)")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 22))
                                .foregroundColor(.appBrown)
                            
                            Text("Moves: \(movesCount)")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 22))
                                .foregroundColor(.appBrown)
                        }
                        .padding(.top, 20)
                        
                        // Show best score if exists
                        if bestScore > 0 {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("BEST SCORE: \(bestScore)/3")
                                    .font(.custom("PlayfairDisplay-Bold", size: 24))
                                    .foregroundColor(.appBrown)
                                
                                Text("Pairs: \(bestPairs) • Moves: \(bestMoves)")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                    .foregroundColor(.appBrown)
                            }
                            .padding(.top, 20)
                        }
                        
                        Spacer()
                        
                        // Try Again button
                        Button(action: {
                            setupGame()
                            showResults = false
                        }) {
                            Text("TRY AGAIN")
                                .font(FontFamily.PlayfairDisplay.bold.swiftUIFont(size: 24))
                                .foregroundColor(.appBrown)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.appLight)
                                .cornerRadius(40)
                        }
                        .padding(.horizontal)
                        
                        // Leave button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("LEAVE")
                                .font(FontFamily.PlayfairDisplay.bold.swiftUIFont(size: 24))
                                .foregroundColor(.appLight)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(.gray)
                                .cornerRadius(40)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadBestScore()
            setupGame()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func setupGame() {
        cards = []
        flippedCards = []
        gameStarted = false
        timeElapsed = 0
        matchedPairs = 0
        movesCount = 0
        showGameOver = false
        showResults = false
        
        // Create pairs of cards
        var gameCards: [Card] = []
        for imageName in cardImages {
            gameCards.append(Card(imageName: imageName))
            gameCards.append(Card(imageName: imageName))
        }
        
        // Shuffle cards
        cards = gameCards.shuffled()
    }
    
    private func startGame() {
        gameStarted = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeElapsed < 60 {
                timeElapsed += 1
            } else {
                endGame()
            }
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        gameStarted = false
        
        // Calculate score based on pairs found and moves made
        calculateScore()
        
        // Save best score if current score is better
        saveBestScore()
        
        // Show Game Over for 2 seconds
        withAnimation {
            showGameOver = true
        }
        
        // Then show results screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showGameOver = false
                showResults = true
            }
        }
    }
    
    private func calculateScore() {
        // Score calculation: 
        // - 3/3 for finding all pairs with minimal moves
        // - 2/3 for finding all pairs but with more moves
        // - 1/3 for finding some pairs
        
        if matchedPairs == cardImages.count {
            if movesCount <= 15 {
                gameScore = 3
            } else {
                gameScore = 2
            }
        } else if matchedPairs >= cardImages.count / 2 {
            gameScore = 1
        } else {
            gameScore = 0
        }
    }
    
    private func loadBestScore() {
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        bestPairs = UserDefaults.standard.integer(forKey: "bestPairs")
        bestMoves = UserDefaults.standard.integer(forKey: "bestMoves")
        
        // If bestMoves is 0 (never set), set it to a high value for comparison
        if bestMoves == 0 {
            bestMoves = 999
        }
    }
    
    private func saveBestScore() {
        let isBetterScore = gameScore > bestScore
        let isSameScoreButBetterMoves = gameScore == bestScore && movesCount < bestMoves
        
        if isBetterScore || isSameScoreButBetterMoves {
            // Save new best score
            UserDefaults.standard.set(gameScore, forKey: "bestScore")
            UserDefaults.standard.set(matchedPairs, forKey: "bestPairs")
            UserDefaults.standard.set(movesCount, forKey: "bestMoves")
            
            // Update current values
            bestScore = gameScore
            bestPairs = matchedPairs
            bestMoves = movesCount
        }
    }
    
    private func cardTapped(_ card: Card) {
        // Block card taps until game starts
        guard gameStarted && !card.isFlipped && !card.isMatched else { return }
        
        // Increment moves count
        movesCount += 1
        
        // Flip card
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index].isFlipped = true
            flippedCards.append(cards[index])
        }
        
        // Check for match when 2 cards are flipped
        if flippedCards.count == 2 {
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        guard flippedCards.count == 2 else { return }
        
        let firstCard = flippedCards[0]
        let secondCard = flippedCards[1]
        
        if firstCard.imageName == secondCard.imageName {
            // Match found
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for card in flippedCards {
                    if let index = cards.firstIndex(where: { $0.id == card.id }) {
                        cards[index].isMatched = true
                    }
                }
                matchedPairs += 1
                flippedCards.removeAll()
                
                // Check if game is won
                if matchedPairs == cardImages.count {
                    endGame()
                }
            }
        } else {
            // No match - flip back
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for card in flippedCards {
                    if let index = cards.firstIndex(where: { $0.id == card.id }) {
                        cards[index].isFlipped = false
                    }
                }
                flippedCards.removeAll()
            }
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct CardView: View {
    let card: Card
    let gameStarted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if card.isMatched {
                    // Empty space for matched cards
                    Color.clear
                        .frame(height: 80)
                } else {
                    // Card with flip animation
                    ZStack {
                        if card.isFlipped {
                            // Front of card - show egg image
                            Image(card.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                        } else {
                            // Back of card - show upCard
                            Image(.upCard)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                        }
                    }
                    .rotation3DEffect(
                        .degrees(card.isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.6), value: card.isFlipped)
                }
            }
        }
        .disabled(!gameStarted || card.isFlipped || card.isMatched)
        .animation(.easeInOut(duration: 0.5), value: card.isMatched)
        .animation(.easeInOut(duration: 0.3), value: gameStarted)
    }
}

#Preview {
    GamePlayView()
}
