import SwiftUI

public struct TrackView: View {
    private let track: Track
    
    private let zoom: CGFloat
    private let height: CGFloat
    
    public init(track: Track, zoom: CGFloat = 20, height: CGFloat = 50) {
        self.track = track
        self.zoom = zoom
        self.height = height
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color.green)
                .frame(width: CGFloat(track.duration) * zoom, height: height)
                .cornerRadius(2)
            ForEach(track.notes, id: \.self) { note in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: CGFloat(note.duration) * self.zoom, height: self.height / CGFloat(NoteClass.allCases.count))
                    .padding(.leading, CGFloat(note.time) * self.zoom)
                    .padding(.top, (CGFloat(note.note.noteClass.rawValue) * self.height) / CGFloat(NoteClass.allCases.count))
            }
        }
    }
}

struct Track_Preview: PreviewProvider {
    @State private static var track = Track(notes: [
        TrackNote(.c, 4, time: 0.0, duration: 0.5),
        TrackNote(.e, 3, time: 0.2, duration: 1.0),
        TrackNote(.g, 4, time: 0.6, duration: 1.0)
    ], id: 0)
    
    static var previews: some View {
        TrackView(track: track)
    }
}
