
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:voterx/main.dart';
import 'package:voterx/screens/auth/login.dart';
import 'package:voterx/screens/index.dart';
import 'package:voterx/screens/mypolls.dart';

class BottomNav {
  int pos = 1;
  Color homeColor = Colors.grey;
  Color myPollsColor = Colors.grey;
  BottomNav(this.pos){
    if(this.pos == 1){
      this.homeColor = Colors.blue;
    }
    if(this.pos == 2){
      this.myPollsColor = Colors.blue;
    }

  }

  build(context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(top: 8, ),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
          Border(top: BorderSide(width: 0.5, color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if(this.pos!=1){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Index()));

              }
            },
            child: Column(
              children: <Widget>[
                Icon(LineIcons.bar_chart, color: homeColor),
                Text(
                  'All Polls',
                  style: TextStyle(fontSize: 10,color: homeColor),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if(this.pos!=2){
                if(isLoggedIn){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyPolls()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                }
              }
            },
            child: Column(
              children: <Widget>[
                Icon(FeatherIcons.userCheck, color: myPollsColor),
                Text(
                  'My Polls',
                  style: TextStyle(fontSize: 10,color: myPollsColor),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}