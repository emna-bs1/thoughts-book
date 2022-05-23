import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/util.dart';

class UpdateEntryDialog extends StatefulWidget {
  final DateTime? selectedDate;

  const UpdateEntryDialog(
      {Key? key,
      this.selectedDate,
      titleTextController,
      descriptionTextController})
      : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final TextEditingController? _titleTextController;
  final TextEditingController? _descriptionTextController;
  final Diary diary;

  @override
  State<UpdateEntryDialog> createState() => _UpdateEntryDialogState();
}

class _UpdateEntryDialogState extends State<UpdateEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          width: widget.width,
          child: Row(
            children: [
              Text(
                formatDate(diary.entryTime!.toDate()),
                style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 5,
                            content: SingleChildScrollView(
                              child: Container(
                                width: widget.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Discard'),
                                            style: TextButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextButton(
                                            onPressed: () {},
                                            child: Text('_buttonText'),
                                            style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: Colors.green,
                                                elevation: 4,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        side:
                                                            BorderSide(
                                                                color: Colors
                                                                    .green))),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(formatDate(widget.selectedDate!))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                splashRadius: 26,
                                                onPressed: () => pickImage(),
                                                icon: const Icon(
                                                    Icons.image_rounded),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 300,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.7 /
                                                      2,
                                                  child: _imageDisplay),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.8),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 250,
                                                  child: TextFormField(
                                                    controller: widget
                                                        ._titleTextController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Title...'),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.8),
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 250,
                                                  child: TextFormField(
                                                    controller:
                                                        _descriptionTextController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Description...'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
// return UpdateEntryDialog()
                        });
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteEntryDialog(
                              thoughtsCollectionReference:
                                  thoughtsCollectionReference,
                              diary: diary);
                        });
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
        )
      ]),
      content: ListTile(
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDateFromTimestampHour(diary.entryTime),
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.network((diary.photosUrls == null)
                  ? 'https://picsum.photos/200/200'
                  : diary.photosUrls.toString()),
            ),
            Row(
              children: [
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        diary.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        diary.entry!,
                      ),
                    ),
                  ],
                ))
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        )
      ],
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        _pickedFile = imageTemporary;
        _imageDisplay = Image.file(imageTemporary);
      });
    } catch (error) {
      print("error: $error");
    }
  }
}
