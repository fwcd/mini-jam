import Foundation
import Combine

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
public class Recorder: NoteSink, ObservableObject {
    private var startTimestamp: Date = Date()
    private var pressed: Set<PressedNote> = []
    
    @Published public var track: Track = Track(notes: [])
    @Published public var isRecording: Bool = false {
        willSet {
            if newValue {
                track = Track(notes: [])
                startTimestamp = Date()
            }
        }
    }
    
    public init() {}
    
    public func start(note: Note) {
        if isRecording {
            pressed.insert(PressedNote(note: note))
        }
    }
    
    public func stop(note: Note) {
        if isRecording, let removed = pressed.remove(PressedNote(note: note)) {
            let duration = -removed.timestamp.timeIntervalSinceNow
            let time = removed.timestamp.timeIntervalSince(startTimestamp)
            track.notes.append(TrackNote(note: note, time: time, duration: duration))
        }
    }
}
