import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lampblack_app/dialdraw.dart';
import 'package:lampblack_app/linechartbig.dart';
import 'package:lampblack_app/linechartsmall.dart';
import 'package:lampblack_app/timeplate.dart';

class HoteManager extends StatefulWidget {
  _HoteManager createState() => _HoteManager();
}

class _HoteManager extends State <HoteManager> {
  double currentValue = 0 ; 
  double time = 0;
  double value;
  List<Offset> points = [];
  List<Offset> points1 = [];
  // X 轴的起始固定偏移
  double offsetx = 44;
  // X 轴的总长度
  double axisxAllLength = 440;
  // 每分钟的长度
  double minuteLength = 440 * 1.0 / 1440;
  // Y 的顶部偏移
  double offsetTop = 20;
  // Y 轴的总长度
  double axisyAllLength = 208;
  // Y 轴刻度值
  double smally = 20 *1.0 / 208;
  double bigally = 100 *1.0/208;

  @override
  Widget build(BuildContext context) {
    timerMethod();
    return Scaffold(
      appBar: AppBar(
        title: Text("实时数据监控"),
        centerTitle: true,
        actions: <Widget>[
          TimePlate(),
          Container(
            width: 40,
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DialDraw("油烟浓度", "mg/m3", currentValue),
                  DialDraw("颗粒物浓度", "mg/m3", currentValue),
                  DialDraw("非甲烷总烃", "mg/m3", currentValue),
                  DialDraw("温度", "˚C", currentValue),
                  DialDraw("湿度", "%RH",currentValue)
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SmallLineChart(points,points1),
                  ),
                  Expanded(
                    child: BigLineChart(),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }


  // 随机数
  double getRandom(int scal){
    double val = Random().nextDouble();
    return val * scal;
  }

  // 定时器
  void timerMethod() {
    Timer(Duration(minutes: 1), (){
      time += 1;
      if(time > 160) {
        time = 0;
        points1 = [];
        points = [];
      } else {
        double val = getRandom(120);
        var offys = val * smally;
        points.add(Offset(time * minuteLength + offsetx  + 10, axisyAllLength - offys));
        double val1 = getRandom(120);
        var offyb = val1 * smally;
        points1.add(Offset(time * minuteLength + offsetx + 10, axisyAllLength - offyb));
      }
      
      print(points);
      setState(() {
        double val = getRandom(100);
        currentValue = val.toInt().toDouble();
        points = points;
        points1= points1;
      });
    });
  }
}

