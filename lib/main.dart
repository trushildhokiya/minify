import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minify/router/router.dart';

void main()=> runApp(Minify());

GoRouter _router = MyRouter().getRouter();


class Minify extends StatelessWidget {
  const Minify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
