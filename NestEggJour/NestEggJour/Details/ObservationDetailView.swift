import SwiftUI

struct ObservationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var observationsManager: ObservationsManager
    var observation: Observation
    
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
                    Text(observation.title)
                        .font(FontFamily.PlayfairDisplay.extraBoldItalic.swiftUIFont(size: 36))
                        .foregroundColor(.appBrown)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Circle()
                        .foregroundColor(.clear)
                        .frame(width: 40, height: 40)
                }
                
                ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.headline)
                                    .foregroundColor(.appBrown)
                                
                                Text(observation.date)
                                    .font(.body)
                                    .foregroundColor(.appBrown)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Location")
                                    .font(.headline)
                                    .foregroundColor(.appBrown)
                                
                                Text(observation.location)
                                    .font(.body)
                                    .foregroundColor(.appBrown)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Coordinates")
                                    .font(.headline)
                                    .foregroundColor(.appBrown)
                                
                                Text(observation.coordinates)
                                    .font(.body)
                                    .foregroundColor(.appBrown)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline)
                                    .foregroundColor(.appBrown)
                                
                                Text(observation.description)
                                    .font(.body)
                                    .foregroundColor(.appBrown)
                            }
                            
                            Image(observation.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 250)
                            Spacer()
                            // Action Buttons
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        observationsManager.toggleSawBird(observation: observation)
                                    }) {
                                        Text("Saw a bird")
                                            .font(FontFamily.PlayfairDisplay.bold.swiftUIFont(size: 18))
                                            .fontWeight(.semibold)
                                            .foregroundColor(observationsManager.didSawBird(observation: observation) ? .white : .appBrown)
                                            .padding(10)
                                            .background(observationsManager.didSawBird(observation: observation) ? Color.appBrown : Color.appLight)
                                            .cornerRadius(25)
                                    }
                                    
                                    Button(action: {
                                        observationsManager.toggleFoundEgg(observation: observation)
                                    }) {
                                        Text("Found an egg")
                                            .font(FontFamily.PlayfairDisplay.bold.swiftUIFont(size: 18))
                                            .fontWeight(.semibold)
                                            .foregroundColor(observationsManager.didFoundEgg(observation: observation) ? .white : .appBrown)
                                            .padding(10)
                                            .background(observationsManager.didFoundEgg(observation: observation) ? Color.appBrown : Color.appLight)
                                            .cornerRadius(25)
                                    }
                                    Spacer()
                                }
                                Button(action: {
                                    observationsManager.toggleWatchedNest(observation: observation)
                                }) {
                                    Text("Watched the nest")
                                        .font(FontFamily.PlayfairDisplay.bold.swiftUIFont(size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundColor(observationsManager.didWatchedNest(observation: observation) ? .white : .appBrown)
                                        .padding(10)
                                        .background(observationsManager.didWatchedNest(observation: observation) ? Color.appBrown : Color.appLight)
                                        .cornerRadius(25)
                                }
                            }
                            
                          
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
    ObservationDetailView(observationsManager: ObservationsManager(), observation: Observation(title: "Test", location: "Test", coordinates: "Test", date: "Test", image: "image_11", description: "Test"))
}
