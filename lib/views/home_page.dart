import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants/constants.dart';
import '../controller/controller.dart';
import '../controller/functions.dart';
import 'notes.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final controllers = Get.put(Controller());
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: text("Home Page", color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kpadding),
            child: Form(
              key: formGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (link) {
                      if (!isLinkValid(link!)) {
                        return "Invalid or empty link";
                      }
                    },
                    controller: controllers.youtubeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Enter youtube link",
                      label: text("Youtube Link"),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () => {
                        if (formGlobalKey.currentState!.validate())
                          Get.to(() => Notes())
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: kcircular,
                        ),
                      ),
                      child: text("Start notes", color: white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
