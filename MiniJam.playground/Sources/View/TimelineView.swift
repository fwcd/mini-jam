import SwiftUI

public struct TimelineView: View {
    @Binding private var tracks: [Track]
    @State private var time: CGFloat = 0
    
    public init(tracks: Binding<[Track]>) {
        self._tracks = tracks
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ForEach(0..<tracks.count) {
                    TrackView(track: self.$tracks[$0])
                }
            }
            TimelineMark()
                .fill(Color.red)
                .offset(x: time)
                .frame(width: 15, height: 40)
        }
    }
}
