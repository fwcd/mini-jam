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
                var playingNotes = Set<Note>()
                
                cancellable = timelineTimer.$time.sink {
                    do {
                        let currentNotes = Set(self.tracks.notesAt(time: $0))
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
    }
}
