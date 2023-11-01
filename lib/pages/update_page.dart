import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class UpdateMovie extends StatefulWidget {
  final String docID;

  const UpdateMovie({
    super.key,
    required this.docID,
  });

  @override
  State<UpdateMovie> createState() => _UpdateMovieState();
}

class _UpdateMovieState extends State<UpdateMovie> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  Map<String, dynamic> movie = {};
  List<String> categories = [];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('movies')
        .doc(widget.docID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          movie = documentSnapshot.data() as Map<String, dynamic>;
        });
        print(movie['name']);
        nameController.text = movie['name'];
        imageController.text = movie['poster'];
        yearController.text = movie['year'];
        categories = List.from(movie['categories']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Movie"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.amber),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    label: Text('Image'),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: yearController,
                  decoration: const InputDecoration(
                    label: Text('Year'),
                    labelStyle: TextStyle(color: Colors.amber),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              DropDownMultiSelect(
                onChanged: (List<dynamic> x) {
                  setState(() {
                    movie['categories'] = x;
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
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('movies')
                      .doc(widget.docID)
                      .update({
                    'name': nameController.value.text,
                    'year': yearController.value.text,
                    'poster': imageController.value.text,
                    'categories': categories
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text('Film modifier avec succes')),
                    );
                  });
                  //  Navigator.pop(context);
                },
                child: const Text(
                  'Modifier',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              )
            ],
          ),
        ));
  }
}
