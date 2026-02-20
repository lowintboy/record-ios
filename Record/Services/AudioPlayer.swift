import AVFoundation
import Combine
import Foundation

@Observable
final class AudioPlayer: NSObject {
    var isPlaying = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var currentTrack: Track?

    private var player: AVAudioPlayer?
    private var timer: AnyCancellable?
    private var queue: [Track] = []
    private var currentIndex: Int = 0

    override init() {
        super.init()
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    func play(_ track: Track, in tracks: [Track]) {
        queue = tracks
        if let index = tracks.firstIndex(of: track) {
            currentIndex = index
        }
        loadAndPlay(track)
    }

    func togglePlayPause() {
        guard let player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopTimer()
        } else {
            player.play()
            isPlaying = true
            startTimer()
        }
    }

    func skipForward() {
        guard !queue.isEmpty else { return }
        currentIndex = (currentIndex + 1) % queue.count
        loadAndPlay(queue[currentIndex])
    }

    func skipBackward() {
        guard let player else { return }
        if player.currentTime > 3 {
            player.currentTime = 0
            currentTime = 0
        } else {
            guard !queue.isEmpty else { return }
            currentIndex = (currentIndex - 1 + queue.count) % queue.count
            loadAndPlay(queue[currentIndex])
        }
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }

    var formattedCurrentTime: String {
        formatTime(currentTime)
    }

    var formattedDuration: String {
        formatTime(duration)
    }

    private func loadAndPlay(_ track: Track) {
        stopTimer()
        do {
            player = try AVAudioPlayer(contentsOf: track.fileURL)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            currentTrack = track
            duration = player?.duration ?? 0
            currentTime = 0
            isPlaying = true
            startTimer()
        } catch {
            print("Failed to play track: \(error.localizedDescription)")
            isPlaying = false
        }
    }

    private func startTimer() {
        timer = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, let player = self.player else { return }
                self.currentTime = player.currentTime
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            skipForward()
        }
    }
}
