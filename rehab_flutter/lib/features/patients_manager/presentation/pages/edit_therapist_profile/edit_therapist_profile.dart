import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/core/data_sources/registration_provider.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_therapist_data.dart';

class EditTherapistProfile extends StatefulWidget {
  final Therapist user;

  const EditTherapistProfile({super.key, required this.user});

  @override
  State<EditTherapistProfile> createState() => _EditTherapistProfileState();
}

class _EditTherapistProfileState extends State<EditTherapistProfile> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final List<String> _availableGenders = availableGenders;
  String? _currentGender;
  File? _image;

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Update the UI
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _editUser() {
    // Convert the birthdate from String to DateTime
    DateTime? birthdate = DateFormat('yyyy-MM-dd').parseStrict(_birthdateController.text);

    // Create the RegisterData instance with all fields
    EditTherapistData editTherapistData = EditTherapistData(
      user: widget.user,
      image: _image,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      licenseNumber: _licenseNumberController.text,
      city: _cityController.text,
      gender: _currentGender!,
      birthDate: birthdate,
    );

    // Dispatch the event to the bloc
    BlocProvider.of<TherapistBloc>(context).add(EditTherapistEvent(editTherapistData));
  }

  @override
  void initState() {
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _cityController.text = widget.user.city;
    _birthdateController.text = DateFormat('yyyy-MM-dd').format(widget.user.birthDate);
    _phoneNumberController.text = widget.user.phoneNumber;
    _licenseNumberController.text = widget.user.licenseNumber;
    _currentGender = widget.user.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TherapistBloc, TherapistState>(
      listenWhen: (previous, current) => previous is TherapistLoading && current is TherapistDone,
      listener: (context, state) {
        if (state is TherapistDone) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is TherapistLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lotties/uploading.json',
                width: 400,
                height: 400,
              ),
              //CupertinoActivityIndicator(color: Colors.white),
            ),
          );
        }
        if (state is TherapistDone) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Edit Profile",
                    style: darkTextTheme().headlineLarge,
                  ),
                  Text(
                    "Profile Details",
                    style: darkTextTheme().headlineSmall,
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _pickImage(),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: _image != null ? FileImage(_image!) : null,
                              radius: 40,
                              child: _image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )
                                  : state.currentTherapist!.imageURL != null
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: state.currentTherapist!.imageURL!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.account_circle,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.camera_alt,
                                color: Color(0xff01FF99),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Personal Information",
                          style: darkTextTheme().displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassContainer(
                        width: double.infinity,
                        shadowStrength: 2,
                        shadowColor: Colors.black,
                        blur: 4,
                        color: Colors.white.withOpacity(0.25),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      decoration: customInputDecoration.copyWith(
                                        labelText: 'First Name',
                                        hintText: 'Enter your First Name',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your first name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      decoration: customInputDecoration.copyWith(
                                        labelText: 'Last Name',
                                        hintText: 'Enter your Last Name',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your last name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _cityController,
                                decoration: customInputDecoration.copyWith(
                                  labelText: 'Location',
                                  hintText: 'Enter your Location',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your city';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () => _selectDate(context),
                                child: IgnorePointer(
                                  child: TextFormField(
                                    controller: _birthdateController,
                                    decoration: customInputDecoration.copyWith(
                                      labelText: 'Birthdate',
                                      hintText: 'Birthdate (YYY-MM-DD)',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your birthdate';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _currentGender,
                                decoration: customInputDecoration.copyWith(
                                  labelText: 'Select Gender',
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _currentGender = newValue!;
                                  });
                                },
                                items: _availableGenders.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a gender';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _phoneNumberController,
                                decoration: customInputDecoration.copyWith(
                                  labelText: 'Phone Number',
                                  hintText: 'Enter your Phone Number',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _licenseNumberController,
                                decoration: customInputDecoration.copyWith(
                                  labelText: 'License Number',
                                  hintText: 'Enter your License Number',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your license number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF128BED),
                                    Color(0xFF01FF99),
                                  ],
                                  stops: [0.3, 1.0],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 10,
                                    blurRadius: 20,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _editUser();
                                  }
                                },
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white,
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  elevation: MaterialStateProperty.all<double>(0),
                                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: const Text("Save"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
