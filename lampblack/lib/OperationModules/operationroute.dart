/// 运维界面
import 'package:flutter/material.dart';

class Operationroute extends StatefulWidget {
  _Operationroute createState() => _Operationroute();
}

class _Operationroute extends State<Operationroute> {
  static Widget _widget;
  static const List<String> _itemsTitle = ["设备状态", "注册设备", "更新设备"];
  static const List<Icon> _itemsIcon = [
    Icon(Icons.devices),
    Icon(Icons.receipt),
    Icon(Icons.update),
  ];
  var stateMap = new Map();
  static var _curIndex;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _itemsTitle.length; i++) {
      var key = "key_$i";
      stateMap[key] = false;
    }
    _clickItems(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("运维"),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Container(
              width: 300,
              color: Colors.black45,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var key = "key_$index";
                  return GestureDetector(
                    child: Container(
                      height: 60,
                      color: stateMap[key] == true
                          ? Colors.redAccent
                          : Colors.black54,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _itemsIcon[index],
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("${_itemsTitle[index]}")
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    onTap: () => _clickItems(index),
                  );
                },
                itemCount: _itemsTitle.length,
              ),
            ),
            Expanded(
              child: _widget,
            )
          ],
        ),
      ),
    );
  }

  // 事件调用
  void _clickItems(int index) {
    var key = "key_$index";
    var otherkey = "key_$_curIndex";
    setState(() {
      stateMap[otherkey] = false;
      stateMap[key] = true;
    });
    _curIndex = index;
    var _tempWidget;
    if (index == 0) {
      _tempWidget = buildDeviceStateWidget();
    }
    if (index == 1) {
      _tempWidget = buildDeviceRegisterWidget();
    }

    if (index == 2) {
      _tempWidget = buildDeviceUpdateWidget();
    }
    setState(() {
      _widget = _tempWidget;
    });
  }
}

// 权限弹窗
Widget buildAlert() {
  return Container(
    color: Colors.red,
  );
}

// 设备状态
Widget buildDeviceStateWidget() {
  return Container(
    child: Column(
      children: <Widget>[
        Container(
          height: 180,
          color: Colors.green,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              "设备名称:",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "Lamp_00000",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              "设备     ID:",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "00001111",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              "设备标签:",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "信阳、烤肉店",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              "设备状态:",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "在线",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              "创建时间:",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "2020-3-20",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              "设备描述:",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "信阳、烤肉店",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.pink,
          ),
        ),
        Container(
          height: 80,
          color: Colors.red,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    "© NetWork小贱和曹小强所有",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                height: 20,
                width: 1,
              ),
              Container(
                width: 200,
                child: Text(
                  "删除设备",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// 设备注册
Widget buildDeviceRegisterWidget() {
  return Container(
    color: Colors.green,
  );
}

// 设备更新
Widget buildDeviceUpdateWidget() {
  return Container(
    color: Colors.purple,
  );
}
