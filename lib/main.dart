import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final Color _amigaBlue = Color(0xff00519e);
final Color _guruRed = Color(0xfff52204);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amiga Forever',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        accentColor: _amigaBlue,
        primaryColor: _amigaBlue,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Topaz',
      ),
      home: MyHomePage(title: 'Amiga Forever'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _panic = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter > 2) {
        _panic = true;
      }
    });
  }

  Widget build(BuildContext context) {
    final List<Widget> columnChildren = _panic
        ? <Widget>[GuruMeditation(error: 0x25, address: 0x65045338)]
        : <Widget>[
            Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.display1),
          ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: _panic ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: columnChildren,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class GuruMeditation extends StatefulWidget {
  GuruMeditation({Key key, this.error = 0, this.address = 0}) :
    assert(error != null),
    assert(address != null),
    super(key: key);

  final int error;
  final int address;

  String get _errorString {
    final StringBuffer buffer = StringBuffer(
      'Software Failure. Press left mouse button to continue.\n'
      'Guru Meditation #'
    );
    buffer.write(error.toRadixString(16).toUpperCase().padLeft(8, '0'));
    buffer.write(',');
    buffer.write(address.toRadixString(16).toUpperCase().padLeft(8, '0'));
    return buffer.toString();
  }

  @override
  GuruMeditationState createState() => GuruMeditationState();
}

class GuruMeditationState extends State<GuruMeditation> {
  Timer borderTimer;
  bool _borderVisible = true;

  @override
  void initState() {
    borderTimer = Timer.periodic(const Duration(milliseconds: 750), (_) {
      setState(() { _borderVisible = !_borderVisible; });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(
        color: _borderVisible ? _guruRed : Colors.transparent,
        width: 4.0,
      )),
      margin: EdgeInsets.all(4.0),
      padding: EdgeInsets.all(4.0),
      child: Text(widget._errorString,
        textAlign: TextAlign.center,
        style: DefaultTextStyle.of(context).style.apply(
          color: _guruRed,
          fontSizeFactor: 0.92,
        ),
      ),
    );
  }

  @override
  void dispose() {
    borderTimer.cancel();
    super.dispose();
  }
}
