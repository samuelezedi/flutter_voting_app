import 'package:flutter/material.dart';

class CreatePolls extends StatefulWidget {
  @override
  _CreatePollsState createState() => _CreatePollsState();
}

class _CreatePollsState extends State<CreatePolls> {
  BuildContext context;
  final _formKey = GlobalKey<FormState>();
  TextEditingController question, opt1, opt2, opt3, opt4 = TextEditingController();

  sendPolls(type) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        ),
        body: Container(
          child: Column(
            children: <Widget>[
              TextFormField(
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter question',
                  prefixIcon: Icon(Icons.question_answer)
                ),
                controller: question,
                validator: (value){
                  return value.toString().trim() == ""  ? 'Enter a question' : null;
                },
              )
            ],
          ),
        )
    );
  }
}
