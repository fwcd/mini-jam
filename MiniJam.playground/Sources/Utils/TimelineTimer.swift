import Combine
import Foundation

/// A timer that provides a conveniently observable time.
public class TimelineTimer: ObservableObject {
    private let interval: TimeInterval
    private var cancellables: [AnyCancellable] = []
    
    @Published public var time: TimeInterval = 0
    
    public init(interval: TimeInterval = 0.05) {
        self.interval = interval
    }
    
    public func stop() {
        cancellables = []
    }
    
    public func start() {
        let startTime = time
        let startTimestamp = Date()
        
        stop()
        
        let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
        cancellables.append(timer.sink { time in
            self.time = startTime + time.timeIntervalSince(startTimestamp)
        })
    }
}
