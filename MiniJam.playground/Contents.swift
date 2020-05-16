//: A SwiftUI-based DAW, inspired by GarageBand

import SwiftUI
import PlaygroundSupport

let samples = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: "Samples")!

let synthesizer: Synthesizer
    
do {
    synthesizer = try Synthesizer(sampleURLs: samples)
} catch {
    fatalError("Could not create synthesizer: \(error)")
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
                PianoView(
                    notes: Note(.c, octave: 3)...Note(.c, octave: 4),
                    synthesizer: synthesizer,
                    whiteKeySize: CGSize(width: 40, height: 150),
                    blackKeySize: CGSize(width: 20, height: 100)
                )
            }
        }
    }
}

// Present the view in Playground
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(MiniJamView())

