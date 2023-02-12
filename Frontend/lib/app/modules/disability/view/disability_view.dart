import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qodra/app/data/models/word_model.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:qodra/app/modules/home/home_view.dart';
import 'package:get/get.dart';
import 'package:qodra/app/shared/app_buttons/app_progress_button.dart';
import 'package:qodra/app/shared/app_text.dart';
import 'package:qodra/app/shared/snack_bar.dart';
import 'package:qodra/app_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class DisabilityView extends StatefulWidget {
  const DisabilityView({Key? key}) : super(key: key);
  @override
  State<DisabilityView> createState() => _DisabilityViewState();
}

class _DisabilityViewState extends State<DisabilityView> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  late VideoPlayerController _controller;
  final fb = FirebaseDatabase.instance;
  ImagePicker videoPicker = ImagePicker();
  File? videoFile;
  File? imageFile = null;
  File? cameraFile;
  String? _uploadedFileURL;
  TextToSpeech tts = TextToSpeech();
  String text = 'hello';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0;
  late final File data;
  String? resultWords;
  bool isLoading = false;
   Uri ? _url ;
  @override
  void initState() {
    if (videoFile != null) {
      _controller = VideoPlayerController.network(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  playVideo(File videoFile) {
    setState(() {
      _controller = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          _controller.play();
          setState(() {});
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    _url=Uri.parse('https://www.google.com/search?q=${resultWords??'search here'}');
    FlutterTts ftts = FlutterTts();
    return Scaffold(
        appBar: AppBar(
          title: AppText(
            'hearing_impairment'.tr,
            fontSize: 22,
            color: Colors.black,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  Get.off(() => const HomeView());
                },
                icon:  Icon(
                  Icons.home,
                  color: kPurpleColor,
                  size: 35,
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: videoFile == null
                  ? const SizedBox()
                  : VideoPlayer(_controller),
              // child: SizedBox(
              //     width: 250,
              //     child: imageFile == null
              //         ? const AppCashedImage(
              //             imageUrl:
              //                 'https://tse1.mm.bing.net/th?id=OIP.fO70gw_g_kI00e1gQA-yJgHaE7&pid=Api&P=0',
              //             fit: BoxFit.fill,
              //           )
              //         : Image.file(
              //             imageFile!,
              //             width: 250,
              //             height: 100,
              //           ))
            ),
            Expanded(
                child: Container(
                  color: kGreyColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              _showChoiceDialog(context);
                            },
                            icon:  Icon(
                              Icons.video_call_outlined,
                              size: 40,
                              color: kPurpleColor,
                            )),
                        // IconButton(
                        //   onPressed: uploadFile,
                        //   icon: const Icon(
                        //     Icons.perm_identity,
                        //     size: 40,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        AppProgressButton(
                          isBordered: true,
                          textColor: Colors.white,
                          backgroundColor: kPurpleColor,
                          // text: 'المستخدم',
                          onPressed: (AnimationController animationController) {
                            print('File Uploaded1');
                            animationController.forward();
                            setState(() {
                              isLoading = true;
                            });
                            if (videoFile != null) {
                              uploadFile().then((value) {
                                Future.delayed(const Duration(seconds: 10))
                                    .then((value) {
                                  showSnackBar('تم رفع الفيديو بنجاح');
                                  animationController.reverse();
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              });
                            } else {
                              print('step2');
                              Future.delayed(const Duration(seconds: 3))
                                  .then((value) {
                                showSnackBar('من فضلك اختر فيديو');
                                animationController.reverse();
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              AppText(
                                'convert'.tr,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.forward, size: 20, color: Colors
                                  .white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 3,
                child: Container(
                  color: kBackgroundDarkColor,
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: IconButton(
                          icon: const Icon(
                            // Icons.volume_up,
                            Icons.search_outlined,
                            size: 40,
                          ),
                          color: LocalStorage.isDArk?Colors.black:Colors.white,
                          onPressed: () async {
                            _launchUrl();
                            // speak();
                            //your custom configuration
                            await ftts.setLanguage("ar-sa");
                            await ftts.setSpeechRate(0.5); //speed of speech
                            await ftts.setVolume(1.0); //volume of speech
                            await ftts.setPitch(1); //pitc of sound
                            //play text to sp
                            // var result = await ftts.speak("Hello World, this is Flutter Campus.");
                            var result = await ftts.speak("مرحبا بكم");
                            if (result == 1) {
                              print('speaking');
                            } else {
                              print('not speaking');
                            }
                          },
                        ),
                      ),
                      Center(
                          child: getWordWidget()
                        //    AppText(
                        //   resultWords ?? '',
                        //   fontSize: 22,
                        //   color: Colors.black,
                        //   fontWeight: FontWeight.bold,
                        // )
                      ),

                    ],
                  ),
                )),
          ],
        ));
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    Navigator.pop(context);
  }

  getVideoFromCamera() async {
    final source = await videoPicker.getVideo(source: ImageSource.camera);
    videoFile = File(source!.path);
  }

  getVideoFromGallery() async {
    final source = await videoPicker.getVideo(source: ImageSource.gallery);
    videoFile = File(source!.path);
  }

  Future uploadFile() async {
    final ref = fb.reference();
    print('File Uploaded1$videoFile');
    try {
      final storageReference = FirebaseStorage.instance.ref().child('videos');
      // final uploadTask = storageReference.putFile(videoFile!);
      storageReference.putFile(videoFile!).then((val) async {
        if (val.state == TaskState.success) {
          String videoUrl = await storageReference.getDownloadURL();
          print('vvvvvvvv  $videoUrl');
          ref.child('videoToText').set({
            'isChange': true,
            'word': '',
            'videoUrl': videoUrl
          }).then((val) {
            print('vvvvvvvv 2 $videoUrl');
            getWordsString();
          });
        }
      });

      //+++++++++++++++++++   ===>>          upload url to firebase database --------------
    } catch (err) {
      print('vvvvv  $err');
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(
              'choose_image'.tr,
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      // _openGallery(context);
                      getVideoFromGallery();
                      playVideo(videoFile ?? File(''));
                      Navigator.pop(context);
                    },
                    title:  Text("gallery".tr),
                    leading:  Icon(
                      Icons.image,
                      color: kPurpleColor,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      // _openCamera(context);
                      getVideoFromCamera();
                      playVideo(videoFile ?? File(''));
                      Navigator.pop(context);
                    },
                    title:  Text("camera".tr),
                    leading:  Icon(
                      Icons.camera_alt_rounded,
                      color: kPurpleColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void speak() {
    tts.setVolume(volume);
    tts.setRate(rate);
    // if (languageCode != null) {
    tts.setLanguage('ar-EG');
    // }
    tts.setPitch(pitch);
    tts.speak(text);
  }

  void getWordsString() {
    try {
      FirebaseDatabase.instance
          .reference()
          .child("videoToText")
          .onValue
          .listen((event) {
        Get.log('word text =>${event.snapshot.toString()}');
        setState(() {
          WordModel model = WordModel.fromJson(event.snapshot.value);
          Get.log('word text =>${model.word}');
          resultWords = model.word;
        });
      });
    } catch (err) {
      Get.log('word text =>${err}');
    }
  }

  getWordWidget() {
    if (isLoading && resultWords == '') {
      Get.log('step1 => ' + resultWords.toString());
      return Center(
        child: JumpingDotsProgressIndicator(
          fontSize: 60.0,
          numberOfDots: 4,
        ),
      );
    } else if (!isLoading && resultWords != null||!isLoading && resultWords == null) {
      Get.log('step2');
      return AppText(
        resultWords ?? 'empty'.tr,
        fontSize: 22,
        color: LocalStorage.isDArk?Colors.black:Colors.white,
        fontWeight: FontWeight.bold,
      );
    }
  }
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url!)) {
      throw 'Could not launch $_url';
    }
  }
}
