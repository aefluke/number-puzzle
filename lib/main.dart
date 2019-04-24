import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new ListDisplay(),
    );
  }
}

class ListDisplay extends StatefulWidget {
  List<String> litems = [];
  int number;
  ListDisplay() {
    this.number = getRandomNumber();
    print(number);
    addThreeItemsAsHint();
  }

  void addThreeItemsAsHint() {
    litems.add(getRandomNumber().toString());
    litems.add(getRandomNumber().toString());
    litems.add(getRandomNumber().toString());
  }

  int getRandomNumber() {
    return Random().nextInt(8999) + 1000;
  }

  String getGuessCount() {
    return (this.litems.length - 2).toString();
  }

  @override
  State createState() => new Answers();
}

class Answers extends State<ListDisplay> {
  final TextEditingController eCtrl = new TextEditingController();

  FocusNode focusNode = new FocusNode();
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sayı Bulmaca"),
        ),
        body: new Column(
          children: <Widget>[
            Builder(
              builder: (context) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: TextField(
                    focusNode: focusNode,
                    textAlign: TextAlign.start,
                    autofocus: true,
                    style: TextStyle(
                        letterSpacing: 20,
                        fontSize: 50,
                        color: Colors.red[300],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    decoration: InputDecoration(
                      helperStyle: TextStyle(fontSize: 10),
                    ),
                    maxLength: 4,
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: eCtrl,
                    onSubmitted: (guessedNumber) {
                      if (guessedNumber.length == 4) {
                        if (guessedNumber == widget.number.toString()) {
                          widget.number = widget.getRandomNumber();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red[300],
                              content: Text(
                                widget.getGuessCount() + ' tahminde kazandın!',
                                style: TextStyle(fontSize: 25),
                              )));
                          widget.litems.clear();
                          widget.addThreeItemsAsHint();
                        } else {
                          widget.litems.insert(0, guessedNumber);
                          FocusScope.of(context).requestFocus(focusNode);
                        }
                        setState(() {});
                        eCtrl.clear();
                      }
                    },
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            new Expanded(
                child: new ListView.builder(
                    itemCount: widget.litems.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      final String userAnswer = widget.litems[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                userAnswer,
                                style: TextStyle(
                                    letterSpacing: 3,
                                    fontSize: 20,
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal),
                              ),
                              Text(
                                calculateHint(userAnswer),
                                style: TextStyle(
                                    letterSpacing: 3,
                                    fontSize: 25,
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal),
                              )
                            ]),
                      );
                    }))
          ],
        ));
  }

  String calculateHint(String answer) {
    List<String> guessList = this.widget.number.toString().split("");
    List<String> answerList = answer.split("");
    String hint = "";
    for (int i = 0; i < guessList.length; i++) {
      String guessedNumber = guessList[i];
      if (answerList[i] == guessedNumber) {
        hint += "+";
        continue;
      } else if (answerList.contains(guessedNumber)) {
        hint += "-";
      }
    }
    return hint;
  }
}
