import AVFoundation
import CoreAudio
import Foundation

/// A wrapper around the native MIDI player.
public class Synthesizer {
    private let engine: AVAudioEngine
    private var sampler = AVAudioUnitSampler()
    private let midiVelocity: UInt8 = 127
    private let midiChannel: MIDIChannelNumber = 0
    
    public init() throws {
        engine = AVAudioEngine()
        
        engine.attach(sampler)
        engine.connect(sampler, to: engine.outputNode, format: engine.inputNode.inputFormat(forBus: 0))
        
        print("Starting engine")
        try engine.start()
        
    }
    
    public func start(note: Note) throws {
        let midiNote = note.midiNumber
        print("Playing \(note)")
        sampler.startNote(midiNote, withVelocity: midiVelocity, onChannel: midiChannel)
    }
    
    public func stop(note: Note) throws {
        sampler.stopNote(note.midiNumber, onChannel: midiChannel)
    }
    
//    private func musicSequenceOf(track: Track) -> MusicSequence {
//        // TODO
//    }
    
    public func play(track: Track, progress: (Int) -> Void) throws {
        // TODO
    }
}
