import 'package:flutter/material.dart';
import 'package:long_press_button_with_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const String title = "Long press button Timer Test";

    return MaterialApp(
      title: title,
      theme: ThemeData.light().copyWith(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: Colors.blue),
      home: const MyHomePage(title: title),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LongPressButtonWithTimer(
              seconds: 3,
              afterLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Text(
                            "Wahoo!!, you've pressed this button for 3 seconds"),
                      );
                    });
              },
              button: ElevatedButton(
                child: const Text("Elevated Button Sample"),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 60),
            LongPressButtonWithTimer(
              seconds: 5,
              initialVisible: false,
              afterLongPress: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Text("Yeah, you clicked and hold for 5 seconds"),
                      );
                    });
              },
              button: TextButton(
                child: const Text("Text Button Sample"),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 60),
            LongPressButtonWithTimer(
              seconds: 10,
              initialVisible: true,
              afterLongPress: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Text("Really? for 10 seconds?"),
                      );
                    });
              },
              button: OutlinedButton(
                child: const Text("OutlinedButton"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
