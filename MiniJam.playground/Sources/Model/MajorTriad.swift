public struct MajorTriad: Harmony {
    public let notes: [Note]
    
    public init(root: Note) {
        notes = [root, root + .majorThird, root + .perfectFifth]
    }
}
