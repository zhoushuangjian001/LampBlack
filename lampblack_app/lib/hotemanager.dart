import 'package:flutter/material.dart';

class HoteManager extends StatefulWidget {
  _HoteManager createState() => _HoteManager();
}

class _HoteManager extends State <HoteManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("实时数据监控"),
      ),
      body: getMainPage(context),
    );
  }
}

Widget getMainPage(BuildContext context){
  return Center(
    child: Text(
      "测试-店家"
    ),
  );
}