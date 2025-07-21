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
        .background(Color("appBrown").opacity(0.8))
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
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    TabBarView()
}
