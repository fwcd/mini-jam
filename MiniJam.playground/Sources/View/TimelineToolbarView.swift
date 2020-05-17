import SwiftUI

/// A toolbar containing buttons for manipulating the timeline state.
public struct TimelineToolbarView: View {
    private let buttonSize: CGFloat
    
    @Binding private var state: TimelineState
    @Binding private var isRecording: Bool
    
    public init(state: Binding<TimelineState>, isRecording: Binding<Bool>, buttonSize: CGFloat = 20) {
        self._state = state
        self._isRecording = isRecording
        self.buttonSize = buttonSize
    }
    
    public var body: some View {
        HStack {
            Button(action: {
                switch self.state {
                case .recording:
                    self.state = .paused
                    self.isRecording = false
                default:
                    self.state = .recording
                    self.isRecording = true
                }
            }) {
                if self.state == .recording {
                    Text("Stop Recording")
                } else {
                    Text("Record")
                }
            }
            Button(action: {
                switch self.state {
                case .playing: self.state = .paused
                default: self.state = .playing
                }
            }) {
                if self.state == .playing {
                    Text("Pause")
                } else {
                    Text("Play")
                }
            }
        }
    }
}
