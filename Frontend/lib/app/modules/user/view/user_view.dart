import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qodra/app/data/models/word_model.dart';
import 'package:qodra/app/data/remote_data_source/word_to_image_api.dart';
import 'package:qodra/app/modules/home/home_view.dart';
import 'package:get/get.dart';
import 'package:qodra/app/shared/app_buttons/app_progress_button.dart';
import 'package:qodra/app/shared/app_cached_image.dart';
import 'package:qodra/app/shared/app_text.dart';
import 'package:qodra/app/shared/app_text_field.dart';
import 'package:qodra/app/shared/snack_bar.dart';
import 'package:qodra/app_constant.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  TextEditingController wordController = TextEditingController();
  final fb = FirebaseDatabase.instance;
  String? imageUrl;
  bool _hasSpeech = false;
   VideoPlayerController ?  _controller;

  String lastWords = "empty".tr;

  String lastError = "";

  String lastStatus = "";
  bool isLoading = false;
  final SpeechToText speech = SpeechToText();
  File? videoFile;

  // YoutubePlayerController _controller1 = YoutubePlayerController(
  //   initialVideoId: 'iLnmTe5Q2Qw',
  //   flags: YoutubePlayerFlags(
  //     autoPlay: true,
  //     mute: true,
  //   ),
  // );

  @override
  void initState() {
    //https://www.youtube.com/shorts/GytiHdv3xso


  }
  playVideo(String url) {
    if (url != null) {
      _controller = VideoPlayerController.network(url??
          'https://www.pexels.com/video/close-up-view-of-slices-of-cantaloupe-7258427/')
        ..initialize().then((_) {
          _controller!.setLooping(true);
          _controller!.play();
          setState(() {});
        });
    }
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    // playVideo('');
    final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          'user'.tr,
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
              icon: Icon(
                Icons.home,
                color: kPurpleColor,
                size: 35,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: Get.height*0.55,
                child: isLoading
                ? Center(
                    child: JumpingDotsProgressIndicator(
                      fontSize: 60.0,
                      numberOfDots: 4,
                    ),
                  )

                : imageUrl == null
                    ? const SizedBox()
                    : Column(
                      children: [
                        SizedBox(
                          height: Get.height*0.33,
                          width: Get.width,
                          child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!)),
                        ),
                        Container(
                            child: VideoProgressIndicator(
                                _controller!,
                                allowScrubbing: true,
                                colors:const VideoProgressColors(
                                  backgroundColor: Colors.redAccent,
                                  playedColor: Colors.green,
                                  bufferedColor: Colors.purple,
                                )
                            )
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: (){
                                    if(_controller!.value.isPlaying){
                                      _controller!.pause();
                                    }else{
                                      _controller!.play();
                                    }
                                    setState(() {
                                    });
                                  },
                                  icon:Icon(_controller!.value.isPlaying?Icons.pause:Icons.play_arrow)
                              ),

                              IconButton(
                                  onPressed: (){
                                    _controller!.seekTo(const Duration(seconds: 0));

                                    setState(() {

                                    });
                                  },
                                  icon:const Icon(Icons.stop)
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                // : AppCashedImage(
                //     imageUrl: imageUrl ??
                //         'https://tse1.mm.bing.net/th?id=OIP.fO70gw_g_kI00e1gQA-yJgHaE7&pid=Api&P=0',
                //     fit: BoxFit.fill,
                //   ),
              ),
            ),
            Container(
              color: kGreyColor,
              height:   Get.height*0.4,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Visibility(
                          visible: false,
                          child: IconButton(
                              onPressed: startListening,
                              icon: Icon(
                                Icons.keyboard_voice,
                                size: 35,
                                color: kPurpleColor,
                              )),
                        ),
                        Expanded(
                          child: CustomTextFormField(
                            backgroundColor: Colors.grey,
                            verticalPadding: 0,
                            horizontalPadding: 0,
                            keyboardType: TextInputType.text,
                            controller: wordController,
                            text: 'write_here'.tr,
                            validateEmptyText: 'empty'.tr,
                            radius: 10,
                            hintText: 'write_here'.tr,
                          ),
                        ),
                        // IconButton(
                        //   icon: const Icon(
                        //     Icons.perm_identity, size: 35, color: Colors.black,),
                        //   onPressed: () {
                        //     ref.child('wordToImage').set(
                        //         {
                        //           'isChange': true,
                        //           'word': wordController.text,
                        //           'imageUrl': 'https://s.yimg.com/ny/api/res/1.2/ilPiGpc1rMdofynEhDwdLw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTUyOTtjZj13ZWJw/https://media.zenfs.com/en/time_72/79bd0de37aa949e77a6dc7b6e5036760'
                        //         });
                        //       setState(() {
                        //         isLoading=true;
                        //       });
                        //       Future.delayed(const Duration(seconds: 5)).then((value) {
                        //         FirebaseDatabase.instance.reference().child(
                        //             "wordToImage").once().then((
                        //             DatabaseEvent snapshot) {
                        //           WordModel  model=  WordModel.fromJson(snapshot.snapshot.value);
                        //           setState(() {
                        //             isLoading=false;
                        //             imageUrl=model.imageUrl;
                        //           });
                        //
                        //         });
                        //       });
                        //
                        //   },
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  AppProgressButton(
                    isBordered: true,
                    textColor: Colors.white,
                    backgroundColor: kPurpleColor,
                    // text: 'المستخدم',
                    onPressed: (AnimationController animationController) {
                      animationController.forward().then((value) {
                        Get.log('vvvvvv  ' + wordController.text.toString());
                        try {
                           fb.reference();
                          FirebaseDatabase.instance
                              .reference()
                              .child('wordToVideo').set({
                            'isChange': true,
                            'word': wordController.text,
                            'videoUrl': ''
                          }).then((val){
                            Future.delayed(Duration(seconds: 5)).then((value){
                              FirebaseDatabase.instance
                                  .reference()
                                  .child("wordToVideo").onChildChanged.listen((DatabaseEvent snapshot) {
                                Get.log('imge url  ===>'+snapshot.snapshot.value.toString());
                                // WordModel model =
                                // WordModel.fromJson(snapshot.snapshot.value);
                                  // setState(() {
                          String image=snapshot.snapshot.value.toString();
                                Get.log('imge url  1===>'+image.toString());
                                    // Get.log('imge url  10==>'+imageUrl.toString());
                                     setState(() {
                                       imageUrl = image;
                                       isLoading = false;
                                     });
                                     if(image !=null){
                                       Get.log('imge url  11===>'+image.toString());
                                       // _controller!.dispose();
                                       animationController.reverse();
                                       playVideo(imageUrl!);
                                     }
                                  // });

                              });
                              Get.log('imge url  2===>'+imageUrl.toString());
                               // playVideo(imageUrl!);
                              setState(() {
                                if(imageUrl!=null&&imageUrl!.isNotEmpty){
                                  Get.log('imge url  2===>'+imageUrl.toString());
                                   // playVideo(imageUrl!);
                                }
                                isLoading = true;
                              });
                            });

                          }).catchError((error, stackTrace) =>
                              print('ddddd ${error.toString()}'));


                        }catch(Err){
                          Get.log('err     => '+Err.toString());
                        }

                      });

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText(
                          'convert'.tr,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(Icons.forward, size: 20, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(flex:1,child:  AppProgressButton(
            //   isBordered: true,
            //   textColor: Colors.white,
            //   backgroundColor: kPurpleColor,
            //   // text: 'المستخدم',
            //   onPressed: (AnimationController animationController) {
            //     animationController.forward();
            //
            //     ref.child('wordToImage').set(
            //         {
            //           'isChange': true,
            //           'word': wordController.text,
            //           'imageUrl': 'https://s.yimg.com/ny/api/res/1.2/ilPiGpc1rMdofynEhDwdLw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTUyOTtjZj13ZWJw/https://media.zenfs.com/en/time_72/79bd0de37aa949e77a6dc7b6e5036760'
            //         });
            //     setState(() {
            //       isLoading=true;
            //     });
            //     Future.delayed(const Duration(seconds: 5)).then((value) {
            //       FirebaseDatabase.instance.reference().child(
            //           "wordToImage").once().then((
            //           DatabaseEvent snapshot) {
            //         WordModel  model=  WordModel.fromJson(snapshot.snapshot.value);
            //         setState(() {
            //           isLoading=false;
            //           imageUrl=model.imageUrl;
            //         });
            //
            //         showSnackBar('تم رفع النص بنجاح');
            //         animationController.reverse();
            //
            //       });
            //     });
            //
            //   },
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: const [
            //       AppText(
            //         'تحويل',
            //         color: Colors.white,
            //         fontSize: 18,
            //       ),
            //       SizedBox(
            //         width: 15,
            //       ),
            //       Icon(Icons.forward, size: 20, color: Colors.white),
            //     ],
            //   ),
            // ),),
            // Container(
            //   color: kBackgroundDarkColor,
            //   child: Center(
            //   child: AppText(
            // lastWords,
            // fontSize: 22,
            // color: LocalStorage.isDArk ? Colors.black : Colors.white,
            // fontWeight: FontWeight.bold,
            //   )),
            // ),
          ],
        ),
      ),
    );
  }

  void startListening() async {
    lastWords = "";
    lastError = "";
    // var locales = await speech.locales();
    // var selectedLocale = locales[LocaleName.];
    speech.listen(onResult: resultListener, localeId: 'ar');
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
      lastWords = "${result.recognizedWords}";
      Get.log('lastWords ==>' + result.finalResult.toString());
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = status;
    });
  }

  retreiveDate() {
    return FutureBuilder(
        future: WordToImageService().getWordData(),
        builder: (_, snap) {
          WordModel wordModel = snap.data as WordModel;
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.connectionState == ConnectionState.done) {
            return AppCashedImage(
              imageUrl: wordModel.imageUrl ??
                  'https://tse1.mm.bing.net/th?id=OIP.fO70gw_g_kI00e1gQA-yJgHaE7&pid=Api&P=0',
              fit: BoxFit.fill,
            );
          } else {
            return const SizedBox();
          }
        });
  }

  void getVideoFromFirebase() async {
    // await launchUrl(Uri.parse('https://firebasestorage.googleapis.com/v0/b/kodra-ee9a0.appspot.com/o/videos?alt=media&token=118e78b7-7975-4ca8-9106-c56dd713b5b6'));
  }
}
