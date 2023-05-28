import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_tube/views/display_notes.dart';

import '../constants/constants.dart';
import '../controller/functions.dart';
import '../models/saved_notes_model.dart';

class SavedNotes extends StatelessWidget {
  SavedNotes({super.key});
  var notes = [];
  var temp = [].obs;
  var isLoading = false.obs;

  Future<void> getNotes() async {
    notes = await getListOfSavedNotes();
    temp.value = notes;
  }

  void filterSearch(String search) {
    if (search.isEmpty) {
      temp.value = notes;
    }
    print(temp());
    List<SavedNote> t = [];
    for (SavedNote element in temp) {
      var doc = element.controller.document;
      if (element.name.contains(search) || doc.toPlainText().contains(search)) {
        t.add(element);
      }
    }
    temp.value = t;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          title: text("Saved Notes"),
        ),
        body: FutureBuilder(
            future: getNotes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (notes.isEmpty) {
                  return text("You haven't written any notes");
                }
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          onChanged: (value) {
                            filterSearch(value);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: kcircular,
                            ),
                            hintText: "Search",
                            suffixIcon: const Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () => Visibility(
                            visible: temp().isNotEmpty,
                            replacement: text("No result found"),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 6 / 4,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: temp().length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                      DisplayNotes(note: temp[index]),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: () async {
                                              isLoading.value = true;
                                              await temp[index].file.delete();
                                              await getNotes();
                                              isLoading.value = false;
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: text(temp[index].name,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return text("Error fetching data");
            }),
      ),
    );
  }
}
