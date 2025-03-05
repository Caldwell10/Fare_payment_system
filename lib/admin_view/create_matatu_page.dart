import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateMatatuPage extends StatefulWidget {
  const CreateMatatuPage({super.key});

  @override
  _CreateMatatuPageState createState() => _CreateMatatuPageState();
}

class _CreateMatatuPageState extends State<CreateMatatuPage> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  Future<void> _createMatatu() async {
    final name = nameController.text.trim();
    final number = numberController.text.trim();

    if (name.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both name and number')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('matatus').add({
        'name': name,
        'number': number,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Matatu created successfully')),
      );

      nameController.clear();
      numberController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating matatu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Matatu'),
        backgroundColor: const Color.fromARGB(255, 108, 105, 105),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Matatu Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.directions_bus),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: 'Matatu Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createMatatu,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color.fromARGB(255, 108, 105, 105),
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Matatu'),
            ),
          ],
        ),
      ),
    );
  }
}
