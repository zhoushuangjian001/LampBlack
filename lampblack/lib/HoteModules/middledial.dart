import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class MiddleDial extends StatelessWidget {
  final String title;
  final String unit;
  final double value;
  // 便利构造函数
  MiddleDial(this.title, this.unit, this.value);
  // 表格间隔
  double tableSpace;
  Picture _dialPicture;
  Picture _indicatorPicture;
  Size boardSize;
  // 初始化参数函数
  void initState() {
    boardSize = new Size(190, 190);
    _dialPicture = DarwBgImageOfDial(boardSize).getBgImage();
    _indicatorPicture = DrawIndicator(boardSize, value).drawIndicator();
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return Center(
      child: CustomPaint(
        size: new Size(190, 190),
        painter:
            DialPainter(_dialPicture, _indicatorPicture, title, unit, value),
      ),
    );
  }
}

/// 绘制刻度盘
class DialPainter extends CustomPainter {
  final Picture bgImagePicture;
  final Picture indicatorPicture;
  final String title;
  final String unit;
  final double value;
  DialPainter(this.bgImagePicture, this.indicatorPicture, this.title, this.unit,
      this.value);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    canvas.drawPicture(bgImagePicture);
    // 绘制单位
    drawUnit(canvas, size, unit, title);
    // 绘制实时数据
    drawRealTimeValue(canvas, size, value);
    // 绘制指针
    drawIndicatorPicture(canvas, size, value);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  // 绘制指针
  void drawIndicatorPicture(Canvas canvas, Size size, double value) {
    double halfWidth = size.width * 0.5;
    double halfHeight = size.height * 0.5;
    double unitAngle = 2 * pi / 65;
    double angle;
    // 处理越界值
    if (value < 0) value = 0;
    if (value > 50) value = 50;
    // 计算角度
    if (value <= 25) {
      angle = -(25 - value) * unitAngle;
    } else {
      angle = (value - 25) * unitAngle;
    }
    canvas.save();
    canvas.translate(halfWidth, halfHeight);
    canvas.rotate(angle);
    canvas.translate(-halfWidth, -halfHeight);
    canvas.drawPicture(indicatorPicture);
    canvas.restore();
  }

  // 绘制单位 & 标题
  void drawUnit(Canvas canvas, Size size, String text, String title) {
    double halfWidth = size.width * 0.5;
    double halfHeight = size.height * 0.5;
    canvas.save();
    canvas.translate(halfWidth, halfHeight);

    // 文字(单位)
    TextPainter unitTextPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = new TextSpan(
          text: text, style: TextStyle(fontSize: 20, color: Colors.red))
      ..layout();
    double pointX = -unitTextPainter.size.width * 0.5;
    double pointY = -halfHeight + 50;
    unitTextPainter.paint(canvas, Offset(pointX, pointY));

    // 文字(标题)
    TextPainter titleTextPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = new TextSpan(
          text: title, style: TextStyle(fontSize: 18, color: Colors.black))
      ..layout();
    double titlePointX = -titleTextPainter.size.width * 0.5;
    double titlePointY = halfHeight - 40;
    titleTextPainter.paint(canvas, Offset(titlePointX, titlePointY));

    canvas.restore();
  }

  /// 绘制实时显示数据
  void drawRealTimeValue(Canvas canvas, Size size, double value) {
    double halfW = size.width * 0.5;
    double halfH = size.height * 0.5;
    Color textColor;
    if (value <= 20) {
      textColor = Colors.green;
    } else if (value > 20 && value <= 80) {
      textColor = Colors.blue;
    } else {
      textColor = Colors.red;
    }
    canvas.save();
    canvas.translate(halfW, halfH);

    TextPainter textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(
          text: value.toString(),
          style: TextStyle(fontSize: 30, color: textColor))
      ..layout();
    double textPointX = -textPainter.size.width * 0.5;
    double textPointY = halfH - 80;
    textPainter.paint(canvas, Offset(textPointX, textPointY));
    canvas.restore();
  }
}

/// 绘制背景刻度盘
class DarwBgImageOfDial {
  // 刻度值
  var dialValueArray = [
    "0",
    "5",
    "10",
    "15",
    "20",
    "25",
    "30",
    "35",
    "40",
    "45",
    "50"
  ];
  // 分割大份数
  final int cutBigApartCount = 13;
  // 每个大份分割小份数
  final int smallApartCountInBigApart = 5;
  final Size size;
  final PictureRecorder _recorder = PictureRecorder();
  DarwBgImageOfDial(this.size);

  /// 绘制表盘刻度
  Picture getBgImage() {
    // 每一份的角度
    int allCutApart = cutBigApartCount * smallApartCountInBigApart;
    double angle = 2 * pi / allCutApart;
    // 绘制背景图
    Canvas canvas = Canvas(_recorder);
    canvas.clipRect(new Rect.fromLTWH(0, 0, size.width, size.height));
    drewDialRule(canvas, size, angle);
    return _recorder.endRecording();
  }

