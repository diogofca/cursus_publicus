import 'package:flutter/material.dart';
import 'login2.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 205, 100, 9),
        ),
        textTheme: GoogleFonts.googleSansTextTheme(),
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return LoginPage();
    //Scaffold(
    //appBar: AppBar(
    //// TRY THIS: Try changing the color here to a specific color (to
    //// Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
    //// change color while the other colors stay the same.
    //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //// Here we take the value from the MyHomePage object that was created by
    //// the App.build method, and use it to set our appbar title.
    //title: Text(widget.title),
    //),
    //body: Center(
    //child: LoginWidget(
    //theme: LoginThemeConfig(
    //backgroundColor: Color(0xFF1A1A1A),
    //headlineStyle: TextStyle(color: Colors.white),
    //googleButtonStyle: SocialButtonStyle(
    //icon: Icon(Icons.g_mobiledata),
    //label: 'Continue with Google',
    //backgroundColor: Color(0xFF2C2C2C),
    //borderColor: Color(0xFF3F3F3F),
    //textColor: Colors.white,
    //),
    //),
    //),
    //),
    //floatingActionButton: FloatingActionButton(
    //onPressed: _incrementCounter,
    //tooltip: 'Increment',
    //child: const Icon(Icons.add),
    //),
    //);
  }
}
