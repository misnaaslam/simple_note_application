import 'package:flutter/material.dart';
import 'package:simple_note_application/model/notes_models.dart';
import 'package:share_plus/share_plus.dart';


class AddNotes extends StatefulWidget {
  final NotesModel? model;

  const AddNotes({super.key, this.model});

  get note => null;



  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  void initState() {

    super.initState();
    initialiseValues();
  }

  void initialiseValues() {
    if (widget.model != null) {
      titleController.text = widget.model!.title!;
      detailsController.text = widget.model!.details!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Notes"),
        backgroundColor: Colors.pinkAccent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: (){
              final title = titleController.text;
              final details = detailsController.text;
              Share.share( title, subject: details,
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            customTextField("Title", titleController, 2),
            customTextField("Details", detailsController, 10),

            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    detailsController.text.isNotEmpty) {

                  final notesModel = NotesModel(
                    title: titleController.text,
                    details: detailsController.text,
                    time: widget.model?.time ??
                        DateTime.now().microsecondsSinceEpoch,
                  );

                  Navigator.pop(context, notesModel);
                }
              },
              child: const Text("Save"),
            ),

          ],
        ),
      ),
    );
  }

  Widget customTextField(String label,
      TextEditingController controller, int maxLines) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

}