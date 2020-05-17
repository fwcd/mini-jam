public enum ScaleTemplate: String, CustomStringConvertible, CaseIterable, Hashable {
    case chromatic = "Chromatic"
    case diatonic = "Diatonic"
    case pentatonic = "Pentatonic"
    
    public var description: String { rawValue }
    
    public func from(key: Note) -> Scale {
        switch self {
        case .chromatic: return ChromaticScale(key: key)
        case .diatonic: return DiatonicScale(key: key)
        case .pentatonic: return PentatonicScale(key: key)
        }
    }
}
