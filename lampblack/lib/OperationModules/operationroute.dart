/// 运维界面
import 'package:flutter/material.dart';

class Operationroute extends StatefulWidget {
  _Operationroute createState() => _Operationroute();
}

class _Operationroute extends State<Operationroute> {
  @override
  void initState() {
    super.initState();
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
        backgroundColor: Colors.blue,
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 30),
              child: Text(
                "删除设备",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Container(
              width: 300,
              color: Colors.transparent,
              child: ConstrainedBox(
                child: Image.asset(
                  "images/op_side_bg.jpg",
                  fit: BoxFit.cover,
                ),
                constraints: BoxConstraints.expand(),
              ),
            ),
            Expanded(
              child: buildView(),
            )
          ],
        ),
      ),
    );
  }
}

// 权限弹窗
Widget buildAlert() {
  return Container(
    color: Colors.red,
  );
}

// 整个布局
Widget buildView() {
  return Container(
    child: ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return indexBuild(index);
      },
      itemCount: 2,
    ),
  );
}

Widget indexBuild(int index) {
  Widget _widget;
  if (index == 0) {
    _widget = Container(
      height: 220,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            color: Colors.black26,
            padding: EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '设备状态栏',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
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
        ],
      ),
    );
  } else {
    var _nameVc = TextEditingController();
    var _describeVc = TextEditingController();
    var _markVc = TextEditingController();
    var _authVc = TextEditingController();
    var _otherVc = TextEditingController();
    var _formKey = GlobalKey<FormState>();
    _widget = Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            color: Colors.black26,
            padding: EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '设备新增和更新',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            height: 250,
            child: Form(
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
                                        if (value.length == 0) return "不能为空";
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
                                        hintText: "请输入设备描述",
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
                                        hintText: "请输入设备标签",
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
          Container(
            color: Colors.lightBlue,
            height: 60,
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
                    onTap: () {},
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
  }
  return _widget;
}
