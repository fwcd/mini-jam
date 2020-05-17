import SwiftUI

public struct TrackView: View {
    @Binding private var track: Track
    
    private let zoom: CGFloat
    private let height: CGFloat
    
    public init(track: Binding<Track>, zoom: CGFloat = 1, height: CGFloat = 50) {
        self._track = track
        self.zoom = zoom
        self.height = height
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: CGFloat(track.duration) * zoom, height: height)
                .cornerRadius(2)
            // TODO: Render notes
        }
    }
}

struct Track_Preview: PreviewProvider {
    @State private static var track = Track(notes: [
        TrackNote(.c, 4, time: 0.0, duration: 0.5),
        TrackNote(.e, 3, time: 0.2, duration: 1.0),
        TrackNote(.g, 4, time: 0.6, duration: 1.0)
    ])
    
    static var previews: some View {
        TrackView(track: $track)
    }
}
