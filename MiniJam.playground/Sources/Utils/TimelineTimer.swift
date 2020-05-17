import Combine
import Foundation

/// A timer that provides a conveniently observable time.
public class TimelineTimer: ObservableObject {
    private let interval: TimeInterval
    private var cancellables: [AnyCancellable] = []
    
    /// Tracks, how many "actors" are currently moving the time (e.g. an automated timer, a dragging user, ...)
    @Published public var moverCount: Int = 0
    @Published public var time: TimeInterval = 0
    
    public init(interval: TimeInterval = 0.05) {
        self.interval = interval
    }
    
    public func stop() {
        moverCount -= cancellables.count
        cancellables = []
    }
    
    public func start() {
        let startTime = time
        let startTimestamp = Date()
        
        stop()
        
        let timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
        moverCount += 1
        cancellables.append(timer.sink { time in
            self.time = startTime + time.timeIntervalSince(startTimestamp)
        })
    }
}
