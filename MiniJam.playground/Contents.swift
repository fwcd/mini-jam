//: A SwiftUI-based playground

import SwiftUI
import PlaygroundSupport

struct MiniJamView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 800, height: 600)
            Text("Hello World!")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }
}

// Present the view in Playground
PlaygroundPage.current.setLiveView(MiniJamView())

