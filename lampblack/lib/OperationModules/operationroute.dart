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
              color: Colors.black12,
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
    child: Container(
      margin: EdgeInsets.only(left: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "设备名称:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Lamp_00001"),
              SizedBox(
                width: 20,
              ),
              Text("设备状态:"),
              Icon(Icons.queue),
              Text("掉线"),
            ],
          )
        ],
      ),
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
