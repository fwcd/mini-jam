import SwiftUI

public struct TimelineView: View {
    @Binding private var state: TimelineState
    @Binding private var tracks: [Track]
    @State private var time: CGFloat = 0
    
    public init(state: Binding<TimelineState>, tracks: Binding<[Track]>) {
        self._state = state
        self._tracks = tracks
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            TimelineToolbarView(state: $state)
            ZStack {
                VStack(alignment: .leading) {
                    ForEach(0..<tracks.count) {
                        TrackView(track: self.$tracks[$0])
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
