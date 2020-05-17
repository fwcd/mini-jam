import Foundation

private struct PressedNote: Hashable {
    let note: Note
    let timestamp: Date = Date()
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.note == rhs.note
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(note)
    }
}

/// A sink that records notes to a track and immediately begins tracking the time.
public struct Recorder: NoteSink {
    public private(set) var track: Track
    private var startTimestamp: Date = Date()
    private var pressed: Set<PressedNote> = []
    
    public init(track: Track) {
        self.track = track
    }
    
    public func start(note: Note) {
        pressed.insert(PressedNote(note: note))
    }
    
    public func stop(note: Note) {
        if let removed = pressed.remove(PressedNote(note: note)) {
            let duration = -removed.timestamp.timeIntervalSinceNow
            let time = removed.timeIntervalSince(startTimestamp)
            track.notes.append(TrackNote(note: note, time: time, duration: duration))
        }
    }
}
