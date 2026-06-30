import 'package:flutter/material.dart';
import 'theme.dart';
import 'constants.dart';

enum LogInSignUpPage { logIn, signUp }

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusforbuttons),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Cursos Publicus",
                style: TextStyle(color: AppTheme.primary, fontSize: 40),
              ),
              Text(
                "Create an Account to send letters",
                style: TextStyle(fontSize: 15),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hint: Text("Email", style: TextStyle()),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextField(
                          obscureText: _obscureText,
                          obscuringCharacter: '*',

                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hint: Text("Password"),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextField(
                          obscureText: _obscureText,
                          obscuringCharacter: '*',

                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hint: Text("Confirm Password"),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  radiusforbuttons,
                                ), // curve amount
                              ),
                            ),
                            child: Text(
                              "Create Account",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogInWidget extends StatefulWidget {
  const LogInWidget({super.key});

  @override
  State<LogInWidget> createState() => _LogInWidgetState();
}

class _LogInWidgetState extends State<LogInWidget> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusforbuttons),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Cursos Publicus",
                style: TextStyle(color: AppTheme.primary, fontSize: 40),
              ),
              Text(
                "Welcome. Log in with Email and Password",
                style: TextStyle(fontSize: 15),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hint: Text("Email", style: TextStyle()),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextField(
                          obscureText: _obscureText,
                          obscuringCharacter: '*',

                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hint: Text("Password"),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                radiusforbuttons,
                              ),
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  radiusforbuttons,
                                ), // curve amount
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(color: Theme.of(context).dividerColor),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusforbuttons),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset(
                              'assets/google_logo.png',
                              width: 10,
                              height: 10,
                            ),
                          ),
                          Text("Sign in with Google"),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusforbuttons),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset(
                              'assets/apple-logo.png',
                              width: 10,
                              height: 10,
                            ),
                          ),
                          Text("Sign in with Apple"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Text("Don't have an account yet? "),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          radiusforbuttons,
                        ), // curve amount
                      ),
                    ),
                    child: Text(
                      "Sign Up/Create an Account",
                      style: TextStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background_login.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(child: Center(child: LogInWidget())),
        ],
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background_login.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(child: Center(child: SignUpWidget())),
        ],
      ),
    );
  }
}
