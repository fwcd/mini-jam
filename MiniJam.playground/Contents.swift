//: A SwiftUI-based DAW, inspired by GarageBand

import SwiftUI
import PlaygroundSupport

/// A note independent of its octave.
enum NoteClass {
    case c
    case d
    case e
    case f
    case g
    case a
    case b
}

/// Defines a note to be a single half-step higher or lower.
enum Accidental {
    case sharp
    case flat
}

/// An octaved note.
struct Note {
    let noteClass: NoteClass
    let accidental: Accidental?
    let octave: Int
    
    init(_ noteClass: NoteClass, _ accidental: Accidental? = nil, octave: Int = 0) {
        self.noteClass = noteClass
        self.accidental = accidental
        self.octave = octave
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
            .fill(note.accidental.map { _ in Color.black }, stroke: note.accidental.flatMap { _ in nil } ?? Color.gray)
            .frame(width: frame.width, height: frame.height)
            .onTapGesture {
                self.action()
            }
    }
}

struct PianoView: View {
    var body: some View {
        PianoKeyView(note: Note(.c, .sharp), frame: CGSize(width: 20, height: 100)) {
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

