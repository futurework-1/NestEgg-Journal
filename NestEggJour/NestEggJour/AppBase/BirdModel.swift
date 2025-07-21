import Foundation

struct EggInfo: Codable {
    let shape: String
    let color: String
    let clutchSize: String
    
    private enum CodingKeys: String, CodingKey {
        case shape, color
        case clutchSize = "clutch_size"
    }
}

struct Bird: Codable, Identifiable {
    let id = UUID()
    let name: String
    let region: String
    let behavior: String
    let appearance: String
    let eggInfo: EggInfo
    let image: String
    let notes: String
    
    private enum CodingKeys: String, CodingKey {
        case name, region, behavior, appearance, image, notes
        case eggInfo = "egg_info"
    }
} 