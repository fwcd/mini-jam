import SwiftUI

public struct PianoKeyView: View {
    private let note: Note
    private let size: CGSize
    private let pressed: Bool
    
    public init(note: Note, size: CGSize, pressed: Bool) {
        self.note = note
        self.size = size
        self.pressed = pressed
    }
    
    public var body: some View {
        Rectangle()
            .fill(pressed
                ? Color.gray
                : note.hasAccidental
                    ? Color.black
                    : Color.white, stroke: note.hasAccidental ? nil : Color.gray)
            .frame(width: size.width, height: size.height)
    }
}
