import SwiftUI

public struct PianoView: View {
    private let notes: [Note]
    
    @GestureState private var pressedKey: Note? = nil
    
    public init<S>(notes: S) where S: Sequence, S.Element == Note {
        self.notes = Array(notes)
    }
    
    public var keyBounds: [(Note, CGRect)] {
        let whiteWidth: CGFloat = 20
        let blackWidth: CGFloat = 10
        
        return notes.scan1({ (CGFloat(0), $0) }) { (entry, note) in
            let newX = entry.0 + (note.hasAccidental ? 0 : whiteWidth)
            return (newX, note)
        }.map { entry in
            let x = entry.0 + (entry.1.hasAccidental ? whiteWidth - (blackWidth / 2) : 0)
            let size = entry.1.hasAccidental
                ? CGSize(width: blackWidth, height: 80)
                : CGSize(width: whiteWidth, height: 100)
            return (entry.1, CGRect(origin: CGPoint(x: x, y: 0), size: size))
        }
    }
    
    public var body: some View {
        let keys = keyBounds.map {
            PianoKeyView(
                note: $0.0,
                size: $0.1.size,
                pressed: pressedKey == $0.0
            )
                .padding(.leading, $0.1.minX)
                .zIndex($0.0.hasAccidental ? 1 : 0)
        }
        
        return ZStack(alignment: .topLeading) {
            ForEach(0..<keys.count) {
                keys[$0]
            }
        }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .updating($pressedKey) { (value, state, _) in
                        state = self.keyBounds.first(where: { $0.1.contains(value.location) })?.0
                    }
                    .onChanged { _ in
                        DispatchQueue.global().async {
                            if let note = self.pressedKey {
                                self.play(note: note)
                            }
                        }
                    }
            )
    }
    
    func play(note: Note) {
        print("Playing \(note)")
    }
}
