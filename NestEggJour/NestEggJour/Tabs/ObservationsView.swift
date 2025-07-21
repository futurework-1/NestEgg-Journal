import SwiftUI

struct ObservationsView: View {
    @StateObject private var observationsManager = ObservationsManager()
    
    var body: some View {
        ZStack {
            Image(.backImg)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Personal observations")
                    .font(FontFamily.PlayfairDisplay.extraBoldItalic.swiftUIFont(size: 40))
                    .foregroundColor(.appBrown)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                ScrollView {
                    LazyVStack(spacing: 30) {
                        ForEach(observationsManager.observations) { observation in
                            ObservationRowView(observation: observation, observationsManager: observationsManager)
                        }
                    }
                }
                .padding(.vertical)
                
                NavigationLink(destination: AddObservationView(observationsManager: observationsManager)) {
                    Text("New note")
                        .font(FontFamily.PlayfairDisplay.bold.swiftUIFont(size: 24))
                        .foregroundColor(.appBrown)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.appLight)
                        .cornerRadius(25)
                }
                .padding(.bottom, 100)
            }
            .padding(.horizontal)
        }
    }
}

struct ObservationRowView: View {
    let observation: Observation
    let observationsManager: ObservationsManager
    
    var body: some View {
        NavigationLink(destination: ObservationDetailView(
            observationsManager: observationsManager,
            observation: observation)
        ) {
            Text(observation.title)
                .font(FontFamily.PlayfairDisplay.semiBold.swiftUIFont(size: 18))
                .foregroundColor(.appBrown)
        }
    }
}

#Preview {
    ObservationsView()
}
