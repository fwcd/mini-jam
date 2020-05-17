public struct MinorTriad: Harmony {
    public let notes: [Note]
    
    public init(root: Note) {
        notes = [root, root + .minorThird, root + .perfectFifth]
    }
}
