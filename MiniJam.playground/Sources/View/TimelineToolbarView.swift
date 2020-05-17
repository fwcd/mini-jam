import SwiftUI

/// A toolbar containing buttons for manipulating the timeline state.
public struct TimelineToolbarView: View {
    private let buttonSize: CGFloat
    
    @Binding private var isPlaying: Bool
    @Binding private var isRecording: Bool
    @Binding private var tracks: [Track]
    
    public init(isPlaying: Binding<Bool>, isRecording: Binding<Bool>, tracks: Binding<[Track]>, buttonSize: CGFloat = 20) {
        self._isPlaying = isPlaying
        self._isRecording = isRecording
        self._tracks = tracks
        self.buttonSize = buttonSize
    }
    
    public var body: some View {
        HStack {
            Button(action: { self.isRecording = !self.isRecording }) {
                if self.isRecording {
                    Text("Stop Recording")
                } else {
                    Text("Record")
                }
            }
            Button(action: { self.isPlaying = !self.isPlaying }) {
                if self.isPlaying {
                    Text("Pause")
                } else {
                    Text("Play")
                }
            }
            Button(action: { self.tracks = [] }) {
                Text("Clear")
            }
        }
    }
}
