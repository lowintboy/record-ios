import SwiftUI

struct NowPlayingView: View {
    @Environment(AudioPlayer.self) private var audioPlayer
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Album art placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(.quaternary)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Image(systemName: "music.note")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 40)

                // Track info
                VStack(spacing: 8) {
                    Text(audioPlayer.currentTrack?.displayName ?? "재생 중인 곡 없음")
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)

                    Text(audioPlayer.currentTrack?.fileName ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding(.horizontal)

                // Progress
                VStack(spacing: 4) {
                    @Bindable var player = audioPlayer
                    Slider(
                        value: Binding(
                            get: { audioPlayer.currentTime },
                            set: { audioPlayer.seek(to: $0) }
                        ),
                        in: 0...max(audioPlayer.duration, 1)
                    )

                    HStack {
                        Text(audioPlayer.formattedCurrentTime)
                        Spacer()
                        Text(audioPlayer.formattedDuration)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // Playback controls
                HStack(spacing: 40) {
                    Button {
                        audioPlayer.skipBackward()
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.title)
                    }

                    Button {
                        audioPlayer.togglePlayPause()
                    } label: {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 64))
                    }

                    Button {
                        audioPlayer.skipForward()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title)
                    }
                }
                .foregroundStyle(.primary)

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                }
            }
        }
    }
}
