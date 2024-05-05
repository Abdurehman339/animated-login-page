import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.grey,
          selectionColor: Colors.grey,
        ),
      ),
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
  StateMachineController? stateMachineController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Artboard? teadyArtBoard;
  SMIBool? isChecking;
  SMINumber? numLook;
  SMIBool? isHandsUp;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    rootBundle.load('assets/animated_login_character.riv').then((data) {
      final file = RiveFile.import(data);
      final artBoard = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(artBoard, 'Login Machine');
      if (stateMachineController != null) {
        artBoard.addController(stateMachineController!);
      }

      for (var element in stateMachineController!.inputs) {
        if (element.name == 'trigSuccess') {
          trigSuccess = element as SMITrigger;
        } else if (element.name == 'trigFail') {
          trigFail = element as SMITrigger;
        } else if (element.name == 'isHandsUp') {
          isHandsUp = element as SMIBool;
        } else if (element.name == 'isChecking') {
          isChecking = element as SMIBool;
        } else if (element.name == 'numLook') {
          numLook = element as SMINumber;
        }
      }

      setState(() {
        teadyArtBoard = artBoard;
      });
    });
    super.initState();
  }

  void handsUp() {
    setState(() {
      numLook!.change(0);
      isChecking!.change(false);
      isHandsUp!.change(true);
    });
  }

  void handsDown() {
    setState(() {
      isHandsUp!.change(false);
    });
  }

  void startChecking(double lookValue) {
    setState(() {
      isHandsUp!.change(false);
      isChecking!.change(true);
      numLook!.change(lookValue);
    });
  }

  void stopChecking() {
    setState(() {
      isHandsUp!.change(false);
      isChecking!.change(false);
    });
  }

  void login() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (_emailController.text == "abdurrehman.musharaf@gmail.com" &&
        _passwordController.text == "admin") {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 226, 234, 1),
      body: teadyArtBoard == null
          ? const SizedBox()
          : GestureDetector(
              onTap: () {
                handsDown();
                stopChecking();
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: double.infinity,
                        child: Rive(
                          artboard: teadyArtBoard!,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: TextField(
                        onTap: () {
                          startChecking(
                              _emailController.text.length.toDouble() * 2);
                        },
                        onChanged: (val) {
                          startChecking(val.length.toDouble() * 2);
                        },
                        controller: _emailController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Email or Username',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      child: TextField(
                        onTap: () {
                          handsUp();
                        },
                        controller: _passwordController,
                        obscureText: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 10,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue.shade200, // Background color
                          foregroundColor: Colors.white, // Text color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded border
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
