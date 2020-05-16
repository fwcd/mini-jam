import AVFoundation
import CoreAudio
import Foundation

/// A wrapper around the native MIDI player.
public class Synthesizer {
    // Based on the tutorial https://rollout.io/blog/building-a-midi-music-app-for-ios-in-swift/
    
    private var sampler = AVAudioUnitSampler()
    private let midiVelocity: UInt8 = 127
    private let midiChannel: MIDIChannelNumber = 0
    
    private var lastMidiNote: UInt8? = nil
    private let player = AVAudioPlayerNode()
    
    public init(sampleURLs: [URL]) throws {
        let engine = AVAudioEngine()
        
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        try sampler.loadAudioFiles(at: sampleURLs)
        engine.prepare()
        try engine.start()
        
    }
    
    public func start(note: Note) throws {
        let midiNote = note.midiNumber
        sampler.startNote(midiNote, withVelocity: midiVelocity, onChannel: midiChannel)
        lastMidiNote = midiNote
    }
    
    public func stop() throws {
        print("Stopping playback")
        if let midiNote = lastMidiNote {
            sampler.stopNote(midiNote, onChannel: midiChannel)
        }
    }
    
//    private func musicSequenceOf(track: Track) -> MusicSequence {
//        // TODO
//    }
    
    public func play(track: Track, progress: (Int) -> Void) throws {
        // TODO
    }
}
