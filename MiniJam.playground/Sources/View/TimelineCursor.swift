import SwiftUI

public struct TimelineCursor: Shape {
    private let thickness: CGFloat = 1
    
    public func path(in rect: CGRect) -> Path {
        Path {
            let centerX = (rect.maxX + rect.minX) / 2
            let knobWidth = rect.maxX - rect.minX
            let knobBezelHeight = knobWidth / 4
            let knobRestHeight = knobWidth / 2
            let knobHeight = knobBezelHeight + knobRestHeight
            $0.move(to: CGPoint(x: rect.minX, y: rect.minY))
            $0.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            $0.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + knobBezelHeight))
            $0.addLine(to: CGPoint(x: centerX + thickness, y: rect.minY + knobHeight))
            $0.addLine(to: CGPoint(x: centerX + thickness, y: rect.maxY))
            $0.addLine(to: CGPoint(x: centerX - thickness, y: rect.maxY))
            $0.addLine(to: CGPoint(x: centerX - thickness, y: rect.minY + knobHeight))
            $0.addLine(to: CGPoint(x: rect.minX, y: rect.minY + knobBezelHeight))
            $0.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
    }
}
