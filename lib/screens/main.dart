import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../model/User.dart';
import '../widgets/edit_profile_widget.dart';
import '../widgets/thoughts_list_view_widget.dart';
import '../widgets/write_Memo_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropDownText;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final _titleTextController = TextEditingController();
    final _descriptionTextController = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          actions: [
            Row(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final usersListStream = snapshot.data!.docs.map((docs) {
                        return MUser.fromDocument(docs);
                      }).where((user) {
                        return user.uid ==
                            FirebaseAuth.instance.currentUser!.uid;
                      }).toList();

                      MUser current = usersListStream[0];

                      return EditProfileWidget(current: current);
                    }),
              ],
            )
          ],
          backgroundColor: Colors.grey.shade100,
          toolbarHeight: 80,
          elevation: 4,
          title: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "''Thoughts",
                  style: TextStyle(
                      color: Colors.blueGrey.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  children: const [
                    TextSpan(
                      text: "Book",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownButton(
                items: <String>['Latest', 'Earliest']
                    .map((String value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ))
                    .toList(),
                hint: _dropDownText == null
                    ? const Text('Sort')
                    : Text(_dropDownText!),
                onChanged: (String? value) {
                  if (value == 'Latest') {
                    setState(() {
                      _dropDownText = value;
                    });
                  } else if (value == 'Earliest') {
                    setState(() {
                      _dropDownText = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                      bottom: BorderSide(
                          width: 0.4, color: Colors.blueGrey.shade200))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SfDateRangePicker(
                    onSelectionChanged: (dateSelection) {
                      setState((){
                        selectedDate = dateSelection.value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 4,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add,
                            size: 40, color: Colors.greenAccent),
                        label: const Padding(
                          padding: EdgeInsets.all(0.8),
                          child: Text('write new'),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return WriteMemoryDialog(selectedDate: selectedDate, width: width, height: height, titleTextController: _titleTextController, descriptionTextController: _descriptionTextController);
                              });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            ThoughtsListViewWidget(selectedDate: selectedDate, width: width),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
