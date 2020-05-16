import SwiftUI

public struct TimelineView: View {
    @Binding private var tracks: [Track]
    @State private var time: CGFloat = 0
    
    public init(tracks: Binding<[Track]>) {
        self._tracks = tracks
    }
    
    public var body: some View {
        ZStack {
            TimelineMark()
                .fill(Color.red)
                .offset(x: time)
                .frame(width: 15, height: 40)
        }
    }
}
