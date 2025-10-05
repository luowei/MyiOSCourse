# MyiOSCourse

CSDN iOS 开发实例教程示例代码集合

## 项目简介

这是一个完整的 iOS 开发课程项目，包含了从基础到进阶的多个 iOS 开发示例代码。项目配套了系统的 PPT 教学文档，涵盖了 iOS 开发环境配置、Objective-C 语言基础、常用框架使用、网络编程、绘图、多媒体等多个方面，是 CSDN iOS 开发教程的完整示例代码库。

## 技术栈

- **开发语言**: Objective-C
- **开发工具**: Xcode 5.0+
- **iOS 版本**: iOS 6.0+
- **依赖管理**: CocoaPods
- **第三方库**: AFNetworking
- **框架**: UIKit, CoreAnimation, CoreText, AVFoundation, MapKit, WebKit 等

## 项目特色

- **系统化教学**: 配套完整的 PPT 课程文档
- **实战导向**: 每个示例都是可运行的完整项目
- **循序渐进**: 从基础到进阶，适合初学者
- **工作空间管理**: 使用 Xcode Workspace 管理多个项目

## 项目结构

```
MyiOSCourse/
├── doc/                           # 课程 PPT 文档
│   ├── 1.iOS开发介绍.pptx            # 第1课：iOS 开发介绍
│   ├── 2.IDE介绍.pptx                # 第2课：Xcode IDE 介绍
│   ├── 3.工作空间及项目的创建及配置.pptx # 第3课：项目管理
│   ├── 4.版本控制系统介绍与git搭建、使用.pptx # 第4课：Git 版本控制
│   ├── 5.OC快速入门.pptx             # 第5课：Objective-C 快速入门
│   ├── 6.OC在xcode4.5之后的新语法.pptx # 第6课：OC 新语法特性
│   ├── 7.OC的常见问题.pptx            # 第7课：OC 常见问题
│   └── 8.iOS常用框架介绍.pptx         # 第8课：iOS 框架介绍
├── HelloWorld/                    # Hello World 入门项目
│   ├── HelloWorld/                   # 主项目
│   ├── HelloWorld WatchKit App/      # Apple Watch 应用
│   ├── HelloWorld WatchKit Extension/ # Watch 扩展
│   ├── Podfile                        # CocoaPods 依赖配置
│   ├── Pods/                          # 第三方库（AFNetworking）
│   └── FrameWorkTest.framework        # 自定义框架
├── HelloWorld_OS/                 # OS X 版本 Hello World
├── OCDemo/                        # Objective-C 语言演示
│   ├── MyClass.h/m                   # 自定义类示例
│   └── RTTest.h/m                    # Runtime 测试
├── AVPlayer-Demo/                 # 音视频播放器演示
├── CoreAnimation-Demo/            # 核心动画演示
├── CoreText-Demo/                 # 文本渲染演示
├── DrawDemo/                      # 绘图演示
├── FrameWorkTest/                 # 框架测试
├── Map-Demo/                      # 地图应用演示
├── Network-Demo/                  # 网络请求演示
├── sprite-test/                   # Sprite Kit 游戏演示
├── StaticLibTest/                 # 静态库测试
├── TabAndTable/                   # 标签与表格视图
├── TextKit-Demo/                  # 文本工具包演示
├── Webkit-Demo/                   # WebKit 浏览器演示
├── MyiOSCourse.xcworkspace/       # Xcode 工作空间
├── .gitignore
└── README.md
```

## 课程大纲

### 第 1 课：iOS 开发介绍
- iOS 平台概述
- iOS 生态系统
- 开发者注册流程
- iOS 开发前景

### 第 2 课：IDE 介绍
- Xcode 开发环境介绍
- Interface Builder 使用
- 调试工具
- 性能分析工具

### 第 3 课：工作空间及项目的创建及配置
- 创建 iOS 项目
- 项目结构说明
- 工作空间 (Workspace) 管理
- 项目配置和 Build Settings

### 第 4 课：版本控制系统介绍与 Git 搭建、使用
- Git 版本控制基础
- Git 在 Xcode 中的集成
- GitHub 使用
- 分支管理和协作开发

### 第 5 课：Objective-C 快速入门
- OC 语法基础
- 类和对象
- 内存管理
- 协议和代理

### 第 6 课：OC 在 Xcode 4.5 之后的新语法
- ARC (自动引用计数)
- Literals 语法糖
- 属性自动合成
- 新的集合操作语法

