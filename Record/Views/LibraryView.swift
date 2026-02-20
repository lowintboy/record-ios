import SwiftUI
import UniformTypeIdentifiers

struct LibraryView: View {
    @Environment(MusicLibrary.self) private var library
    @Environment(AudioPlayer.self) private var audioPlayer

    @State private var showFileImporter = false

    var body: some View {
        Group {
            if library.tracks.isEmpty {
                ContentUnavailableView(
                    "라이브러리가 비어 있습니다",
                    systemImage: "music.note",
                    description: Text("+ 버튼을 눌러 음악 파일을 추가하세요")
                )
            } else {
                trackList
            }
        }
        .navigationTitle("RECORD")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showFileImporter = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: MusicLibrary.supportedTypes,
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                for url in urls {
                    library.importTrack(from: url)
                }
            case .failure(let error):
                print("File import failed: \(error.localizedDescription)")
            }
        }
    }

    private var trackList: some View {
        List {
            ForEach(library.tracks, id: \.id) { (track: Track) in
                Button {
                    audioPlayer.play(track, in: library.tracks)
                } label: {
                    HStack {
                        Image(systemName: "music.note")
                            .foregroundStyle(.secondary)
                        VStack(alignment: .leading) {
                            Text(track.displayName)
                                .foregroundStyle(.primary)
                            Text(track.fileName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if audioPlayer.currentTrack == track {
                            Image(systemName: audioPlayer.isPlaying ? "speaker.wave.2.fill" : "speaker.fill")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
            .onDelete { offsets in
                library.deleteTrack(at: offsets)
            }
        }
    }
}
