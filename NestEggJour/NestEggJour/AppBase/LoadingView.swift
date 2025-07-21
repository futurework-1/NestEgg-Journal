import SwiftUI

struct LoadingView: View {
    @State private var showTabBar = false
    
    var body: some View {
        if showTabBar {
            TabBarView()
                .transition(.opacity)
        } else {
            Image(.loadingPage)
                .resizable()
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showTabBar = true
                        }
                    }
                }
        }
    }
}
#Preview {
    LoadingView()
}
