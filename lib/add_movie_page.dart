import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class AddMoviePage extends StatefulWidget {
  const AddMoviePage({super.key});

  @override
  State<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController posterController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  List<String> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Movie"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(
                  color: Colors.white30,
                  width: 1.5,
                ),
              ),
              title: Row(
                children: [
                  const Text("Nom"),
                  const SizedBox(width: 18),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Nom de la film",
                        border: InputBorder.none,
                      ),
                      controller: nameController,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 21),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(
                  color: Colors.white30,
                  width: 1.5,
                ),
              ),
              title: Row(
                children: [
                  const Text("Année"),
                  const SizedBox(width: 18),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Année de production",
                        border: InputBorder.none,
                      ),
                      controller: yearController,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 21),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(
                  color: Colors.white30,
                  width: 1.5,
                ),
              ),
              title: Row(
                children: [
                  const Text("Image"),
                  const SizedBox(width: 18),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Image de la film",
                        border: InputBorder.none,
                      ),
                      controller: posterController,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 21),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  categories = x;
                });
              },
              options: const [
                'Action',
                'Science-fiction',
                'Aventure',
                'Comédie',
              ],
              selectedValues: categories,
              whenEmpty: 'Catégorie',
            ),
            const SizedBox(height: 21),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(51),
              ),
              onPressed: () {
                if (nameController.value.text.isNotEmpty ||
                    yearController.value.text.isNotEmpty ||
                    posterController.value.text.isNotEmpty ||
                    categories.isNotEmpty) {
                  FirebaseFirestore.instance.collection('movies').add({
                    'name': nameController.value.text,
                    'year': yearController.value.text,
                    'poster': posterController.value.text,
                    'categories': categories,
                    'likes': 0,
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Données non valide! Remplissez tout les champ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  );
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}
