import 'package:flutter/material.dart';
import 'package:lampblack_app/dialdraw.dart';

class HoteManager extends StatefulWidget {
  _HoteManager createState() => _HoteManager();
}

class _HoteManager extends State <HoteManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("实时数据监控"),
        //backgroundColor: Color(0xFF141524),
      ),
      body: getMainPage(context),
    );
  }
}

Widget getMainPage(BuildContext context){
  return DialDraw();
}