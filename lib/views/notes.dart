import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note_tube/views/saved_notes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constants/constants.dart';
import '../controller/controller.dart';
import '../controller/functions.dart';
import '../controller/gpt_controller.dart';

class Notes extends StatelessWidget {
  Notes({super.key});
  @override
  final controller = Get.put(Controller());

  var isLoading = false.obs;

  Uint8List? imageFile;

  YoutubePlayerController youtubeController = YoutubePlayerController(
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        loop: true,
        autoPlay: false,
        showLiveFullscreenButton: false,
        forceHD: true,
        enableCaption: false,
      ),
      initialVideoId: YoutubePlayer.convertUrlToId(getYoutubeLink())!);
  @override
  Widget build(BuildContext context) {
    final gptController = Get.put(ChatGptController());
    final formGlobalKey = GlobalKey<FormState>();
    final promtGlobalKey = GlobalKey<FormState>();
    var fileName = "notes-app";
    var prompt = "";

    AlertDialog saveAlert = AlertDialog(
      title: text("Save File"),
      content: SizedBox(
        height: height * 0.2,
        child: Form(
          key: formGlobalKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  fileName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name cant be empty";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Enter name",
                  label: text("Name"),
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        try {
                          if (formGlobalKey.currentState!.validate()) {
                            var status = await Permission.storage.request();
                            if (status.isGranted) {
                              isLoading.value = true;
                              await writeQuillToStorage(
                                name: fileName,
                                quillController: controller.quillController,
                              );
                            } else {
                              Get.snackbar(
                                colorText: Colors.white,
                                backgroundColor: Colors.black,
                                isDismissible: true,
                                overlayColor: Colors.black,
                                snackPosition: SnackPosition.BOTTOM,
                                "Storage permission not granted",
                                "Please go to setting and grant storage permission",
                              );
                            }
                          }
                          isLoading.value = false;
                          Get.snackbar(
                            onTap: (value) {
                              youtubeController.pause();
                              Get.to(SavedNotes());
                            },
                            colorText: Colors.white,
                            backgroundColor: Colors.black,
                            isDismissible: true,
                            overlayColor: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                            "File Saved",
                            "Go to saved notes to access it.",
                          );
                        } catch (e) {
                          Get.snackbar(
                            duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.black,
                            isDismissible: true,
                            overlayColor: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                            "Error saving the file",
                            "There was an error while trying to save the file\n${e.toString()}",
                          );
                        }
                        isLoading.value = false;
                      },
                      child: isLoading.value
                          ? const CircularProgressIndicator()
                          : text("Save", color: white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    AlertDialog promtAlert = AlertDialog(
      title: text("Enter prompt"),
      content: SizedBox(
        height: height * 0.28,
        child: Form(
          key: promtGlobalKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  prompt = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Prompt cant be empty";
                  } else {
                    return null;
                  }
                },
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "eg. What is deforestation?",
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () async {
                        try {
                          if (formGlobalKey.currentState!.validate()) {
                            var qc = controller.quillController;
                            isLoading.value = true;

                            controller.quillController.replaceText(
                              qc.document.length - 1,
                              0,
                              await gptController.generateText(prompt),
                              const TextSelection.collapsed(offset: 0),
                            );

                            print(controller.quillController.getPlainText());
                            isLoading.value = false;
                          }
                        } catch (e) {
                          Get.snackbar(
                            duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.black,
                            isDismissible: true,
                            overlayColor: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                            "Error getting prompt",
                            "There was an error \n${e.toString()}",
                          );
                          isLoading.value = false;
                        }
                      },
                      child: isLoading.value
                          ? const FittedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : text("Go!", color: white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        controller.quillController.clear();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () async {
                    await showDialog(
                      barrierDismissible: !isLoading.value,
                      context: context,
                      builder: (BuildContext context) {
                        return saveAlert;
                      },
                    );
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.download),
                ),
              ),
              Align(
                alignment: const Alignment(-0.8, 1),
                child: InkWell(
                  // borderRadius: BorderRadius.circular(10),
                  radius: 10,
                  customBorder: CircleBorder(),
                  onTap: () async {
                    await showDialog(
                      barrierDismissible: !isLoading.value,
                      context: context,
                      builder: (BuildContext context) {
                        return promtAlert;
                      },
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/ChatGPT.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                YoutubePlayer(
                  aspectRatio: 16 / 9,
                  controller: youtubeController,
                  showVideoProgressIndicator: true,
                  progressColors: const ProgressBarColors(
                    backgroundColor: Colors.red,
                  ),
                  progressIndicatorColor: Colors.red,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(
                      isExpanded: true,
                      colors: const ProgressBarColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.white,
                        handleColor: Colors.red,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    RemainingDuration(),
                    const PlaybackSpeedButton(),
                  ],
                ),
                QuillToolbar.basic(
                  multiRowsDisplay: false,
                  showCodeBlock: true,
                  controller: controller.quillController,
                ),
                Expanded(
                  child: QuillEditor(
                    padding: const EdgeInsets.all(20.0),
                    expands: true,
                    autoFocus: true,
                    focusNode: FocusNode(canRequestFocus: true),
                    scrollable: true,
                    scrollController: controller.quillScrollController,
                    controller: controller.quillController,
                    readOnly: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
