import Foundation

/// A MIDI-like track containing the recorded instrument.
public struct Track: Identifiable {
    // TODO: Consider a more efficient data structure for the notes, e.g. an interval tree
    
    public var notes: [TrackNote]
    public var id: Int
    
    public var duration: TimeInterval { notes.map { $0.time + $0.duration }.max() ?? 0 }
    
    public func notesAt(time: TimeInterval) -> [Note] {
        notes.filter { $0.contains(time: time) }.map { $0.note }
    }
}
