public enum ChordTemplate: String, CustomStringConvertible, CaseIterable, Hashable, Identifiable {
    case none = "None"
    case majorTriad = "Major Triad"
    case minorTriad = "Minor Triad"
    
    public var description: String { rawValue }
    
    public var id: String { rawValue }
    public func from(root: Note) -> Chord {
        switch self {
        case .none: return Unison(root: root)
        case .majorTriad: return MajorTriad(root: root)
        case .minorTriad: return MinorTriad(root: root)
        }
    }
}
