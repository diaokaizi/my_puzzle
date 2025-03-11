import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuzzleModel extends ChangeNotifier {
  // 图片相关
  File? selectedImage;
  String? imagePath;
  
  // 游戏设置
  int difficulty = 3; // 默认3x3
  bool isPlaying = false;
  
  // 游戏状态
  List<PuzzlePiece> puzzlePieces = [];
  DateTime? startTime;
  int moveCount = 0;
  bool isCompleted = false;
  
  // 选择图片
  void setImage(File image) {
    selectedImage = image;
    imagePath = image.path;
    notifyListeners();
  }
  
  // 设置难度
  void setDifficulty(int level) {
    difficulty = level;
    notifyListeners();
  }
  
  // 开始游戏
  void startGame() {
    if (selectedImage != null) {
      isPlaying = true;
      moveCount = 0;
      isCompleted = false;
      startTime = DateTime.now();
      // 生成拼图块的逻辑将在后续实现
      notifyListeners();
    }
  }
  
  // 移动拼图块
  void movePiece(int index) {
    if (!isPlaying || isCompleted) return;
    
    // 移动逻辑将在后续实现
    moveCount++;
    
    // 检查是否完成
    checkCompletion();
    notifyListeners();
  }
  
  // 检查是否完成拼图
  void checkCompletion() {
    // 检查逻辑将在后续实现
    // 如果完成，设置isCompleted = true
  }
  
  // 重置游戏
  void resetGame() {
    isPlaying = false;
    puzzlePieces = [];
    moveCount = 0;
    isCompleted = false;
    startTime = null;
    notifyListeners();
  }
  
  // 获取游戏时长（秒）
  int getElapsedTime() {
    if (startTime == null) return 0;
    return DateTime.now().difference(startTime!).inSeconds;
  }
}

// 拼图块类
class PuzzlePiece {
  final Image image;
  final int correctPosition;
  int currentPosition;
  
  PuzzlePiece({
    required this.image,
    required this.correctPosition,
    required this.currentPosition,
  });
  
  bool isCorrect() => correctPosition == currentPosition;
} 