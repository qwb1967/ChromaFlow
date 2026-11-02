import SwiftUI

struct Ball: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var color: Color
    var depth: CGFloat
    var lifePhase: CGFloat
    let lifeDuration: CGFloat
    let fadeRatio: CGFloat = 0.2
    
    // 使用一个类来处理缓存
    private class Cache {
        var displaySize: CGFloat?
        var blurRadius: CGFloat?
        var displayColor: Color?
        var lastPhase: CGFloat = 0
    }
    private let cache = Cache()
    
    var isAlive: Bool {
        lifePhase < 1.0
    }
    
    var fadeOpacity: CGFloat {
        if lifePhase < fadeRatio {
            // 淡入阶段
            return lifePhase / fadeRatio
        } else if lifePhase > (1.0 - fadeRatio) {
            // 淡出阶段
            return (1.0 - lifePhase) / fadeRatio
        }
        // 正常显示阶段
        return 1.0
    }
    
    var speedFactor: CGFloat {
        if lifePhase > (1.0 - fadeRatio) {
            // 在淡出阶段，速度逐渐减慢
            return (1.0 - lifePhase) / fadeRatio
        }
        return 1.0
    }
    
    var currentScale: CGFloat {
        1.0  // 移除呼吸效果，保持固定大小
    }
    
    var displaySize: CGFloat {
        if cache.displaySize == nil || cache.lastPhase != lifePhase {
            cache.displaySize = size * (0.3 + depth * 0.7)
            cache.lastPhase = lifePhase
        }
        return cache.displaySize!
    }
    
    var blurRadius: CGFloat {
        if cache.blurRadius == nil || cache.lastPhase != lifePhase {
            cache.blurRadius = displaySize * (0.2 * (1.0 - depth))
            cache.lastPhase = lifePhase
        }
        return cache.blurRadius!
    }
    
    var displayColor: Color {
        if cache.displayColor == nil || cache.lastPhase != lifePhase {
            cache.displayColor = color.opacity((0.7 + depth * 0.3) * fadeOpacity)
            cache.lastPhase = lifePhase
        }
        return cache.displayColor!
    }
    
    var currentVelocity: CGPoint {
        let scale = currentScale * speedFactor  // 同时考虑呼吸效果和生命周期
        return CGPoint(
            x: velocity.x * scale,
            y: velocity.y * scale
        )
    }
    
    mutating func update(deltaTime: TimeInterval) {
        // 只更新生命周期，移除呼吸效果更新
        lifePhase += CGFloat(deltaTime) / lifeDuration
        
        // 清除缓存
        cache.displaySize = nil
        cache.blurRadius = nil
        cache.displayColor = nil
    }
    
    // 添加预设的颜色主题
    static let colorThemes: [[Color]] = [
        // 蓝紫色系
        [
            Color(red: 0.2, green: 0.6, blue: 0.9),
            Color(red: 0.4, green: 0.3, blue: 0.9),
            Color(red: 0.6, green: 0.4, blue: 1.0)
        ],
        // 粉色系
        [
            Color(red: 1.0, green: 0.4, blue: 0.6),
            Color(red: 0.9, green: 0.3, blue: 0.5),
            Color(red: 1.0, green: 0.5, blue: 0.7)
        ],
        // 绿色系
        [
            Color(red: 0.3, green: 0.8, blue: 0.5),
            Color(red: 0.4, green: 0.9, blue: 0.4),
            Color(red: 0.2, green: 0.7, blue: 0.6)
        ],
        // 橙色系
        [
            Color(red: 1.0, green: 0.6, blue: 0.2),
            Color(red: 0.9, green: 0.5, blue: 0.3),
            Color(red: 1.0, green: 0.7, blue: 0.4)
        ],
        // 紫色系
        [
            Color(red: 0.7, green: 0.3, blue: 0.9),
            Color(red: 0.6, green: 0.4, blue: 1.0),
            Color(red: 0.8, green: 0.5, blue: 0.9)
        ]
    ]
    
    static func generateRandomColor(depth: CGFloat) -> Color {
        let colorStyle = Int.random(in: 0...10)
        
        switch colorStyle {
        case 0...6:  // 70% 概率使用预设主题
            let theme = colorThemes.randomElement()!
            return theme.randomElement()!
            
        case 7...8:  // 20% 概率使用HSB随机色
            return Color(
                hue: .random(in: 0...1),
                saturation: 0.7 + depth * 0.3,
                brightness: 0.8 + depth * 0.2
            )
            
        default:     // 10% 概率使用渐变混合色
            let color1 = colorThemes.randomElement()!.randomElement()!
            let color2 = colorThemes.randomElement()!.randomElement()!
            let mix = Double.random(in: 0.3...0.7)
            
            // 混合两种颜色
            let uiColor1 = NSColor(color1)
            let uiColor2 = NSColor(color2)
            
            var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
            var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
            
            uiColor1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
            uiColor2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
            
            return Color(
                red: red1 * mix + red2 * (1 - mix),
                green: green1 * mix + green2 * (1 - mix),
                blue: blue1 * mix + blue2 * (1 - mix)
            )
        }
    }
    
    static func generateBall(
        in size: CGSize,
        depth: CGFloat,
        theme: WallpaperTheme,
        isBlackMode: Bool = false
    ) -> Ball {
        // 确保屏幕尺寸有效
        guard size.width > 0, size.height > 0 else {
            // 返回默认球
            return Ball(
                position: CGPoint(x: 100, y: 100),
                velocity: CGPoint(x: 20, y: 20),
                size: 50,
                color: theme.generateBallColor(isBlackMode: isBlackMode),
                depth: depth,
                lifePhase: 0,
                lifeDuration: 30
            )
        }

        let speedFactor = 0.3 + depth * 0.7
        let baseSpeed = CGFloat.random(in: 20...40)  // 降低速度范围
        let speed = baseSpeed * speedFactor

        // 确保球的大小不会超过屏幕
        let maxSize = min(size.width, size.height) * 0.3 // 最大尺寸为屏幕较小边的30%
        let minSize = max(20, maxSize * 0.2)  // 最小尺寸至少20像素
        let baseSize = CGFloat.random(in: minSize...maxSize)

        // 安全的位置计算
        let margin = baseSize / 2
        let minX = max(margin, margin)
        let maxX = max(minX + 1, size.width - margin)  // 确保范围有效
        let minY = max(margin, margin)
        let maxY = max(minY + 1, size.height - margin)  // 确保范围有效

        let position: CGPoint
        if maxX > minX && maxY > minY {
            position = CGPoint(
                x: CGFloat.random(in: minX...maxX),
                y: CGFloat.random(in: minY...maxY)
            )
        } else {
            // 如果空间太小，放在中心
            position = CGPoint(x: size.width / 2, y: size.height / 2)
        }

        // 使用主题颜色
        let color = theme.generateBallColor(isBlackMode: isBlackMode)

        return Ball(
            position: position,
            velocity: CGPoint(
                x: CGFloat.random(in: -speed...speed),
                y: CGFloat.random(in: -speed...speed)
            ),
            size: baseSize,
            color: color,
            depth: depth,
            lifePhase: 0,
            lifeDuration: .random(in: 30...45)
        )
    }
} 
