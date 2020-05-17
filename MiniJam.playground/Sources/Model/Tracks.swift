import Combine

/// An observable multi-track project.
public class Tracks: ObservableObject {
    @Published public var tracks: [Track] = []
    private var currentID: Int = 0
    
    public init() {}
    
    public func nextID() -> Int {
        let id = currentID
        currentID += 1
        return id
    }
}
