import SwiftUI

struct ContentView: View {
    @Environment(AudioPlayer.self) private var audioPlayer

    @State private var showNowPlaying = false

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                LibraryView()
            }

            if audioPlayer.currentTrack != nil {
                MiniPlayerBar(showNowPlaying: $showNowPlaying)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
            }
        }
        .sheet(isPresented: $showNowPlaying) {
            NowPlayingView()
        }
    }
}
