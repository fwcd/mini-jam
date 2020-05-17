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
    private let tracks: Tracks
    private let timelineTimer: TimelineTimer
    
    private var startTimestamp: Date = Date()
    private var pressed: Set<PressedNote> = []
    
    @Published public var track: Track? = nil
    @Published public var isRecording: Bool = false {
        willSet {
            if newValue {
                // Starting a new recording, make sure the timeline shows a live timer
                track = Track(notes: [], id: tracks.nextID())
                startTimestamp = Date()
                timelineTimer.start()
            } else if let recording = track {
                // Finished the recording, append the new track to the project
                tracks.tracks.append(recording)
                track = nil
                timelineTimer.stop()
                timelineTimer.time = 0
            }
        }
    }
    
    public init(tracks: Tracks, timelineTimer: TimelineTimer) {
        self.tracks = tracks
        self.timelineTimer = timelineTimer
    }
    
    public func start(note: Note) {
        if isRecording {
            pressed.insert(PressedNote(note: note))
        }
    }
    
    public func stop(note: Note) {
        if isRecording, let removed = pressed.remove(PressedNote(note: note)) {
            let duration = -removed.timestamp.timeIntervalSinceNow
            let time = removed.timestamp.timeIntervalSince(startTimestamp)
            track!.notes.append(TrackNote(note: note, time: time, duration: duration))
        }
    }
}
