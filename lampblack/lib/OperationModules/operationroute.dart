/// 运维界面
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idkitflutter/IDKit/IDKitToast.dart';
import 'package:lampblack/IDKit/IDKitAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Operationroute extends StatefulWidget {
  _Operationroute createState() => _Operationroute();
}

class _Operationroute extends State<Operationroute> {
  static const String apikey = "B=zpzEVugV0VJ5nbbnw3aGba124=";
  static const String deviceIdKey = "com.lamp_device_id_key";
  // 串口发送指令
  static const String serialSendCmd = "com.serilasend.cmd";
  // 设备信息默认设置
  static const List<String> _list = ["设备状态栏", "设备新增和更新", "串口发送指令"];
  Map stateMap = Map();
  Widget _widget;
  int _curIndex;
  String _devideName;
  String _devideId;
  String _devideMark;
  String _devideTime;
  String _devideDesc;
  bool _devideState;
  String _cmdString;
  // 缓存对象
  SharedPreferences _pref;
  // 设置默认值
  void _setDefaultValue() {
    _devideName = "--------";
    _devideName = "--------";
    _devideMark = "--------";
    _devideTime = "--------";
    _devideDesc = "--------";
    _devideId = "--------";
    _devideState = false;
    _cmdString = "-------";
  }

  // 获取缓存对象
  void _getSharePref() async {
    _pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    // 初始获取存储对象
    _getSharePref();
    for (int i = 0; i < _list.length; i++) {
      var _key = "key_$i";
      stateMap[_key] = false;
    }
    // 设置初始值
    _setDefaultValue();
    getDevideInfo();
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
                clickMethod: (index) async {
                  if (index == 1) {
                    IDKitAlert.removeAlert();
                  } else {
                    _delDevide();
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
                        onTap: () {
                          if (index == 0) {
                            getDevideInfo();
                          }
                          _buildSelecdWidget(index);
                        },
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

  // 删除设备
  void _delDevide() {
    if (_pref != null) {
      var _did = _pref.getString(deviceIdKey);
      if (_did != null && _did.length != 0) {
        IDKitToast.showLoading(context);
        BaseOptions _baseOptions = BaseOptions();
        _baseOptions.connectTimeout = 2000;
        _baseOptions.receiveTimeout = 2000;
        _baseOptions.headers = {"api-key": apikey};
        Dio _dio = Dio(_baseOptions);
        _dio.delete("http://api.heclouds.com/devices/$_did").then((result) {
          var res = result.data;
          if (res["errno"] == 0 && res["error"] == "succ") {
            IDKitToast.removeToast();
            IDKitToast.showText(context, "设备删除成功！");
            _setDefaultValue();
            _pref.remove(deviceIdKey);
            IDKitAlert.removeAlert();
          } else {
            IDKitToast.removeToast();
            IDKitToast.showText(context, "设备删除失败！");
            IDKitAlert.removeAlert();
          }
        }).catchError((err) {
          IDKitToast.removeToast();
        });
      }
    }
  }

  // 请求设备信息
  void getDevideInfo() async {
    _pref = await SharedPreferences.getInstance();
    if (_pref != null) {
      var _did = _pref.getString(deviceIdKey);
      if (_did != null && _did.length != 0) {
        Dio _dio = Dio();
        _dio.options.headers = {"api-key": apikey};
        _dio.get("http://api.heclouds.com/devices/$_did").then((value) {
          var errno = value.data["errno"];
          var err = value.data["error"];
          if (err == "succ" || errno == 0) {
            _devideName = value.data["data"]["title"] ?? "--------";
            _devideId = value.data["data"]["id"] ?? "--------";
            _devideMark = (value.data["data"]["tags"]).toString() ?? "--------";
            _devideTime = value.data["data"]["create_time"] ?? "--------";
            _devideDesc = value.data["data"]["desc"] ?? "--------";
            _devideState = value.data["data"]["online"] ?? false;
            _buildSelecdWidget(0);
          }
        });
      }
    }
  }

  // 选择那个模块
  void _buildSelecdWidget(int index) async {
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
                                _devideName ?? "",
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
                                _devideId ?? "",
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
                                _devideMark ?? "",
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
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      _devideState == true
                                          ? "images/z_line.png"
                                          : "images/n_line.png",
                                      width: 18,
                                      height: 18,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _devideState == true ? "在线" : "掉线",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                )),
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
                                _devideTime ?? "",
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
                                _devideDesc ?? "",
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
                  height: 200,
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
                            var did = _pref.getString(deviceIdKey);
                            if (did != null && did.length != 0) {
                              IDKitToast.showText(context, "该设备已经被注册！");
                              return;
                            }
                            if (_formKey.currentState.validate()) {
                              IDKitToast.showLoading(context);
                              var tags = "${_markVc.value.text}";
                              Map _param = Map<String, dynamic>();
                              _param["title"] = "${_nameVc.value.text}";
                              _param["desc"] = "${_describeVc.value.text}";
                              _param["tags"] = tags.split(",");
                              if (_authVc.value.text.length != 0) {
                                _param["auth_info"] = "${_authVc.value.text}";
                              }
                              BaseOptions options = BaseOptions(
                                connectTimeout: 5000,
                                receiveTimeout: 3000,
                                headers: {"api-key": apikey},
                              );
                              Dio _dio = Dio(options);
                              _dio
                                  .post("http://api.heclouds.com/devices",
                                      data: json.encode(_param))
                                  .then((value) async {
                                var errno = value.data["errno"];
                                var err = value.data["error"];
                                if (err == "succ" || errno == 0) {
                                  IDKitToast.removeToast();
                                  var id = value.data["data"]["device_id"];
                                  _pref.setString(deviceIdKey, id);
                                  IDKitToast.showText(context, "添加设备成功！");
                                }
                              }).catchError((err) {
                                IDKitToast.removeToast();
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
                          onTap: () async {
                            var did = _pref.getString(deviceIdKey);
                            if (did != null && did.length != 0) {
                              if (_formKey.currentState.validate()) {
                                IDKitToast.showLoading(context);
                                var tags = "${_markVc.value.text}";
                                Map _param = Map<String, dynamic>();
                                _param["title"] = "${_nameVc.value.text}";
                                _param["desc"] = "${_describeVc.value.text}";
                                _param["tags"] = tags.split(",");
                                if (_authVc.value.text.length != 0) {
                                  _param["auth_info"] = "${_authVc.value.text}";
                                }
                                BaseOptions options = BaseOptions(
                                  connectTimeout: 5000,
                                  receiveTimeout: 3000,
                                  headers: {"api-key": apikey},
                                  method: "PUT",
                                );
                                Dio _dio = Dio(options);
                                _dio
                                    .request(
                                  "http://api.heclouds.com/devices/$did",
                                  data: json.encode(_param),
                                )
                                    .then((value) {
                                  var errno = value.data["errno"];
                                  var err = value.data["error"];
                                  if (err == "succ" || errno == 0) {
                                    IDKitToast.removeToast();
                                    IDKitToast.showText(context, "更新设备成功！");
                                  } else {
                                    IDKitToast.removeToast();
                                    IDKitToast.showText(context, "更新设备失败！");
                                  }
                                }).catchError((err) {
                                  IDKitToast.removeToast();
                                });
                              }
                            } else {
                              IDKitToast.showText(context, "请先注册设备！");
                            }
                          },
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
    } else if (index == 2) {
      _cmdString = _pref.getString(serialSendCmd);
      var _cmdVc = TextEditingController();
      widget = Container(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  bottom: 5,
                ),
                width: double.infinity,
                child: Text(
                  "原串口发送指令:",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  _cmdString,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black38,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                width: double.infinity,
                child: Text(
                  "新串口发送指令:",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 44,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _cmdVc,
                        decoration: InputDecoration(
                          hintText: "请输入发送指令",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Container(
                        width: 300,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            "发送该指令",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        var _value = _cmdVc.value.text;
                        if (_value.length == 0) {
                          IDKitToast.showText(context, "请输入发送指令");
                          return;
                        }
                        var _cmd = _pref.getString(serialSendCmd);
                        if (_cmd == null || _cmd.length == 0) {
                          // 存储 cmd
                          _pref.setString(serialSendCmd, _value);
                          setState(() {
                            _cmdString = _value;
                            _buildSelecdWidget(2);
                          });
                          IDKitToast.showText(context, "发送指令成功");
                        } else if (_value == _cmd) {
                          IDKitToast.showText(context, "发送指令与元指令相同");
                        } else {
                          IDKitAlert.alert(
                            context,
                            title: "温馨提示",
                            content: "是否确定更改发送指令",
                            actions: ["取消", "确定"],
                            clickMethod: (index) {
                              if (index == 0) {
                                IDKitAlert.removeAlert();
                              } else {
                                _pref.setString(serialSendCmd, _value);
                                setState(() {
                                  _cmdString = _value;
                                  _buildSelecdWidget(2);
                                });
                                IDKitToast.showText(context, "发送指令成功");
                                IDKitAlert.removeAlert();
                              }
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    setState(() {
      _widget = widget;
    });
  }
}
