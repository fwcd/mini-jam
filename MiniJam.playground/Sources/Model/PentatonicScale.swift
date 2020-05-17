public struct PentatonicScale: Scale {
    public let notes: [Note]
    
    public init(key: Note) {
       notes = [
           key,
           key.advanced(by: 2),
           key.advanced(by: 4),
           key.advanced(by: 7),
           key.advanced(by: 9)
       ]
   }
}
