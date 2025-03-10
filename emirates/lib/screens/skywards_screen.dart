import 'package:country_code_picker/country_code_picker.dart';
import 'package:emirates/models/user_form_model.dart';
import 'package:emirates/repository/user_repository.dart';
import 'package:emirates/widgets/utils.dart';
import 'package:flutter/material.dart';

class SkywardsScreen extends StatefulWidget {
  const SkywardsScreen({super.key});

  @override
  State<SkywardsScreen> createState() => _SkywardsScreenState();
}

class _SkywardsScreenState extends State<SkywardsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // repository instance
  final UserRepository _userRepository = UserRepository();

  String? selectedCountryCode = '+60';
  String? selectedCountryText = 'Country / Territory of residence';
  String dropdownValue = titles.first;
  DateTime? selectedDate;
  bool isLoading = false;
  bool isChecked = false;
  bool light = true;

  Future<void> submitForm() async {
    // First validate the form
    if (!_validateForm()) {
      showSnackBar(context, 'Please fill in all required fields');
      return;
    }

    if (!isChecked) {
      showSnackBar(context, 'Please accept the terms and conditions');
      return;
    }

    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      // Format the phone number - ensure it's actually numeric
      String phoneStr = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
      int? phoneNum = int.tryParse(phoneStr);
      if (phoneNum == null) {
        showSnackBar(context, 'Please enter a valid phone number');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Format the date - ensure it's valid
      if (selectedDate == null) {
        showSnackBar(context, 'Please select your date of birth');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Make sure country is selected
      if (selectedCountryText == null ||
          selectedCountryText == 'Country / Territory of residence') {
        showSnackBar(context, 'Please select your country of residence');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Create user form data with validated fields
      UserFormModel userForm = UserFormModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phoneNumber: phoneNum,
        dateOfBirth: selectedDate!.millisecondsSinceEpoch,
        country: selectedCountryText ?? '',
      );

      // Store data using repository
      print("Submitting form data to repository...");
      String result = await _userRepository.storeUserData(userForm);
      print("Repository result: $result");

      setState(() {
        isLoading = false;
      });

      if (result == "success") {
        // Show success message
        showSnackBar(
          context,
          'Successfully registered! Welcome to Emirates Skywards',
        );

        // Navigate to next screen or clear form
        _clearForm();
      } else {
        // Show error message
        showSnackBar(context, 'Error: $result');
      }
    } catch (e) {
      print("Exception in form submission: $e");
      setState(() {
        isLoading = false;
      });

      showSnackBar(context, 'An unexpected error occurred: $e');
    }
  }

  bool _validateForm() {
    // Check if required fields are filled
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        selectedDate == null ||
        selectedCountryText == 'Country / Territory of residence') {
      return false;
    }

    // Basic email validation
    if (!_emailController.text.contains('@') ||
        !_emailController.text.contains('.')) {
      showSnackBar(context, 'Please enter a valid email address');
      return false;
    }

    // Password validation (at least 6 characters)
    if (_passwordController.text.length < 6) {
      showSnackBar(context, 'Password should be at least 6 characters');
      return false;
    }

    return true;
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    setState(() {
      selectedDate = null;
      isChecked = false;
      selectedCountryText = 'Country / Territory of residence';
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  static const List<String> titles = ['Mr', 'Mrs', 'Ms', 'Miss', 'Undisclosed'];

  Future<void> _selectDOB(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Join Emirates Skywards',
          style: TextStyle(color: Colors.red, fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'If you have a membership number to activate, please enter it below.',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Emirates Skywards membership',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Title'),
                  SizedBox(width: 10),
                  DropdownButton(
                    style: TextStyle(color: Colors.purpleAccent),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    value: dropdownValue,
                    items: [
                      for (final title in titles)
                        DropdownMenuItem(value: title, child: Text(title)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _firstNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'First Name (as per passport)',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _lastNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Last Name (as per passport)',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CountryCodePicker(
                    initialSelection: selectedCountryCode,
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    showFlag: true,
                    onChanged: (country) {
                      setState(() {
                        selectedCountryCode = country.dialCode;
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Date of Birth: '),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () => _selectDOB(context),
                    child: Text(
                      selectedDate == null
                          ? 'Select Date of Birth'
                          : selectedDate.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Country / Territory of residence: '),
                  SizedBox(width: 10),
                  CountryCodePicker(
                    initialSelection: selectedCountryText,
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                    showFlag: true,
                    onChanged: (country) {
                      setState(() {
                        selectedCountryText = country.name;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          'I have read the and agree to the terms and conditions ',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sign up for Emirates newsletters'),
                  Switch(
                    activeColor: Colors.redAccent,
                    value: light,
                    onChanged: (value) {
                      setState(() {
                        light = value;
                      });
                    },
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStateProperty.all(Colors.yellow),
              //   ),
              //   child: Text('Join Now!'),
              // ),
              isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.yellowAccent,
                    ),
                  )
                  : GestureDetector(
                    onTap: submitForm,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Join Now!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
