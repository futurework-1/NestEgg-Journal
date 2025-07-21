import SwiftUI

struct SettingsView: View {
    @State var notificationsOn: Bool = true
    @StateObject private var observationsManager = ObservationsManager()
    
    var body: some View {
        ZStack {
            Image(.backImg)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Encyclopedia of Birds and Eggs")
                    .font(FontFamily.PlayfairDisplay.extraBoldItalic.swiftUIFont(size: 40))
                    .foregroundColor(.appBrown)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                NavigationLink {
                    SettingDetailsView(observationsManager: observationsManager, type: .units)
                } label: {
                    Text("Unit control")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.appBrown)
                }
                
                HStack {
                    Text("Notifications")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.appBrown)
                    
                    Toggle("", isOn: $notificationsOn)
                        .labelsHidden()
                }
                
                NavigationLink {
                    SettingDetailsView(observationsManager: observationsManager, type: .data)
                } label: {
                    Text("Data")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.appBrown)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SettingsView()
}

enum SettingsType: String {
    case units = "Unit control"
    case data = "Data"
}
