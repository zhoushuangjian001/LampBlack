import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DialDraw extends StatefulWidget {
  _DialDraw createState() => _DialDraw();
}

class _DialDraw extends State<DialDraw> {
  Size boardSize;
  // 表格间隔
  double tableSpace;
  Picture _dialPicture;
  Picture _indicatorPicture;

  @override
  void initState() {
    super.initState();
    boardSize = new Size(250, 250);
    _dialPicture = DarwBgImageOfDial(boardSize).getBgImage();
    _indicatorPicture = DrawIndicator(boardSize).drawIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: boardSize,
        painter: DialPainter(_dialPicture, _indicatorPicture),
      ),
    );
  }
}

/// 绘制刻度盘
class DialPainter extends CustomPainter {

  final Picture bgImagePicture;
  final Picture indicatorPicture;

  DialPainter(this.bgImagePicture, this.indicatorPicture);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    canvas.drawPicture(bgImagePicture);
    // 绘制单位
    drawUnit(canvas, size, "mg/m3", "油烟浓度");
    // 绘制指针
    drawIndicatorPicture(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  // 绘制指针
  void drawIndicatorPicture(Canvas canvas, Size size){
    double halfWidth = size.width * 0.5;
    double halfHeight = size.height *0.5;
    canvas.save();
    canvas.translate(halfWidth, halfHeight);
    canvas.rotate(0.0966);
    canvas.translate(-halfWidth, -halfHeight);
    canvas.drawPicture(indicatorPicture);
    canvas.restore();
  }

  // 绘制单位
  void drawUnit(Canvas canvas, Size size, String text, String title) {
    double halfWidth = size.width * 0.5;
    double halfHeight = size.height *0.5;
    canvas.save();
    canvas.translate(halfWidth, halfHeight);

    // 文字(单位)
    TextPainter unitTextPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = new TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 20,
          color: Colors.red
        )
      )
      ..layout();
    double pointX = - unitTextPainter.size.width * 0.5;
    double pointY = -halfHeight + 50;
    unitTextPainter.paint(canvas, Offset(pointX, pointY));

    // 文字(标题)
    TextPainter titleTextPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = new TextSpan(
        text: title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black
        )
      )
      ..layout();
    double titlePointX = - titleTextPainter.size.width * 0.5;
    double titlePointY = halfHeight - 50;
    titleTextPainter.paint(canvas, Offset(titlePointX,titlePointY));

    canvas.restore();
  }
}


class DarwBgImageOfDial {
  // 刻度值
  var dialValueArray = ["0","10","20","30","40","50","60","70","80","90","100"];
  // 分割大份数
  final int cutBigApartCount = 13;
  // 每个大份分割小份数
  final int smallApartCountInBigApart = 5;
  final Size size;
  final PictureRecorder _recorder = PictureRecorder();
  DarwBgImageOfDial(this.size);

  /// 绘制表盘刻度
  Picture getBgImage(){
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
    canvas.drawArc(new Rect.fromCircle(center: Offset(0, 0),radius: halfWidth - 15), - 41.25 * angle, angle * 10, false, paintBgRing);
    paintBgRing.color = Colors.blue;
    canvas.drawArc(new Rect.fromCircle(center: Offset(0, 0),radius: halfWidth - 15), - 31.25 * angle, angle * 30, false, paintBgRing);
    paintBgRing.color = Colors.red;
    canvas.drawArc(new Rect.fromCircle(center: Offset(0, 0),radius: halfWidth - 15), - 1.25 * angle, angle * 10, false, paintBgRing);

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
    drawLongLineOfDial(canvas, paintMain, halfHeight, dialValueArray[5],50);
    // 绘制大刻度面板
    canvas.save();
    for (int i = 51; i<= 100; i++) {
      if (i % 2 == 0) {
        canvas.rotate(0.09666);
        if(i % 10 == 0) {       
          int index = (i/10).ceil();
          drawLongLineOfDial(canvas, paintMain, halfHeight, dialValueArray[index], i);
        } else {
          drawShortLineOfDial(canvas, otherPaint, halfHeight);
        }
      }
    }
    canvas.restore();
    // 绘制小刻度面板
    canvas.save();
    for (int i = 49 ; i >= 0; i--) {
      if(i % 2 == 0) {
        canvas.rotate(- 0.09666);
        if(i % 10 == 0) {
          int index = (i/10).ceil();
          drawLongLineOfDial(canvas, paintMain, halfHeight, dialValueArray[index], i);
        } else {
          drawShortLineOfDial(canvas, otherPaint, halfHeight);
        }
      }
    }
    canvas.restore();

    canvas.restore();
  }

  /// 绘制长刻度
  void drawLongLineOfDial(Canvas canvas, Paint paint, double halfHeight, String text, int index){
    // 顶点和尾点处理
    var rehab = 20;
    canvas.drawLine(new Offset(0, -halfHeight), new Offset(0, -halfHeight + rehab), paint);
    // 颜色变化
    var textColor;
    if (index <= 20 ) {
      textColor = Colors.green;
    } else if (index > 20 && index <= 80) {
      textColor = Colors.blue;
    } else {
      textColor = Colors.red;
    }
    // 绘制文字
    TextPainter textPainter = new TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: 13
        )
      )
      ..layout();
      double halfPositionX = - textPainter.size.width * 0.5;
      double halfPositionY = - halfHeight + 29;
      textPainter.paint(canvas, new Offset(halfPositionX,halfPositionY ));
  }

  /// 绘制短刻度
  void drawShortLineOfDial(Canvas canvas, Paint paint, double halfHeight) {
    canvas.drawLine(new Offset(0, -halfHeight), new Offset(0, -halfHeight + 10), paint);
  }

}


/// 绘制指针
class DrawIndicator {
  final PictureRecorder _recorder = PictureRecorder();
  final Size size;

  DrawIndicator(this.size);

  // 绘制 path
  Picture drawIndicator(){
    Canvas canvas = Canvas(_recorder);
    canvas.clipRect(new Rect.fromLTWH(0, 0, size.width, size.height));

    double halfWidth = size.width * 0.5;
    double halfHeight = size.height * 0.5;

    var indicatorPath = Path()
      ..moveTo(-5, 20)
      ..lineTo(5, 20)
      ..lineTo(8, 30)
      ..lineTo(0.5, - halfHeight + 40)
      ..lineTo(-0.5, - halfHeight + 40)
      ..lineTo(-8, 30)
      ..close();
    canvas.save();
    canvas.translate(halfWidth, halfHeight);
    var paint = new Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawPath(indicatorPath, paint);
    paint.color = Colors.black;
    canvas.drawCircle(new Offset(0, 0), 5, paint);
    canvas.restore();
    return _recorder.endRecording();
  }
}