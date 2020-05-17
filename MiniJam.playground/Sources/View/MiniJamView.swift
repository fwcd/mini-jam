import SwiftUI

public struct MiniJamView: View {
    private static let synthesizer = try! Synthesizer()
    private static let baseOctave: Int = 4
    
    @State private var timelineState: TimelineState = .paused
    @State private var autoChord: ChordTemplate = .none
    @State private var progression: ProgressionTemplate = .none
    @State private var scale: ScaleTemplate = .chromatic
    @State private var key: NoteClass = .c
    @State private var time: CGFloat = 0
    
    @ObservedObject private var tracks: Tracks = Tracks()
    @ObservedObject private var recorder: Recorder = Recorder(tracks: Tracks()) // Dummy
    
    public init() {
        recorder = Recorder(tracks: tracks)
    }

    public var body: some View {
        VStack(spacing: 20) {
            Text("MiniJam")
                .font(.title)
                .fontWeight(.light)
            TimelineView(
                state: $timelineState,
                tracks: $tracks.tracks,
                isRecording: $recorder.isRecording,
                time: $time
            )
            PianoView(
                notes: Note(.c, Self.baseOctave)..<Note(.c, Self.baseOctave + 2),
                baseOctave: Self.baseOctave,
                chordTemplate: $autoChord,
                scaleTemplate: $scale,
                progressionTemplate: $progression,
                key: $key,
                recorder: recorder,
                synthesizer: Self.synthesizer,
                whiteKeySize: CGSize(width: 40, height: 150),
                blackKeySize: CGSize(width: 20, height: 100)
            )
            VStack {
                EnumPicker(selection: $autoChord, label: Text("Auto-Chord"))
                EnumPicker(selection: $scale, label: Text("Scale"))
                EnumPicker(selection: $key, label: Text("Key"))
                // WIP:
                // EnumPicker(selection: $progression, label: Text("Progression"))
            }
                .frame(width: 500, alignment: .leading)
            Text("""
                Tap/drag the keys to play!
                Tip: Pentatonic and blues scales sound great in every key!
                """)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
            .frame(width: 800, height: 600)
    }
}