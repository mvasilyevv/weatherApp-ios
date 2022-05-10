import Foundation

class City: Codable {
    var name: String?
    var country: String?
    var region: String?

    init() {}
    
    private enum CodingKeys: String, CodingKey {
        case name, country, region
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.region = try container.decodeIfPresent(String.self, forKey: .region)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.country, forKey: .country)
        try container.encode(self.region, forKey: .region)
    }
}