  /// 绘制刻度尺
  void drewDialRule(Canvas canvas, Size size, double angle) {
    canvas.save();
    double halfWidth = size.width * 0.5;
    double halfHeight = size.height * 0.5;
    canvas.translate(halfWidth, halfHeight);

    /// 刻度盘底色绘制
    var paintBgRing = new Paint()
      ..color = Colors.green
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
        new Rect.fromCircle(center: Offset(0, 0), radius: halfWidth - 15),
        -41.25 * angle,
        angle * 10,
        false,
        paintBgRing);
    paintBgRing.color = Colors.blue;
    canvas.drawArc(
        new Rect.fromCircle(center: Offset(0, 0), radius: halfWidth - 15),
        -31.25 * angle,
        angle * 30,
        false,
        paintBgRing);
    paintBgRing.color = Colors.red;
    canvas.drawArc(
        new Rect.fromCircle(center: Offset(0, 0), radius: halfWidth - 15),
        -1.25 * angle,
        angle * 10,
        false,
        paintBgRing);

    /// 刻度绘制
    // 画笔(整刻度)
    var paintMain = new Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.fill;
    // 画笔（其他刻度）
    var otherPaint = new Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    // 顶点单独绘制
    drawLongLineOfDial(canvas, paintMain, halfHeight, dialValueArray[5], 50);
    // 绘制大刻度面板
    canvas.save();
    for (int i = 51; i <= 100; i++) {
      if (i % 2 == 0) {
        canvas.rotate(0.09666);
        if (i % 10 == 0) {
          int index = (i / 10).ceil();
          drawLongLineOfDial(
              canvas, paintMain, halfHeight, dialValueArray[index], i);
        } else {
          drawShortLineOfDial(canvas, otherPaint, halfHeight);
        }
      }
    }
    canvas.restore();
    // 绘制小刻度面板
    canvas.save();
    for (int i = 49; i >= 0; i--) {
      if (i % 2 == 0) {
        canvas.rotate(-0.09666);
        if (i % 10 == 0) {
          int index = (i / 10).ceil();
          drawLongLineOfDial(
              canvas, paintMain, halfHeight, dialValueArray[index], i);
        } else {
          drawShortLineOfDial(canvas, otherPaint, halfHeight);
        }
      }
    }
    canvas.restore();

    canvas.restore();
  }

  /// 绘制长刻度
  void drawLongLineOfDial(
      Canvas canvas, Paint paint, double halfHeight, String text, int index) {
    // 顶点和尾点处理
    var rehab = 20;
    canvas.drawLine(
        new Offset(0, -halfHeight), new Offset(0, -halfHeight + rehab), paint);
    // 颜色变化
    var textColor;
    if (index <= 20) {
      textColor = Colors.green;
    } else if (index > 20 && index <= 80) {
      textColor = Colors.blue;
    } else {
      textColor = Colors.red;
    }
    // 绘制文字
    TextPainter textPainter = new TextPainter()
      ..textDirection = TextDirection.ltr
      ..text =
          TextSpan(text: text, style: TextStyle(color: textColor, fontSize: 13))
      ..layout();
    double halfPositionX = -textPainter.size.width * 0.5;
    double halfPositionY = -halfHeight + 29;
    textPainter.paint(canvas, new Offset(halfPositionX, halfPositionY));
  }

  /// 绘制短刻度
  void drawShortLineOfDial(Canvas canvas, Paint paint, double halfHeight) {
    canvas.drawLine(
        new Offset(0, -halfHeight), new Offset(0, -halfHeight + 10), paint);
  }
}

/// 绘制指针
class DrawIndicator {
  final PictureRecorder _recorder = PictureRecorder();
  final Size size;
  final double value;
  DrawIndicator(this.size, this.value);

  // 绘制 path
  Picture drawIndicator() {
    Canvas canvas = Canvas(_recorder);
    canvas.clipRect(new Rect.fromLTWH(0, 0, size.width, size.height));

    double halfWidth = size.width * 0.5;
    double halfHeight = size.height * 0.5;

    var indicatorPath = Path()
      ..moveTo(-5, 20)
      ..lineTo(5, 20)
      ..lineTo(8, 30)
      ..lineTo(0.5, -halfHeight + 40)
      ..lineTo(-0.5, -halfHeight + 40)
      ..lineTo(-8, 30)
      ..close();
    canvas.save();
    canvas.translate(halfWidth, halfHeight);
    // 颜色处理
    Color paintColor;
    if (value <= 20) {
      paintColor = Colors.green;
    } else if (value > 20 && value <= 80) {
      paintColor = Colors.blue;
    } else {
      paintColor = Colors.red;
    }
    var paint = new Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(indicatorPath, paint);
    paint.color = Colors.black;
    canvas.drawCircle(new Offset(0, 0), 5, paint);
    canvas.restore();
    return _recorder.endRecording();
  }
}
