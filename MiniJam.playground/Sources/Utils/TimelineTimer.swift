import Combine
import Foundation

/// A timer that provides a conveniently observable time.
public class TimelineTimer: ObservableObject {
    private let interval: TimeInterval
    private var cancellables: [AnyCancellable] = []
    
    @Published public var time: TimeInterval = 0
    
    public init(interval: TimeInterval = 0.01) {
        self.interval = interval
    }
    
    public func stop() {
        cancellables = []
    }
    
    public func start() {
        stop()
        
        let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
        let startTimestamp = Date()
        cancellables.append(timer.sink { time in
            self.time = time.timeIntervalSince(startTimestamp)
        })
    }
}
