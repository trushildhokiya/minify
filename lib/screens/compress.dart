import 'dart:io';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';

class CompressPage extends StatefulWidget {
  final FilePickerResult file;

  const CompressPage({super.key, required this.file});

  @override
  State<CompressPage> createState() => _CompressPageState();
}

class _CompressPageState extends State<CompressPage> {
  late double percent = 0;
  late String fileName = "sample";
  late String filePath = "sample";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    handleCompression(widget.file);
  }

  void handleCompression(FilePickerResult file) async {

    File originalFile = File(file.files.single.path!);

    //image
    if (file.files.single.extension == 'jpg' || file.files.single.extension == 'jpeg' || file.files.single.extension == 'png'||file.files.single.extension == 'svg') {
      compressImage(originalFile);
    }

    //video
    else if (file.files.single.extension == 'mp4'||file.files.single.extension == 'mkv') {
      compressVideo(originalFile);
    }

    //pdf
    else if (file.files.single.extension == 'pdf') {
      compressPdf(originalFile);
    }
    
  }

  void compressImage(File file) async {
    try {

      // redad input file
      final input = ImageFile(
        rawBytes: file.readAsBytesSync(),
        filePath: file.path,
      );

      // configuration
      Configuration config = const Configuration(
        outputType: ImageOutputType.jpg,
        useJpgPngNativeCompressor: false,
        quality: 50,
      );

      // compress
      final param = ImageFileConfiguration(input: input, config: config);
      final output = await compressor.compress(param);


      // check permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // get directory
      Directory _directory = Directory("");
      if (Platform.isAndroid) {
        _directory = Directory("/storage/emulated/0/Download");
      } else {
        _directory = await getApplicationDocumentsDirectory();
      }
      final exPath = _directory.path;

      // get compression ratio and set state
      double compressionRatio = (input.sizeInBytes - output.sizeInBytes) / input.sizeInBytes;

      setState(() {
        percent = double.parse(compressionRatio.toStringAsFixed(2)).abs();
        fileName = file.path.split('/').last;
      });

      // save file to directory
      await Directory(exPath).create(recursive: true);
      final compressedFilePath = '${exPath}/${fileName}_minify_compressed.jpg';
      final compressedFile = File(compressedFilePath);
      await compressedFile.writeAsBytes(output.rawBytes);

      //set loading false and update path
      setState(() {
        filePath = compressedFilePath;
        isLoading = false;
      });

    } catch (e) {
      print('Error while compressing image: $e');
    }
  }

  void compressPdf(File file)async{

    try{

      final inputPath = file.path;
      final name = file.path.split('/').last;

      // Check storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Get the directory for saving compressed PDF
      Directory _directory = Directory("");
      if (Platform.isAndroid) {
        _directory = Directory("/storage/emulated/0/Download");
      } else {
        _directory = await getApplicationDocumentsDirectory();
      }
      final exPath = _directory.path;

      // Create directory if it doesn't exist
      await Directory(exPath).create(recursive: true);

      // Compress PDF file
      final compressedFilePath = '$exPath/${name}_minify_compressed.pdf';
      await PdfCompressor.compressPdfFile(inputPath, compressedFilePath, CompressQuality.HIGH);

      // Calculate compression ratio
      int originalSize = await file.length();
      File compressedFile = File(compressedFilePath);
      int compressedSize = await compressedFile.length();

      double compressionRatio = (originalSize - compressedSize) / originalSize;

      // Calculate compression percentage
      double compressionPercentage = compressionRatio * 100;

      setState(() {
        percent = double.parse(compressionRatio.toStringAsFixed(2)).abs();
        fileName = name;
        filePath = compressedFilePath;
        isLoading = false;
      });

    }
    catch(e){
      print("Error occurred while execution $e");
    }
  }

  void compressVideo(File file)async{

    try {

      final inputPath = file.path;
      final name = file.path.split('/').last;

      // Check storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        inputPath,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      // Calculate compression ratio
      int originalSize = await file.length();
      File compressedFile = File(mediaInfo!.path!);
      int compressedSize = await compressedFile.length();

      double compressionRatio = (originalSize - compressedSize) / originalSize;

      setState(() {
        percent = double.parse(compressionRatio.toStringAsFixed(2)).abs();
        fileName = name;
        filePath = mediaInfo.path!;
        isLoading = false;
      });


    } catch (e) {
      print('Error while compressing video: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: isLoading // Show progress indicator while loading
            ? const Center(child: CircularProgressIndicator(color: Colors.green,))
            : SingleChildScrollView(
          child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 40),
                      child: CircularPercentIndicator(
                        animation: true,
                        animationDuration: 1000,
                        percent: percent,
                        radius: 170,
                        lineWidth: 20,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          "${percent * 100}%\nSaved",
                          style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w500,
                              color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green.shade200,
                        progressColor: Colors.green,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                            child: Center(
                              child: Text(
                                "Saved ${percent * 100}% size",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "File name: $fileName",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.brown.shade700,
                              borderRadius:BorderRadius.circular(6)
                            ),
                            child: const Text(
                              "Thank you for using minify. Hope you like our product. Don't forget to rate us on play Store",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton.icon(
                              icon: const Icon(
                                LucideIcons.send,
                                color: Colors.white,
                                size: 15,
                              ),
                              label: const Text(
                                "Share",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightGreen.shade900),
                              ),
                              onPressed: () async {
                                final result = await Share.shareXFiles([XFile(filePath)], text: "Minify: A product by Orion");

                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