### 第 7 课：OC 的常见问题
- 内存泄漏排查
- 野指针问题
- 循环引用
- 性能优化技巧

### 第 8 课：iOS 常用框架介绍
- UIKit 框架
- Foundation 框架
- CoreData 框架
- 其他常用框架

## 示例项目详解

### 1. HelloWorld
**功能**: iOS 开发入门项目
- 基本的 iOS 应用结构
- CocoaPods 依赖管理示例
- AFNetworking 网络库集成
- Apple Watch 应用扩展
- 自定义 Framework 创建

**依赖**:
```ruby
platform :ios, '7.0'
pod "AFNetworking", "~> 2.0"
```

### 2. OCDemo
**功能**: Objective-C 语言特性演示
- 自定义类的创建和使用
- Runtime 运行时特性测试
- 方法交换 (Method Swizzling)
- 消息转发机制

**主要文件**:
- `MyClass.h/m`: 基础类定义示例
- `RTTest.h/m`: Runtime API 使用示例

### 3. AVPlayer-Demo
**功能**: 音视频播放
- AVPlayer 的使用
- 视频播放控制
- 播放进度显示
- 音频会话管理

### 4. CoreAnimation-Demo
**功能**: 核心动画演示
- CALayer 图层动画
- 关键帧动画
- 转场动画
- 动画组合

### 5. CoreText-Demo
**功能**: 文本渲染
- 富文本显示
- 自定义文本布局
- 图文混排
- 文本绘制优化

### 6. DrawDemo
**功能**: 2D 绘图
- Core Graphics 绘图
- 贝塞尔曲线
- 渐变和阴影
- 自定义视图绘制

### 7. Map-Demo
**功能**: 地图应用
- MapKit 框架使用
- 地图显示和交互
- 标注和覆盖层
- 地理编码

### 8. Network-Demo
**功能**: 网络编程
- NSURLConnection 使用
- NSURLSession 使用
- JSON 数据解析
- 异步请求处理

### 9. Webkit-Demo
**功能**: Web 浏览器
- WKWebView 使用
- JavaScript 交互
- 网页加载进度
- Cookie 管理

### 10. TextKit-Demo
**功能**: 文本工具包
- 动态文本排版
- 文本容器
- 文本附件
- 排除路径

### 11. TabAndTable
**功能**: 标签和表格视图
- UITabBarController 使用
- UITableView 数据源和代理
- 自定义 Cell
- 表格编辑

### 12. sprite-test
**功能**: SpriteKit 游戏
- Sprite Kit 框架基础
- 节点和场景
- 物理引擎
- 粒子效果

### 13. StaticLibTest
**功能**: 静态库测试
- 静态库创建
- 静态库引用
- 头文件导出

### 14. FrameWorkTest
**功能**: 自定义框架
- Framework 创建
- Framework 集成
- 资源打包

## 依赖要求

### 开发环境
- **macOS**: 10.9 或更高版本
- **Xcode**: 5.0 或更高版本
- **iOS SDK**: iOS 6.0 或更高版本
- **CocoaPods**: 最新版本

### 第三方库
- **AFNetworking**: 2.0+（网络请求库）

## 安装和运行

### 1. 克隆项目

```bash
git clone <repository-url>
cd MyiOSCourse
```

### 2. 安装 CocoaPods

```bash
# 安装 CocoaPods
sudo gem install cocoapods

# 或使用 Homebrew
brew install cocoapods
```

### 3. 安装依赖

```bash
# 进入 HelloWorld 项目
cd HelloWorld

# 安装依赖
pod install
```

### 4. 打开工作空间

```bash
# 返回项目根目录
cd ..

# 打开工作空间（推荐）
open MyiOSCourse.xcworkspace

# 或打开单个项目
cd HelloWorld
open HelloWorld.xcworkspace
```

### 5. 运行项目

1. 在 Xcode 中选择目标设备（模拟器或真机）
2. 选择要运行的 Scheme
3. 点击运行按钮 (Command + R)

## 学习路径

### 阶段一：基础入门（第 1-4 课）
1. 阅读 PPT：了解 iOS 开发概况
2. 熟悉 Xcode IDE 环境
3. 学习项目创建和配置
4. 掌握 Git 版本控制

**实践项目**: HelloWorld, HelloWorld_OS

