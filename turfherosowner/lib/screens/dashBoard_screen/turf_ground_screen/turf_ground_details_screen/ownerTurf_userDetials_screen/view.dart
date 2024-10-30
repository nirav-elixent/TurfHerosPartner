// ignore_for_file: must_be_immutable

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_ground_screen/turf_ground_details_screen/ownerTurf_ground_screen.dart/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class OwnerTurfUserDetailsScreen extends StatefulWidget {
  TurfList turfListDetails;
  OwnerTurfUserDetailsScreen({required this.turfListDetails, super.key});

  @override
  State<OwnerTurfUserDetailsScreen> createState() =>
      _OwnerTurfUserDetailsScreenState();
}

class _OwnerTurfUserDetailsScreenState
    extends State<OwnerTurfUserDetailsScreen> {
  final variable = Get.put(LoadBookingAvailableSlotDataViewModel());
  RxBool loading = false.obs;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayLoaderWithAppIcon(
        isLoading: loading.value,
        circularProgressColor: appColor,
        appIcon: SizedBox(
          height: 30.h,
          width: 30.w,
          child: Padding(
            padding:  EdgeInsets.all(8.w),
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
                          firstNameTextField(context),
                          Obx(
                            () => SizedBox(
                              height: variable.firstNameSelected.value == true
                                  ? 20.h
                                  : 0.h,
                            ),
                          ),
                          lastNameTextField(context),
                          Obx(
                            () => SizedBox(
                              height: variable.lastNameSelected.value == true
                                  ? 20.h
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
                                  ? 20.h
                                  : 0.h,
                            ),
                          ),
                          emailTextField(),
                          Obx(
                            () => SizedBox(
                              height: variable.emailIDSelected.value == true
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (co) => OwnerTurfGroundScreen(
                                        turfListDetails: widget.turfListDetails,
                                        userId: "",
                                      )));
                        } else {
                          loading.value = false;
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
}
/*   try {
                                final response = await api.apiPostCall(
                                    context, "user/update-user-profile",
                                    body: {
                                      "firstName": variable
                                          .firstNameController.value.text,
                                      "lastName": variable
                                          .lastNameController.value.text,
                                      "email": variable
                                          .emailIDController.value.text
                                    },
                                    headers: {
                                      "Authorization": "Bearer $authToken",
                                      'Content-type': 'application/json',
                                      "app-version": "1.0",
                                      "app-platform":
                                          Platform.isIOS ? "ios" : "android"
                                    });

                                ApiResponse data =
                                    ApiResponse.fromJson(response);
                                if (data.responseCode == 200) {
                                  loading.value = false;
                                
                                  Fluttertoast.showToast(msg: data.response);
                               
                                } else {
                                  loading.value = false;
                                  Fluttertoast.showToast(msg: data.response);
                                }
                              } catch (e) {
                                loading.value = false;
                                Fluttertoast.showToast(msg: e.toString());
                              }*/