import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Reseau {
  final List marks;
  final Size size;
  Reseau(this.marks, this.size);

  PictureRecorder _recorder = PictureRecorder();
  // 配置时间
  List getXAsix(){
    var array = [];
    for(int i = 0; i <= 24; i ++){
      if(i % 2 == 0) {
        if (i == 0) {
          array.add("$i");
        } else {
          array.add("$i时");
        }
      }
    }
    return array;
  }

  // 绘制
  Picture drawBgReseau(){
    // 数字处理
    var markArray = marks.reversed.toList();
    var listArray = getXAsix();
    double lineWidth = 1;
    double offsetLeft = 60;
    double offsetRight = 15;
    double offsetTop = 20;
    double offsetBot = 40;
    double spacingX = (size.width - offsetLeft - offsetRight - listArray.length * lineWidth)/(listArray.length - 1);
    double spacingY = (size.height - offsetBot - offsetTop - marks.length * lineWidth)/marks.length;
    Canvas canvas = Canvas(_recorder);
    var paint = Paint()
      ..color = Colors.black38
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;
    
    for(int i=0; i<listArray.length; i++){
      var asixY = offsetTop;
      if (i ==0) asixY = 10;
      var p1 = Offset(offsetLeft + i *(lineWidth + spacingX), asixY);
      var p2 = Offset(offsetLeft + i *(lineWidth + spacingX) ,size.height - offsetBot);
      canvas.drawLine(p1, p2, paint);

      // 绘制文字
      canvas.save();
      TextPainter textPainter = TextPainter()
        ..textDirection = TextDirection.ltr
        ..text = TextSpan(
          text: listArray[i],
          style: TextStyle(
            fontSize: 12,
            color: Colors.black38
          )
        )
        ..layout();

      double offsetx =  offsetLeft + i *(lineWidth + spacingX) - textPainter.size.width;
      double pointy = size.height - offsetBot + textPainter.size.height;
      canvas.translate(offsetx, pointy);
      if(i !=0 ){
        canvas.rotate(- pi * 0.15);
      }
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    for(int i = 0; i <= marks.length ; i ++) {
      var p1 = Offset(offsetLeft , offsetTop + i *(spacingY + lineWidth));
      var p2 = Offset(size.width - offsetRight, offsetTop + i *(spacingY + lineWidth));
      canvas.drawLine(p1, p2, paint);
      if(i != 0) {
        // 绘制横向刻度
        canvas.save();
        TextPainter textPainter = TextPainter()
          ..textDirection = TextDirection.ltr
          ..text = TextSpan(
            text: markArray[i - 1],
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16
            )
          )
          ..layout();
        double offsety = offsetTop + (i -1) *(spacingY + lineWidth) - textPainter.size.height *0.5;
        double offsetx = offsetLeft - textPainter.size.width - 5;
        canvas.translate(offsetx, offsety);
        textPainter.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }
    return _recorder.endRecording();
  }
}