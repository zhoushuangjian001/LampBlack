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
      time += 3;
      if(time > 160) {
        time = 0;
        points1 = [];
        points = [];
      } else {
        double val = getRandom(100);
        points.add(Offset(time, val));
        double val1 = getRandom(20);
        points1.add(Offset(time, val1));
      }
      
      setState(() {
        double val = getRandom(100);
        currentValue = val.toInt().toDouble();
        points = points;
        points1= points1;
      });
    });
  }
}

