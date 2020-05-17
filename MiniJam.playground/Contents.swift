//: A SwiftUI-based DAW, inspired by GarageBand

import SwiftUI
import PlaygroundSupport

let synthesizer: Synthesizer

do {
    synthesizer = try Synthesizer()
} catch {
    fatalError("Could not create synthesizer: \(error)")
}

struct MiniJamView: View {
    @State private var tracks: [Track] = []
    @State private var autoChord: ChordTemplate = .unison

    var body: some View {
        VStack(spacing: 20) {
            Text("MiniJam")
                .font(.title)
                .fontWeight(.light)
            TimelineView(tracks: $tracks)
            PianoView(
                notes: Note(.c, 4)..<Note(.c, 6),
                autoChord: $autoChord,
                synthesizer: synthesizer,
                whiteKeySize: CGSize(width: 40, height: 150),
                blackKeySize: CGSize(width: 20, height: 100)
            )
            Picker(selection: $autoChord, label: Text("Auto-Chord")) {
                Text("None").tag(ChordTemplate.unison)
                Text("Major Triad").tag(ChordTemplate.majorTriad)
                Text("Minor Triad").tag(ChordTemplate.minorTriad)
            }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 500)
            Text("Tap the keys to play!")
                .foregroundColor(.gray)
        }
            .frame(width: 800, height: 600)
    }
}

// Present the view in Playground
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(MiniJamView())

