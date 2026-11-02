//
//  ContentView.swift
//  ChromaFlow
//
//  Created by 钱文博 on 2024/12/22.
//

import SwiftUI
import Combine

// 主题枚举
enum WallpaperTheme: String, CaseIterable {
    case colorful = "colorful"
    case green = "green"
    case yellow = "yellow"
    case orange = "orange"
    case red = "red"
    case purple = "purple"
    case blue = "blue"
    case warmSilver = "warmSilver"
    case coolSilver = "coolSilver"

    var localizedName: String {
        switch self {
        case .colorful: return NSLocalizedString("theme.colorful", comment: "")
        case .green: return NSLocalizedString("theme.green", comment: "")
        case .yellow: return NSLocalizedString("theme.yellow", comment: "")
        case .orange: return NSLocalizedString("theme.orange", comment: "")
        case .red: return NSLocalizedString("theme.red", comment: "")
        case .purple: return NSLocalizedString("theme.purple", comment: "")
        case .blue: return NSLocalizedString("theme.blue", comment: "")
        case .warmSilver: return NSLocalizedString("theme.warmSilver", comment: "")
        case .coolSilver: return NSLocalizedString("theme.coolSilver", comment: "")
        }
    }
    
    var colors: [Color] {
        switch self {
        case .colorful:
            return [
                Color(red: 0.2, green: 0.6, blue: 0.9),
                Color(red: 0.3, green: 0.8, blue: 0.7)
            ]
        case .green:
            return [
                Color(red: 0.3, green: 0.8, blue: 0.4),
                Color(red: 0.2, green: 0.6, blue: 0.3)
            ]
        case .yellow:
            return [
                Color(red: 0.9, green: 0.8, blue: 0.3),
                Color(red: 0.8, green: 0.7, blue: 0.2)
            ]
        case .orange:
            return [
                Color(red: 0.9, green: 0.6, blue: 0.2),
                Color(red: 0.8, green: 0.4, blue: 0.1)
            ]
        case .red:
            return [
                Color(red: 0.9, green: 0.3, blue: 0.3),
                Color(red: 0.8, green: 0.2, blue: 0.2)
            ]
        case .purple:
            return [
                Color(red: 0.7, green: 0.3, blue: 0.9),
                Color(red: 0.6, green: 0.2, blue: 0.8)
            ]
        case .blue:
            return [
                Color(red: 0.3, green: 0.5, blue: 0.9),
                Color(red: 0.2, green: 0.4, blue: 0.8)
            ]
        case .warmSilver:
            return [
                Color(red: 0.9, green: 0.9, blue: 0.85),
                Color(red: 0.8, green: 0.8, blue: 0.75)
            ]
        case .coolSilver:
            return [
                Color(red: 0.85, green: 0.85, blue: 0.9),
                Color(red: 0.75, green: 0.75, blue: 0.8)
            ]
        }
    }
    
    // 添加预览球的固定颜色
    var previewBallColors: [Color] {
        switch self {
        case .colorful:
            return [
                Color(hue: 0.6, saturation: 0.8, brightness: 0.9),   // 蓝色
                Color(hue: 0.3, saturation: 0.8, brightness: 0.9),   // 绿色
                Color(hue: 0.9, saturation: 0.8, brightness: 0.9)    // 紫色
            ]
        case .green:
            return [
                Color(red: 0.4, green: 0.9, blue: 0.5),
                Color(red: 0.3, green: 0.8, blue: 0.4),
                Color(red: 0.5, green: 0.7, blue: 0.4)
            ]
        case .yellow:
            return [
                Color(red: 0.9, green: 0.8, blue: 0.3),
                Color(red: 0.8, green: 0.7, blue: 0.2)
            ]
        case .orange:
            return [
                Color(red: 0.9, green: 0.6, blue: 0.2),
                Color(red: 0.8, green: 0.4, blue: 0.1)
            ]
        case .red:
            return [
                Color(red: 0.9, green: 0.3, blue: 0.3),
                Color(red: 0.8, green: 0.2, blue: 0.2)
            ]
        case .purple:
            return [
                Color(red: 0.7, green: 0.3, blue: 0.9),
                Color(red: 0.6, green: 0.2, blue: 0.8)
            ]
        case .blue:
            return [
                Color(red: 0.3, green: 0.5, blue: 0.9),
                Color(red: 0.2, green: 0.4, blue: 0.8)
            ]
        case .warmSilver:
            return [
                Color(red: 0.9, green: 0.9, blue: 0.85),
                Color(red: 0.8, green: 0.8, blue: 0.75)
            ]
        case .coolSilver:
            return [
                Color(red: 0.85, green: 0.85, blue: 0.9),
                Color(red: 0.75, green: 0.75, blue: 0.8)
            ]
        }
    }
    
