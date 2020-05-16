/// A pitch independent of its octave on the Western 12-tone-scale.
public enum NoteClass: Int, CaseIterable, CustomStringConvertible, Comparable, Hashable {
    case c = 0
    case cSharpDFlat = 1
    case d = 2
    case dSharpEFlat = 3
    case e = 4
    case f = 5
    case fSharpGFlat = 6
    case g = 7
    case gSharpAFlat = 8
    case a = 9
    case aSharpBFlat = 10
    case b = 11
    
    public var description: String {
        switch self {
        case .c: return "C"
        case .cSharpDFlat: return "C♯/D♭"
        case .d: return "D"
        case .dSharpEFlat: return "D♯/E♭"
        case .e: return "E"
        case .f: return "F"
        case .fSharpGFlat: return "F♯/G♭"
        case .g: return "G"
        case .gSharpAFlat: return "G♯/A♭"
        case .a: return "A"
        case .aSharpBFlat: return "A♯/B♭"
        case .b: return "B"
        }
    }
    
    public var hasAccidental: Bool {
        switch self {
        case .cSharpDFlat, .dSharpEFlat, .fSharpGFlat, .gSharpAFlat, .aSharpBFlat: return true
        default: return false
        }
    }
    
    public static func <(lhs: NoteClass, rhs: NoteClass) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
