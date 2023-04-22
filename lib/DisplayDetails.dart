import 'package:flutter/material.dart';

class DisplayDetails extends StatefulWidget {
  String firstName;
  String lastName;
  String email;
  String phone;
  String age;
  String cv;

  final String documentPath;

  DisplayDetails(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.age,
      required this.cv,
      this.documentPath = ''});

  // route name for the registration form
  static const String routeName = '/registration/details';

  @override
  _DisplayDetailsState createState() => _DisplayDetailsState();
}

class _DisplayDetailsState extends State<DisplayDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Details of ${widget.firstName}',
                  style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 20),
              const Divider(),
              // display the details here from the form fields
              Text('First Name: ${widget.firstName}'),
              const SizedBox(height: 20),
              Text('Last Name: ${widget.lastName}'),
              const SizedBox(height: 20),
              Text('Email: ${widget.email}'),
              const SizedBox(height: 20),
              Text('Phone: ${widget.phone}'),
              const SizedBox(height: 20),
              Text('Date of Birth: ${widget.age}'),
              const SizedBox(height: 20),
              Text('Uploaded CV: ${widget.cv}'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
