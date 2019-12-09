import 'package:flutter/material.dart';

main() => runApp(LampBlackApp());

class LampBlackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginRoute(),
      ),
    );
  }
}

class LoginRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ConstrainedBox(
            child: Image.asset(
              "./assets/login_bg.jpg",
              fit: BoxFit.cover,
            ),
            constraints: BoxConstraints.expand()),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120,
              ),
              Container(
                child: Text(
                  "物联网油烟管理平台",
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                height: 100,
              )
            ],
          ),
        ),
        Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ItemButton(
                    title: "店家", 
                    icon: Icon(
                      Icons.ac_unit,
                      size: 35
                    ), 
                    methodBlock: () {}),
                ItemButton(
                    title: "运维",
                    icon: Icon(
                      Icons.access_alarm,
                      size: 35
                    ),
                    methodBlock: () {}),
              ],
            ),
            width: 300,
            height: 100,
          ),
        )
      ],
    );
  }
}

class ItemButton extends StatelessWidget {
  ItemButton({Key key, this.title, this.icon, this.methodBlock})
      : super(key: key);
  final String title;
  final Icon icon;
  final VoidCallback methodBlock;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: icon,
            ),
            Container(
              child: Text(title),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white54,
        ),
      ),
      onTap: methodBlock,
    );
  }
}
