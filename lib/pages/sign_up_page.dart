import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:movies/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();

  String _email = '';
  String _password = '';

  bool validatedPassword = false;

  bool visibilityPassword = true;
  void _handleSignUp() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      print("user registered: ${userCredential.user!.email}");
    } catch (e) {
      // print("Error During Registration: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Registration"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const Center(
                            child: Text(
                          "Registration",
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        )),
                        const SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'Entrer votre adresse mail',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(21)),
                            ),
                          ),
                          cursorColor: Colors.white,
                          validator: (value) {
                            if (EmailValidator.validate(value!)) {
                              return null;
                            }
                            return "Entrer une adresse mail valide";
                          },
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: visibilityPassword,
                          decoration: InputDecoration(
                            prefixIconColor: Colors.white,
                            prefixIcon: const Icon(Icons.key),
                            hintText: 'Entrer votre mot de passe',
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(21)),
                            ),
                            focusColor: Colors.white,
                            suffixIconColor: Colors.white,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  visibilityPassword = !visibilityPassword;
                                });
                              },
                              icon: Icon(visibilityPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          cursorColor: Colors.white,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Entrez un mot de passe";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(51),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                validatedPassword) {
                              _handleSignUp();
                              _emailController.clear();
                              _passwordController.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Le mot de passe ne respect pas les critère tout les bar doit etre en vert',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Enregistrer',
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
                              "Si vous avez un compte",
                              style: TextStyle(color: Colors.amber),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        FlutterPwValidator(
                          width: 400,
                          height: 200,
                          minLength: 8,
                          uppercaseCharCount: 1,
                          lowercaseCharCount: 1,
                          numericCharCount: 1,
                          specialCharCount: 1,
                          //    normalCharCount: 1,
                          onSuccess: () {
                            setState(() {
                              validatedPassword = true;
                            });
                          },
                          onFail: () {},
                          strings: FrenchStrings(),
                          defaultColor: Colors.pink,
                          controller: _passwordController,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FrenchStrings implements FlutterPwValidatorStrings {
  @override
  final String atLeast = '8 caractères au moins';
  @override
  final String uppercaseLetters = ' 1 letter majuscule';
  @override
  final String numericCharacters = '1 chiffre';
  @override
  final String specialCharacters = '1 caractères spécial ';
  @override
  final String lowercaseLetters = '1 lettre minuscule';
  @override
  final String normalLetters = "ddd";
}
