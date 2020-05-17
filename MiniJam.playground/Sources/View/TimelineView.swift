import SwiftUI

public struct TimelineView: View {
    private let trackWidth: CGFloat = 500
    private let trackHeight: CGFloat = 50
    
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
            TimelineToolbarView(state: $state, isRecording: $isRecording, tracks: $tracks)
            ScrollView {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        ForEach(tracks) { track in
                            HStack {
                                TrackView(track: track, height: self.trackHeight)
                                Spacer()
                            }
                        }
                    }
                        .frame(width: trackWidth)
                    TimelineCursor()
                        .fill(Color.red)
                        .offset(x: time)
                        .frame(width: 15)
                }
            }
            .frame(width: trackWidth, height: trackHeight * 2)
        }
    }
}
