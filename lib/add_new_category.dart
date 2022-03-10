import 'package:flutter/material.dart';
import 'package:wardrobe_task/resources/firestore_methods.dart';


class AddNewCategoryScreen extends StatefulWidget {
  const AddNewCategoryScreen({Key? key}) : super(key: key);

  @override
  _AddNewCategoryScreenState createState() => _AddNewCategoryScreenState();
}

class _AddNewCategoryScreenState extends State<AddNewCategoryScreen> {
  late TextEditingController _categoryNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryNameController =TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _categoryNameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        controller: _categoryNameController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          label: Text("New Category"),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(),
         filled: true,
          icon: Icon(Icons.text_fields)
        ),
      ),
      actions: [
        ElevatedButton(onPressed: () async{
          if(_categoryNameController.text.isNotEmpty){
            FireStoreMethods().addNewCategory(_categoryNameController.text);
            _categoryNameController.clear();
            Navigator.pop(context);
          }
        }, child: const Text("Add",style: TextStyle(color: Colors.white),))
      ],
    );
  }
}
