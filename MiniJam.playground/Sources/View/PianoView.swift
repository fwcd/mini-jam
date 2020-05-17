import SwiftUI

/// A customizable piano keyboard with the ability to automatically play chords and highlight scales over a given note.
public struct PianoView: View {
    private let notes: [Note]
    private let baseOctave: Int
    private let synthesizer: Synthesizer
    
    private let whiteKeySize: CGSize
    private let blackKeySize: CGSize
    
    @Binding private var chordTemplate: ChordTemplate
    @Binding private var scaleTemplate: ScaleTemplate
    @Binding private var progressionTemplate: ProgressionTemplate
    @Binding private var key: NoteClass
    
    @GestureState private var pressedKey: Note? = nil
    @State private var playingNotes: Set<Note> = []
    private let recorder: Recorder
    
    private var pressedNotes: Set<Note> {
        pressedKey.map { Set(chordTemplate.from(root: $0).notes) } ?? Set()
    }
    private var scale: Scale {
        scaleTemplate.from(key: Note(key, baseOctave))
    }
    
    public init<S>(
        notes: S,
        baseOctave: Int,
        chordTemplate: Binding<ChordTemplate>,
        scaleTemplate: Binding<ScaleTemplate>,
        progressionTemplate: Binding<ProgressionTemplate>,
        key: Binding<NoteClass>,
        recorder: Recorder,
        synthesizer: Synthesizer,
        whiteKeySize: CGSize = CGSize(width: 20, height: 100),
        blackKeySize: CGSize = CGSize(width: 10, height: 80)
    ) where S: Sequence, S.Element == Note {
        self.notes = Array(notes)
        self.baseOctave = baseOctave
        self._chordTemplate = chordTemplate
        self._scaleTemplate = scaleTemplate
        self._progressionTemplate = progressionTemplate
        self._key = key
        self.recorder = recorder
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
        let scaleNoteClasses = Set(scale.notes.map { $0.noteClass })
        let keys = keyBounds.map {
            PianoKeyView(
                note: $0.0,
                size: $0.1.size,
                pressed: playingNotes.contains($0.0),
                enabled: scaleNoteClasses.contains($0.0.noteClass)
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
                        let newPressed = self.keyBounds
                            .filter { $0.1.contains(value.location) }
                            .max(by: compareAscending { $0.0.hasAccidental ? 1 : 0 })?.0
                        // Only update the pressed state if we are not on a key that does not belong to the current scale
                        if newPressed.map({ self.scale.notes.map { $0.noteClass }.contains($0.noteClass) }) ?? true {
                            state = newPressed
                        }
                    }
                    .onChanged { _ in
                        DispatchQueue.global().async {
                            self.updatePlaying()
                        }
                    }
                    .onEnded { _ in
                        self.stop()
                    }
            )
    }
    
    /// Plays (and possibly records) the pressed notes to the speaker using the synthesizer.
    private func updatePlaying() {
        do {
            let notes = pressedNotes
            if notes != playingNotes {
                stop()
                for note in notes {
                    try synthesizer.start(note: note)
                    if recorder.isRecording {
                        recorder.start(note: note)
                    }
                }
                playingNotes = notes
            }
        } catch {
            print("Could not play notes using synthesizer: \(error)")
        }
    }
    
    /// Stops playing the pressed notes to the speaker using the synthesizer.
    private func stop() {
        do {
            for note in playingNotes {
                try synthesizer.stop(note: note)
                if recorder.isRecording {
                    recorder.stop(note: note)
                }
            }
            playingNotes = []
        } catch {
            print("Could not stpo notes using synthesizer: \(error)")
        }
    }
}
