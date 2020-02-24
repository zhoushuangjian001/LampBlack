/// 运维界面
import 'package:flutter/material.dart';

class Operationroute extends StatefulWidget {
  _Operationroute createState() => _Operationroute();
}

class _Operationroute extends State<Operationroute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "运维"
        ),
      ),
      body: Container(
        child: Text(
          "operation 运维"
        ),
      ),
    );
  }
}