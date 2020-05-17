import Combine

public class Player: ObservableObject {
    private let synthesizer: Synthesizer
    private let cancellable: AnyCancellable?
    @Published public var time: Double
    
    public init() {
        let timer =
        cancellable = timer.connect() as! AnyCancellable
    }
    
    deinit {
        cancel()
    }
    
    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    public func start() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.time += 1 }
    }
}
