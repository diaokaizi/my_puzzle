# MyPuzzle - 拼图游戏应用

MyPuzzle是一个美观简洁的Flutter拼图游戏应用，允许用户上传本地图片并将其转换为拼图游戏。

## 功能特点

- 从设备相册选择或使用相机拍摄图片
- 支持多种难度级别（3x3、4x4、5x5、6x6）
- 实时计时和移动次数统计
- 查看原图功能
- 美观的游戏完成界面和统计信息

## 截图

(应用截图将在应用完成后添加)

## 技术栈

- Flutter框架
- Provider状态管理
- 图片处理和拼图算法
- 动画效果

## 安装和运行

### 前提条件

- 安装Flutter SDK（2.0.0或更高版本）
- 安装Android Studio或VS Code
- 配置好Flutter开发环境

### 安装步骤

1. 克隆仓库
   ```
   git clone https://github.com/yourusername/my_puzzle.git
   ```

2. 进入项目目录
   ```
   cd my_puzzle
   ```

3. 获取依赖
   ```
   flutter pub get
   ```

4. 运行应用
   ```
   flutter run
   ```

## 项目结构

```
lib/
  ├── main.dart              # 应用入口
  ├── models/                # 数据模型
  │   └── puzzle_model.dart  # 拼图游戏模型
  ├── screens/               # 页面
  │   ├── home_screen.dart           # 主页面
  │   ├── image_select_screen.dart   # 图片选择页面
  │   ├── difficulty_select_screen.dart  # 难度选择页面
  │   ├── game_screen.dart           # 游戏页面
  │   └── completion_screen.dart     # 完成页面
  ├── utils/                 # 工具类
  │   ├── theme.dart         # 主题和样式
  │   └── image_splitter.dart  # 图片切割工具
  └── widgets/               # 可复用组件
      └── custom_button.dart  # 自定义按钮
```

## 使用说明

1. 启动应用，点击"开始游戏"按钮
2. 从相册选择图片或使用相机拍摄
3. 选择游戏难度（3x3、4x4、5x5或6x6）
4. 开始拼图游戏，通过点击拼图块移动它们
5. 完成拼图后，查看游戏统计信息

## 贡献

欢迎提交问题和功能请求！如果您想贡献代码，请先开一个issue讨论您想要更改的内容。

## 许可证

[MIT](LICENSE)