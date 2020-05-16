import SwiftUI

public struct PianoView: View {
    private let notes: [Note]
    private let synthesizer: Synthesizer
    
    private let whiteKeySize: CGSize
    private let blackKeySize: CGSize
    
    @GestureState private var pressedKey: Note? = nil
    
    public init<S>(notes: S, synthesizer: Synthesizer, whiteKeySize: CGSize = CGSize(width: 20, height: 100), blackKeySize: CGSize = CGSize(width: 10, height: 80)) where S: Sequence, S.Element == Note {
        self.notes = Array(notes)
        self.synthesizer = synthesizer
        self.whiteKeySize = whiteKeySize
        self.blackKeySize = blackKeySize
    }
    
    public var keyBounds: [(Note, CGRect)] {
        return notes.scan1({ (CGFloat(0), $0) }) { (entry, note) in
            let newX = entry.0 + (note.hasAccidental ? 0 : whiteKeySize.width)
            return (newX, note)
        }.map { entry in
            let x = entry.0 + (entry.1.hasAccidental ? whiteKeySize.width - (blackKeySize.width / 2) : 0)
            let size = entry.1.hasAccidental ? blackKeySize : whiteKeySize
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
                        state = self.keyBounds.filter { $0.1.contains(value.location) }.max(by: compareAscending { $0.0.hasAccidental ? 1 : 0 })?.0
                    }
                    .onChanged { _ in
                        DispatchQueue.global().async {
                            if let note = self.pressedKey {
                                self.play(note: note)
                            }
                        }
                    }
                    .onEnded { _ in
                        self.stop()
                    }
            )
    }
    
    private func play(note: Note) {
        do {
            try synthesizer.start(note: note)
        } catch {
            print("Could not play note \(note) using synthesizer: \(error)")
        }
    }
    
    private func stop() {
        do {
            try synthesizer.stop()
        } catch {
            print("Could not stpo note using synthesizer: \(error)")
        }
    }
}
