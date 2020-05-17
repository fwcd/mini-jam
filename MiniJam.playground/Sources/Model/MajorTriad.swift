public struct MajorTriad: Harmony {
    public let notes: [Note]
    
    public init(root: Note) {
        notes = [root, root.advanced(by: 3), root.advanced(by: 5)]
    }
}
