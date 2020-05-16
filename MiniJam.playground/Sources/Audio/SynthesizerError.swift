import Foundation

public enum SynthesizerError: Error {
    case couldNotCreateGraph(Int32)
    case couldNotCreateIoNode(Int32)
    case couldNotCreateSynthNode(Int32)
    case couldNotOpenGraph(Int32)
    case couldNotCloseGraph(Int32)
    case couldNotInitializeGraph(Int32)
    case couldNotStartGraph(Int32)
    case couldNotStopGraph(Int32)
    case couldNotConnectGraph(Int32)
    case midiError(Int32)
    case invalidNote(String)
}
