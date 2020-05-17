import SwiftUI
import Foundation

/// A toolbar containing buttons for manipulating the timeline state.
public struct TimelineToolbarView: View {
    private let buttonSize: CGFloat
    
    @Binding private var time: TimeInterval
    @Binding private var isPlaying: Bool
    @Binding private var isRecording: Bool
    @Binding private var tracks: [Track]
    
    public init(time: Binding<TimeInterval>, isPlaying: Binding<Bool>, isRecording: Binding<Bool>, tracks: Binding<[Track]>, buttonSize: CGFloat = 20) {
        self._time = time
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
                .disabled(self.isPlaying)
            Button(action: { self.isPlaying = !self.isPlaying }) {
                if self.isPlaying {
                    Text("Pause")
                } else {
                    Text("Play")
                }
            }
                .disabled(self.isRecording)
            Button(action: { self.time = 0 }) {
                Text("Back")
            }
                .disabled(self.isRecording)
            Button(action: { self.tracks = [] }) {
                Text("Clear")
            }
        }
    }
}
