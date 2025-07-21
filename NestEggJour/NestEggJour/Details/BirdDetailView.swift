import SwiftUI

struct BirdDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var birdsManager: BirdsManager
    var bird: Bird
    
    var body: some View {
        ZStack {
            Image(.backImg)
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(.backNavButton)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    Spacer()
                    Text(bird.name)
                        .font(FontFamily.PlayfairDisplay.extraBoldItalic.swiftUIFont(size: 36))
                        .foregroundColor(.appBrown)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Circle()
                        .foregroundColor(.clear)
                        .frame(width: 40, height: 40)
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Bird Image
                        Image(bird.image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Region Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Region")
                                    .font(.headline)
                                    .foregroundColor(.appBrown)
                                
                                Text(bird.region)
                                    .font(.body)
                                    .foregroundColor(.appBrown)
                            }
                            
                            // Behavior Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Behavior")
                                    .font(.headline)
                                    .foregroundColor(.appBrown)
                                
                                Text(bird.behavior)
                                    .font(.body)
                                    .foregroundColor(.appBrown)
                            }
                            
                            // Appearance Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Appearance")
                                    .font(.headline)
                                    .foregroundColor(.appBrown)
                                
                                Text(bird.appearance)
                                    .font(.body)
                                    .foregroundColor(.appBrown)
                            }
                            
                            // Eggs Info Card
                            VStack(spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Eggs")
                                            .font(.headline)
                                            .foregroundColor(.appBrown)
                                        
                                        Text(bird.eggInfo.color)
                                            .font(.body)
                                            .foregroundColor(.appBrown)
                                    }
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Laying")
                                            .font(.headline)
                                            .foregroundColor(.appBrown)
                                        
                                        Text(bird.eggInfo.clutchSize)
                                            .font(.body)
                                            .foregroundColor(.appBrown)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(20)
                            .background(Color.appLight)
                            .cornerRadius(15)
                            
                            // Action Buttons
                            HStack(spacing: 15) {
                                Button(action: {
                                    birdsManager.toggleStudied(bird: bird)
                                }) {
                                    Text("Studied")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundColor(birdsManager.isStudied(bird: bird) ? .white : .appBrown)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(birdsManager.isStudied(bird: bird) ? Color.appBrown : Color.appLight)
                                        .cornerRadius(25)
                                }
                                
                                Button(action: {
                                    birdsManager.toggleFavourite(bird: bird)
                                }) {
                                    Text("Favourites")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundColor(birdsManager.isFavourite(bird: bird) ? .white : .appBrown)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(birdsManager.isFavourite(bird: bird) ? Color.appBrown : Color.appLight)
                                        .cornerRadius(25)
                                }
                            }
                            
                            // Notes Section
                            if !bird.notes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(bird.notes)
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding(16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.appBrown.opacity(0.8))
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.appLight, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    BirdDetailView(birdsManager: BirdsManager(), bird: Bird(name: "Zaryanka", region: "Test", behavior: "Test", appearance: "Test", eggInfo: EggInfo(shape: "Test", color: "Test", clutchSize: "4-6 eggs"), image: "image_1", notes: "Test"))
}
