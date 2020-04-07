import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'axisymark.dart';
import 'scrollreseau.dart';

// ignore: must_be_immutable
class BigLineChart extends StatelessWidget {
  Picture _bgReseau;
  final List<Offset> temperaturePoints;
  final List<Offset> humidityPoints;
  final double jumpValue;
  BigLineChart(this.temperaturePoints, this.humidityPoints, this.jumpValue);

  // 初始配置
  List<String> marks = [
    "0",
    "10",
    "20",
    "30",
    "40",
    "50",
    "60",
    "70",
    "80",
    "90",
    "100",
  ];

  // ScrollController
  ScrollController _scrollC1 = ScrollController();

  void initConfig() {
    Size size = Size(10000, 270);
    _bgReseau = ScrollReseau(marks.length, size).getBgView();
  }

  void finshUi() {
    WidgetsBinding.instance.addPostFrameCallback((value) {
      _scrollC1.jumpTo(jumpValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    finshUi();
    initConfig();
    return Center(
        child: Container(
      width: 512,
      color: Colors.white38,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomPaint(
                  size: Size(150, 30),
                  painter: LineChartTopItemView("温度", Colors.red),
                ),
                CustomPaint(
                  size: Size(140, 30),
                  painter: LineChartTopItemView("湿度", Colors.blue),
                )
              ],
            ),
          ),
          Container(
            height: 270,
            child: Row(
              children: <Widget>[
                AxisYMark(marks.reversed.toList(), Size(40, 270)),
                Container(
                  width: 440,
                  child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      controller: _scrollC1,
                      child: Container(
                        width: 10000,
                        child: CustomPaint(
                          size: Size(10000, 270),
                          painter: LineChart(
                            _bgReseau,
                            temperaturePoints,
                            humidityPoints,
                          ),
                        ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}

/// 折线图的顶部
class LineChartTopItemView extends CustomPainter {
  final String title;
  final Color color;
  LineChartTopItemView(this.title, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double lineWidth = 2;
    double height = size.height;
    double width = size.width;
    canvas.save();
    var paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;
    var p1 = Offset(10, height * 0.5 - lineWidth * 0.5);
    var p2 = Offset(60, height * 0.5 - lineWidth * 0.5);
    canvas.drawLine(p1, p2, paint);
    canvas.save();
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(35, height * 0.5 - lineWidth * 0.5), 5, paint);
    canvas.restore();
    TextPainter textPainter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = TextSpan(
          text: title, style: TextStyle(fontSize: 12, color: Colors.black))
      ..layout();
    double textpointX = width - 70;
    double textpointY = height * 0.5 - textPainter.size.height * 0.5;
    textPainter.paint(canvas, Offset(textpointX, textpointY));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// 折线图
class LineChart extends CustomPainter {
  Picture _bgReseau;
  final List<Offset> points1;
  final List<Offset> points2;
  LineChart(this._bgReseau, this.points1, this.points2);
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制网格背景图片
    canvas.drawPicture(_bgReseau);
    drawMethod(canvas, 0, points1);
    drawMethod(canvas, 1, points2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// 绘制
  void drawMethod(Canvas canvas, int type, List<Offset> points) {
    var color = Colors.white;
    if (type == 0) {
      color = Colors.red;
    } else if (type == 1) {
      color = Colors.blue;
    }
    var paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    canvas.drawPoints(PointMode.polygon, points, paint);
  }
}
