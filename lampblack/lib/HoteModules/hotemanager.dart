import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idkitflutter/IDKit/IDKitToast.dart';
import 'package:lampblack/HoteModules/middledial.dart';
import 'package:lampblack/HoteModules/smalldial.dart';
import 'dialdraw.dart';
import 'linechartbig.dart';
import 'linechartsmall.dart';
import 'timeplate.dart';

class HoteManager extends StatefulWidget {
  _HoteManager createState() => _HoteManager();
}

class _HoteManager extends State<HoteManager> {
  double currentValue = 0;
  double time = 0;
  double value;
  double jumpValue = 0;
  List<Offset> points = [];
  List<Offset> points1 = [];
  // X 轴的起始固定偏移
  double offsetx = 0;
  // X 轴的总长度
  double axisxAllLength = 10000 - 10000 * 1.0 / 24;
  // 每分钟的长度
  double minuteLength = (10000 - 10000 * 1.0 / 24) / 1440;
  // Y 的顶部偏移
  double offsetTop = 20;
  // Y 轴的总长度
  double axisyAllLength = 230;
  // Y 轴刻度值
  double smally = 210 * 1.0 / 20;
  double bigally = 210 * 1.0 / 100;

  // 打开串口的方法
  static const openedSerialPorytPlatform =
      const MethodChannel('com.lamp.serialport');
  // 发送指令获取串口信息
  static const sendCmdSerialProtDataPlatform =
      const MethodChannel('com.lamp.serialportdata');

  // 油烟浓度值
  double _lampblackConcentrationValue;
  // 颗粒物浓度值
  double _particleConcentrationValue;
  // 非甲烷总烃值
  double _nonMethaneTotalHydrocarbonConcentrationValue;
  // 温度值
  double _temperatureValue;
  // 湿度值
  double _humidityValue;

  // 初始化，该方法只调用一次
  @override
  void initState() {
    super.initState();
    // 初始化参数值
    _lampblackConcentrationValue = 0;
    _particleConcentrationValue = 0;
    _nonMethaneTotalHydrocarbonConcentrationValue = 0;
    _temperatureValue = 0;
    _humidityValue = 0;

    // 打开串口
    openedSerialPort();
  }

  // 异常数据初始化
  void _abnormalSetDefaultData() {
    setState(() {
      _lampblackConcentrationValue = 0;
      _particleConcentrationValue = 0;
      _nonMethaneTotalHydrocarbonConcentrationValue = 0;
      _temperatureValue = 0;
      _humidityValue = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    SmallDial("油烟浓度", "mg/m3", _lampblackConcentrationValue),
                    SmallDial("颗粒物浓度", "mg/m3", _particleConcentrationValue),
                    MiddleDial("非甲烷总烃", "mg/m3",
                        _nonMethaneTotalHydrocarbonConcentrationValue),
                    DialDraw("温度", "˚C", _temperatureValue),
                    DialDraw("湿度", "%RH", _humidityValue),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SmallLineChart(points, points1, jumpValue),
                    ),
                    Expanded(
                      child: BigLineChart(),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  /// 打开串口调用
  void openedSerialPort() {
    openedSerialPorytPlatform
        .invokeMethod("callOpendSerialportMethod")
        .then((isState) {
      if (isState) {
        // 开启定时器
        timerGetSerialPortDataMethod();
      } else {
        IDKitToast.showText(context, "Device serial port open failed");
      }
    }).catchError((err) {
      IDKitToast.showText(context, "Device serial port open failed");
    });
  }

  // 定时器获取串口数据
  void timerGetSerialPortDataMethod() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      sendCmdSerialProtDataPlatform
          .invokeMethod("sendCommandObtainSerialPortData")
          .then((data) {
        var numstr = data as String;
        if (numstr.length == 0 || numstr == null) {
          _abnormalSetDefaultData();
          return;
        }
        List dataList = _to16List(numstr);
        if (dataList.length < 12) {
          _abnormalSetDefaultData();
          return;
        }
        setState(() {
          // 油烟浓度
          _lampblackConcentrationValue = _serialDataAnalysis(dataList, 3, 1000);
          // 颗粒物
          _particleConcentrationValue = _serialDataAnalysis(dataList, 5, 1000);
          // 非甲烷浓度
          _nonMethaneTotalHydrocarbonConcentrationValue =
              _serialDataAnalysis(dataList, 11, 1000);
          // 温度
          _temperatureValue = _serialDataAnalysis(dataList, 9, 10);
          // 湿度
          _humidityValue = _serialDataAnalysis(dataList, 7, 10);
        });
      }).catchError((err) {
        _abnormalSetDefaultData();
        IDKitToast.showText(context, "Failed to get serial data");
      });
    });
  }

  // 串口数据解析
  double _serialDataAnalysis(List list, int start, int scale) {
    if (list == null || list.length == 0) return 0;
    if (list.length < start || list.length < (start + 1)) return 0;
    if (scale == 0) return 0;
    return (256 * int.parse(list[start]) + int.parse(list[start + 1])) / scale;
  }

  // 字符串转16进制
  List<String> _to16List(String numstr) {
    List _list = [];
    for (int i = 0; i < numstr.length; i++) {
      if (i % 2 != 0) {
        var c = numstr.substring(i - 1, i + 1);
        _list.add("0x" + c);
      }
    }
    return _list;
  }
}
