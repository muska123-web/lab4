import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantifyecommerceshop/firebase_options.dart';
import 'package:plantifyecommerceshop/utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthenticationRepository());
  runApp(const App());
}

class AuthenticationRepository {
  // Placeholder for auth logic
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Established',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const PostScreen(),
    );
  }
}

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          "Firebase Initialized!",
          style: TextStyle(fontSize: 20, color: Colors.black), // Make sure it's visible
        ),
      ),
      backgroundColor: Colors.white, // Prevent black screen
    );
  }
}
