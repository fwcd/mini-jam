//: A SwiftUI-based DAW, inspired by GarageBand

import SwiftUI
import PlaygroundSupport

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

