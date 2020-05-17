/// A facility that provides the ability to start and stop playing notes.
public protocol NoteSink {
    mutating func start(note: Note) throws
    
    mutating func stop(note: Note) throws
}
