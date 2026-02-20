import Foundation

struct Track: Identifiable, Codable, Equatable {
    let id: UUID
    let fileName: String
    let displayName: String
    let dateAdded: Date

    var fileURL: URL {
        FileManagerService.musicDirectory.appendingPathComponent(fileName)
    }

    init(id: UUID = UUID(), fileName: String, displayName: String, dateAdded: Date = .now) {
        self.id = id
        self.fileName = fileName
        self.displayName = displayName
        self.dateAdded = dateAdded
    }
}
