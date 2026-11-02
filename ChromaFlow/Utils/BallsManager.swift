import SwiftUI

/// 管理球动画的共享逻辑
class BallsManager: ObservableObject {
    @Published var balls: [Ball] = []
    @Published var aliveBalls: [Ball] = []

    private var minBalls: Int
    private var maxBalls: Int

    init(minBalls: Int = 15, maxBalls: Int = 30) {
        self.minBalls = minBalls
        self.maxBalls = maxBalls
    }

    /// 初始化球
    func initializeBalls(in size: CGSize, theme: WallpaperTheme, isBlackMode: Bool) {
        balls.removeAll()
        aliveBalls.removeAll()

        for _ in 0..<minBalls {
            let layer = Int.random(in: 0..<5)
            let depth = CGFloat(layer) / 4
            let ball = Ball.generateBall(
                in: size,
                depth: depth,
                theme: theme,
                isBlackMode: isBlackMode
            )
            balls.append(ball)
            aliveBalls.append(ball)
        }
    }

    /// 更新球的状态和位置
    func updateBalls(in size: CGSize, deltaTime: TimeInterval, theme: WallpaperTheme, isBlackMode: Bool) {
        guard maxBalls > 0 else { return }

        var newAliveBalls = [Ball]()

        // 更新现有球
        for i in balls.indices {
            var ball = balls[i]
            ball.update(deltaTime: deltaTime)

            if ball.isAlive {
                // 更新位置
                let currentVelocity = ball.currentVelocity
                ball.position.x += currentVelocity.x * CGFloat(deltaTime)
                ball.position.y += currentVelocity.y * CGFloat(deltaTime)

                // 边界碰撞检测
                handleBoundaryCollision(&ball, in: size)

                newAliveBalls.append(ball)
            }

            balls[i] = ball
        }

        // 更新球列表
        balls = newAliveBalls
        aliveBalls = newAliveBalls

        // 生成新球
        generateNewBallsIfNeeded(in: size, deltaTime: deltaTime, theme: theme, isBlackMode: isBlackMode)
    }

    /// 处理边界碰撞
    private func handleBoundaryCollision(_ ball: inout Ball, in size: CGSize) {
        let margin = ball.displaySize / 2

        if ball.position.x - margin < 0 {
            ball.position.x = margin
            ball.velocity.x = abs(ball.velocity.x)
        }
        if ball.position.x + margin > size.width {
            ball.position.x = size.width - margin
            ball.velocity.x = -abs(ball.velocity.x)
        }
        if ball.position.y - margin < 0 {
            ball.position.y = margin
            ball.velocity.y = abs(ball.velocity.y)
        }
        if ball.position.y + margin > size.height {
            ball.position.y = size.height - margin
            ball.velocity.y = -abs(ball.velocity.y)
        }
    }

    /// 生成新球
    private func generateNewBallsIfNeeded(in size: CGSize, deltaTime: TimeInterval, theme: WallpaperTheme, isBlackMode: Bool) {
        let currentCount = balls.count
        guard currentCount < maxBalls else { return }

        let baseChance = currentCount < minBalls ? 0.8 : 0.3
        let generateChance = baseChance * deltaTime

        if Double.random(in: 0...1) < generateChance {
            let layer = Int.random(in: 0..<5)
            let depth = CGFloat(layer) / 4
            let newBall = Ball.generateBall(
                in: size,
                depth: depth,
                theme: theme,
                isBlackMode: isBlackMode
            )
            balls.append(newBall)
            aliveBalls.append(newBall)
        }
    }

    /// 更新球的颜色
    func updateBallColors(theme: WallpaperTheme, isBlackMode: Bool) {
        for i in balls.indices {
            balls[i].color = theme.generateBallColor(isBlackMode: isBlackMode)
        }
        aliveBalls = balls
    }

    /// 清空所有球
    func clearBalls() {
        balls.removeAll()
        aliveBalls.removeAll()
    }

    /// 调整球数量限制
    func updateBallLimits(minBalls: Int, maxBalls: Int) {
        self.minBalls = minBalls
        self.maxBalls = maxBalls

        // 如果当前球数超过新的最大值，移除多余的球
        if balls.count > maxBalls {
            balls = Array(balls.prefix(maxBalls))
            aliveBalls = balls
        }
    }
}