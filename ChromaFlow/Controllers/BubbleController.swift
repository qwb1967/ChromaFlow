import SwiftUI
import Combine
import CoreVideo
import CoreGraphics
import AppKit

@MainActor
final class BubbleController: ObservableObject {
    @Published private(set) var bubbles: [Bubble] = []
    private var displayLink: CVDisplayLink?
    private var lastTime: CFTimeInterval = 0
    
    init() {
        setupBubbles()
        setupDisplayLink()
    }
    
    deinit {
        if let displayLink = displayLink {
            CVDisplayLinkStop(displayLink)
        }
    }
    
    private func setupDisplayLink() {
        var displayLink: CVDisplayLink?
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        
        let opaqueself = Unmanaged.passUnretained(self).toOpaque()
        
        let callback: CVDisplayLinkOutputCallback = { _, _, _, _, _, opaquePointer in
            let controller = Unmanaged<BubbleController>.fromOpaque(opaquePointer!).takeUnretainedValue()
            Task { @MainActor in
                controller.update()
            }
            return kCVReturnSuccess
        }
        
        CVDisplayLinkSetOutputCallback(displayLink!, callback, opaqueself)
        CVDisplayLinkStart(displayLink!)
        self.displayLink = displayLink
    }
    
    @objc private func update() {
        let now = CACurrentMediaTime()
        let deltaTime = lastTime == 0 ? 1.0/60.0 : now - lastTime
        lastTime = now
        
        let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)
        var updatedBubbles = bubbles
        
        for i in 0..<updatedBubbles.count {
            updatedBubbles[i].move(in: screenSize, deltaTime: deltaTime)
        }
        
        bubbles = updatedBubbles
    }
    
    private func setupBubbles() {
        guard let screen = NSScreen.main else { return }
        let screenSize = screen.visibleFrame.size
        
        var newBubbles: [Bubble] = []
        let baseSize = min(screenSize.width, screenSize.height)
        
        // 生成所有可能的位置网格
        let cols = 6
        let rows = 5
        let cellWidth = screenSize.width / CGFloat(cols)
        let cellHeight = screenSize.height / CGFloat(rows)
        
        var positions = generatePositions(cols: cols, rows: rows)
        positions.shuffle()
        
        // 1. 创建3个最大的球（完全清晰，无光晕）
        for _ in 0..<3 {
            let bubble = createBubble(
                at: getRandomPosition(from: &positions, cellWidth: cellWidth, cellHeight: cellHeight),
                size: baseSize / 4,
                depth: 0.99,
                speedRange: 80...120,
                saturation: 0.9,
                brightness: 1.0,
                type: .largest
            )
            newBubbles.append(bubble)
        }
        
        // 2. 创建5个中大的球（轻微光晕）
        for _ in 0..<5 {
            let bubble = createBubble(
                at: getRandomPosition(from: &positions, cellWidth: cellWidth, cellHeight: cellHeight),
                size: baseSize / 5,
                depth: 0.85,
                speedRange: 60...90,
                saturation: 0.85,
                brightness: 0.95,
                type: .large
            )
            newBubbles.append(bubble)
        }
        
        // 3. 创建5个中等的球（中等光晕）
        for _ in 0..<5 {
            let bubble = createBubble(
                at: getRandomPosition(from: &positions, cellWidth: cellWidth, cellHeight: cellHeight),
                size: baseSize / 6,
                depth: 0.7,
                speedRange: 40...70,
                saturation: 0.8,
                brightness: 0.9,
                type: .medium
            )
            newBubbles.append(bubble)
        }
        
        // 4. 创建2个最小的球（大光晕）
        for _ in 0..<2 {
            let bubble = createBubble(
                at: getRandomPosition(from: &positions, cellWidth: cellWidth, cellHeight: cellHeight),
                size: baseSize / 8,
                depth: 0.5,
                speedRange: 20...40,
                saturation: 0.75,
                brightness: 0.85,
                type: .small
            )
            newBubbles.append(bubble)
        }
        
        // 添加一些清晰的球（完全不透明，无光晕）
        for _ in 0..<4 {
            let bubble = createBubble(
                at: getRandomPosition(from: &positions, cellWidth: cellWidth, cellHeight: cellHeight),
                size: baseSize * CGFloat.random(in: 0.15...0.25), // 随机大小
                depth: 0.95,
                speedRange: 40...80,  // 中等速度
                saturation: 0.9,
                brightness: 1.0,
                type: .clear
            )
            newBubbles.append(bubble)
        }
        
        bubbles = newBubbles
    }
    
    private func generatePositions(cols: Int, rows: Int) -> [(x: Int, y: Int)] {
        var positions: [(x: Int, y: Int)] = []
        for row in 0..<rows {
            for col in 0..<cols {
                positions.append((col, row))
            }
        }
        return positions
    }
    
    private func getRandomPosition(from positions: inout [(x: Int, y: Int)], cellWidth: CGFloat, cellHeight: CGFloat) -> CGPoint {
        let index = Int.random(in: 0..<positions.count)
        let (col, row) = positions.remove(at: index)
        return CGPoint(
            x: cellWidth * (CGFloat(col) + CGFloat.random(in: 0.2...0.8)),
            y: cellHeight * (CGFloat(row) + CGFloat.random(in: 0.2...0.8))
        )
    }
    
    private func createBubble(
        at position: CGPoint,
        size: CGFloat,
        depth: CGFloat,
        speedRange: ClosedRange<CGFloat>,
        saturation: CGFloat,
        brightness: CGFloat,
        type: BubbleType
    ) -> Bubble {
        let angle = CGFloat.random(in: 0...(2 * .pi))
        let speed = CGFloat.random(in: speedRange)
        let velocity = CGPoint(
            x: cos(angle) * speed,
            y: sin(angle) * speed
        )
        
        let hue = CGFloat.random(in: 0...1)
        let color = Color(
            hue: hue,
            saturation: saturation,
            brightness: brightness
        )
        
        return Bubble(
            position: position,
            velocity: velocity,
            size: size * CGFloat.random(in: 0.95...1.0),
            baseColor: color,
            depth: depth,
            type: type
        )
    }
} 
