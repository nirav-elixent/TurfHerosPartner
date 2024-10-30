// ignore_for_file: prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appConstns/AppConstns.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/view.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final appVariable = Get.put(AppConstns());
  var _formKey = GlobalKey<FormState>();

  late SharedPreferences prefs;
  var authToken = "";
  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    // appVariable.moblieNuController.value.text =
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<AppConstns>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayLoaderWithAppIcon(
        isLoading: appVariable.isLoading.value,
        circularProgressColor: appColor,
        appIcon: SizedBox(
          height: 30.h,
          width: 30.w,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/loader_image.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: whiteColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  CustomToolbar(
                    title: "Basic Information ",
                    onTap: () {
                      Get.back();
                    },
                  ),
                  SizedBox(
                    height: 52.h,
                  ),
                  Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Obx(
                            () => AppTextFiled(
                              controller: appVariable.firstNameController.value,
                              focusNode: appVariable.firstNameFocusNode.value,
                              selected: appVariable.firstNameSelected.value,
                              lebel: "First name",
                              onSubmitt: (value) {
                                FocusScope.of(context).requestFocus(
                                    appVariable.lastNameFocusNode.value);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  appVariable.firstNameSelected.value = false;
                                  return "Please Enter your first name";
                                } else if (appVariable.firstNameController.value
                                            .text.length <
                                        4 &&
                                    value.length < 4) {
                                  appVariable.firstNameSelected.value = false;
                                  return "please enter 4 charter";
                                } else {
                                  appVariable.firstNameSelected.value = true;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Obx(
                            () => SizedBox(
                              height:
                                  appVariable.firstNameSelected.value == true
                                      ? 20.h
                                      : 0.h,
                            ),
                          ),
                          Obx(
                            () => AppTextFiled(
                              controller: appVariable.lastNameController.value,
                              focusNode: appVariable.lastNameFocusNode.value,
                              selected: appVariable.lastNameSelected.value,
                              lebel: "Last name",
                              onSubmitt: (value) {
                                FocusScope.of(context).requestFocus(
                                    appVariable.moblieNuFocusNode.value);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  appVariable.lastNameSelected.value = false;
                                  return "Please Enter your last name";
                                } else if (appVariable.lastNameController.value
                                            .text.length <
                                        4 &&
                                    value.length < 4) {
                                  appVariable.lastNameSelected.value = false;
                                  return "please enter 4 charter";
                                }
                                appVariable.lastNameSelected.value = true;
                                return null;
                              },
                            ),
                          ),
                          Obx(
                            () => SizedBox(
                              height: appVariable.lastNameSelected.value == true
                                  ? 20.h
                                  : 0.h,
                            ),
                          ),
                          Obx(
                            () => AppTextFiled(
                              controller: appVariable.moblieNuController.value,
                              focusNode: appVariable.moblieNuFocusNode.value,
                              selected: appVariable.moblieNuSelected.value,
                              lebel: "",
                              enable: false,
                              onSubmitt: (value) {
                                FocusScope.of(context).requestFocus(
                                    appVariable.emailIDFocusNode.value);
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  appVariable.moblieNuSelected.value = false;
                                  return "Please Enter your moblie number";
                                } else if (appVariable.moblieNuController.value
                                            .text.length <
                                        10 &&
                                    value.length < 10) {
                                  appVariable.moblieNuSelected.value = false;
                                  return "please enter 10 digit mobile number";
                                }
                                appVariable.moblieNuSelected.value = true;
                                return null;
                              },
                            ),
                          ),
                          Obx(
                            () => SizedBox(
                              height: appVariable.moblieNuSelected.value == true
                                  ? 20.h
                                  : 0.h,
                            ),
                          ),
                          Obx(
                            () => AppTextFiled(
                              controller: appVariable.emailIDController.value,
                              focusNode: appVariable.emailIDFocusNode.value,
                              selected: appVariable.emailIDSelected.value,
                              lebel: "E-mail",
                              onSubmitt: (value) {
                                print(appVariable.emailIDController.value.text);
                              },
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  appVariable.emailIDSelected.value = false;
                                  return "Email is required";
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  appVariable.emailIDSelected.value = false;
                                  return 'Please enter a valid email address';
                                }
                                appVariable.emailIDSelected.value = true;
                                return null;
                              },
                            ),
                          ),
                          Obx(
                            () => SizedBox(
                              height: appVariable.emailIDSelected.value == true
                                  ? 30.h
                                  : 5.h,
                            ),
                          ),
                        ],
                      )),
                  CustomeButton(
                      title: "Submit",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          updateDetails();
                          // try {
                          //   final response = await api.apiPostCall(
                          //       context, "user/update-user-profile",
                          //       body: {
                          //         "firstName": appVariable
                          //             .firstNameController.value.text,
                          //         "lastName": appVariable
                          //             .lastNameController.value.text,
                          //         "email": appVariable
                          //             .emailIDController.value.text
                          //       },
                          //       headers: {
                          //         "Authorization": "Bearer $authToken",
                          //         'Content-type': 'application/json',
                          //         "app-version": "1.0",
                          //         "app-platform":
                          //             Platform.isIOS ? "ios" : "android"
                          //       });

                          //   ApiResponse data =
                          //       ApiResponse.fromJson(response);
                          //   if (data.responseCode == 200) {
                          //     loading.value = false;
                          //     Get.offAndToNamed(dashBoard_screen);
                          //     Fluttertoast.showToast(msg: data.response);
                          //     print(data.response);
                          //   } else {
                          //     loading.value = false;
                          //     Fluttertoast.showToast(msg: data.response);
                          //   }
                          // } catch (e) {
                          //   loading.value = false;
                          //   Fluttertoast.showToast(msg: e.toString());
                          // }
                        } else {
                          Fluttertoast.showToast(msg: "Please fillup Details");
                        }
                      }),
                  SizedBox(
                    height: 20.h,
                  ),
                  SvgPicture.asset("assets/images/user_details_image.svg")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateDetails() async {
    var body = {
      "firstName": appVariable.firstNameController.value.text,
      "lastName": appVariable.lastNameController.value.text,
      "email": appVariable.emailIDController.value.text
    };

    await appVariable.userDetailsUpdate(authToken, body);

    if (appVariable.baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: "register successful");
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context, MaterialPageRoute(builder: (cc) => const DashBoardSreen()));
    } else {
      Fluttertoast.showToast(msg: appVariable.baseResponse.value.response);
    }
  }
}
