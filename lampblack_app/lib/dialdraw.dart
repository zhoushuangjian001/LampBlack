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
  Picture _picture;


  @override
  void initState() {
    super.initState();
    boardSize = new Size(400, 400);
    _picture = DarwBgImageOfDial(boardSize).getBgImage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: boardSize,
        painter: DialPainter(_picture),
      ),
    );
  }
}

class DialPainter extends CustomPainter {

  final Picture bgImagePicture;
  DialPainter(this.bgImagePicture);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    canvas.drawPicture(bgImagePicture);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


class DarwBgImageOfDial {
  // 刻度值
  var dialValueArray = ["0","10","20","30","40","50","60","70","80","90","100"];
  final Size size;
  final PictureRecorder _recorder = PictureRecorder();
  DarwBgImageOfDial(this.size);

  // 绘制表盘刻度
  Picture getBgImage(){
    Canvas canvas = Canvas(_recorder);
    canvas.clipRect(new Rect.fromLTWH(0, 0, size.width, size.height));
    drewDialRule(canvas, size);
    return _recorder.endRecording();
  }
  
  // 绘制刻度尺
  void drewDialRule(Canvas canvas, Size size) {
    canvas.save();
    double halfWidth = size.width * 0.5;
    double halfHeight = size.height * 0.5;
    canvas.translate(halfWidth, halfHeight);

    // 画笔(整刻度)
    var paintMain = new Paint()
      ..color = Colors.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.fill;

    // 画笔（其他刻度）
    var otherPaint = new Paint()
      ..color = Colors.green
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    drawLongLineOfDial(canvas, paintMain, halfHeight, dialValueArray[5]);

    canvas.save();
    for (int i = 51; i<= 100; i++) {
      if (i % 2 == 0) {
        canvas.rotate(0.09666);
        if(i % 10 == 0) {       
          int index = (i/10).ceil();
          drawLongLineOfDial(canvas, paintMain, halfHeight, dialValueArray[index]);
        } else {
          drawShortLineOfDial(canvas, otherPaint, halfHeight);
        }
      }
    }
    canvas.restore();

    canvas.save();
    for (int i = 49 ; i >= 0; i--) {
      if(i % 2 == 0) {
        canvas.rotate(- 0.09666);
        if(i % 10 == 0) {
          int index = (i/10).ceil();
          drawLongLineOfDial(canvas, paintMain, halfHeight, dialValueArray[index]);
        } else {
          drawShortLineOfDial(canvas, otherPaint, halfHeight);
        }
      }
    }
    canvas.restore();

    canvas.restore();
  }

  // 绘制长刻度
  void drawLongLineOfDial(Canvas canvas, Paint paint, double halfHeight, String text){
    canvas.drawLine(new Offset(0, -halfHeight), new Offset(0, -halfHeight + 15), paint);

    // 绘制文字
    TextPainter textPainter = new TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(
        text: text,
        style: TextStyle(
          color: paint.color,
          fontSize: 10
        )
      )
      ..layout();
      double halfPositionX = - textPainter.size.width * 0.5;
      double halfPositionY = - halfHeight + 19;
      textPainter.paint(canvas, new Offset(halfPositionX,halfPositionY ));
  }

  // 绘制短刻度
  void drawShortLineOfDial(Canvas canvas, Paint paint, double halfHeight) {
    canvas.drawLine(new Offset(0, -halfHeight), new Offset(0, -halfHeight + 5), paint);
  }

}