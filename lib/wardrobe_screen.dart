import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe_task/add_new_category.dart';
import 'package:wardrobe_task/providers/user_provider.dart';
import 'package:wardrobe_task/resources/auth_methods.dart';
import 'package:wardrobe_task/widget/category_widget.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({Key? key}) : super(key: key);

  @override
  _WardrobePageState createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
    _firestore = FirebaseFirestore.instance;
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            Icon(
              Icons.lightbulb,
              color: Colors.grey,
            ),
            Icon(
              Icons.person,
              color: Colors.grey,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.purple,
        unselectedFontSize: 0.0,
        selectedFontSize: 0.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: ""),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => AddNewCategoryScreen());
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.white70.withOpacity(0.9),

      body: StreamBuilder(
          stream: _firestore
              .collection("users")
              .doc(Provider.of<UserProvider>(context).getUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> wardrobe =
                  Map<String, dynamic>.from(snapshot.data!.data()!["data"]);
              return ListView.builder(
                itemCount: wardrobe.length,
                  itemBuilder: (context, index) => CategoryWidget(categoryName: wardrobe.keys.toList()[index],imagesLink: wardrobe.values.toList()[index],));
            } else if (snapshot.hasError) {
              return const Icon(Icons.error_outline);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
