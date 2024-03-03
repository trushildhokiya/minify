import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:minify/screens/compress.dart';
import 'package:minify/screens/home.dart';
import 'package:minify/screens/splash.dart';

class MyRouter{

  final _router = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/compress',
        builder: (context, state) {
          Set<FilePickerResult> results = state.extra as Set<FilePickerResult>;
          FilePickerResult result = results.first;
          return CompressPage(file: result);
        },
      ),
    ],
  );

  GoRouter getRouter(){
    return _router;
  }
}