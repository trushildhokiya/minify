import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import '../components/iconTile.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;

  Future handleFileChoose() async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg','jpeg', 'pdf', 'mp4','png','svg','mkv'],
    );

    if (result != null) {
      context.push('/compress',extra: {result});
    } else {
      // User canceled the picker
      print("Something went wrong");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 400,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Compress anything Anywhere",
                        style: kBannerText,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconTile(path: 'assets/images/pdf.png'),
                            IconTile(path: 'assets/images/png.png'),
                            IconTile(path: 'assets/images/jpg.png'),
                            IconTile(path: 'assets/images/mp4.png'),
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                LucideIcons.plus,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('File type supported', style: kSmallText)
                    ],
                  ),
                ),
              ),
              Container(
                height: 300,
                margin: const EdgeInsets.fromLTRB(15, 50, 15, 15),
                child: GestureDetector(
                  onTap:handleFileChoose,
                  child: DottedBorder(
                    color: Colors.grey.shade600,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [6, 4],
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.file,color: Colors.green, size: 55,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Select file from device",style: kNormalBoldText.copyWith(fontSize: 14),),
                            )
                          ],
                        ),
                      )
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(LucideIcons.home),
            title: Text("Home"),
            selectedColor: Colors.greenAccent.shade700,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(LucideIcons.folder),
            title: Text("Recents"),
            selectedColor: Colors.greenAccent.shade700,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(LucideIcons.settings),
            title: Text("Settings"),
            selectedColor: Colors.greenAccent.shade700,
          ),
        ],
      ),
    );
  }
}
