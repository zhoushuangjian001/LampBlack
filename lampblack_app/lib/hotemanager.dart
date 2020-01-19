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
  double jumpValue = 0;
  List<Offset> points = [];
  List<Offset> points1 = [];
  // X 轴的起始固定偏移
  double offsetx = 0;
  // X 轴的总长度
  double axisxAllLength = 10000 - 10000 *1.0/24;
  // 每分钟的长度
  double minuteLength = (10000 - 10000 *1.0/24) / 1440;
  // Y 的顶部偏移
  double offsetTop = 20;
  // Y 轴的总长度
  double axisyAllLength = 230;
  // Y 轴刻度值
  double smally =  210 * 1.0/20;
  double bigally = 210 *1.0 / 100;

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
                    child: SmallLineChart(points,points1, jumpValue),
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
    Timer(Duration(seconds: 1), (){
      if(time % 60 == 0 && time != 0) {
        jumpValue = minuteLength * time;
      }
      time += 1;
      if(time > 10000) {
        time = 0;
        points1 = [];
        points = [];
      } else {
        double val = getRandom(20);
        var offys = val * smally;
        points.add(Offset(time * minuteLength + offsetx , axisyAllLength - offys));
        double val1 = getRandom(20);
        var offyb = val1 * smally;
        points1.add(Offset(time * minuteLength + offsetx, axisyAllLength - offyb));
      }
      
      setState(() {
        double val = getRandom(100);
        currentValue = val.toInt().toDouble();
        points = points;
        points1= points1;
        jumpValue = jumpValue;
      });
    });
  }
}

