import Foundation

class BirdsManager: ObservableObject {
    @Published var birds: [Bird] = []
    @Published var studiedBirds: Set<String> = []
    @Published var favouriteBirds: Set<String> = []
    
    init() {
        loadBirds()
        loadStudiedBirds()
        loadFavouriteBirds()
    }
    
    private func loadBirds() {
        guard let url = Bundle.main.url(forResource: "encyclopedia", withExtension: "json") else {
            print("Could not find encyclopedia.json file")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedBirds = try JSONDecoder().decode([Bird].self, from: data)
            self.birds = decodedBirds
        } catch {
            print("Error loading birds data: \(error)")
        }
    }
    
    // MARK: - Studied Birds
    func toggleStudied(bird: Bird) {
        if studiedBirds.contains(bird.name) {
            studiedBirds.remove(bird.name)
        } else {
            studiedBirds.insert(bird.name)
        }
        saveStudiedBirds()
    }
    
    func isStudied(bird: Bird) -> Bool {
        return studiedBirds.contains(bird.name)
    }
    
    private func saveStudiedBirds() {
        UserDefaults.standard.set(Array(studiedBirds), forKey: "StudiedBirds")
    }
    
    private func loadStudiedBirds() {
        if let saved = UserDefaults.standard.array(forKey: "StudiedBirds") as? [String] {
            studiedBirds = Set(saved)
        }
    }
    
    // MARK: - Favourite Birds
    func toggleFavourite(bird: Bird) {
        if favouriteBirds.contains(bird.name) {
            favouriteBirds.remove(bird.name)
        } else {
            favouriteBirds.insert(bird.name)
        }
        saveFavouriteBirds()
    }
    
    func isFavourite(bird: Bird) -> Bool {
        return favouriteBirds.contains(bird.name)
    }
    
    private func saveFavouriteBirds() {
        UserDefaults.standard.set(Array(favouriteBirds), forKey: "FavouriteBirds")
    }
    
    private func loadFavouriteBirds() {
        if let saved = UserDefaults.standard.array(forKey: "FavouriteBirds") as? [String] {
            favouriteBirds = Set(saved)
        }
    }
    
    // MARK: - Clear Data
    func clearAllProgress() {
        studiedBirds.removeAll()
        favouriteBirds.removeAll()
        saveStudiedBirds()
        saveFavouriteBirds()
    }
    
    func clearFavourites() {
        favouriteBirds.removeAll()
        saveFavouriteBirds()
    }
    
    func clearStudiedBirds() {
        studiedBirds.removeAll()
        saveStudiedBirds()
    }
} 