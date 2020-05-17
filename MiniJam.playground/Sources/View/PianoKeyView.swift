import SwiftUI

public struct PianoKeyView: View {
    private let note: Note
    private let size: CGSize
    private let pressed: Bool
    private let enabled: Bool
    
    public init(note: Note, size: CGSize, pressed: Bool, enabled: Bool) {
        self.note = note
        self.size = size
        self.pressed = pressed
        self.enabled = enabled
    }
    
    public var body: some View {
        Rectangle()
            .fill(pressed
                ? Color.gray
                : note.hasAccidental
                    ? Color.black
                    : Color.white, stroke: note.hasAccidental ? nil : Color.gray)
            .frame(width: size.width, height: size.height)
            .opacity(enabled ? 1 : 0.7)
    }
}
