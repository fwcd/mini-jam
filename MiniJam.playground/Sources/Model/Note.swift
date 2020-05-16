/// An octaved note.
public struct Note: CustomStringConvertible, Hashable, Identifiable, Comparable, Strideable {
    public let noteClass: NoteClass
    public let octave: Int
    
    public var description: String { "\(noteClass)\(octave)" }
    public var numValue: Int { (octave * NoteClass.allCases.count) + noteClass.rawValue }
    public var hasAccidental: Bool { noteClass.hasAccidental }
    public var id: Int { numValue }
    public var midiNumber: Int { 127 + Note(.g, octave: 9).numValue - numValue }
    
    public init(numValue: Int) {
        noteClass = NoteClass(rawValue: numValue % NoteClass.allCases.count)!
        octave = numValue / NoteClass.allCases.count
    }
    
    public init(_ noteClass: NoteClass, octave: Int = 0) {
        self.noteClass = noteClass
        self.octave = octave
    }
    
    public static func <(lhs: Note, rhs: Note) -> Bool {
        lhs.numValue < rhs.numValue
    }
    
    public func advanced(by n: Int) -> Note {
        Note(numValue: numValue + n)
    }
    
    public func distance(to n: Note) -> Int {
        n.numValue - numValue
    }
}
