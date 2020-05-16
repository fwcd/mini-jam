import SwiftUI

extension Shape {
    public func fill<S>(_ fill: S?, stroke: Color?) -> some View where S: ShapeStyle {
        ZStack {
            if fill != nil {
                self.fill(fill!)
            }
            if stroke != nil {
                self.stroke(stroke!)
            }
        }
    }
}
