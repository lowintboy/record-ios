import Foundation
import UniformTypeIdentifiers

@Observable
final class MusicLibrary {
    private(set) var tracks: [Track] = []

    init() {
        loadLibrary()
    }

    func importTrack(from url: URL) {
        let accessed = url.startAccessingSecurityScopedResource()
        defer {
            if accessed { url.stopAccessingSecurityScopedResource() }
        }

        let fileName = url.lastPathComponent
        let displayName = url.deletingPathExtension().lastPathComponent
        let destinationURL = FileManagerService.musicDirectory.appendingPathComponent(fileName)

        do {
            try FileManagerService.copyFile(from: url, to: destinationURL)
            let track = Track(fileName: fileName, displayName: displayName)
            tracks.append(track)
            saveLibrary()
        } catch {
            print("Failed to import track: \(error.localizedDescription)")
        }
    }

    func deleteTrack(_ track: Track) {
        try? FileManagerService.deleteFile(at: track.fileURL)
        tracks.removeAll { $0.id == track.id }
        saveLibrary()
    }

    func deleteTrack(at offsets: IndexSet) {
        let tracksToDelete = offsets.map { tracks[$0] }
        for track in tracksToDelete {
            try? FileManagerService.deleteFile(at: track.fileURL)
        }
        tracks.remove(atOffsets: offsets)
        saveLibrary()
    }

    private func saveLibrary() {
        do {
            let data = try JSONEncoder().encode(tracks)
            try data.write(to: FileManagerService.libraryFileURL)
        } catch {
            print("Failed to save library: \(error.localizedDescription)")
        }
    }

    private func loadLibrary() {
        guard FileManager.default.fileExists(atPath: FileManagerService.libraryFileURL.path) else { return }
        do {
            let data = try Data(contentsOf: FileManagerService.libraryFileURL)
            tracks = try JSONDecoder().decode([Track].self, from: data)
        } catch {
            print("Failed to load library: \(error.localizedDescription)")
        }
    }

    static let supportedTypes: [UTType] = [.mp3, .mpeg4Audio, .wav, .audio, .aiff]
}