    // 添加球的颜色生成函数
    func generateBallColor(isBlackMode: Bool = false) -> Color {
        switch self {
        case .colorful:  // 多彩主题：随机生成各种颜色
            return Color(
                hue: .random(in: 0...1),
                saturation: .random(in: 0.7...0.9),
                brightness: .random(in: 0.8...1.0)
            )
        default:  // 其他主题
            if isBlackMode {
                // 在黑色背景模式下使用主题颜色
                let themeColors = colors
                return themeColors.randomElement() ?? .white
            } else {
                // 普通模式使用白色，随机透明度
                return Color.white.opacity(.random(in: 0.3...0.6))
            }
        }
    }
    
    func colors(isDark: Bool, isBlackMode: Bool = false) -> [Color] {
        if isBlackMode {
            // 纯黑色背景
            return [Color.black, Color.black]
        }
        
        let baseColors = colors
        if isDark {
            // 深色模式下降低亮度
            return baseColors.map { color in
                var hue: CGFloat = 0
                var saturation: CGFloat = 0
                var brightness: CGFloat = 0
                var alpha: CGFloat = 0
                
                NSColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
                
                return Color(hue: hue,
                           saturation: saturation,
                           brightness: brightness * 0.6,
                           opacity: alpha)
            }
        }
        return baseColors
    }
}

struct ContentView: View {
    @State private var balls = [Ball]()
    @State private var aliveBalls = [Ball]()  // 缓存活跃的球
    @State private var lastTime = Date()
    @StateObject private var displayLink = DisplayLinkController()
    @StateObject private var themeManager = ThemeManager.shared
    @State private var isHoveringCloseButton = false
    @State private var previewTheme: WallpaperTheme = ThemeManager.shared.currentTheme

    // 修改球数量的常量为可变的
    @State private var minBalls = 15
    @State private var maxBalls = 30
    
    // 修改清除球的方法
    func clearBalls() {
        print("Clearing balls, current count: \(balls.count)")
        // 将最小和最大球数设为0，防止生成新球
        minBalls = 0
        maxBalls = 0
        // 清空所有球
        balls.removeAll()
        // 重置最后更新时间
        lastTime = Date()
        print("Balls cleared, new count: \(balls.count)")
    }
    
    // 添加一个视图销毁时的清理方法
    private func cleanup() {
        // 先停止生成新球
        minBalls = 0
        maxBalls = 0
        // 清空所有球
        balls.removeAll()
        // 停止计时器
        displayLink.stop()
    }
    
    // 添加一个重置球数量的方法
    func resetBallCounts() {
        minBalls = 15
        maxBalls = 30
    }
    
    // 修改启动计时器的方法
    func startDisplayLink() {
        displayLink.start()
    }
    
