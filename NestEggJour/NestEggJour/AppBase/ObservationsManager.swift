import Foundation

class ObservationsManager: ObservableObject {
    @Published var observations: [Observation] = []
    @Published var sawBirdObservations: Set<String> = []
    @Published var foundEggObservations: Set<String> = []
    @Published var watchedNestObservations: Set<String> = []
    
    private let userObservationsKey = "UserObservations"
    
    init() {
        loadObservations()
        loadSawBirdObservations()
        loadFoundEggObservations()
        loadWatchedNestObservations()
    }
    
    private func loadObservations() {
        var allObservations: [Observation] = []
        
        // Load from JSON file
        if let url = Bundle.main.url(forResource: "observations", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonObservations = try JSONDecoder().decode([Observation].self, from: data)
                allObservations.append(contentsOf: jsonObservations)
            } catch {
                print("Error loading observations from JSON: \(error)")
            }
        }
        
        // Load user observations from UserDefaults
        loadUserObservations(&allObservations)
        
        self.observations = allObservations
    }
    
    private func loadUserObservations(_ observations: inout [Observation]) {
        if let data = UserDefaults.standard.data(forKey: userObservationsKey) {
            do {
                let userObservations = try JSONDecoder().decode([Observation].self, from: data)
                observations.append(contentsOf: userObservations)
            } catch {
                print("Error loading user observations: \(error)")
            }
        }
    }
    
    func addObservation(_ observation: Observation) {
        observations.append(observation)
        saveUserObservations()
    }
    
    private func saveUserObservations() {
        // Get only user-added observations (exclude JSON ones)
        if let data = UserDefaults.standard.data(forKey: userObservationsKey) {
            do {
                var userObservations = try JSONDecoder().decode([Observation].self, from: data)
                // Add the new observation to user observations
                if let lastObservation = observations.last {
                    // Check if this observation is not already in user observations
                    if !userObservations.contains(where: { $0.title == lastObservation.title && $0.date == lastObservation.date }) {
                        userObservations.append(lastObservation)
                    }
                }
                let encodedData = try JSONEncoder().encode(userObservations)
                UserDefaults.standard.set(encodedData, forKey: userObservationsKey)
            } catch {
                print("Error updating user observations: \(error)")
            }
        } else {
            // First time saving - save only the last observation
            if let lastObservation = observations.last {
                do {
                    let data = try JSONEncoder().encode([lastObservation])
                    UserDefaults.standard.set(data, forKey: userObservationsKey)
                } catch {
                    print("Error saving first user observation: \(error)")
                }
            }
        }
    }
    
    // MARK: - Saw Bird Observations
    func toggleSawBird(observation: Observation) {
        let key = "\(observation.title)_\(observation.date)"
        if sawBirdObservations.contains(key) {
            sawBirdObservations.remove(key)
        } else {
            sawBirdObservations.insert(key)
        }
        saveSawBirdObservations()
    }
    
    func didSawBird(observation: Observation) -> Bool {
        let key = "\(observation.title)_\(observation.date)"
        return sawBirdObservations.contains(key)
    }
    
    private func saveSawBirdObservations() {
        UserDefaults.standard.set(Array(sawBirdObservations), forKey: "SawBirdObservations")
    }
    
    private func loadSawBirdObservations() {
        if let saved = UserDefaults.standard.array(forKey: "SawBirdObservations") as? [String] {
            sawBirdObservations = Set(saved)
        }
    }
    
    // MARK: - Found Egg Observations
    func toggleFoundEgg(observation: Observation) {
        let key = "\(observation.title)_\(observation.date)"
        if foundEggObservations.contains(key) {
            foundEggObservations.remove(key)
        } else {
            foundEggObservations.insert(key)
        }
        saveFoundEggObservations()
    }
    
    func didFoundEgg(observation: Observation) -> Bool {
        let key = "\(observation.title)_\(observation.date)"
        return foundEggObservations.contains(key)
    }
    
    private func saveFoundEggObservations() {
        UserDefaults.standard.set(Array(foundEggObservations), forKey: "FoundEggObservations")
    }
    
    private func loadFoundEggObservations() {
        if let saved = UserDefaults.standard.array(forKey: "FoundEggObservations") as? [String] {
            foundEggObservations = Set(saved)
        }
    }
    
    // MARK: - Watched Nest Observations
    func toggleWatchedNest(observation: Observation) {
        let key = "\(observation.title)_\(observation.date)"
        if watchedNestObservations.contains(key) {
            watchedNestObservations.remove(key)
        } else {
            watchedNestObservations.insert(key)
        }
        saveWatchedNestObservations()
    }
    
    func didWatchedNest(observation: Observation) -> Bool {
        let key = "\(observation.title)_\(observation.date)"
        return watchedNestObservations.contains(key)
    }
    
    private func saveWatchedNestObservations() {
        UserDefaults.standard.set(Array(watchedNestObservations), forKey: "WatchedNestObservations")
    }
    
    private func loadWatchedNestObservations() {
        if let saved = UserDefaults.standard.array(forKey: "WatchedNestObservations") as? [String] {
            watchedNestObservations = Set(saved)
        }
    }
    
    // MARK: - Clear Data
    func clearAllObservationStates() {
        sawBirdObservations.removeAll()
        foundEggObservations.removeAll()
        watchedNestObservations.removeAll()
        saveSawBirdObservations()
        saveFoundEggObservations()
        saveWatchedNestObservations()
    }
    
    func clearUserHistory() {
        // Clear user-added observations
        UserDefaults.standard.removeObject(forKey: userObservationsKey)
        
        // Clear all observation states
        clearAllObservationStates()
        
        // Reload observations to remove user-added ones
        loadObservations()
    }
} 