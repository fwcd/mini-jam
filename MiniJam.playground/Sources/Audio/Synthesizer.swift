import AVFoundation
import CoreAudio
import Foundation

/// A wrapper around the native MIDI player.
public class Synthesizer {
    // Based on the tutorial https://rollout.io/blog/building-a-midi-music-app-for-ios-in-swift/
    
    private let engine: AVAudioEngine
    private var sampler = AVAudioUnitSampler()
    private let midiVelocity: UInt8 = 127
    private let midiChannel: MIDIChannelNumber = 0
    
    private var playingMidiNote: UInt8? = nil
    
    public init() throws {
        engine = AVAudioEngine()
        
        engine.attach(sampler)
        engine.connect(sampler, to: engine.outputNode, format: engine.inputNode.inputFormat(forBus: 0))
        
        print("Starting engine")
        try engine.start()
        
    }
    
    public func start(note: Note, ignorePlaying: Bool = false) throws {
        let midiNote = note.midiNumber
        if ignorePlaying || midiNote != playingMidiNote {
            if !ignorePlaying {
                try stop()
            }
            print("Playing \(note)")
            sampler.startNote(midiNote, withVelocity: midiVelocity, onChannel: midiChannel)
            playingMidiNote = midiNote
        }
    }
    
    public func stop(note: Note? = nil) throws {
        if let midiNote = note?.midiNumber ?? playingMidiNote {
            sampler.stopNote(midiNote, onChannel: midiChannel)
            playingMidiNote = nil
        }
    }
    
//    private func musicSequenceOf(track: Track) -> MusicSequence {
//        // TODO
//    }
    
    public func play(track: Track, progress: (Int) -> Void) throws {
        // TODO
    }
}
