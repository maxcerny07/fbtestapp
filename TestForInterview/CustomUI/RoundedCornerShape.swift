//
//  RoundedCornerShape.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import SwiftUI

struct RoundedCornerShape: Shape {
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        // Start top-left
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        
        // Top edge
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(withCenter: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
                    radius: topRight,
                    startAngle: .pi * 1.5,
                    endAngle: 0,
                    clockwise: true)
        
        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(withCenter: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
                    radius: bottomRight,
                    startAngle: 0,
                    endAngle: .pi / 2,
                    clockwise: true)
        
        // Bottom edge
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(withCenter: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft),
                    radius: bottomLeft,
                    startAngle: .pi / 2,
                    endAngle: .pi,
                    clockwise: true)
        
        // Left edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(withCenter: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
                    radius: topLeft,
                    startAngle: .pi,
                    endAngle: .pi * 1.5,
                    clockwise: true)
        
        path.close()
        return Path(path.cgPath)
    }
}
