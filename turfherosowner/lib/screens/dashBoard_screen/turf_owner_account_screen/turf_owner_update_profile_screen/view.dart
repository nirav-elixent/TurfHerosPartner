import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class TurfOwnerUpdateProfileScreen extends StatefulWidget {
  const TurfOwnerUpdateProfileScreen({super.key});

  @override
  State<TurfOwnerUpdateProfileScreen> createState() =>
      _TurfOwnerUpdateProfileScreenState();
}

class _TurfOwnerUpdateProfileScreenState
    extends State<TurfOwnerUpdateProfileScreen> {
  final variable = Get.put(LoadBookingAvailableSlotDataViewModel());

  final _formKey = GlobalKey<FormState>();

  late SharedPreferences prefs;
  String authToken = "";

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void dispose() {
    Get.delete<LoadBulkBookingAvailableSlotDataViewModel>();
    _loadPreferences();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    Timer(Duration(milliseconds: 500), () {
      userData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtil().screenWidth < 600
        ? moblieView(context)
        : tabletView(context);
  }

  Scaffold moblieView(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              CustomToolbar(
                title: "Update Profile ",
                onTap: () {
                  Get.back();
                },
              ),
              SizedBox(
                height: 24.h,
              ),
              Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      firstNameTextField(context),
                      Obx(
                        () => SizedBox(
                          height: variable.firstNameSelected.value == true
                              ? 24.h
                              : 0.h,
                        ),
                      ),
                      lastNameTextField(context),
                      Obx(
                        () => SizedBox(
                          height: variable.lastNameSelected.value == true
                              ? 24.h
                              : 0.h,
                        ),
                      ),
                      moblieNumberTextField(context),
                      // Obx(
                      //   () => AppTextFiled(
                      //     controller:
                      //         variable.moblieNuController.value,
                      //     focusNode:
                      //         variable.moblieNuFocusNode.value,
                      //     selected: variable.moblieNuSelected.value,
                      //     lebel: "",
                      //     enable: false,
                      //     onSubmitt: (value) {
                      //       FocusScope.of(context).requestFocus(
                      //           variable.emailIDFocusNode.value);
                      //     },
                      //     keyboardType: TextInputType.number,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         variable.moblieNuSelected.value =
                      //             false;
                      //         return "Please Enter your moblie number";
                      //       } else if (variable.moblieNuController
                      //                   .value.text.length <
                      //               10 &&
                      //           value.length < 10) {
                      //         variable.moblieNuSelected.value =
                      //             false;
                      //         return "please enter 10 digit mobile number";
                      //       }
                      //       variable.moblieNuSelected.value = true;
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      Obx(
                        () => SizedBox(
                          height: variable.moblieNuSelected.value == true
                              ? 24.h
                              : 0.h,
                        ),
                      ),
                      emailTextField(),
                      Obx(
                        () => SizedBox(
                          height: variable.emailIDSelected.value == true
                              ? 32.h
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (co) => OwnerTurfGroundScreen(
                      //               turfListDetails: widget.turfListDetails,
                      //               userId: "",
                      //             )));
                    } else {
                      Fluttertoast.showToast(msg: "Please fillup Details");
                    }
                  }),
              SizedBox(
                height: 32.h,
              ),
              SvgPicture.asset("assets/images/user_details_image.svg")
            ],
          ),
        ),
      ),
    );
  }

  Scaffold tabletView(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              TabletCustomToolbar(
                title: "Update Profile ",
                onTap: () {
                  Get.back();
                },
              ),
              SizedBox(
                height: 24.h,
              ),
              Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      tabletFirstNameTextField(context),
                      Obx(
                        () => SizedBox(
                          height: variable.firstNameSelected.value == true
                              ? 24.h
                              : 0.h,
                        ),
                      ),
                      talbetLastNameTextField(context),
                      Obx(
                        () => SizedBox(
                          height: variable.lastNameSelected.value == true
                              ? 24.h
                              : 0.h,
                        ),
                      ),
                      tabletMoblieNumberTextField(context),
                      // Obx(
                      //   () => AppTextFiled(
                      //     controller:
                      //         variable.moblieNuController.value,
                      //     focusNode:
                      //         variable.moblieNuFocusNode.value,
                      //     selected: variable.moblieNuSelected.value,
                      //     lebel: "",
                      //     enable: false,
                      //     onSubmitt: (value) {
                      //       FocusScope.of(context).requestFocus(
                      //           variable.emailIDFocusNode.value);
                      //     },
                      //     keyboardType: TextInputType.number,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         variable.moblieNuSelected.value =
                      //             false;
                      //         return "Please Enter your moblie number";
                      //       } else if (variable.moblieNuController
                      //                   .value.text.length <
                      //               10 &&
                      //           value.length < 10) {
                      //         variable.moblieNuSelected.value =
                      //             false;
                      //         return "please enter 10 digit mobile number";
                      //       }
                      //       variable.moblieNuSelected.value = true;
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      Obx(
                        () => SizedBox(
                          height: variable.moblieNuSelected.value == true
                              ? 24.h
                              : 0.h,
                        ),
                      ),
                      tabletEmailTextField(),
                      Obx(
                        () => SizedBox(
                          height: variable.emailIDSelected.value == true
                              ? 32.h
                              : 5.h,
                        ),
                      ),
                    ],
                  )),
              TabletCustomeButton(
                  title: "Submit",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      updateDetails();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (co) => OwnerTurfGroundScreen(
                      //               turfListDetails: widget.turfListDetails,
                      //               userId: "",
                      //             )));
                    } else {
                      Fluttertoast.showToast(msg: "Please fillup Details");
                    }
                  }),
              SizedBox(
                height: 64.h,
              ),
              SvgPicture.asset("assets/images/user_details_image.svg",height: 200.h,)
            ],
          ),
        ),
      ),
    );
  }

  userData() async {
    await variable.myDetails(authToken);

    if (variable.baseResponseUserDetails.value.responseCode == 200) {
      //Fluttertoast.showToast(msg: variable.baseResponseUserDetails.value.response);
      variable.firstNameController.value.text = variable
          .baseResponseUserDetails.value.data["userDetail"]["firstName"];

      variable.lastNameController.value.text =
          variable.baseResponseUserDetails.value.data["userDetail"]["lastName"];
      variable.emailIDController.value.text =
          variable.baseResponseUserDetails.value.data["userDetail"]["email"];
      variable.moblieNuController.value.text = variable
          .baseResponseUserDetails.value.data["userDetail"]["phoneNumber"]
          .toString();
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseUserDetails.value.response);
    }
  }

  updateDetails() async {
    var body = {
      "firstName": variable.firstNameController.value.text,
      "lastName": variable.lastNameController.value.text,
      "email": variable.emailIDController.value.text
    };
    await variable.updateDetailsData(authToken, body);

    if (variable.baseResponseUpdateDetails.value.responseCode == 200) {
      Fluttertoast.showToast(
          msg: variable.baseResponseUpdateDetails.value.response);
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseUpdateDetails.value.response);
    }
  }

  Obx firstNameTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.firstNameController.value,
        focusNode: variable.firstNameFocusNode.value,
        selected: variable.firstNameSelected.value,
        lebel: "First name",
        onSubmitt: (value) {
          FocusScope.of(context).requestFocus(variable.lastNameFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.firstNameSelected.value = false;
            return "Please Enter your first name";
          } else if (variable.firstNameController.value.text.length < 4 &&
              value.length < 4) {
            variable.firstNameSelected.value = false;
            return "please enter 4 charter";
          } else {
            variable.firstNameSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx tabletFirstNameTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.firstNameController.value,
        focusNode: variable.firstNameFocusNode.value,
        selected: variable.firstNameSelected.value,
        lebel: "First name",
        onSubmitt: (value) {
          FocusScope.of(context).requestFocus(variable.lastNameFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.firstNameSelected.value = false;
            return "Please Enter your first name";
          } else if (variable.firstNameController.value.text.length < 4 &&
              value.length < 4) {
            variable.firstNameSelected.value = false;
            return "please enter 4 charter";
          } else {
            variable.firstNameSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx lastNameTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.lastNameController.value,
        focusNode: variable.lastNameFocusNode.value,
        selected: variable.lastNameSelected.value,
        lebel: "Last name",
        onSubmitt: (value) {
          FocusScope.of(context).requestFocus(variable.moblieNuFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.lastNameSelected.value = false;
            return "Please Enter your last name";
          } else if (variable.lastNameController.value.text.length < 4 &&
              value.length < 4) {
            variable.lastNameSelected.value = false;
            return "please enter 4 charter";
          }
          variable.lastNameSelected.value = true;
          return null;
        },
      ),
    );
  }

  Obx talbetLastNameTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.lastNameController.value,
        focusNode: variable.lastNameFocusNode.value,
        selected: variable.lastNameSelected.value,
        lebel: "Last name",
        onSubmitt: (value) {
          FocusScope.of(context).requestFocus(variable.moblieNuFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.lastNameSelected.value = false;
            return "Please Enter your last name";
          } else if (variable.lastNameController.value.text.length < 4 &&
              value.length < 4) {
            variable.lastNameSelected.value = false;
            return "please enter 4 charter";
          }
          variable.lastNameSelected.value = true;
          return null;
        },
      ),
    );
  }

  Stack moblieNumberTextField(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => AppTextFiled(
            controller: variable.moblieNuController.value,
            focusNode: variable.moblieNuFocusNode.value,
            selected: variable.moblieNuSelected.value,
            lebel: "",
            contentPadding: EdgeInsets.only(left: 78.w),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(10),
            ],
            onSubmitt: (value) {
              FocusScope.of(context)
                  .requestFocus(variable.emailIDFocusNode.value);
            },
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                variable.moblieNuSelected.value = false;
                return "Please Enter your moblie number";
              } else if (variable.moblieNuController.value.text.length < 10 &&
                  value.length < 10) {
                variable.moblieNuSelected.value = false;
                return "please enter 10 digit mobile number";
              }
              variable.moblieNuSelected.value = true;
              return null;
            },
          ),
        ),
        CountryCodePicker(
          onInit: (value) {
            variable.phoneCode.value = value!.dialCode!;
          },
          onChanged: (value) {
            variable.phoneCode.value = value.dialCode!;
          },
          initialSelection: 'IN',
          padding: EdgeInsets.only(left: 16.w),
          favorite: const ['+91', 'IN'],
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          showDropDownButton: true,
          showFlag: false,
          alignLeft: false,
        ),
      ],
    );
  }

  Stack tabletMoblieNumberTextField(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: variable.moblieNuController.value,
          onChanged: (value) {
            variable.mobileNumber.value = value;
          },
          style: TabletAppstyle.mobilwNumber_text_style,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(10),
          ],
          keyboardType: TextInputType.number,
          enabled: false,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 58.w, top: 10.h, bottom: 10.h),
            constraints: BoxConstraints(maxHeight: 50.h, maxWidth: 340.w),
            hintText: "Enter mobile Number",
            hintStyle: TabletAppstyle.hint_text_style,
            filled: true,
            fillColor: textFiledColor,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: fillColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: fillColor, width: 1.w)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: fillColor)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: fillColor)),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 4.w,
          child: CountryCodePicker(
            onInit: (value) {
              variable.phoneCode.value = value!.dialCode!;
            },
            onChanged: (value) {
              variable.phoneCode.value = value.dialCode!;
            },
            initialSelection: 'IN',
            padding: EdgeInsets.zero,
            favorite: const ['+91', 'IN'],
            showCountryOnly: false,
            textStyle: TabletAppstyle.phoneCode_style,
            showOnlyCountryWhenClosed: false,
            showDropDownButton: true,
            showFlag: false,
            alignLeft: false,
          ),
        ),
      ],
    );
  }

  Obx emailTextField() {
    return Obx(
      () => AppTextFiled(
        controller: variable.emailIDController.value,
        focusNode: variable.emailIDFocusNode.value,
        selected: variable.emailIDSelected.value,
        lebel: "E-mail",
        onSubmitt: (value) {},
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            variable.emailIDSelected.value = false;
            return "Email is required";
          } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            variable.emailIDSelected.value = false;
            return 'Please enter a valid email address';
          }
          variable.emailIDSelected.value = true;
          return null;
        },
      ),
    );
  }

  Obx tabletEmailTextField() {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.emailIDController.value,
        focusNode: variable.emailIDFocusNode.value,
        selected: variable.emailIDSelected.value,
        lebel: "E-mail",
        onSubmitt: (value) {},
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            variable.emailIDSelected.value = false;
            return "Email is required";
          } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            variable.emailIDSelected.value = false;
            return 'Please enter a valid email address';
          }
          variable.emailIDSelected.value = true;
          return null;
        },
      ),
    );
  }
}
