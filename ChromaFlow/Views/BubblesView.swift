import SwiftUI

struct BubblesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHoveringCloseButton = false
    @State private var balls = [Ball]()
    @State private var lastTime = Date()
    @StateObject private var displayLink = DisplayLinkController()
    @State private var isActive = false

    // 根据省电模式动态调整球的数量
    private var minBalls: Int {
        themeManager.isPowerSaveMode ? 10 : 15
    }
    private var maxBalls: Int {
        themeManager.isPowerSaveMode ? 20 : 30
    }

    // 修改帧率控制
    private var frameInterval: Int {
        themeManager.isPowerSaveMode ? 2 : 1  // 省电模式下每2帧更新一次（约30fps），正常模式每帧更新（60fps）
    }
    @State private var frameCount = 0
    @State private var accumulatedTime: TimeInterval = 0  // 添加时间累积器

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 只显示活着的球
                ForEach(balls.filter(\.isAlive)) { ball in
                    Circle()
                        .fill(ball.displayColor)
                        .frame(width: ball.displaySize, height: ball.displaySize)
                        .blur(radius: ball.blurRadius)
                        .position(ball.position)
                }
            }
            .onAppear {
                isActive = true
                // 启动计时器
                displayLink.start()
                // 初始化球
                initializeBalls(in: geometry.size)
            }
            .onDisappear {
                isActive = false
                // 停止计时器
                displayLink.stop()
                // 清除所有球
                balls.removeAll()
            }
            .onChange(of: themeManager.currentTheme) { oldTheme, newTheme in
                guard isActive else { return }
                // 清除所有现有的球
                balls.removeAll()
                // 重新初始化新主题的球
                initializeBalls(in: geometry.size)
            }
            .onChange(of: themeManager.isBlackMode) { oldValue, newValue in
                // 更新所有球的颜色
                for i in balls.indices {
                    var ball = balls[i]
                    ball.color = themeManager.currentTheme.generateBallColor(
                        isBlackMode: themeManager.isBlackMode
                    )
                    balls[i] = ball
                }
            }
            .onChange(of: themeManager.isPowerSaveMode) { oldValue, newValue in
                // 果开启省电模式，少球的数量
                if themeManager.isPowerSaveMode && balls.count > maxBalls {
                    balls = Array(balls.prefix(maxBalls))
                }
            }
            .onChange(of: colorScheme) { oldValue, newValue in
                // 检查是否是自动模式或自动黑色模式
                if themeManager.appearanceMode == .auto || themeManager.appearanceMode == .autoBlack {
                    // 更新所有球的颜色
                    for i in balls.indices {
                        var ball = balls[i]
                        ball.color = themeManager.currentTheme.generateBallColor(
                            isBlackMode: themeManager.isBlackMode
                        )
                        balls[i] = ball
                    }
                    // 重新生成静态壁纸
                    DispatchQueue.main.async {
                        if let existingWindow = WallpaperManager.wallpaperWindow,
                           let mainScreen = NSScreen.main {
                            // 更新现有窗口的内容
                            autoreleasepool {
                                let contentView = NSHostingView(rootView:
                                    BubblesView()
                                        .environmentObject(ThemeManager.shared)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                )
                                contentView.frame = mainScreen.frame
                                existingWindow.contentView = contentView
                            }

                            // 重新生成并设置静态壁纸
                            WallpaperManager.createAndSetStaticWallpaper(for: mainScreen)
                        }
                    }
                }
            }
            .onReceive(displayLink.timer) { time in
                guard isActive else { return }
                
                let currentDelta = time.timeIntervalSince(lastTime)
                accumulatedTime += currentDelta
                frameCount += 1
                
                // 省电模式下只在特定帧更新
                if frameCount % frameInterval == 0 {
                    updateBalls(in: geometry.size, deltaTime: accumulatedTime)
                    accumulatedTime = 0  // 重置累积时间
                }
                
                lastTime = time
            }
        }
        .background(Color.clear)
    }

    private func initializeBalls(in size: CGSize) {
        // 初始化球，生成最小数量的球
        for _ in 0..<minBalls {
            let layer = Int.random(in: 0..<5)
            let depth = CGFloat(layer) / 4
            balls.append(Ball.generateBall(
                in: size,
                depth: depth,
                theme: themeManager.currentTheme,
                isBlackMode: themeManager.isBlackMode
            ))
        }
    }

    private func updateBalls(in size: CGSize, deltaTime: TimeInterval) {
        // 更新现有球的位置
        for i in balls.indices {
            var ball = balls[i]
            
            // 更新生命周期
            ball.update(deltaTime: deltaTime)
            
            if ball.isAlive {
                let currentVelocity = ball.currentVelocity
                ball.position.x += currentVelocity.x * CGFloat(deltaTime)
                ball.position.y += currentVelocity.y * CGFloat(deltaTime)
                
                // 边界检查和反弹
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
            
            balls[i] = ball
        }

        // 移除死亡的球
        balls.removeAll(where: { !$0.isAlive })

        // 根据当前的数量决定是否添加新球
        let currentCount = balls.count
        if currentCount < maxBalls {
            // 改球的生成逻辑，降低生成概率但保持合理范围
            let baseChance = currentCount < minBalls ?
                (themeManager.isPowerSaveMode ? 0.6 : 0.8) :
                (themeManager.isPowerSaveMode ? 0.2 : 0.3)
            let generateChance = baseChance * deltaTime

            if Double.random(in: 0...1) < generateChance {
                let layer = Int.random(in: 0..<5)
                let depth = CGFloat(layer) / 4
                balls.append(Ball.generateBall(
                    in: size,
                    depth: depth,
                    theme: themeManager.currentTheme,
                    isBlackMode: themeManager.isBlackMode
                ))
            }
        }
    }
}

#Preview {
    BubblesView()
        .frame(width: 800, height: 600)
}

