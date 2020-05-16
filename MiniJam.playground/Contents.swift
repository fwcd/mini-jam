//: A SwiftUI-based DAW, inspired by GarageBand

import SwiftUI
import PlaygroundSupport

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

/// An octaved note.
public struct Note: CustomStringConvertible, Hashable, Identifiable, Comparable, Strideable {
    public let noteClass: NoteClass
    public let octave: Int
    
    public var description: String { "\(noteClass)\(octave)" }
    public var numValue: Int { (octave * NoteClass.allCases.count) + noteClass.rawValue }
    public var hasAccidental: Bool { noteClass.hasAccidental }
    public var id: Int { numValue }
    
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

/// A MIDI track containing the recorded instrument.
struct Track {
    var notes: [Note]
}

struct TimelineMark: Shape {
    private let thickness: CGFloat = 1
    
    func path(in rect: CGRect) -> Path {
        Path {
            let centerX = (rect.maxX + rect.minX) / 2
            let knobWidth = rect.maxX - rect.minX
            let knobBezelHeight = knobWidth / 4
            let knobRestHeight = knobWidth / 2
            let knobHeight = knobBezelHeight + knobRestHeight
            $0.move(to: CGPoint(x: rect.minX, y: rect.minY))
            $0.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            $0.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + knobBezelHeight))
            $0.addLine(to: CGPoint(x: centerX + thickness, y: rect.minY + knobHeight))
            $0.addLine(to: CGPoint(x: centerX + thickness, y: rect.maxY))
            $0.addLine(to: CGPoint(x: centerX - thickness, y: rect.maxY))
            $0.addLine(to: CGPoint(x: centerX - thickness, y: rect.minY + knobHeight))
            $0.addLine(to: CGPoint(x: rect.minX, y: rect.minY + knobBezelHeight))
            $0.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
    }
}

struct TimelineView: View {
    @Binding private var tracks: [Track]
    @State private var time: CGFloat = 0
    
    init(tracks: Binding<[Track]>) {
        self._tracks = tracks
    }
    
    var body: some View {
        ZStack {
            TimelineMark()
                .fill(Color.red)
                .offset(x: time)
                .frame(width: 15, height: 40)
        }
    }
}

extension Shape {
    func fill<S>(_ fill: S?, stroke: Color?) -> some View where S: ShapeStyle {
        ZStack {
            if fill != nil {
                self.fill(fill!)
            }
            if stroke != nil {
                self.stroke(stroke!)
            }
        }
    }
}

struct PianoKeyView: View {
    private let note: Note
    private let size: CGSize
    private let pressed: Bool
    
    init(note: Note, size: CGSize, pressed: Bool) {
        self.note = note
        self.size = size
        self.pressed = pressed
    }
    
    var body: some View {
        Rectangle()
            .fill(pressed
                ? Color.gray
                : note.hasAccidental
                    ? Color.black
                    : Color.white, stroke: note.hasAccidental ? nil : Color.gray)
            .frame(width: size.width, height: size.height)
    }
}

extension Array {
    /// Performs a "running reduce" on the array.
    public func scan<R>(_ base: R, _ accumulator: (R, Element) -> R) -> [R] {
        var result = [R]()
        for elem in self {
            result.append(accumulator(result.last ?? base, elem))
        }
        return result
    }
    
    /// Performs a "running reduce" on the array with at least one element in the array.
    public func scan1<R>(_ initializer: (Element) -> R, _ accumulator: (R, Element) -> R) -> [R] {
        guard let f = first else { return [] }
        var result = [initializer(f)]
        for elem in dropFirst() {
            result.append(accumulator(result.last!, elem))
        }
        return result
    }
}

struct PianoView: View {
    private let notes: [Note]
    
    @GestureState private var pressedKey: Note? = nil
    
    init<S>(notes: S) where S: Sequence, S.Element == Note {
        self.notes = Array(notes)
    }
    
    var keyBounds: [(Note, CGRect)] {
        let whiteWidth: CGFloat = 20
        let blackWidth: CGFloat = 10
        
        return notes.scan1({ (CGFloat(0), $0) }) { (entry, note) in
            let newX = entry.0 + (note.hasAccidental ? 0 : whiteWidth)
            return (newX, note)
        }.map { entry in
            let x = entry.0 + (entry.1.hasAccidental ? whiteWidth - (blackWidth / 2) : 0)
            let size = entry.1.hasAccidental
                ? CGSize(width: blackWidth, height: 80)
                : CGSize(width: whiteWidth, height: 100)
            return (entry.1, CGRect(origin: CGPoint(x: x, y: 0), size: size))
        }
    }
    
    var body: some View {
        let keys = keyBounds.map {
            PianoKeyView(
                note: $0.0,
                size: $0.1.size,
                pressed: pressedKey == $0.0
            )
                .padding(.leading, $0.1.minX)
                .zIndex($0.0.hasAccidental ? 1 : 0)
        }
        
        return ZStack(alignment: .topLeading) {
            ForEach(0..<keys.count) {
                keys[$0]
            }
        }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .updating($pressedKey) { (value, state, _) in
                        state = self.keyBounds.first(where: { $0.1.contains(value.location) })?.0
                    }
                    .onChanged { _ in
                        DispatchQueue.global().async {
                            if let note = self.pressedKey {
                                self.play(note: note)
                            }
                        }
                    }
            )
    }
    
    func play(note: Note) {
        print("Playing \(note)")
    }
}

struct MiniJamView: View {
    @State private var tracks: [Track] = []
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 800, height: 600)
            VStack {
                Text("MiniJam")
                    .font(.subheadline)
                    .foregroundColor(.black)
                TimelineView(tracks: $tracks)
                PianoView(notes: Note(.c, octave: 0)...Note(.c, octave: 1))
            }
        }
    }
}

// Present the view in Playground
PlaygroundPage.current.setLiveView(MiniJamView())

