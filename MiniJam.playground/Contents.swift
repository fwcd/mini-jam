//: A SwiftUI-based DAW, inspired by GarageBand

import SwiftUI
import PlaygroundSupport

struct MiniJamView: View {
    private let synthesizer = try! Synthesizer()
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
                PianoView(
                    notes: Note(.c, octave: 0)...Note(.c, octave: 1),
                    synthesizer: synthesizer,
                    whiteKeySize: CGSize(width: 40, height: 150),
                    blackKeySize: CGSize(width: 20, height: 100)
                )
            }
        }
    }
}

// Present the view in Playground
PlaygroundPage.current.setLiveView(MiniJamView())

