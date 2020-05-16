import AudioToolbox

private func runCatching(_ error: (Int32) -> SynthesizerError, _ action: () -> Int32) throws {
    let status = action()
    guard status == OSStatus(noErr) else { throw error(status) }
}

/// A wrapper around the native MIDI player.
public struct Synthesizer {
    // Based on the tutorial https://rollout.io/blog/building-a-midi-music-app-for-ios-in-swift/
    
    private var graph: AUGraph!
    private var synthNode = AUNode()
    private var ioNode = AUNode()
    private var synthUnit: AudioUnit!
    
    public init() throws {
        try runCatching(SynthesizerError.couldNotCreateGraph) {
            NewAUGraph(&graph)
        }
        
        try runCatching(SynthesizerError.couldNotCreateIoNode) {
            var ioDescription = AudioComponentDescription(
                componentType: OSType(kAudioUnitType_Output),
                componentSubType: OSType(kAudioUnitSubType_DefaultOutput), // use RemoteIO on iOS
                componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
                componentFlags: 0,
                componentFlagsMask: 0
            )
            return AUGraphAddNode(graph, &ioDescription, &ioNode)
        }
        
        try runCatching(SynthesizerError.couldNotCreateSynthNode) {
            var synthDescription = AudioComponentDescription(
                componentType: OSType(kAudioUnitType_MusicDevice),
                componentSubType: OSType(kAudioUnitSubType_Sampler),
                componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
                componentFlags: 0,
                componentFlagsMask: 0
            )
            return AUGraphAddNode(graph, &synthDescription, &synthNode)
        }
    }
    
    public func play(note: Note) throws {
        let midiNote = note.midiNumber
        let midiVelocity: UInt32 = 64
        
        guard midiNote >= 0 && midiNote < 128 else {
            throw SynthesizerError.invalidNote("Node \(note)'s MIDI value \(midiNote) is outside of the MIDI range!")
        }
        
        try runCatching(SynthesizerError.midiError) {
            MusicDeviceMIDIEvent(synthUnit, UInt32(0x90), UInt32(midiNote), midiVelocity, 0)
        }
    }
    
//    private func musicSequenceOf(track: Track) -> MusicSequence {
//        // TODO
//    }
    
    public func play(track: Track, progress: (Int) -> Void) throws {
        // TODO
    }
}
