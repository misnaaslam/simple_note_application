import 'package:flutter/material.dart';
import 'package:simple_note_application/view/add_notes.dart';
import 'package:simple_note_application/controller/database.dart';
import 'package:simple_note_application/model/notes_models.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NotesModel> notesItems = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    notesItems = await DatabaseConnection.getDatabaseData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Simple Notes"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: notesItems.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(notesItems[index].title ?? 'Untitled'),
            subtitle: Text(notesItems[index].details ?? 'No Details'),


            leading: IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotes(
                      model: notesItems[index],
                    ),
                  ),
                );

                await DatabaseConnection.updateData(
                  result,
                  result.time,
                );

                notesItems[index] = result;

                setState(() {});
              },
              icon: const Icon(Icons.edit),
            ),
            trailing: IconButton(
              onPressed: () async {

                bool? confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text
                        ("Are you sure you want to delete this note?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
                if (confirmDelete == true) {
                  await DatabaseConnection.deleteData(notesItems[index].time!);
                  notesItems.removeAt(index);
                  setState(() {});
                }
              },
              icon: const Icon(Icons.delete),
            ),

          ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotes(),
            ),
          );

          if (result != null) {
            notesItems.add(result);
            await DatabaseConnection.insertData(result);
            setState(() {});
          }
        },
      ),
    );
  }
}
