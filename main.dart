import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var guessedNumber = TextEditingController(); // for textformfield control
  static Random ran = new Random(); // generate random number using Random()
  int randomNumber = ran.nextInt(20) + 1;
  int numberOfTries = 0; //initial value
  int numberOfTimes = 3; // final value

  @override
  Widget build(BuildContext context) {
    print(randomNumber);
    return Scaffold(
      appBar: AppBar(
        title: Text('Let\'s Try Your Guess',
            style: TextStyle(color: Colors.grey[900])),
        centerTitle: true,
        backgroundColor: Colors.yellow[700],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40.0),
              Image.asset('images/main-remove.png', height: 150.0),
              SizedBox(height: 40.0),
              Text(
                'Please Input a Number From 1 to 20',
                style: TextStyle(
                    color: Colors.grey[850],
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0),
              ),
              SizedBox(height: 2.0),
              Text(
                'Remember- You have only three chance',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              ),
              SizedBox(height: 30.0),
              Container(
                width: 200.0,
                child: TextFormField(
                  controller: guessedNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Your Guess',
                    labelStyle: TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.yellow[700])),
                onPressed: guess,
                child: Text(
                  'Guess',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void guess() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    //form field isn't empty if it is then show this toast message
    if (isEmpty()) {
      makeToast("You did not enter a number");
      return;
    }
    //this will convert guessedNumber string into integer
    int guess = int.parse(guessedNumber.text);
    // if user enter more than  20 or less than 1 then show this toast
    if (guess > 20 || guess < 1) {
      makeToast("Choose number between 1 and 20");
      guessedNumber.clear();
      return;
    }

    numberOfTries++;
    if (numberOfTries == numberOfTimes && guess != randomNumber) {
      makeToast(
          "Game Over! Your Number of Tries is: $numberOfTries Number was: $randomNumber");
      numberOfTries = 0;
      randomNumber = ran.nextInt(20);
      guessedNumber.clear();
      return;
    }
    //logic behind toast value
    if (guess > randomNumber) {
      makeToast("Try Lower! Number of Tries is: $numberOfTries");
    } else if (guess < randomNumber) {
      makeToast("Try Higher! Number of Tries is: $numberOfTries");
    } else if (guess == (randomNumber + 1)) {
      makeToast("Near About!!: $numberOfTries");
    } else if (guess == (randomNumber - 1)) {
      makeToast("Near About!!: $numberOfTries");
    } else if (guess == randomNumber) {
      makeToast("That's right. You Win! Number of Tries is: $numberOfTries");
      numberOfTries = 0; //After winning number of tries will be again 0
      randomNumber = ran.nextInt(20) +
          1; // after winning again computer will generate random number

    }
    guessedNumber.clear();
  }

  //Toast function and their properties
  void makeToast(String feedback) {
    Fluttertoast.showToast(
        msg: feedback,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 18);
  }

  //isEmpty method
  bool isEmpty() {
    return guessedNumber.text.isEmpty;
  }
}
