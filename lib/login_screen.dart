import 'package:flutter/material.dart';
import 'package:wardrobe_task/register_screen.dart';
import 'package:wardrobe_task/resources/auth_methods.dart';
import 'package:wardrobe_task/wardrobe_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.withOpacity(0.9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child:  Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 50),),
                  ),
                  const Divider(thickness: 2,indent: 80,endIndent:80,color: Colors.black,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        label: Text("Email ID"),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        label: Text("Password"),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        filled: true,
                      ),
                      obscureText: true,
                    ),
                  ),
                  ElevatedButton(onPressed: () async{
                    final String res = await AuthMethods().loginUser(email: _emailController.text,password: _passwordController.text);
                    if(res=="success"){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const WardrobePage()));

                    }
                  }, child: const Text("Login",style: TextStyle(fontSize: 20),)),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Does not have an account?'),
                        TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const RegisterScreen()));
                          },
                          child: const Text("Register"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
