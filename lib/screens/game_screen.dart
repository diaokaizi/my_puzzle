import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_model.dart';
import '../utils/theme.dart';
import '../utils/image_splitter.dart';
import '../widgets/custom_button.dart';
import 'completion_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isLoading = true;
  bool _showOriginal = false;
  List<Image> _puzzlePieces = [];
  List<int> _currentArrangement = [];
  late int _gridSize;
  
  @override
  void initState() {
    super.initState();
    _initializePuzzle();
  }
  
  Future<void> _initializePuzzle() async {
    final puzzleModel = Provider.of<PuzzleModel>(context, listen: false);
    _gridSize = puzzleModel.difficulty;
    
    // 开始游戏
    puzzleModel.startGame();
    
    try {
      // 切割图片
      _puzzlePieces = await ImageSplitter.splitImage(
        imageFile: puzzleModel.selectedImage!,
        rows: _gridSize,
        columns: _gridSize,
      );
      
      // 打乱拼图块
      _currentArrangement = ImageSplitter.shufflePieces(_gridSize * _gridSize);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('初始化拼图失败: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _onPieceTapped(int index) {
    // 这里将在后续实现拼图块的移动逻辑
    final puzzleModel = Provider.of<PuzzleModel>(context, listen: false);
    puzzleModel.movePiece(index);
    
    // 检查是否完成拼图
    if (puzzleModel.isCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CompletionScreen(),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final puzzleModel = Provider.of<PuzzleModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('拼图游戏'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _initializePuzzle();
            },
            tooltip: '重新开始',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 游戏信息
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoCard(
                        icon: Icons.timer,
                        title: '时间',
                        value: _formatTime(puzzleModel.getElapsedTime()),
                      ),
                      _buildInfoCard(
                        icon: Icons.swap_horiz,
                        title: '移动次数',
                        value: puzzleModel.moveCount.toString(),
                      ),
                    ],
                  ),
                ),
                
                // 拼图区域
                Expanded(
                  child: Stack(
                    children: [
                      // 拼图游戏区域
                      Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                              boxShadow: AppTheme.defaultShadow,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                              child: _buildPuzzleGrid(),
                            ),
                          ),
                        ),
                      ),
                      
                      // 原图预览
                      if (_showOriginal)
                        Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                                boxShadow: AppTheme.defaultShadow,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                                child: Image.file(
                                  puzzleModel.selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // 底部控制按钮
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: '查看原图',
                          icon: Icons.image,
                          backgroundColor: AppTheme.secondaryColor,
                          onPressed: () {
                            setState(() {
                              _showOriginal = !_showOriginal;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primaryColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPuzzleGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridSize,
      ),
      itemCount: _gridSize * _gridSize,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final pieceIndex = _currentArrangement[index];
        return GestureDetector(
          onTap: () => _onPieceTapped(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: _puzzlePieces[pieceIndex],
          ),
        );
      },
    );
  }
  
  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
} 