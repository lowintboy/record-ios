import SwiftUI

@main
struct RecordApp: App {
    @State private var musicLibrary = MusicLibrary()
    @State private var audioPlayer = AudioPlayer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(musicLibrary)
                .environment(audioPlayer)
        }
    }
}
