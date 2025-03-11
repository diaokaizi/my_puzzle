import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utils/theme.dart';
import '../widgets/custom_button.dart';
import 'image_select_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                // Logo和标题
                _buildLogoAndTitle(context),
                const SizedBox(height: 60),
                
                // 开始游戏按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomButton(
                    text: '开始游戏',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => _navigateToImageSelect(context),
                    height: 56,
                  ),
                ),
                const SizedBox(height: 20),
                
                // 设置按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomButton(
                    text: '设置',
                    icon: Icons.settings,
                    isOutlined: true,
                    onPressed: () {
                      // 设置功能将在后续实现
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('设置功能即将推出')),
                      );
                    },
                    height: 56,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle(BuildContext context) {
    return Column(
      children: [
        // Logo占位符 - 后续可替换为实际logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: AppTheme.defaultShadow,
          ),
          child: const Icon(
            Icons.extension,
            size: 70,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        
        // 应用标题
        Text(
          'MyPuzzle',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 36,
              ),
        ),
        const SizedBox(height: 8),
        
        // 应用副标题
        Text(
          '创建您自己的拼图游戏',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
      ],
    );
  }

  void _navigateToImageSelect(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImageSelectScreen()),
    );
  }
} 