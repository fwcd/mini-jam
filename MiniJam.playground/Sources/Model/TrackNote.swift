import Foundation

/// A note with a duration and a (starting) time.
public struct TrackNote: Hashable {
    public let note: Note
    public let time: TimeInterval
    public let duration: TimeInterval
    
    public init(note: Note, time: TimeInterval, duration: TimeInterval) {
        self.note = note
        self.time = time
        self.duration = duration
    }
    
    public init(_ noteClass: NoteClass, _ octave: Int, time: TimeInterval, duration: TimeInterval) {
        self.init(note: Note(noteClass, octave), time: time, duration: duration)
    }
    
    public func contains(time: TimeInterval) -> Bool {
        time >= self.time && time < (self.time + duration)
    }
}
