public struct TrackNote: Hashable {
    public let note: Note
    public let time: Double
    public let duration: Double
    
    public init(note: Note, time: Double, duration: Double) {
        self.note = note
        self.time = time
        self.duration = duration
    }
    
    public init(_ noteClass: NoteClass, _ octave: Int, time: Double, duration: Double) {
        self.init(note: Note(noteClass, octave), time: time, duration: duration)
    }
    
    public func contains(time: Double) -> Bool {
        time >= self.time && time < (self.time + duration)
    }
}
