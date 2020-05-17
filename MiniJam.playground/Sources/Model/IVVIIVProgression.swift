/// A common progression in Western music.
public struct IVVIIVProgression: Progression {
    public let chords: [Chord]
    
    public init(scale: Scale) {
        chords = [
            MajorTriad(root: scale.notes[0]),
            MajorTriad(root: scale.notes[4]),
            MinorTriad(root: scale.notes[5]),
            MajorTriad(root: scale.notes[3])
        ]
    }
}
