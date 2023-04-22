// Registration form with validation using Flutter

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';

import 'DisplayDetails.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  // route name for the registration form
  static const String routeName = '/registration';

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _dateController = TextEditingController();

  final _subjectController = TextEditingController(text: 'The subject');

  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;

  String fileName = 'No file selected';

  bool cvUploaded = false;

  String firstName = '';

  String lastName = '';

  String emailData = '';

  String phone = '';

  String date = '';

  String? attachment;

  bool isSubmitting = false;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your birth date';
    }
    try {
      // format the date to yyyy-MM-dd
      final DateTime date =
          DateFormat('yyyy-MM-dd').parse(_dateController.text);
      // calculate the age in years from the date of birth entered by the user and compare it with 18 years to validate
      final age = DateTime.now().difference(date).inDays ~/ 365;
      if (age < 18) {
        return 'You must be at least 18 years old';
      }
      return null;
    } catch (e) {
      return 'Please enter a valid date (yyyy-MM-dd)';
    }
  }

  final nameRegExp = RegExp(r'^[a-zA-Z ]{5,}$');

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your name.';
    }
    if (!nameRegExp.hasMatch(value)) {
      return 'Please enter a valid name.';
    }
    return null;
  }

  // function to upload pdf or doc file to the server
  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      setState(() {
        cvUploaded = true;
        fileName = result.files.first.name;
      });
      final file = result.files.first;
    } else {
      // User canceled the picker
      return;
    }
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      body:
          'Hello, \n\nYour form has been submitted successfully with the following details: \n\n First Name: $firstName\n Last Name: $lastName\n Date of Birth: $date\n Email: $emailData\n Phone Number: $phone',
      subject: _subjectController.text,
      recipients: [emailData],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[200],
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.6,
          // padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text('Registration Form', style: TextStyle(fontSize: 30)),
                const Divider(),
                const SizedBox(height: 20),
                const Text('Your one stop solution for registration'),
                const SizedBox(height: 20),
                const Text('Please fill in the details below'),
                const SizedBox(height: 20),
                Stack(children: [
                  Center(
                    child: SizedBox(
                      width: 500,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'First Name',
                                ),
                                onSaved: (value) {
                                  firstName = value!;
                                },
                                validator: validateName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Last Name',
                                ),
                                onSaved: (value) {
                                  lastName = value!;
                                },
                                validator: validateName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Date of Birth',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                onTap: () async {
                                  DateTime? date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );
                                  // format the date to display in the text field
                                  if (date != null) {
                                    setState(() {
                                      _dateController.text =
                                          '${date.year}-${date.month}-${date.day}';
                                      _selectedDate = date;
                                    });
                                  }
                                },
                                onSaved: (value) {
                                  _dateController.text = value.toString();
                                  date = value.toString();
                                },
                                validator: validateAge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                ),
                                onSaved: (value) {
                                  emailData = value!;
                                },
                                validator: validateEmail,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Phone Number',
                                ),
                                onSaved: (value) {
                                  phone = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            // give a option to user to upload a cv or resume in pdf or doc format
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(fileName,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: uploadFile,
                                    child: const Text('Upload'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            cvUploaded == true
                                ? const Text('CV Uploaded')
                                : const Text('Please upload a CV'),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() {
                                    isSubmitting = true;
                                  });
                                  Timer(const Duration(seconds: 5), () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/registration/details',
                                        (Route<dynamic> route) => false);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DisplayDetails(
                                          firstName: firstName,
                                          lastName: lastName,
                                          email: emailData,
                                          phone: phone,
                                          age: date,
                                          cv: fileName,
                                        ),
                                      ),
                                    );
                                  });
                                }
                              },
                              child: const Text('Submit'),
                            ),
                            const SizedBox(height: 20),
                            // button to send email to the user with the details entered
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  sendEmail();
                                }
                              },
                              child: const Text('Send Email'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isSubmitting == true)
                    Center(
                      child: Container(
                        color: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 20.0),
                              Text(
                                'Submitting details...',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
