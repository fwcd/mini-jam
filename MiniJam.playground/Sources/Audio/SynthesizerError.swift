import Foundation

public enum SynthesizerError: Error {
    case couldNotCreateGraph(Int32)
    case couldNotCreateIoNode(Int32)
    case couldNotCreateSynthNode(Int32)
    case midiError(Int32)
    case invalidNote(String)
}
