import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageSplitter {
  /// 将图片切割成网格
  static Future<List<Image>> splitImage({
    required File imageFile,
    required int rows,
    required int columns,
  }) async {
    // 读取图片文件
    final Uint8List bytes = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    // 计算每个拼图块的尺寸
    final int pieceWidth = (image.width / columns).floor();
    final int pieceHeight = (image.height / rows).floor();

    // 存储切割后的图片
    List<Image> pieces = [];

    // 切割图片
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {
        // 计算当前拼图块的位置
        final int left = x * pieceWidth;
        final int top = y * pieceHeight;

        // 创建一个画布来绘制拼图块
        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(recorder);

        // 绘制拼图块
        final Paint paint = Paint();
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(
            left.toDouble(),
            top.toDouble(),
            pieceWidth.toDouble(),
            pieceHeight.toDouble(),
          ),
          Rect.fromLTWH(
            0,
            0,
            pieceWidth.toDouble(),
            pieceHeight.toDouble(),
          ),
          paint,
        );

        // 完成绘制并转换为图片
        final ui.Picture picture = recorder.endRecording();
        final ui.Image pieceImage = await picture.toImage(
          pieceWidth,
          pieceHeight,
        );

        // 将图片转换为字节数据
        final ByteData? byteData = await pieceImage.toByteData(
          format: ui.ImageByteFormat.png,
        );
        final Uint8List pieceBytes = byteData!.buffer.asUint8List();

        // 创建Flutter图片组件
        pieces.add(Image.memory(pieceBytes));
      }
    }

    return pieces;
  }

  /// 打乱拼图块
  static List<int> shufflePieces(int count) {
    final List<int> indices = List.generate(count, (index) => index);
    indices.shuffle();
    return indices;
  }
} 