import SwiftUI

/// A view presenting the user's recorded tracks.
public struct TimelineView: View {
    private let zoom: CGFloat
    private let trackWidth: CGFloat = 500
    private let trackHeight: CGFloat = 50
    
    @Binding private var state: TimelineState
    @Binding private var tracks: [Track]
    @Binding private var isRecording: Bool
    @Binding private var time: TimeInterval
    
    public init(state: Binding<TimelineState>, tracks: Binding<[Track]>, isRecording: Binding<Bool>, time: Binding<TimeInterval>, zoom: CGFloat = 20) {
        self._state = state
        self._tracks = tracks
        self._isRecording = isRecording
        self._time = time
        self.zoom = zoom
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            TimelineToolbarView(state: $state, isRecording: $isRecording, tracks: $tracks)
            ScrollView {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        ForEach(tracks) { track in
                            HStack {
                                TrackView(track: track, zoom: self.zoom, height: self.trackHeight)
                                Spacer()
                            }
                        }
                    }
                        .frame(width: trackWidth)
                    TimelineCursor()
                        .fill(Color.red)
                        .offset(x: CGFloat(time) * zoom)
                        .frame(width: 15)
                }
            }
            .frame(width: trackWidth, height: trackHeight * 2)
        }
    }
}
