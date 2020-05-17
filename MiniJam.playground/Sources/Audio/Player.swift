import Foundation
import Combine

/// A facility that plays a track using the synthesizer.
public class Player: ObservableObject {
    private let tracks: Tracks
    private let timelineTimer: TimelineTimer
    private let synthesizer: Synthesizer
    
    private var cancellable: AnyCancellable? = nil
    
    @Published public var isPlaying: Bool = false {
        willSet {
            if newValue {
                timelineTimer.start()
            } else {
                timelineTimer.stop()
            }
        }
    }
    
    public init(tracks: Tracks, timelineTimer: TimelineTimer, synthesizer: Synthesizer) {
        self.tracks = tracks
        self.timelineTimer = timelineTimer
        self.synthesizer = synthesizer
        
        // Subscribe to the timer
        var playingNotes = Set<Note>()
        cancellable = timelineTimer.$time.combineLatest(timelineTimer.$moverCount).sink { (time, moverCount) in
            do {
                // Only play sounds if the time is moving
                let currentNotes = moverCount > 0 ? Set(self.tracks.notesAt(time: time)) : Set()
                if playingNotes != currentNotes {
                    for note in playingNotes {
                        try self.synthesizer.stop(note: note)
                    }
                    for note in currentNotes {
                        try self.synthesizer.start(note: note)
                    }
                    playingNotes = currentNotes
                }
            } catch {
                print("Could not synthesize sound while playing: \(error)")
            }
        }
    }
}
