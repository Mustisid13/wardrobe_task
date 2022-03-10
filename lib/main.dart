import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe_task/login_screen.dart';
import 'package:wardrobe_task/providers/user_provider.dart';
import 'package:wardrobe_task/wardrobe_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),

      ],
      child: MaterialApp(
        title: 'Wardrobe App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData){

                 return const WardrobePage();
                } else if(snapshot.hasError){
                  return Center(child: Text("${snapshot.error}"),);
                }
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(color: Colors.purple,),);
              }

              return const LoginScreen();
            }
        )
      ),
    );
  }
}


