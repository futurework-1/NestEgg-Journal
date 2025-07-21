import SwiftUI

struct EncyclopediaView: View {
    @StateObject private var birdsManager = BirdsManager()
    @State private var selectedArea = "All"
    @State private var selectedSize = "All"
    @State private var selectedPlace = "All"
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    // Filter options
    private let areaOptions = ["All", "Europe", "Asia", "North America", "Eurasia"]
    private let sizeOptions = ["All", "Tiny", "Small", "Medium", "Large"]
    private let placeOptions = ["All", "Forest", "Coast", "Field", "Garden", "Water"]
    
    // Filtered birds
    private var filteredBirds: [Bird] {
        birdsManager.birds.filter { bird in
            let matchesArea = selectedArea == "All" || bird.region.contains(selectedArea)
            let matchesSize = selectedSize == "All" || getBirdSize(bird).contains(selectedSize.lowercased())
            let matchesPlace = selectedPlace == "All" || getBirdPlace(bird).contains(selectedPlace.lowercased())
            
            return matchesArea && matchesSize && matchesPlace
        }
    }
    
    var body: some View {
        ZStack {
            Image(.backImg)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Encyclopedia of Birds and Eggs")
                    .font(FontFamily.PlayfairDisplay.extraBoldItalic.swiftUIFont(size: 40))
                    .foregroundColor(.appBrown)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 10) {

                    Menu {
                        ForEach(areaOptions, id: \.self) { area in
                            Button(area) {
                                selectedArea = area
                            }
                        }

                    } label: {
                        HStack {
                            Text(selectedArea)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.appBrown)
                                .font(.caption)
                        }
                        .foregroundColor(.appBrown)
                        .padding(8)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    
                    // Size Filter
                    Menu {
                        ForEach(sizeOptions, id: \.self) { size in
                            Button(size) {
                                selectedSize = size
                            }
                        }

                    } label: {
                        HStack {
                            Text(selectedSize)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.appBrown)
                                .font(.caption)
                        }
                        .foregroundColor(.appBrown)
                        .padding(8)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    
                    // Place Filter
                    Menu {
                        ForEach(placeOptions, id: \.self) { place in
                            Button(place) {
                                selectedPlace = place
                            }
                        }

                    } label: {
                        HStack {
                            Text(selectedPlace)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.appBrown)
                                .font(.caption)
                        }
                        .foregroundColor(.appBrown)
                        .padding(8)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                    
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(filteredBirds) { bird in
                            BirdCardView(bird: bird, birdsManager: birdsManager)
                        }
                    }
                }
                .padding(.bottom, 80)
            }
            .padding(.horizontal)
        }
    }
    
    // Helper functions for filtering
    private func getBirdSize(_ bird: Bird) -> String {
        let appearance = bird.appearance.lowercased()
        let behavior = bird.behavior.lowercased()
        let name = bird.name.lowercased()
        
        // Tiny birds - самые маленькие
        if appearance.contains("tiny") {
            return "tiny"
        }
        
        // Small birds - маленькие
        if appearance.contains("small") || behavior.contains("small size") {
            return "small"
        }
        
        // Large birds - большие
        if appearance.contains("large") || name.contains("great") {
            return "large"
        }
        
        // Medium birds - средние (по умолчанию)
        return "medium"
    }
    
    private func getBirdPlace(_ bird: Bird) -> String {
        let region = bird.region.lowercased()
        let behavior = bird.behavior.lowercased()
        
        var places: [String] = []
        
        if region.contains("forest") || behavior.contains("forest") {
            places.append("forest")
        }
        if region.contains("coast") || behavior.contains("coast") {
            places.append("coast")
        }
        if region.contains("field") || region.contains("meadow") {
            places.append("field")
        }
        if region.contains("garden") {
            places.append("garden")
        }
        if region.contains("water") || behavior.contains("water") {
            places.append("water")
        }
        
        return places.joined(separator: " ")
    }
}

struct BirdCardView: View {
    let bird: Bird
    let birdsManager: BirdsManager
    
    var body: some View {
        NavigationLink(destination: BirdDetailView(birdsManager: birdsManager, bird: bird)) {
            Image(bird.image)
                .resizable()
                .scaledToFill()
                .overlay( Text(bird.name)
                    .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .lineLimit(2)
                    .background(Color.black.opacity(0.4)),
                          alignment: .bottom
                  
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 2)
                )
                .cornerRadius(20)
        }
    }
}

#Preview {
    EncyclopediaView()
}
