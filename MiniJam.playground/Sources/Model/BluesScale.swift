/// The hexatonic blues scale.
public struct BluesScale: Scale {
    public let notes: [Note]
    
    public init(key: Note) {
       notes = [
           key,
           key.advanced(by: 3),
           key.advanced(by: 5),
           key.advanced(by: 6),
           key.advanced(by: 7),
           key.advanced(by: 10)
       ]
   }
}
