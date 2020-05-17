import SwiftUI

public struct TimelineView: View {
    @Binding private var state: TimelineState
    @Binding private var tracks: [Track]
    @Binding private var isRecording: Bool
    @State private var time: CGFloat = 0
    
    public init(state: Binding<TimelineState>, tracks: Binding<[Track]>, isRecording: Binding<Bool>) {
        self._state = state
        self._tracks = tracks
        self._isRecording = isRecording
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            TimelineToolbarView(state: $state, isRecording: $isRecording)
            ZStack {
                VStack(alignment: .leading) {
                    ForEach(tracks) { track in
                        TrackView(track: track)
                    }
                }
                TimelineCursor()
                    .fill(Color.red)
                    .offset(x: time)
                    .frame(width: 15, height: 40)
            }
        }
    }
}