    // 修改计算属性来根据背景颜色决定文字颜色
    private var appearanceModeTextColor: Color {
        // 检查当前预览主题的背景颜色是否是纯黑色
        let currentColors = previewTheme.colors(
            isDark: themeManager.isDarkMode,
            isBlackMode: themeManager.isBlackMode
        )
        
        // 如果背景是纯黑色（两个颜色都是黑色），使用白色文字
        if currentColors.allSatisfy({ color in
            let components = NSColor(color).cgColor.components ?? []
            return components.count >= 3 && components[0] == 0 && components[1] == 0 && components[2] == 0
        }) {
            return .white
        }
        
        // 其他情况使用黑色文字
        return .black
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景渐变
                LinearGradient(
                    colors: previewTheme.colors(
                        isDark: themeManager.isDarkMode,
                        isBlackMode: themeManager.isBlackMode
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // 显示缓存的活跃球
                ForEach(aliveBalls) { ball in
                    Circle()
                        .fill(ball.displayColor)
                        .frame(width: ball.displaySize, height: ball.displaySize)
                        .blur(radius: ball.blurRadius)
                        .position(ball.position)
                }
                
                // 预览窗口
                VStack {
                    Spacer()
                    
                    // 使用 ScrollView 包装预览窗口行
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(WallpaperTheme.allCases, id: \.self) { theme in
                                // 预览窗口
                                ZStack {
                                    // 背景渐变
                                    LinearGradient(
                                        colors: theme.colors,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    
                                    // 静态的气泡示例
                                    if theme == .colorful {
                                        // 多彩使用不同颜色的球，但透明度在0.3-0.6之间
                                        Circle()
                                            .fill(Color(hue: 0.6, saturation: 0.8, brightness: 0.9).opacity(0.6))  // 蓝色球，透明度0.6
                                            .frame(width: 70, height: 70)
                                            .offset(x: -20, y: -10)
                                        
                                        Circle()
                                            .fill(Color(hue: 0.3, saturation: 0.8, brightness: 0.9).opacity(0.45))  // 绿色球，透明度0.45
                                            .frame(width: 50, height: 50)
                                            .offset(x: 30, y: 20)
                                        
                                        Circle()
                                            .fill(Color(hue: 0.9, saturation: 0.8, brightness: 0.9).opacity(0.3))  // 紫色球，透明度0.3
                                            .frame(width: 40, height: 40)
                                            .offset(x: 10, y: -25)
                                    } else {
                                        // 其他主题使用半透明白色球
                                        Circle()
                                            .fill(Color.white.opacity(0.6))  // 最大的球透明度0.6
                                            .frame(width: 70, height: 70)
                                            .offset(x: -20, y: -10)
                                        
                                        Circle()
                                            .fill(Color.white.opacity(0.45))  // 中等的球透明度0.45
                                            .frame(width: 50, height: 50)
                                            .offset(x: 30, y: 20)
                                        
                                        Circle()
                                            .fill(Color.white.opacity(0.3))  // 最小的球透明度0.3
                                            .frame(width: 40, height: 40)
                                            .offset(x: 10, y: -25)
                                    }
                                }
                                .frame(width: 160, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(previewTheme == theme ? 0.8 : 0.1), lineWidth: previewTheme == theme ? 2 : 1)
                                )
                                .scaleEffect(previewTheme == theme ? 1.15 : 1.0)
                                .offset(y: previewTheme == theme ? -10 : 0)  // 选中时略微上移
                                .zIndex(previewTheme == theme ? 1 : 0)
                                .shadow(color: Color.black.opacity(previewTheme == theme ? 0.3 : 0), radius: 10)
                                .animation(
                                    .spring(
                                        response: 0.3,
                                        dampingFraction: 0.7,
                                        blendDuration: 0
                                    ),
                                    value: previewTheme == theme
                                )
                                .padding(.vertical, 20)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        previewTheme = theme
                                        // 更新所有现有球的颜色
                                        for i in balls.indices {
                                            var ball = balls[i]
                                            ball.color = theme.generateBallColor(
                                                isBlackMode: themeManager.isBlackMode
                                            )
                                            balls[i] = ball
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 100)  // 为底部按钮留
                }
                
                // 设置壁纸按钮 - 使用绝对定位
                HStack(spacing: 20) {
                    // 外观模式切换按钮
                    Menu {
                        ForEach(AppearanceMode.allCases, id: \.self) { mode in
                            Button(action: {
                                themeManager.updateAppearanceMode(mode)
                            }) {
                                HStack {
                                    Image(systemName: mode.icon)
                                    Text(mode.localizedName)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    } label: {
                        HStack {
                            Image(systemName: themeManager.appearanceMode.icon)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white)
                                .font(.system(size: 12))
                            Text(themeManager.appearanceMode.localizedName)
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(6)
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    .frame(width: 100)
                    .tint(.white)
                    
                    // 设置壁纸按钮
                    Button(action: {
                        // 先更新主题，然后在下一个运行循环中设置壁纸
                        // 这样确保 ThemeManager 的更新已经完成
                        themeManager.updateTheme(previewTheme)
                        DispatchQueue.main.async {
                            // 强制刷新静态壁纸
                            if let screen = NSScreen.main {
                                WallpaperManager.createAndSetStaticWallpaper(for: screen)
                            }
                            WallpaperManager.setAsWallpaper()
                        }
                    }) {
                        Text(NSLocalizedString("button.setWallpaper", comment: ""))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        Color.white.opacity(
                                            themeManager.appearanceMode == .black || 
                                            themeManager.appearanceMode == .autoBlack ? 0.3 : 0
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
                .position(
                    x: geometry.size.width / 2 - 40,
                    y: geometry.size.height - 40
                )
            }
            .onAppear {
                // 确保先清除所有现有的球
                balls.removeAll()
                
                // 重置球数量并初始化
                resetBallCounts()
                
                // 启动计时器
                startDisplayLink()
                
                // 初始化球，生成最小数量的球
                for _ in 0..<minBalls {
                    let layer = Int.random(in: 0..<5)
                    let depth = CGFloat(layer) / 4
                    let newBall = Ball.generateBall(
                        in: geometry.size,
                        depth: depth,
                        theme: previewTheme,
                        isBlackMode: themeManager.isBlackMode
                    )
                    balls.append(newBall)
                    aliveBalls.append(newBall)
                }
                previewTheme = themeManager.currentTheme
            }
            .onReceive(displayLink.timer) { time in
                // 如果计时器不应该运行，直接返回
                guard displayLink.isActive else { return }
                // 如果没有球，也不需要更新
                guard !balls.isEmpty else { return }
                
                let deltaTime = time.timeIntervalSince(lastTime)
                updateBalls(in: geometry.size, deltaTime: deltaTime)
                lastTime = time
            }
            .onDisappear {
                cleanup()  // 使用新的清理方法
            }
        }
        .background(Color.black)
    }
    
    
    private func updateBalls(in size: CGSize, deltaTime: TimeInterval) {
        // 如果最大球数为0，直接返回
        guard maxBalls > 0 else { return }

        // 更新现有球
        var newAliveBalls = [Ball]()
        for i in balls.indices {
            var ball = balls[i]
            ball.update(deltaTime: deltaTime)

            if ball.isAlive {
                let currentVelocity = ball.currentVelocity
                ball.position.x += currentVelocity.x * CGFloat(deltaTime)
                ball.position.y += currentVelocity.y * CGFloat(deltaTime)

                // 边界碰撞检测
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

                newAliveBalls.append(ball)
            }

            balls[i] = ball
        }

        // 移除死亡的球并更新活跃球缓存
        balls = newAliveBalls
        aliveBalls = newAliveBalls

        // 当前的数决定添加新球
        let currentCount = balls.count
        if currentCount < maxBalls {
            // 当球数量少于最小值时，加生成概率
            let baseChance = currentCount < minBalls ? 0.8 : 0.3
            let generateChance = baseChance * deltaTime

            if Double.random(in: 0...1) < generateChance {
                let layer = Int.random(in: 0..<5)
                let depth = CGFloat(layer) / 4
                let newBall = Ball.generateBall(
                    in: size,
                    depth: depth,
                    theme: previewTheme,
                    isBlackMode: themeManager.isBlackMode
                )
                balls.append(newBall)
                aliveBalls.append(newBall)
            }
        }
    }
}

// 修改 DisplayLink 控制器
class DisplayLinkController: ObservableObject {
    @Published var timer: Timer.TimerPublisher
    private var timerCancellable: AnyCancellable?
    private var currentFrameRate: Double = 60.0
    private let stateLock = NSLock()  // 添加锁保护状态
    private var _isRunning = false

    private var isRunning: Bool {
        get {
            stateLock.lock()
            defer { stateLock.unlock() }
            return _isRunning
        }
        set {
            stateLock.lock()
            defer { stateLock.unlock() }
            _isRunning = newValue
        }
    }

    init() {
        self.timer = Timer.publish(every: 1/60, on: .main, in: .common)
    }

    func start() {
        stateLock.lock()
        guard !_isRunning else {
            stateLock.unlock()
            return
        }
        _isRunning = true
        stateLock.unlock()

        self.timer = Timer.publish(every: 1/currentFrameRate, on: .main, in: .common)
        self.timerCancellable = AnyCancellable(self.timer.connect())
    }

    func stop() {
        stateLock.lock()
        guard _isRunning else {
            stateLock.unlock()
            return
        }
        _isRunning = false
        let cancellable = timerCancellable
        timerCancellable = nil
        stateLock.unlock()

        cancellable?.cancel()
        // 创建一个的未启动的计时器，但不连接
        self.timer = Timer.publish(every: 1/currentFrameRate, on: .main, in: .common)
    }

    deinit {
        stop()
    }

    func updateFrameRate(_ frameRate: Double) {
        guard frameRate != currentFrameRate else { return }
        currentFrameRate = frameRate

        if isActive {
            stop()
            start()
        }
    }

    // 添加一个方法来检查状态
    var isActive: Bool {
        stateLock.lock()
        defer { stateLock.unlock() }
        return _isRunning && timerCancellable != nil
    }
}

#Preview {
    ContentView()
}
