/// A facility that provides the ability to start and stop playing notes.
public protocol NoteSink {
    func start(note: Note) throws
    
    func stop(note: Note) throws
}
