import 'dart:io';

import 'package:chat_app/consts.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:chat_app/services/navigation_service.dart';
// import 'package:chat_app/services/storage_service.dart'; // Commented
import 'package:chat_app/widgets/custom_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _regiterFormKey = GlobalKey();

  late AuthService _authService;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseService _databaseService;
  // late StorageService _storageService; // Commented

  String? email, password, name;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
    // _storageService = _getIt.get<StorageService>(); // Commented
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            _headerText(),
            if (!isLoading) _registerForm(),
            if (!isLoading) _loginAccountLink(),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            "Register an account using the form below",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _regiterFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormFeild(
              hintText: "Name",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: Name_Validation_Regex,
              onSaved: (value) {
                setState(
                  () {
                    name = value;
                  },
                );
              },
            ),
            CustomFormFeild(
              hintText: "Email",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(
                  () {
                    email = value;
                  },
                );
              },
            ),
            CustomFormFeild(
              hintText: "Password",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              obsecureText: true,
              onSaved: (value) {
                setState(
                  () {
                    password = value;
                  },
                );
              },
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(Placeholder_Pfp) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.06,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if (_regiterFormKey.currentState?.validate() ?? false) {
              _regiterFormKey.currentState?.save();
              bool result = await _authService.signup(email!, password!);
              if (result) {
                String? pfpURL;

                // Agar image select hui hai toh upload karne ki koshish karega
                if (selectedImage != null) {
                  // pfpURL = await _storageService.uploadUserPfp(file: selectedImage!, uid: _authService.user!.uid);
                }

                await _databaseService.createUserProfile(
                  userProfile: UserProfile(
                    uid: _authService.user!.uid,
                    name: name,
                    pfpUrl: pfpURL ??
                        "", // Agar image upload na ho toh empty string set karega
                  ),
                );

                _alertService.showToast(
                    text: "User registered successfully", icon: Icons.check);
                _navigationService.goBack();
                _navigationService.pushReplacementNamed("/home");
              } else {
                throw Exception("Unable to register user");
              }
            }
          } catch (e) {
            print(e);
            _alertService.showToast(
              text: "Failed to register, Please try again",
              icon: Icons.error,
            );
          }
          setState(() {
            isLoading = false;
          });
        },
        child: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () {
            _navigationService.goBack();
          },
          child: const Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        )
      ],
    ));
  }
}
/* 
fire base me store krwana he  image ko to phir ye code 

import 'package:chat_app/consts.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/widgets/custom_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _regiterFormKey = GlobalKey();

  late AuthService _authService;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late StorageService _storageService;
  late DatabaseService _databaseService;

  String? email, password, name;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            _headerText(),
            if (!isLoading) _registerForm(),
            if (!isLoading) _loginAccountLink(),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            "Register an account using the form below",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _regiterFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormFeild(
              hintText: "Name",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: Name_Validation_Regex,
              onSaved: (value) {
                setState(
                  () {
                    name = value;
                  },
                );
              },
            ),
            CustomFormFeild(
              hintText: "Email",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(
                  () {
                    email = value;
                  },
                );
              },
            ),
            CustomFormFeild(
              hintText: "Password",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              obsecureText: true,
              onSaved: (value) {
                setState(
                  () {
                    password = value;
                  },
                );
              },
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(Placeholder_Pfp) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.06,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          setState(() {
            isLoading = false;
          });
          try {
            if ((_regiterFormKey.currentState?.validate() ?? false) &&
                selectedImage != null) {
              _regiterFormKey.currentState?.save();
              bool result = await _authService.signup(email!, password!);
              if (result) {
                String? pfpURL = await _storageService.uploadUserPfp(
                    file: selectedImage!, uid: _authService.user!.uid);
                if (pfpURL != null) {
                  await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                        uid: _authService.user!.uid, name: name, pfpUrl: ""),
                  );
                  _alertService.showToast(
                      text: "User registered successfully", icon: Icons.check);
                  _navigationService.goBack();
                  _navigationService.pushReplacementNamed("/home");
                } else {
                  throw Exception(
                    "Enable to upload user profile picture",
                  );
                }
              } else {
                throw Exception(
                  "Enable to register user",
                );
              }
            }
          } catch (e) {
            print(e);
            _alertService.showToast(
              text: "Failed to register, Please try again",
              icon: Icons.error,
            );
          }
          setState(() {
            isLoading = false;
          });
        },
        child: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Already have an accont? "),
        GestureDetector(
          onTap: () {
            _navigationService.goBack();
          },
          child: const Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        )
      ],
    ));
  }
}
*/
