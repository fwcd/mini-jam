public struct Unison: Chord {
    public let notes: [Note]
    
    public init(root: Note) {
        notes = [root]
    }
}
