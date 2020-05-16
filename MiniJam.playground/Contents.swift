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
public struct Note: CustomStringConvertible, Hashable, Comparable, Strideable {
    public let noteClass: NoteClass
    public let octave: Int
    
    public var description: String { "\(noteClass)\(octave)" }
    public var numValue: Int { (octave * NoteClass.allCases.count) + noteClass.rawValue }
    public var hasAccidental: Bool { noteClass.hasAccidental }
    
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
    private let frame: CGSize
    private let action: () -> Void
    
    init(note: Note, frame: CGSize, action: @escaping () -> Void) {
        self.note = note
        self.frame = frame
        self.action = action
    }
    
    var body: some View {
        Rectangle()
            .fill(note.hasAccidental ? Color.black : nil, stroke: note.hasAccidental ? nil : Color.gray)
            .frame(width: frame.width, height: frame.height)
            .onTapGesture {
                self.action()
            }
    }
}

struct PianoView: View {
    var body: some View {
        PianoKeyView(note: Note(.cSharpDFlat), frame: CGSize(width: 20, height: 100)) {
            print("Playing note")
        }
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
                PianoView()
            }
        }
    }
}

// Present the view in Playground
PlaygroundPage.current.setLiveView(MiniJamView())

