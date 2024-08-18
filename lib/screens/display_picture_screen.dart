import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'edit_contact_page.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  DisplayPictureScreen({required this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String scannedText = "Scanning...";
  String name = "";
  final nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  final phoneRegExp = RegExp(
      r'(\+\d{1,2}\s?)?(\(\d{1,4}\)\s?)?(\d{3}[\s.-]?\d{3}[\s.-]?\d{4})');
  final emailRegExp = RegExp(r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
      caseSensitive: false);
  List<String> phones = [];
  List<String> emails = [];

  @override
  void initState() {
    super.initState();
    _scanCard();
  }

  Future<void> _scanCard() async {
    final inputImage = InputImage.fromFilePath(widget.imagePath);
    final textDetector = TextRecognizer();
    final RecognizedText recognisedText =
        await textDetector.processImage(inputImage);

    // Logique pour analyser le texte extrait et identifier les informations pertinentes
    // Par exemple, utiliser des expressions régulières pour identifier les numéros de téléphone et les emails

    // extract phone and emails
    final foundPhones = phoneRegExp
        .allMatches(recognisedText.text)
        .map((match) => match.group(0))
        .cast<String>()
        .toList();
    final foundEmails = emailRegExp
        .allMatches(recognisedText.text)
        .map((match) => match.group(0))
        .cast<String>()
        .toList();

    if (foundPhones.isNotEmpty) phones = foundPhones;
    if (foundEmails.isNotEmpty) emails = foundEmails;

    // si ces infos ont été trouvées, on les retire du text extrait.
    //final recognisedTextString = recognisedText.text;
    //final cleanedText = _removePhoneAndEmail(recognisedTextString);

    // dans la suite on va utiliser cleanedText
    String extractedText = '';
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText += line.text + '\n';

        // old method to extract name
        /*if (name.isEmpty) {
          if (nameRegExp.hasMatch(line.text)) {
            name = line.text.trim();
          }
        }*/
      }
    }

    if(extractedText.isNotEmpty){
      String cleanedText = _removePhoneAndEmail(extractedText);
      cleanedText.split("\n").forEach((line) {
        if(line.length >= 3){
          if(name.isEmpty){
            if (nameRegExp.hasMatch(line)) {
              name = line.trim();
            }
          }
        }
      });
    }


    setState(() {
      phones = phones;
      emails = emails;
      scannedText = extractedText;
    });

    textDetector.close();
  }

  String _removePhoneAndEmail(String text) {
    String cleanedText = text;
    cleanedText = cleanedText.replaceAll(phoneRegExp, '');
    cleanedText = cleanedText.replaceAll(emailRegExp, '');

    return cleanedText.trim();
  }


  Widget formatExtractedText(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nom : $name',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Téléphones :',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...phones
            .map((phone) => Text(phone, style: const TextStyle(fontSize: 18)))
            .toList(),
        const SizedBox(height: 8),
        const Text(
          'Emails :',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...emails
            .map((email) => Text(email, style: const TextStyle(fontSize: 18)))
            .toList(),
      ],
    );
  }

  void _saveContact() {
    if (phones.isEmpty && emails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Aucun, numéro ou email trouvé. \nEssayez de reprendre la photo.'),
        backgroundColor: Color(0xfff0ad4e),
      ));
    }
    final newContact = Contact(
      givenName: name,
      phones: phones.map((phone) => Item(label: 'mobile', value: phone)).toList(),
      emails: emails.map((email) => Item(label: 'work', value: email)).toList(),
    );

    ContactsService.addContact(newContact);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact enregistré avec succès !')));
  }

  void _goToEditPage(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditContactPage(
          scannedText: scannedText,
          name: name,
          phones: phones,
          emails: emails,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Informations scannées')),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red,
                            image: DecorationImage(
                              image: Image.file(File(widget.imagePath)).image,
                              // replace with your image asset
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    const Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Informations extraites:",
                            style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          formatExtractedText(context),
                        ],
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Texte reconnu",
                            style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(scannedText),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, -1),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(16.0),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: _goToEditPage,
                    child: const Text('Edit before saving'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: _saveContact,
                    child: const Text('Save to Contacts'),
                  )
                ],
              ),
            )
          ],
        ));
  }
}