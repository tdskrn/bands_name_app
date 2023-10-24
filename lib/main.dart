import 'package:bands_name_app/config/services/socket_service.dart';
import 'package:bands_name_app/presentation/screens/home_screen.dart';
import 'package:bands_name_app/presentation/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SocketService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomeScreen(),
          'status': (_) => const StatusScreen()
        },
      ),
    );
  }
}
