public struct ChromaticScale: Scale {
    public let notes: [Note]
    
    public init(key: Note) {
        var octavedKey = key
        octavedKey.octave += 1
        notes = Array(key..<octavedKey)
    }
}
