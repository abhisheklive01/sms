
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClinicRegistrationPage(),
    );
  }
}

class ClinicRegistrationPage extends StatefulWidget {
  @override
  _ClinicRegistrationPageState createState() => _ClinicRegistrationPageState();
}

class _ClinicRegistrationPageState extends State<ClinicRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _clinicNameController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display the data in the console.
      print('Clinic Name: ${_clinicNameController.text}');
      print('Address Line 1: ${_addressLine1Controller.text}');
      print('Address Line 2: ${_addressLine2Controller.text}');
      print('City: ${_cityController.text}');
      print('State: ${_stateController.text}');
      print('Country: ${_countryController.text}');
      print('Postal Code: ${_postalCodeController.text}');
      print('Contact Number: ${_contactNumberController.text}');
      print('Email: ${_emailController.text}');

      // Optionally, you can navigate to another screen or show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form Submitted Successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinic Registration'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                labelText: 'Clinic Name',
                controller: _clinicNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the clinic name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Address Line 1',
                controller: _addressLine1Controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address line 1';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Address Line 2',
                controller: _addressLine2Controller,
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'City',
                controller: _cityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'State',
                controller: _stateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the state';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Country',
                controller: _countryController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the country';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Postal Code',
                controller: _postalCodeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the postal code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Contact Number',
                controller: _contactNumberController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        labelStyle: TextStyle(color: Colors.blueGrey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
