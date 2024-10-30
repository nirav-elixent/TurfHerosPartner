// ignore_for_file: avoid_print, must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/User_detils_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class OtpScreen extends StatefulWidget {
  String mobileNumber, phoneCode;

  OtpScreen({required this.mobileNumber, required this.phoneCode, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final variable = Get.put(OtpVerifyViewModel());
  late SharedPreferences prefs;
  static const maxSeconds = 90;

  Timer? timer;
  void startTimer() {
    timer?.cancel(); // Cancel any existing timer
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (variable.seconds > 0) {
        variable.seconds--;
        variable.minutes.value = variable.seconds.value ~/ 60;
        variable.secondText.value = variable.seconds.value % 60;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    variable.seconds.value = maxSeconds;
    _loadPreferences();
    startTimer();
    super.initState();
  }

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    timer?.cancel();

    Get.delete<OtpVerifyViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayLoaderWithAppIcon(
        isLoading: variable.isLoading.value,
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
        child: ScreenUtil().screenWidth < 600
            ? mobileView(context)
            : tabletView(context),
      ),
    );
  }

  Scaffold mobileView(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 42.h),
                child: CustomToolbar(
                  title: "Verification Code",
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.r),
                child: Text(
                  "Enter the 6 digit number that send to ${widget.phoneCode}${widget.mobileNumber} on Whatsapp",
                  textAlign: TextAlign.center,
                  style: login_text_style,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.r),
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  textStyle: otp_text_style,
                  animationType: AnimationType.fade,
                  focusNode: variable.focusNode.value,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      activeColor: appColor,
                      selectedColor: appColor,
                      borderRadius: BorderRadius.circular(5.r),
                      inactiveColor: greyColor),
                  animationDuration: const Duration(milliseconds: 300),
                  controller: variable.controller.value,
                  onCompleted: (code) {
                    variable.otpCode.value = code;
                  },
                  onChanged: (code) {
                    variable.otpCode.value = code;
                    // print(value);
                    // setState(() {
                    //   currentText = value;
                    // });
                  },
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              SizedBox(
                height: 33.h,
              ),
              CustomeButton(
                  title: "Verify",
                  onTap: () async {
                    variable.isLoading.value = true;
                    if (variable.otpCode.isEmpty) {
                      variable.isLoading.value = false;
                      Fluttertoast.showToast(msg: "Please Enter OTP");
                    } else {
                      var body = {
                        "countryCode":
                            "${widget.phoneCode.isEmpty ? 91 : widget.phoneCode}",
                        "phoneNumber": widget.mobileNumber,
                        "otp": variable.otpCode.value
                      };

                      await variable.otpVerify(body);

                      if (variable.baseResponse.value.responseCode == 200) {
                        redirectPage(
                            variable.baseResponse.value,
                            UserData.fromJson(variable
                                .baseResponse.value.data["userDetail"]));
                      } else {
                        Fluttertoast.showToast(
                            msg: variable.baseResponse.value.response);
                      }
                    }
                  }),
              SizedBox(
                  height: 430.h,
                  child: SvgPicture.asset("assets/images/cricket_rafiki.svg")),
              GestureDetector(
                onTap: () {
                  variable.seconds.value == 0 ? resendCode() : null;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Don’t Receive Anything ? ",
                            style: terms_text_style,
                            children: [
                          TextSpan(
                              text: variable.seconds.value == 0
                                  ? "Resend Code"
                                  : "",
                              style: condition_text_style)
                        ])),
                    variable.seconds.value != 0
                        ? Obx(() => Text(
                              "0${variable.minutes.value}:${variable.secondText.value}",
                              style: terms_text_style,
                            ))
                        : Container()
                  ],
                ),
              )
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
              Padding(
                padding: EdgeInsets.only(bottom: 48.h),
                child: TabletCustomToolbar(
                  title: "Verification Code",
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 64.w),
                child: Text(
                  "Enter the 6 digit number that send to ${widget.phoneCode}${widget.mobileNumber} on Whatsapp",
                  textAlign: TextAlign.center,
                  style:TabletAppstyle.login_text_style,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 72.r),
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  textStyle: TabletAppstyle.otp_text_style,
                  animationType: AnimationType.fade,
                  focusNode: variable.focusNode.value,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      activeColor: appColor,
                      selectedColor: appColor,
                      borderRadius: BorderRadius.circular(5.r),
                      inactiveColor: greyColor),
                  animationDuration: const Duration(milliseconds: 300),
                  controller: variable.controller.value,
                  onCompleted: (code) {
                    variable.otpCode.value = code;
                  },
                  onChanged: (code) {
                    variable.otpCode.value = code;
                    // print(value);
                    // setState(() {
                    //   currentText = value;
                    // });
                  },
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              SizedBox(
                height: 36.h,
              ),
              TabletCustomeButton(
                  title: "Verify",
                  onTap: () async {
                    variable.isLoading.value = true;
                    if (variable.otpCode.isEmpty) {
                      variable.isLoading.value = false;
                      Fluttertoast.showToast(msg: "Please Enter OTP");
                    } else {
                      var body = {
                        "countryCode":
                            "${widget.phoneCode.isEmpty ? 91 : widget.phoneCode}",
                        "phoneNumber": widget.mobileNumber,
                        "otp": variable.otpCode.value
                      };

                      await variable.otpVerify(body);

                      if (variable.baseResponse.value.responseCode == 200) {
                        redirectPage(
                            variable.baseResponse.value,
                            UserData.fromJson(variable
                                .baseResponse.value.data["userDetail"]));
                      } else {
                        Fluttertoast.showToast(
                            msg: variable.baseResponse.value.response);
                      }
                    }
                  }),
              SizedBox(
                  height: 430.h,
                  child: SvgPicture.asset("assets/images/cricket_rafiki.svg")),
              GestureDetector(
                onTap: () {
                  variable.seconds.value == 0 ? resendCode() : null;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Don’t Receive Anything ? ",
                            style: terms_text_style,
                            children: [
                          TextSpan(
                              text: variable.seconds.value == 0
                                  ? "Resend Code"
                                  : "",
                              style: TabletAppstyle.condition_text_style)
                        ])),
                    variable.seconds.value != 0
                        ? Obx(() => Text(
                              "0${variable.minutes.value}:${variable.secondText.value}",
                              style: TabletAppstyle.terms_text_style,
                            ))
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  redirectPage(ApiResponse data, UserData response) async {
    await prefs.setString("authToken", data.data["token"]);
    await prefs.setString("firstName", response.firstName!);
    await prefs.setString("lastName", response.lastName!);
    await prefs.setString("phoneNumber", response.phoneNumber.toString());
    await prefs.setString("phoneCode", response.phoneCode.toString());
    await prefs.setString("email", response.email.toString());
    await prefs.setString("customer_id", response.id.toString());
    Fluttertoast.showToast(msg: data.response);
    if (response.firstName == "") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (cc) => const UserDetailsScreen()));
    } else if (response.lastName == "") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (cc) => const UserDetailsScreen()));
    } else if (response.email == "") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (cc) => const UserDetailsScreen()));
    } else if (response.phoneNumber.toString() == "") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (cc) => const UserDetailsScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (cc) => const DashBoardSreen()));
    }
  }

  resendCode() async {
    final apiService = Get.put(LoginWithNumberViewModel());

    await apiService.loginWithNumber({
      "countryCode": "${widget.phoneCode.isEmpty ? 91 : widget.phoneCode}",
      "phoneNumber": widget.mobileNumber
    });
    if (apiService.baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: apiService.baseResponse.value.response);
    } else {
      Fluttertoast.showToast(msg: apiService.baseResponse.value.response);
    }
  }
}
       // try {
                              //   final response = await api.apiPostCall(
                              //       context, "verify-otp",
                              //       headers: {
                              //         'Content-type': 'application/json',
                              //         "app-version": "1.0",
                              //         "app-platform":
                              //             Platform.isIOS ? "ios" : "android"
                              //       },
                              //       body: {
                              //         "countryCode":
                              //             "${variable.phoneCode.value.isEmpty ? 91 : variable.phoneCode.value}",
                              //         "phoneNumber":
                              //             "${variable.mobileNumber}",
                              //         "otp": variable.otpCode.value
                              //       });
                              //   ApiResponse data =
                              //       ApiResponse.fromJson(response);
                              //   if (data.responseCode == 200) {
                              //     print("print12 ${data.data}");
                              //     loading.value = false;
                              //     UserData response = UserData.fromJson(
                              //         data.data!["userDetail"]);
                              //     //print("print12 ${response.firstName}");
                              //     print("print12 ${data.data["token"]}");
                              //     await prefs.setString(
                              //         "authToken", data.data["token"]);
                              //     await prefs.setString(
                              //         "firstName", response.firstName!);
                              //     await prefs.setString(
                              //         "lastName", response.lastName!);
                              //     await prefs.setString("phoneNumber",
                              //         response.phoneNumber.toString());
                              //     await prefs.setString("phoneCode",
                              //         response.phoneCode.toString());
                              //     await prefs.setString(
                              //         "email", response.email.toString());
                              //     await prefs.setString(
                              //         "customer_id", response.id.toString());
                              //     Fluttertoast.showToast(msg: data.response);
                              //     if (response.firstName == "") {
                              //       Get.offAndToNamed(user_details_screen);
                              //     } else if (response.lastName == "") {
                              //       Get.offAndToNamed(user_details_screen);
                              //     } else if (response.email == "") {
                              //       Get.offAndToNamed(user_details_screen);
                              //     } else if (response.phoneNumber.toString() ==
                              //         "") {
                              //       Get.offAndToNamed(user_details_screen);
                              //     } else {
                              //       Get.offAndToNamed(dashBoard_screen);
                              //     }
                              //   } else if (data.responseCode == 400) {
                              //     loading.value = false;
                              //     Fluttertoast.showToast(msg: data.response);
                              //   }
                              //   print("print12 ${data.data}");
                              // } catch (e) {
                              //   print(e);
                              // }