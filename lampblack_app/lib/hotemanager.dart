import 'package:flutter/material.dart';
import 'package:lampblack_app/dialdraw.dart';

class HoteManager extends StatefulWidget {
  _HoteManager createState() => _HoteManager();
}

class _HoteManager extends State <HoteManager> {
  double currentValue = 0 ; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("实时数据监控"),
        //backgroundColor: Color(0xFF141524),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DialDraw("油烟浓度", "mg/m3", currentValue),
                  DialDraw("颗粒物浓度", "mg/m3", currentValue),
                  DialDraw("非甲烷总烃", "mg/m3", currentValue),
                  DialDraw("温度", "˚C", currentValue),
                  DialDraw("湿度", "%RH",currentValue)
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("油烟浓度"),
                    onPressed: (){
                      setState(() {
                        currentValue ++;
                        print("----");
                        print(currentValue);
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("颗粒物"),
                    onPressed: (){
                      setState(() {
                        currentValue --;
                        print("----");
                        print(currentValue);
                      });

                    },
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

