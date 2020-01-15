import 'dart:ui';

import 'package:flutter/material.dart';

class TimePlate extends StatefulWidget {
  _TimePlate createState() => _TimePlate();
}

class _TimePlate extends State<TimePlate> {
  // 年月日 时分秒
  int year;
  int month;
  int day;
  int hour;
  int minute;
  int second;

  void getTime(){
    Future.delayed(Duration(seconds: 1),(){
      DateTime time = DateTime.now();
      setState(() {
        year = time.year;
        month = time.month;
        day = time.day;
        hour = time.hour;
        minute = time.minute;
        second = time.second;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    year = day = hour = month = minute = second = 00;
  }

  @override
  Widget build(BuildContext context) {
    getTime();
    return Container(
      child: Center(
        child: Text(
          "$year 年 " + "$month".padLeft(2,"0")+ " 月 " + "$day".padLeft(2,"0") + " 日 " + "$hour".padLeft(2,"0") + " 时 " + "$minute".padLeft(2,"0") + " 分 " + "$second".padLeft(2,"0") + " 秒",
          style: TextStyle(
            fontSize: 20
          ),
        ),
      )
    );
  }
}