import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrobe_task/resources/firestore_methods.dart';
import 'package:wardrobe_task/utils.dart';

import '../resources/storage_methods.dart';

class CategoryWidget extends StatefulWidget {
  final String categoryName;
  final List imagesLink;

  const CategoryWidget(
      {Key? key, required this.categoryName, required this.imagesLink})
      : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  late TextEditingController _newCategoryNameController;
  bool _isLoading = false;

  handleClick(value) {
    switch (value) {
      case 'Edit':
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: TextFormField(
                  controller: _newCategoryNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      label: Text("New Name"),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.text_fields)),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        if (_newCategoryNameController.text.isNotEmpty) {
                          FireStoreMethods().updateCategoryName(
                              widget.categoryName,
                              _newCategoryNameController.text);
                          _newCategoryNameController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Change",
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              );
            });
        break;
      case 'Delete':
        FireStoreMethods().deleteData(widget.categoryName);
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _newCategoryNameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _newCategoryNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.categoryName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              PopupMenuButton(
                key: _key,
                onSelected: handleClick,
                itemBuilder: (context) {
                  return ["Edit", "Delete"].map((choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  widget.imagesLink.map((e) => buildImageCard(e)).toList()),
        )
      ],
    );
  }

  Card buildImageCard(String imgUrl) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: imgUrl != ""
                ? Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                    height: 170,
                    width: 150,
                    scale: 4,
                  )
                : InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: const Text("Add an image"),
                              children: [
                                SimpleDialogOption(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.camera_alt),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Take a photo"),
                                    ],
                                  ),
                                  onPressed: () async {
                                    Uint8List? file =
                                        await pickImage(ImageSource.camera);
                                    await buildPreviewImage(context, file);
                                  },
                                ),
                                SimpleDialogOption(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.image),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Choose from gallery"),
                                    ],
                                  ),
                                  onPressed: () async {
                                    // Navigator.of(context).pop();
                                    Uint8List? file =
                                        await pickImage(ImageSource.gallery);
                                    await buildPreviewImage(context, file);
                                  },
                                ),
                                SimpleDialogOption(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.cancel),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: const Icon(
                      Icons.upload,
                      size: 150,
                    ))),
      ),
    );
  }

  buildPreviewImage(BuildContext context, Uint8List? file) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: MemoryImage(file!), fit: BoxFit.cover),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    String url = await StorageMethods()
                        .uploadImageToStorage(widget.categoryName, file);
                    FireStoreMethods()
                        .addImageToCategory(widget.categoryName, url);
                    setState(() {
                      _isLoading = false;
                    });

                    Navigator.pop(context);
                  },
                  child: _isLoading? const CircularProgressIndicator():const Text("Add Image")),
              TextButton(
                  onPressed: () {
                    file = null;
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
