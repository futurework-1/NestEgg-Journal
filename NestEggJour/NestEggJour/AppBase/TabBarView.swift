import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                switch selectedTab {
                case 0:
                    EncyclopediaView()
                case 1:
                    ObservationsView()
                case 2:
                    GameView()
                case 3:
                    SettingsView()
                default:
                    EmptyView()
                }
                
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<4) { index in
                TabBarButton(
                    isSelected: selectedTab == index,
                    imageName: getImageName(for: index, isSelected: selectedTab == index),
                    action: { selectedTab = index }
                )
                .padding(.top)
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color(hex:"4B2200"))
    }
    
    private func getImageName(for index: Int, isSelected: Bool) -> String {
        let tabNumber = index + 1
        return isSelected ? "tab\(tabNumber)s" : "tab\(tabNumber)"
    }
}

struct TabBarButton: View {
    let isSelected: Bool
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 42)
        }
    }
}

#Preview {
    TabBarView()
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let red, green, blue, alpha: Double
        
        switch hex.count {
        case 3:
            red = Double((int >> 8) & 0xF) / 15.0
            green = Double((int >> 4) & 0xF) / 15.0
            blue = Double(int & 0xF) / 15.0
            alpha = 1.0
        case 6:
            red = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >> 8) & 0xFF) / 255.0
            blue = Double(int & 0xFF) / 255.0
            alpha = 1.0
        case 8:
            red = Double((int >> 24) & 0xFF) / 255.0
            green = Double((int >> 16) & 0xFF) / 255.0
            blue = Double((int >> 8) & 0xFF) / 255.0
            alpha = Double(int & 0xFF) / 255.0
        default:
            self.init(.black)
            return
        }
        
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}
