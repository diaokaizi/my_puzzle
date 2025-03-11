import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_model.dart';
import '../utils/theme.dart';
import '../widgets/custom_button.dart';
import 'difficulty_select_screen.dart';

class ImageSelectScreen extends StatefulWidget {
  const ImageSelectScreen({Key? key}) : super(key: key);

  @override
  State<ImageSelectScreen> createState() => _ImageSelectScreenState();
}

class _ImageSelectScreenState extends State<ImageSelectScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择图片失败: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择图片'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 图片选择说明
            Text(
              '请选择一张图片作为拼图',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '您可以从相册选择图片或使用相机拍摄',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // 图片预览区域
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildImagePreview(),
            ),
            const SizedBox(height: 30),

            // 图片选择按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomButton(
                    text: '相册',
                    icon: Icons.photo_library,
                    backgroundColor: AppTheme.secondaryColor,
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    text: '相机',
                    icon: Icons.camera_alt,
                    backgroundColor: AppTheme.secondaryColor,
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 继续按钮
            CustomButton(
              text: '继续',
              icon: Icons.arrow_forward,
              onPressed: _selectedImage == null
                  ? null
                  : () {
                      // 保存选择的图片到模型
                      final puzzleModel = Provider.of<PuzzleModel>(context, listen: false);
                      puzzleModel.setImage(_selectedImage!);
                      
                      // 导航到难度选择页面
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DifficultySelectScreen(),
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

  Widget _buildImagePreview() {
    if (_selectedImage == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Icon(
            Icons.add_photo_alternate,
            size: 80,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: AppTheme.defaultShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
} 