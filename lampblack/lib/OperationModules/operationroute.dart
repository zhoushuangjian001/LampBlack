import 'package:dio/dio.dart';

/// 运维界面
import 'package:flutter/material.dart';
import 'package:lampblack/IDKit/IDKitAlert.dart';

class Operationroute extends StatefulWidget {
  _Operationroute createState() => _Operationroute();
}

class _Operationroute extends State<Operationroute> {
  static const List<String> _list = ["设备状态栏", "设备新增和更新", "其他"];
  Map stateMap = Map();
  Widget _widget;
  int _curIndex;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _list.length; i++) {
      var _key = "key_$i";
      stateMap[_key] = false;
    }
    _buildSelecdWidget(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "运维",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 30, top: 15),
              child: Text(
                "删除设备",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            onTap: () {
              IDKitAlert.alert(
                context,
                title: "温馨提示",
                content: "您确定要删除设备吗，删除后设备在云上信息将全部清除！",
                actions: ["确定", "取消"],
                clickMethod: (index) {
                  if (index == 1) {
                    IDKitAlert.removeAlert();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Container(
              width: 300,
              color: Colors.transparent,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var _title = _list[index];
                  var _key = "key_$index";
                  var _isState = stateMap[_key];
                  return Column(
                    children: <Widget>[
                      Divider(
                        height: 0.5,
                        color: Colors.black12,
                      ),
                      GestureDetector(
                        child: Container(
                          height: 60,
                          child: Align(
                            child: Text(
                              _title,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                          color:
                              _isState == true ? Colors.blue : Colors.black38,
                        ),
                        onTap: () => _buildSelecdWidget(index),
                      ),
                    ],
                  );
                },
                itemCount: _list.length,
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

  // 选择那个模块
  void _buildSelecdWidget(int index) {
    var key = "key_$_curIndex";
    stateMap[key] = false;
    var _key = "key_$index";
    stateMap[_key] = true;
    _curIndex = index;

    Widget widget;
    if (index == 0) {
      widget = Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "设备名称:",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "Lamp_00000",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "设备    ID:",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "00001111",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "设备标签:",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "信阳、烤肉店",
                                style: TextStyle(
                                  fontSize: 20,
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "设备状态:",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "在线",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "创建时间:",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "2020-3-20",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "设备描述:",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "信阳、烤肉店",
                                style: TextStyle(
                                  fontSize: 20,
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
          ],
        ),
      );
    } else if (index == 1) {
      var _nameVc = TextEditingController();
      var _describeVc = TextEditingController();
      var _markVc = TextEditingController();
      var _authVc = TextEditingController();
      var _otherVc = TextEditingController();
      var _formKey = GlobalKey<FormState>();
      widget = ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 280,
                  child: Scaffold(
                    body: Form(
                      key: _formKey,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "设备名称",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: TextFormField(
                                              controller: _nameVc,
                                              decoration: InputDecoration(
                                                hintText: "请输入设备名称",
                                              ),
                                              validator: (value) {
                                                if (value.length == 0)
                                                  return "不能为空";
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "设备描述",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: TextFormField(
                                              controller: _describeVc,
                                              decoration: InputDecoration(
                                                hintText: "请入设备描述",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "设备标签",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: TextFormField(
                                              controller: _markVc,
                                              decoration: InputDecoration(
                                                hintText: "请入设备标签",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "设备鉴权信息",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: TextFormField(
                                              controller: _authVc,
                                              decoration: InputDecoration(
                                                hintText: "请输入设备鉴权信息",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "设备其他信息",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: TextFormField(
                                              controller: _otherVc,
                                              decoration: InputDecoration(
                                                hintText: "请输入设备其他信息",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.lightBlue,
                  height: 60,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              "新增设备",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              Map _param = Map<String, dynamic>();
                              _param["title"] = _nameVc.value;
                              _param["desc"] = _describeVc.value;
                              _param["tags"] = _markVc.value;
                              _param["auth_info"] = _authVc.value;
                              _param["other"] = _otherVc.value;

                              BaseOptions options = BaseOptions(
                                baseUrl: "http://api.heclouds.com",
                                connectTimeout: 5000,
                                receiveTimeout: 3000,
                              );
                              Dio _dio = Dio(options);
                              _dio
                                  .post("/devices", queryParameters: _param)
                                  .then((value) {
                                print(value);
                              });
                            }
                          },
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            child: Text(
                              "更新设备",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: 1,
      );
    } else {
      widget = Container(
        color: Colors.pink,
      );
    }
    setState(() {
      _widget = widget;
    });
  }
}
