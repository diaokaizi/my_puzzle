import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../models/puzzle_model.dart';
import '../utils/theme.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({Key? key}) : super(key: key);

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final puzzleModel = Provider.of<PuzzleModel>(context);
    final int elapsedTime = puzzleModel.getElapsedTime();
    final int moveCount = puzzleModel.moveCount;
    final int difficulty = puzzleModel.difficulty;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // 背景和内容
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 祝贺图标
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.defaultShadow,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 祝贺标题
                    Text(
                      '恭喜！',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),

                    // 祝贺副标题
                    Text(
                      '您已成功完成拼图',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // 游戏统计卡片
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                        boxShadow: AppTheme.defaultShadow,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '游戏统计',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            icon: Icons.grid_4x4,
                            label: '难度',
                            value: '$difficulty x $difficulty',
                          ),
                          const Divider(height: 24),
                          _buildStatRow(
                            icon: Icons.timer,
                            label: '用时',
                            value: _formatTime(elapsedTime),
                          ),
                          const Divider(height: 24),
                          _buildStatRow(
                            icon: Icons.swap_horiz,
                            label: '移动次数',
                            value: '$moveCount',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 再玩一次按钮
                    CustomButton(
                      text: '再玩一次',
                      icon: Icons.replay,
                      onPressed: () {
                        puzzleModel.resetGame();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      height: 56,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 顶部彩带效果
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes分 ${remainingSeconds.toString().padLeft(2, '0')}秒';
  }
} 