### 阶段二：语言基础（第 5-7 课）
1. 学习 Objective-C 基础语法
2. 掌握 ARC 和新语法特性
3. 了解常见问题和解决方案

**实践项目**: OCDemo

### 阶段三：框架应用（第 8 课）
1. 学习 iOS 常用框架
2. 掌握 UI 控件使用
3. 理解 MVC 架构模式

**实践项目**: TabAndTable

### 阶段四：进阶功能
1. 网络编程
2. 多媒体处理
3. 图形绘制
4. 地图应用

**实践项目**:
- Network-Demo (网络)
- AVPlayer-Demo (多媒体)
- DrawDemo, CoreAnimation-Demo (绘图)
- Map-Demo (地图)

### 阶段五：高级特性
1. 文本渲染
2. Web 集成
3. 游戏开发
4. 框架开发

**实践项目**:
- CoreText-Demo, TextKit-Demo (文本)
- Webkit-Demo (Web)
- sprite-test (游戏)
- FrameWorkTest, StaticLibTest (框架)

## 开发技巧

### 1. 使用工作空间
工作空间可以同时管理多个项目，方便学习和对比：
```bash
# 打开工作空间而非单独项目
open MyiOSCourse.xcworkspace
```

### 2. CocoaPods 使用
```bash
# 安装依赖
pod install

# 更新依赖
pod update

# 搜索第三方库
pod search AFNetworking
```

### 3. Git 分支管理
项目已创建 develop 分支：
```bash
# 查看分支
git branch -a

# 切换到 develop 分支
git checkout develop

# 创建自己的功能分支
git checkout -b feature/my-feature
```

### 4. 调试技巧
- 使用断点调试
- LLDB 命令行调试
- Instruments 性能分析
- 日志输出 NSLog

## 常见问题

### Q: CocoaPods 安装失败？
A: 尝试更新 Ruby gems 或使用国内镜像源。

### Q: 项目编译错误？
A: 确保已运行 `pod install` 并打开 `.xcworkspace` 文件而非 `.xcodeproj`。

### Q: 模拟器运行缓慢？
A: 可以尝试重置模拟器或使用真机测试。

### Q: 真机调试需要什么？
A: 需要 Apple 开发者账号、开发证书和 Provisioning Profile。

### Q: 如何查看课程文档？
A: PPT 文档位于 `doc/` 目录，使用 PowerPoint 或兼容软件打开。

## 技术要点

### Objective-C 语言
- 消息传递机制
- 协议和委托模式
- 类别 (Category) 和扩展 (Extension)
- KVO 和 KVC
- Block 闭包

### iOS 框架
- **UIKit**: 用户界面
- **Foundation**: 基础数据类型和工具
- **CoreAnimation**: 动画
- **AVFoundation**: 音视频
- **MapKit**: 地图
- **WebKit**: Web 浏览
- **SpriteKit**: 2D 游戏

### 设计模式
- MVC (Model-View-Controller)
- 单例模式
- 观察者模式
- 工厂模式
- 代理模式

## 扩展学习

### 推荐资源
- [Apple 官方文档](https://developer.apple.com/documentation/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/)
- [Objective-C 编程指南](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/)
- [WWDC 视频](https://developer.apple.com/videos/)

### 进阶方向
1. **Swift 语言**: 学习 Swift 替代 Objective-C
2. **SwiftUI**: 现代化的 UI 框架
3. **Combine**: 响应式编程框架
4. **iOS 高级特性**: 多线程、性能优化、安全等

## 项目维护

### 版本控制
- `master`: 主分支，稳定版本
- `develop`: 开发分支，最新代码

### 提交规范
遵循良好的 Git 提交信息格式：
```
feat: 添加新功能
fix: 修复 bug
docs: 文档更新
refactor: 代码重构
test: 测试相关
```

## 许可证

本项目为 CSDN iOS 开发教程配套代码，仅供学习参考使用。

## 作者

- luowei
- CSDN iOS 开发讲师

## 相关链接

- CSDN 课程主页: 待补充
- 项目 GitHub: 待补充
- 技术博客: 待补充

## 贡献

欢迎提交 Issue 和 Pull Request 改进项目。

## 更新日志

- **2014-xx-xx**: 创建项目，添加基础示例
- **2014-xx-xx**: 创建 develop 分支
- **2025-xx-xx**: 更新 README 文档
