import SwiftUI

/// A toolbar containing buttons for manipulating the timeline state.
public struct TimelineToolbarView: View {
    private let buttonSize: CGFloat
    
    @Binding private var state: TimelineState
    
    public init(state: Binding<TimelineState>, buttonSize: CGFloat = 20) {
        self._state = state
        self.buttonSize = buttonSize
    }
    
    public var body: some View {
        HStack {
            Button(action: { self.state = TimelineState.recording }) {
                Text("Record")
            }
            Button(action: {
                switch self.state {
                case .playing: self.state = .paused
                default: self.state = .playing
                }
            }) {
                if self.state == .playing {
                    // TODO: Icon
                    Text("Pause")
                } else {
                    // TODO: Icon
                    Text("Play")
                }
            }
        }
    }
}
