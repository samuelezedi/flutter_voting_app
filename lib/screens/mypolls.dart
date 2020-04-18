import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:voterx/screens/widgets/botton_nav.dart';

class MyPolls extends StatefulWidget {
  @override
  _MyPollsState createState() => _MyPollsState();
}

class _MyPollsState extends State<MyPolls> {

  getStream( ) {

  }

  @override
  Widget build( BuildContext context ) {
    return Scaffold(
        bottomNavigationBar: BottomNav(2).build(context),
        backgroundColor: Colors.grey[200],
        body: StreamBuilder(
            stream: getStream(),
            builder: ( context, snapshot ) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.data.documents.length == 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[


                          IconButton(
                            icon: Icon(
                              FeatherIcons.info, color: Colors.black54,),
                            onPressed: ( ) {

                            },
                          ),
                          IconButton(
                            icon: Icon(
                              FeatherIcons.barChart2, color: Colors.black54,),
                            onPressed: ( ) {

                            },
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 120,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Oops!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "No polls available yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.50,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          onPressed: ( ) {

                          },
                          color: Colors.blue,
                          child: Text(
                            'Create Poll',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              }

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: ( ) {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            LineIcons.arrow_left,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(FeatherIcons.info, color: Colors
                                  .black54,),
                              onPressed: ( ) {

                              },
                            ),
                            IconButton(
                              icon: Icon(FeatherIcons.share2, color: Colors
                                  .black54,),
                              onPressed: ( ) {

                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: ( context, index ) {
                          var data = snapshot.data.documents[index];

                          return Container(
                            margin: EdgeInsets.only(bottom: 10,
                                left: 10,
                                right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ListTile(

                              title: Text(data['name']),
                              subtitle: Text(data['username'],
                                style: TextStyle(fontSize: 15),),
                              trailing: IconButton(
                                onPressed: ( ) {

                                },
                                icon: Icon(Icons.arrow_forward_ios,
                                  color: Colors.black54,),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }
        )
    );
  }
}
