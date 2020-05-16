extension Array {
    /// Performs a "running reduce" on the array.
    public func scan<R>(_ base: R, _ accumulator: (R, Element) -> R) -> [R] {
        var result = [R]()
        for elem in self {
            result.append(accumulator(result.last ?? base, elem))
        }
        return result
    }
    
    /// Performs a "running reduce" on the array with at least one element in the array.
    public func scan1<R>(_ initializer: (Element) -> R, _ accumulator: (R, Element) -> R) -> [R] {
        guard let f = first else { return [] }
        var result = [initializer(f)]
        for elem in dropFirst() {
            result.append(accumulator(result.last!, elem))
        }
        return result
    }
}
