import SwiftUI

/// A view presenting the user's recorded tracks.
public struct TimelineView: View {
    private let zoom: CGFloat
    private let trackWidth: CGFloat = 500
    private let trackHeight: CGFloat = 50
    
    @Binding private var tracks: [Track]
    @Binding private var recordingTrack: Track?
    @Binding private var isPlaying: Bool
    @Binding private var isRecording: Bool
    @Binding private var moverCount: Int
    @Binding private var time: TimeInterval
    
    @State private var dragging: Bool = false
    
    public init(
        tracks: Binding<[Track]>,
        recordingTrack: Binding<Track?>,
        isPlaying: Binding<Bool>,
        isRecording: Binding<Bool>,
        moverCount: Binding<Int>,
        time: Binding<TimeInterval>,
        zoom: CGFloat = 20
    ) {
        self._tracks = tracks
        self._recordingTrack = recordingTrack
        self._isPlaying = isPlaying
        self._isRecording = isRecording
        self._moverCount = moverCount
        self._time = time
        self.zoom = zoom
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            TimelineToolbarView(time: $time, isPlaying: $isPlaying, isRecording: $isRecording, tracks: $tracks)
            ScrollView {
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        // Render currently recording track
                        if recordingTrack != nil {
                            // Workaround for not being able to use if-let in view builders
                            HStack {
                                TrackView(track: recordingTrack!, isLive: true, zoom: self.zoom, height: self.trackHeight)
                                Spacer()
                            }
                        }
                        // Render existing tracks
                        ForEach(tracks) { track in
                            HStack {
                                TrackView(track: track, isLive: false, zoom: self.zoom, height: self.trackHeight)
                                Spacer()
                            }
                        }
                    }
                        .frame(width: trackWidth)
                    GeometryReader { geometry in
                        TimelineCursor()
                            .fill(Color.red)
                            .offset(x: (CGFloat(self.time) * self.zoom) - (geometry.size.width / 2))
                            .frame(width: 15)
                    }
                }
            }
            .frame(width: trackWidth, height: trackHeight * 2)
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onChanged { value in
                        self.time = Double(value.location.x / self.zoom)
                        if !self.dragging {
                            self.dragging = true
                            self.moverCount += 1
                        }
                    }
                    .onEnded { _ in
                        self.dragging = false
                        self.moverCount -= 1
                    }
            )
        }
    }
}
