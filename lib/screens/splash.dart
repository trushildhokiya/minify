import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 4),(){
      context.pushReplacement('/home');
    });
  }

  @override
  void dispose() {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: "logo",
                  child: Icon(LucideIcons.folderCog, size: 80, color: Colors.white,),
                ),
              ),
              Center(
                child: Text("MINIFY",style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: Colors.white
                ),),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40, // Adjust this value to change the distance from the bottom
            child: Center(
              child: Column(
                children: [
                  Text(
                    "A product by",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Orion",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
