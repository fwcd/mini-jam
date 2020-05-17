public enum ProgressionTemplate: String, CaseIterable, Hashable {
    case none = "None"
    case ivviiv = "I-V-vi-IV"
    
    public func from(key: Note) -> Progression? {
        switch self {
        case .ivviiv: return IVVIIVProgression(scale: DiatonicScale(key: key))
        case .none: return nil
        }
    }
}
