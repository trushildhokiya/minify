import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.path});

  final String path;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(child: Image.asset(path),backgroundColor: Colors.transparent,),
    );
  }
}
