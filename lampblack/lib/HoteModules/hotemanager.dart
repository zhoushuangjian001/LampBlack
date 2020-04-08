import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idkitflutter/IDKit/IDKitToast.dart';
import 'package:lampblack/HoteModules/middledial.dart';
import 'package:lampblack/HoteModules/smalldial.dart';
import 'package:lampblack/IDKit/IDKitAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dialdraw.dart';
import 'linechartbig.dart';
import 'linechartsmall.dart';
import 'timeplate.dart';

class HoteManager extends StatefulWidget {
  _HoteManager createState() => _HoteManager();
}

class _HoteManager extends State<HoteManager> {
  // 滚动偏移（分钟为准）
  double jumpValue = 0;
  // 温度点组
  List<Offset> temperaturePoints = [];
  // 湿度点组
  List<Offset> humidityPoints = [];
  // 颗粒物点组
  List<Offset> particulatePoints = [];
  // 油烟浓度点组
  List<Offset> lampPoints = [];

  /// X 轴的配置
  // X 轴的起始固定偏移
  double xStartOffset = 0;
  // X 轴的总长度
  double xAxisLength = 9600;
  // X 轴每分钟的长度
  double xMinuteLength;

  /// Y 轴配置
  // Y 轴的总长度
  double yAsixLength = 230;
  // Y 的顶部偏移
  double yAsixTop = 20;

  /// Y 轴刻度值
  // 20 刻度
  double ySmallUnitValue;
  // 100 刻度
  double yBigUnitValue;

  // 定时器取值间隔
  int timeInterval = 10;

  // 串口发送指令
  static const String serialSendCmd = "com.serilasend.cmd";

  // 打开串口的方法
  static const openedSerialPorytPlatform =
      const MethodChannel('com.lamp.serialport');
  // 发送指令获取串口信息
  static const sendCmdSerialProtDataPlatform =
      const MethodChannel('com.lamp.serialportdata');

  // 缓存对象
  SharedPreferences _pref;

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
    // 刻度值初始化
    ySmallUnitValue = (yAsixLength - yAsixTop) / 20;
    yBigUnitValue = ySmallUnitValue / 5;
    xMinuteLength = xAxisLength / 1440;

    // 初始化参数值
    _lampblackConcentrationValue = 0;
    _particleConcentrationValue = 0;
    _nonMethaneTotalHydrocarbonConcentrationValue = 0;
    _temperatureValue = 0;
    _humidityValue = 0;
    // 获取存储值
    _getSharePref();
    // 打开串口
    openedSerialPort();
  }

  // X 轴点的获取
  double xAxsiValue() {
    DateTime time = DateTime.now();
    int hour = time.hour;
    int minute = time.minute;
    int second = time.second;
    // 跳转值
    if (hour == 0) {
      jumpValue = 0;
      removeAllPoints();
    } else {
      jumpValue = hour * xAxisLength / 24;
    }
    // 转化为分
    double value = hour * 60 + minute + second / 60;
    return value * xMinuteLength + xStartOffset;
  }

  // 清空所有点数组
  void removeAllPoints() {
    temperaturePoints = [];
    humidityPoints = [];
    particulatePoints = [];
    humidityPoints = [];
  }

  // 值转化为点
  void yAxsiValueToPoint(
      List<Offset> points, double dx, double value, double unitvalue) {
    double dy = yAsixLength - value * unitvalue;
    Offset point = Offset(dx, dy);
    points.add(point);
  }

  // 获取缓存对象
  void _getSharePref() async {
    _pref = await SharedPreferences.getInstance();
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
                      // 颗粒物 & 油烟
                      child: SmallLineChart(
                        particulatePoints,
                        lampPoints,
                        jumpValue,
                      ),
                    ),
                    Expanded(
                      child: BigLineChart(
                        temperaturePoints,
                        humidityPoints,
                        jumpValue,
                      ),
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
    var _cmd = _pref.getString(serialSendCmd);
    if (_cmd == null || _cmd.length == 0) {
      IDKitAlert.alert(context,
          title: "温馨提示",
          content: "清先注册发射指令",
          actions: ["确定"], clickMethod: (index) {
        Navigator.of(context).pop();
        IDKitAlert.removeAlert();
      });
      return;
    }
    Timer.periodic(Duration(seconds: timeInterval), (timer) {
      sendCmdSerialProtDataPlatform
          .invokeMethod(
        "sendCommandObtainSerialPortData",
        _cmd,
      )
          .then((data) {
        var numstr = data as String;
        if (numstr.length == 0 || numstr == null) {
          _abnormalSetDefaultData();
          IDKitToast.showText(context, "字符串为零");
          return;
        }
        List dataList = _to16List(numstr);
        if (dataList.length < 12) {
          _abnormalSetDefaultData();
          IDKitToast.showText(context, "数字个数不够12");
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

          /// 数组点的操作
          // 颗粒物
          yAxsiValueToPoint(particulatePoints, xAxsiValue(),
              _particleConcentrationValue, ySmallUnitValue);
          // 油烟浓度
          yAxsiValueToPoint(lampPoints, xAxsiValue(),
              _lampblackConcentrationValue, ySmallUnitValue);

          // 温度
          yAxsiValueToPoint(temperaturePoints, xAxsiValue(), _temperatureValue,
              yBigUnitValue);
          // 湿度
          yAxsiValueToPoint(
              humidityPoints, xAxsiValue(), _humidityValue, yBigUnitValue);
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
  List _to16List(String numstr) {
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
