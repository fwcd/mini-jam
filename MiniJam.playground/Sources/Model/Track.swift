/// A MIDI track containing the recorded instrument.
public struct Track {
    public var notes: [TrackNote]
    
    public var duration: Double { (notes.map { $0.time + $0.duration }.max() ?? 0) - (notes.map { $0.time }.min() ?? 0) }
}
