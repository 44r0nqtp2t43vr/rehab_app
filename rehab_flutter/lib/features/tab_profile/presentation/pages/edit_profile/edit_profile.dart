import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/data_sources/registration_provider.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/tab_profile/domain/entities/edit_user_data.dart';

class EditProfile extends StatefulWidget {
  final AppUser user;

  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  List<String> _selectedConditions = [];
  String _currentCondition = availableConditions[0];
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

  void _addCondition() {
    if (!_selectedConditions.contains(_currentCondition)) {
      setState(() {
        _selectedConditions.add(_currentCondition);
      });
    }
  }

  void _removeCondition(String condition) {
    setState(() {
      _selectedConditions.remove(condition);
    });
  }

  void _editUser() {
    // Convert the birthdate from String to DateTime
    DateTime? birthdate = DateFormat('yyyy-MM-dd').parseStrict(_birthdateController.text);

    // Create the RegisterData instance with all fields
    EditUserData editUserData = EditUserData(
      user: widget.user,
      image: _image,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      city: _cityController.text,
      gender: _genderController.text,
      birthDate: birthdate,
      conditions: _selectedConditions,
    );

    // Dispatch the event to the bloc
    BlocProvider.of<UserBloc>(context).add(EditUserEvent(editUserData));
  }

  @override
  void initState() {
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _cityController.text = widget.user.city;
    _birthdateController.text = DateFormat('yyyy-MM-dd').format(widget.user.birthDate);
    _genderController.text = widget.user.gender;
    _phoneNumberController.text = widget.user.phoneNumber;
    _selectedConditions = List.from(widget.user.conditions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (previous, current) => previous is UserLoading && current is UserDone,
      listener: (context, state) {
        if (state is UserDone) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(body: Center(child: CupertinoActivityIndicator(color: Colors.white)));
        }
        if (state is UserDone) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
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
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.green,
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
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
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _genderController,
                              decoration: customInputDecoration.copyWith(
                                labelText: 'Gender',
                                hintText: 'Enter your Gender',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter gender';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _currentCondition,
                              decoration: customInputDecoration.copyWith(
                                labelText: 'Select Condition',
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _currentCondition = newValue!;
                                });
                              },
                              items: availableConditions.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            Theme(
                              data: smallIconButtonTheme,
                              child: IconButton(
                                onPressed: _addCondition,
                                icon: const Icon(Icons.add),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: _selectedConditions
                                  .map((condition) => Chip(
                                        label: Text(condition),
                                        onDeleted: () => _removeCondition(condition),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _editUser();
                          }
                        },
                        child: const Text("Save"),
                      ),
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
