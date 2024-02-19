import Foundation

public class Debounce<T> {
    private let block: @Sendable (T) async -> Void
    private let duration: ContinuousClock.Duration
    private var task: Task<Void, Never>?
    
    public init(
        duration: ContinuousClock.Duration,
        block: @Sendable @escaping (T) async -> Void
    ) {
        self.duration = duration
        self.block = block
    }
    
    public func emit(value: T) {
        task?.cancel()
        task = Task { [duration, block] in
            do {
                try await Task.sleep(for: duration)
                await block(value)
            } catch {}
        }
    }
}
