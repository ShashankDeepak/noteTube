import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../constants/constants.dart';
import '../models/saved_notes_model.dart';

class DisplayNotes extends StatelessWidget {
  DisplayNotes({super.key, required this.note});
  final SavedNote note;
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: text(note.name),
          centerTitle: true,
          backgroundColor: white,
          elevation: 0,
        ),
        body: QuillEditor(
          padding: const EdgeInsets.all(20.0),
          expands: true,
          autoFocus: false,
          focusNode: FocusNode(canRequestFocus: false),
          scrollable: true,
          scrollController: scrollController,
          controller: note.controller,
          readOnly: true,
        ),
      ),
    );
  }
}
