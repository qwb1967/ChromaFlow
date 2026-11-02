import SwiftUI

struct Bubble {
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var color: Color
    var depth: CGFloat
    let baseColor: Color
    let type: BubbleType
    var isFixed: Bool  // 是否是固定位置的球
    
    init(position: CGPoint, velocity: CGPoint, size: CGFloat, baseColor: Color, depth: CGFloat, type: BubbleType, isFixed: Bool = false) {
        self.position = position
        self.velocity = velocity
        self.size = size
        self.baseColor = baseColor
        self.color = baseColor
        self.depth = depth
        self.type = type
        self.isFixed = isFixed
    }
    
    mutating func move(in bounds: CGSize, deltaTime: TimeInterval) {
        // 如果是固定位置的球，不进行移动
        guard !isFixed else { return }
        
        // 更新位置
        position.x += velocity.x * CGFloat(deltaTime)
        position.y += velocity.y * CGFloat(deltaTime)
        
        // 边界碰撞
        let margin: CGFloat = size * 0.5
        
        if position.x - margin < 0 {
            position.x = margin
            velocity.x = abs(velocity.x)
        }
        if position.x + margin > bounds.width {
            position.x = bounds.width - margin
            velocity.x = -abs(velocity.x)
        }
        if position.y - margin < 0 {
            position.y = margin
            velocity.y = abs(velocity.y)
        }
        if position.y + margin > bounds.height {
            position.y = bounds.height - margin
            velocity.y = -abs(velocity.y)
        }
    }
} 