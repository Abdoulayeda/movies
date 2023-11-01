import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/add_movie_page.dart';
import 'package:movies/loader.dart';
import 'package:movies/pages/login_page.dart';
import 'package:movies/pages/update_page.dart';

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({super.key});

  @override
  State<MoviesInformation> createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _moviesStream =
      FirebaseFirestore.instance.collection('movies').snapshots();

  //Fonction pour ajour un like a un film
  void addLikes(String docID, int likes) {
    var newLikes = likes + 1;
    try {
      FirebaseFirestore.instance.collection('movies').doc(docID).update({
        'likes': newLikes,
      }).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.amber,
              content: Text(
                'Like is added succesful',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  //Function pour supprimer un film
  void deleteMovie(BuildContext context, String docID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            icon: const Icon(Icons.dangerous),
            title: const Text("Confirmation"),
            content: const Text("Voulez vous supprimez ce film ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Annuler',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  try {
                    FirebaseFirestore.instance
                        .collection('movies')
                        .doc(docID)
                        .delete()
                        .then(
                      (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Le film a été supprimé avec succès',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Impossible de supprimer ce film'),
                    ));
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "Confirmer",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String? email = _auth.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddMoviePage(),
                fullscreenDialog: true,
              ),
            );
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
        title: Row(children: [
          const Text(
            "Movies App",
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(width: 11),
          Text(
            email.toString(),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.amber,
              letterSpacing: 1,
            ),
          )
        ]),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _moviesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> movie =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 135,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(2, 3))
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 85,
                        height: 135,
                        child: Image.network(
                          movie['poster'],
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                          frameBuilder: (BuildContext context, Widget child,
                              int? frame, bool wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              // L'image a été chargée de manière synchrone, attendez un court délai avant d'afficher l'image.
                              Future.delayed(
                                const Duration(seconds: 1),
                                () => child,
                              );
                            }
                            return child;
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        width: 210,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text("Année de production"),
                            Text(movie['year'].toString()),
                            Row(
                              children: [
                                for (final categorie in movie['categories'])
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Chip(
                                      backgroundColor: Colors.pink,
                                      label: Text(
                                        categorie,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Likes',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      addLikes(document.id, movie['likes']);
                                    });
                                  },
                                  child: const Icon(Icons.favorite),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  movie['likes'].toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                deleteMovie(context, document.id);
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateMovie(
                                    docID: document.id,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.amber,
                              size: 25,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
