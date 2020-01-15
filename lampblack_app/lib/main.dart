import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lampblack_app/hotemanager.dart';

void main(){
  debugPaintSizeEnabled = false;
  return runApp(LampBlackApp());
}

class LampBlackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginRoute(),
      ),
      routes: {
        "hote":(context) => HoteManager()
      },
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
            constraints: BoxConstraints.expand()
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "物联网油烟管理平台",
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ItemButton(
                      title:"店家",
                      icon: Icon(
                        Icons.home,
                        size: 60,
                      ),
                      methodBlock: (){
                        Navigator.pushNamed(context, "hote");
                      }
                    ),
                    SizedBox(

                    ),
                    ItemButton(
                      title: "运维",
                      icon: Icon(
                        Icons.person,
                        size: 60,
                      ),
                      methodBlock: (){

                      },
                    )
                  ],
                ),
              )
            ],
          )
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: icon,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 25
                ),
              )
            )
          ],
        ),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          color: Colors.white70,
        ),
      ),
      onTap: methodBlock,
    );
  }
}
