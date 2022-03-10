import 'package:flutter/material.dart';
import 'package:wardrobe_task/login_screen.dart';
import 'package:wardrobe_task/resources/auth_methods.dart';
import 'package:wardrobe_task/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.withOpacity(0.9),
      body: Center(
        child: SingleChildScrollView(
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
                      child:  Text("Register",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 50),),
                    ),
                    const Divider(thickness: 2,indent: 80,endIndent:80,color: Colors.black,),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          label: Text("Username"),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
                    ),
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
                      final String res = await AuthMethods().signUpUser(email: _emailController.text,password: _passwordController.text,username: _usernameController.text);
                      if(res == "success"){
                        showSnackBar("Successfully Register", context);
                        _passwordController.clear();
                        _emailController.clear();
                        _usernameController.clear();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));

                      }
                    }, child: const Text("Register",style: TextStyle(fontSize: 20),)),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                            },
                            child: const Text("Login"),
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
      ),
    );
  }
}
