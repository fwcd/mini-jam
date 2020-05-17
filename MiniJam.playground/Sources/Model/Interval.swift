public enum Interval: Int {
    case perfectUnison = 0
    case minorSecond = 1
    case majorSecond = 2
    case minorThird = 3
    case majorThird = 4
    case perfectFourth = 5
    case diminishedFifth = 6
    case perfectFifth = 7
    case minorSixth = 8
    case majorSixth = 9
    case minorSeventh = 10
    case majorSeventh = 11
    case perfectOctave = 12
}

extension Note {
    public static func +(lhs: Note, rhs: Interval) -> Note {
        lhs.advanced(by: rhs.rawValue)
    }
}
