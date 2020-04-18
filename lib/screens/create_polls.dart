import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CreatePolls extends StatefulWidget {
  @override
  _CreatePollsState createState() => _CreatePollsState();
}

class _CreatePollsState extends State<CreatePolls> {
  BuildContext context;
  final _formKey = GlobalKey<FormState>();
  TextEditingController question, opt1, opt2, opt3, opt4,hour,minutes,seconds = TextEditingController();
  var sec = <PopupMenuEntry<String>>[];
  var hours = <PopupMenuEntry<String>>[];
  var mins = <PopupMenuEntry<String>>[];

  sendPolls(type) {

  }

  populateFields(value,type) {
    if(type == 'sec') {
      for (var i = 1; i <= value; i++) {
        sec.add(PopupMenuItem<String>(
          value: i.toString(),
          child: Text(i.toString()),
        ));
      }
    }
    if(type == 'hour') {
      for (var i = 1; i <= value; i++) {
        hours.add(PopupMenuItem<String>(
          value: i.toString(),
          child: Text(i.toString()),
        ));
      }
    }
    if(type == 'min') {
      for (var i = 1; i <= value; i++) {
        mins.add(PopupMenuItem<String>(
          value: i.toString(),
          child: Text(i.toString()),
        ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateFields(60,'min');
    populateFields(60,'sec');
    populateFields(25,'hour');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Poll'),
        ),
        body: Container(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter question',
                      prefixIcon: Icon(LineIcons.question)
                    ),
                    controller: question,
                    validator: (value){
                      return value.toString().trim() == ""  ? 'Enter a question' : null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    maxLength: 30,
                    decoration: InputDecoration(
                        hintText: 'Option 1',
                        counterText: '',
                        prefixIcon: Icon(LineIcons.info_circle)
                    ),
                    controller: opt1,
                    validator: (value){
                      return value.toString().trim() == ""  ? 'Enter a question' : null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    maxLength: 30,
                    decoration: InputDecoration(
                      counterText: '',
                        hintText: 'Option 2',
                        prefixIcon: Icon(LineIcons.info_circle)
                    ),
                    controller: opt2,
                    validator: (value){
                      return value.toString().trim() == ""  ? 'Enter a question' : null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    maxLength: 30,
                    decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Option 3 (optional)',
                        prefixIcon: Icon(LineIcons.info_circle)
                    ),
                    controller: opt3,
                    validator: (value){
                      return value.toString().trim() == ""  ? 'Enter a question' : null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    maxLength: 30,
                    decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Option 4 (optional)',
                        prefixIcon: Icon(LineIcons.info_circle)
                    ),
                    controller: opt4,
                    validator: (value){
                      return value.toString().trim() == ""  ? 'Enter a question' : null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: TextFormField(
                          maxLength: 30,
                          initialValue: "24",
                          decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Hour',
                            suffixIcon: popMenu(1)
                          ),
                          readOnly: true,
                          controller: hour,
                          validator: (value){
                            return value.toString().trim() == ""  ? 'Enter a question' : null;
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: TextFormField(
                          maxLength: 30,
                          decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Min',
                            suffixIcon: popMenu(2)
                          ),
                          readOnly: true,
                          controller: minutes,
                          validator: (value){
                            return value.toString().trim() == ""  ? 'empty' : null;
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: TextFormField(
                          maxLength: 30,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Sec',
                            suffixIcon: popMenu(3)
                          ),
                          readOnly: true,
                          controller: seconds,
                          validator: (value){
                            return value.toString().trim() == ""  ? 'empty' : null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 35,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: FlatButton(
                        onPressed: () {
                          sendPolls(2);
                        },
                        child: Text('Draft',style: TextStyle(color: Colors.blue),),
                      ),
                    ),
                    Container(
                      height: 35,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: FlatButton(
                        onPressed: () {
                          sendPolls(1);
                        },
                        child: Text('Publish',style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }



  popMenu(type) {
      return PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
        itemBuilder: (BuildContext context) => type == 1 ? hours : type == 2 ? mins : sec,
        onSelected: (value) {
          print(value);
          designateAction(value,type);
        },
      );
  }

  designateAction(value,type) {
    if(type == 1){
      setState(() {
        hour.text = value;
      });
    }
    if(type == 2){
      print('DSFDFSF');
      print(value);
      setState(() {
        print(value);
        minutes.text = value ;
      });
    }
    if(type == 3){
      setState(() {
        seconds.text = value;
      });
    }
  }
}
