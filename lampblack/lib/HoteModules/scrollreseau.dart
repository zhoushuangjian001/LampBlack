import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollReseau {
  final markycount;
  final Size size;
  ScrollReseau(this.markycount, this.size);

  PictureRecorder _recorder = PictureRecorder();
  // 获取数组
  List getXAsix() {
    var array = [];
    for (int i = 0; i <= 24; i++) {
      if (i == 0) {
        array.add("$i");
      } else {
        array.add("$i时");
      }
    }
    return array;
  }

  // 绘制
  Picture getBgView() {
    var list = getXAsix();
    Canvas canvas = Canvas(_recorder);
    canvas.save();
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    // 绘制底线
    Offset p1 = Offset(0, size.height - 42);
    Offset p2 = Offset(size.width, size.height - 42);
    canvas.drawLine(p1, p2, paint);
    canvas.restore();

    canvas.save();
    paint.color = Colors.black26;
    paint.strokeWidth = 1;
    double everyyoffset = (size.height - 60) / (markycount - 1);
    double everyxoffset = size.width * 1.0 / list.length;
    for (int i = 0; i < markycount - 1; i++) {
      var p1 = Offset(0, 20 + i * everyyoffset);
      var p2 = Offset(size.width - everyxoffset, 20 + i * everyyoffset);
      canvas.drawLine(p1, p2, paint);
    }

    for (int i = 0; i < list.length; i++) {
      double offsetx = i * everyxoffset;
      double offsety1 = 20;
      double offsety2 = size.height - 42;
      canvas.drawLine(
          Offset(offsetx, offsety1), Offset(offsetx, offsety2), paint);

      // 绘制文字
      canvas.save();
      TextPainter textPainter = TextPainter()
        ..textDirection = TextDirection.ltr
        ..text = TextSpan(
            text: list[i],
            style: TextStyle(fontSize: 12, color: Colors.black38))
        ..layout();

      double offset = i * everyxoffset - textPainter.size.width;
      double pointy = size.height - 40 + textPainter.size.height;
      canvas.translate(offset, pointy);
      if (i != 0) {
        canvas.rotate(-pi * 0.15);
      }
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
    canvas.restore();
    return _recorder.endRecording();
  }
}
