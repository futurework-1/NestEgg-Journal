import Foundation

struct Observation: Codable, Identifiable {
    let id: UUID
    let title: String
    let location: String
    let coordinates: String
    let date: String
    let image: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case title, location, coordinates, date, image, description
    }
    
    init(title: String, location: String, coordinates: String, date: String, image: String, description: String) {
        self.id = UUID()
        self.title = title
        self.location = location
        self.coordinates = coordinates
        self.date = date
        self.image = image
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.title = try container.decode(String.self, forKey: .title)
        self.location = try container.decode(String.self, forKey: .location)
        self.coordinates = try container.decode(String.self, forKey: .coordinates)
        self.date = try container.decode(String.self, forKey: .date)
        self.image = try container.decode(String.self, forKey: .image)
        self.description = try container.decode(String.self, forKey: .description)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(location, forKey: .location)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(date, forKey: .date)
        try container.encode(image, forKey: .image)
        try container.encode(description, forKey: .description)
    }
} 