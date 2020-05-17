import SwiftUI

/// The main view of the application. Stores most of the application's state.
public struct MiniJamView: View {
    private static let playerSynth = try! Synthesizer()
    private static let pianoSynth = try! Synthesizer()
    private static let baseOctave: Int = 4
    
    @State private var autoChord: ChordTemplate = .none
    @State private var progression: ProgressionTemplate = .none
    @State private var scale: ScaleTemplate = .chromatic
    @State private var key: NoteClass = .c
    
    @ObservedObject private var timelineTimer: TimelineTimer
    @ObservedObject private var tracks: Tracks
    @ObservedObject private var player: Player
    @ObservedObject private var recorder: Recorder
    
    public init() {
        let timelineTimer = TimelineTimer()
        let tracks = Tracks()
        
        self.timelineTimer = timelineTimer
        self.tracks = tracks
        recorder = Recorder(tracks: tracks, timelineTimer: timelineTimer)
        player = Player(tracks: tracks, timelineTimer: timelineTimer, synthesizer: Self.playerSynth)
    }

    public var body: some View {
        VStack(spacing: 20) {
            Text("MiniJam")
                .font(.title)
                .fontWeight(.light)
            TimelineView(
                tracks: $tracks.tracks,
                recordingTrack: $recorder.track,
                isPlaying: $player.isPlaying,
                isRecording: $recorder.isRecording,
                moverCount: $timelineTimer.moverCount,
                time: $timelineTimer.time
            )
            PianoView(
                notes: Note(.c, Self.baseOctave)..<Note(.c, Self.baseOctave + 2),
                baseOctave: Self.baseOctave,
                chordTemplate: $autoChord,
                scaleTemplate: $scale,
                progressionTemplate: $progression,
                key: $key,
                recorder: recorder,
                synthesizer: Self.pianoSynth,
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
