import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/pages/movies_page.dart';
import 'package:movies/pages/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _email = "";
  String _password = "";
  bool passwordVisibiled = true;
  void _handleLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoviesInformation()),
        );
      }
    } catch (e) {
      print("Error $e");
      // rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Connexion"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Connexion",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 21),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIconColor: Colors.white,
                  focusColor: Colors.white,
                  prefixIcon: Icon(Icons.mail),
                  hintText: 'Entrer votre adresse mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(21)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrer un mail";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              const SizedBox(height: 21),
              TextFormField(
                obscureText: passwordVisibiled,
                cursorColor: Colors.white,
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIconColor: Colors.white,
                  prefixIcon: const Icon(Icons.key),
                  hintText: 'Entrer votre mot de passe',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(21)),
                  ),
                  focusColor: Colors.transparent,
                  suffixIconColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordVisibiled = !passwordVisibiled;
                      });
                    },
                    icon: Icon(passwordVisibiled
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez votre mot de passe";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(height: 21),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(51),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  _handleLogin();
                },
                child: const Text(
                  'Connecter',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Si vous avez pas de compte!",
                    style: TextStyle(color: Colors.amber),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
