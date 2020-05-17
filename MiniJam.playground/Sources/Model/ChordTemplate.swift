public enum ChordTemplate: Int, Hashable, Identifiable {
    case unison = 0
    case majorTriad
    case minorTriad
    
    public var id: Int { rawValue }
    public func from(root: Note) -> Chord {
        switch self {
        case .unison: return Unison(root: root)
        case .majorTriad: return MajorTriad(root: root)
        case .minorTriad: return MinorTriad(root: root)
        }
    }
}
