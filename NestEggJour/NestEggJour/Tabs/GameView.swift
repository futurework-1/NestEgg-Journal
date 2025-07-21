import SwiftUI

struct GameView: View {
    var body: some View {
        ZStack {
            Image(.backImg)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Find a pair of eggs")
                    .font(FontFamily.PlayfairDisplay.extraBoldItalic.swiftUIFont(size: 40))
                    .foregroundColor(.appBrown)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                Spacer()
                NavigationLink {
                    GamePlayView()
                } label: {
                    Image(.startButton)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    GameView()
}
