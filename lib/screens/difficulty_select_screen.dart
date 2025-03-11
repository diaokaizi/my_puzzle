import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_model.dart';
import '../utils/theme.dart';
import '../widgets/custom_button.dart';
import 'game_screen.dart';

class DifficultySelectScreen extends StatelessWidget {
  const DifficultySelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzleModel = Provider.of<PuzzleModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择难度'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 难度选择说明
            Text(
              '选择拼图难度',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '难度越高，拼图块数量越多',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // 难度选择卡片
            Expanded(
              child: AnimationLimiter(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  padding: const EdgeInsets.all(8),
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 400),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      _buildDifficultyCard(
                        context,
                        title: '简单',
                        subtitle: '3 x 3',
                        icon: Icons.sentiment_satisfied_alt,
                        color: Colors.green,
                        difficulty: 3,
                        isSelected: puzzleModel.difficulty == 3,
                      ),
                      _buildDifficultyCard(
                        context,
                        title: '中等',
                        subtitle: '4 x 4',
                        icon: Icons.sentiment_neutral,
                        color: Colors.orange,
                        difficulty: 4,
                        isSelected: puzzleModel.difficulty == 4,
                      ),
                      _buildDifficultyCard(
                        context,
                        title: '困难',
                        subtitle: '5 x 5',
                        icon: Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                        difficulty: 5,
                        isSelected: puzzleModel.difficulty == 5,
                      ),
                      _buildDifficultyCard(
                        context,
                        title: '专家',
                        subtitle: '6 x 6',
                        icon: Icons.psychology,
                        color: Colors.purple,
                        difficulty: 6,
                        isSelected: puzzleModel.difficulty == 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 开始游戏按钮
            CustomButton(
              text: '开始游戏',
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(),
                  ),
                );
              },
              height: 56,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int difficulty,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        Provider.of<PuzzleModel>(context, listen: false).setDifficulty(difficulty);
      },
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          side: isSelected
              ? BorderSide(color: color, width: 3)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: color,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 18,
                      color: color,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '已选择',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 