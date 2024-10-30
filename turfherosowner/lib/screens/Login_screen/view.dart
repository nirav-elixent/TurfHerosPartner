// ignore_for_file: avoid_print, empty_catches, use_build_context_synchronously
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/screens/otp_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../const/appColor/AppColor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final variable = Get.put(LoginWithNumberViewModel());

  @override
  void dispose() {
    Get.delete<LoginWithNumberViewModel>();
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
            padding: EdgeInsets.all(8.r),
            child: Image.asset(
              "assets/images/loader_image.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        child: ScreenUtil().screenWidth < 600
            ? moblieView(context)
            : tabletView(context),
      ),
    );
  }

  Scaffold moblieView(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(
        () => SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20.r,
                ),
                Text(
                  "Login to Turf Heros",
                  style: title_style,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 16.h),
                  child: Text(
                    "Enter your phone number in order to sent you your OTP security code",
                    textAlign: TextAlign.center,
                    style: login_text_style,
                  ),
                ),
                Stack(
                  children: [
                    TextFormField(
                      controller: variable.mobileNumberController.value,
                      onChanged: (value) {
                        variable.mobileNumber.value = value;
                      },
                      style: mobilwNumber_text_style,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 78.r),
                        constraints:
                            BoxConstraints(maxHeight: 45.h, maxWidth: 333.w),
                        hintText: "Enter mobile Number",
                        hintStyle: hint_text_style,
                        filled: true,
                        fillColor: textFiledColor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: fillColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide:
                                BorderSide(color: fillColor, width: 1.w)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: fillColor)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: fillColor)),
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
                      padding: EdgeInsets.zero,
                      favorite: const ['+91', 'IN'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      showDropDownButton: true,
                      showFlag: false,
                      alignLeft: false,
                    ),
                  ],
                ),
                SizedBox(
                  height: 33.h,
                ),
                CustomeButton(
                    title: "Send OTP",
                    onTap: () async {
                      if (variable.mobileNumberController.value.text.isEmpty &&
                          variable.mobileNumberController.value.text.length <
                              10) {
                        variable.isLoading.value = false;
                        Fluttertoast.showToast(
                            msg: "Please Enter Mobile Number",
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        await variable.loginWithNumber({
                          "countryCode":
                              "${variable.phoneCode.value.isEmpty ? 91 : variable.phoneCode.value}",
                          "phoneNumber": variable.mobileNumber.value
                        });
                        if (variable.baseResponse.value.responseCode == 200) {
                          Fluttertoast.showToast(
                              msg: variable.baseResponse.value.response);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OtpScreen(
                                      mobileNumber: variable.mobileNumber.value,
                                      phoneCode: variable.phoneCode.value)));
                        } else {
                          Fluttertoast.showToast(
                              msg: variable.baseResponse.value.response);
                        }
                      }
                    }),
                SizedBox(
                  height: 38.h,
                ),
                SvgPicture.asset("assets/images/login_bottom_image.svg"),
                SizedBox(
                  height: 128.h,
                ),
                GestureDetector(
                  onTap: () {
                    _launchURLBrowser(
                        "https://www.turfheros.com/terms-and-conditions");
                    // https://www.turfheros.com/terms-and-conditions
                  },
                  child: RichText(
                      text: TextSpan(
                          text: "By continuing you agree to the  ",
                          style: terms_text_style,
                          children: [
                        TextSpan(
                            text: "Terms & Condition",
                            style: condition_text_style)
                      ])),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scaffold tabletView(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(
        () => SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20.r,
                ),
                Text(
                  "Login to Turf Hero",
                  style: TabletAppstyle.title_style,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 64.w, vertical: 32.h),
                  child: Text(
                    "Enter your phone number in order to sent you your OTP security code",
                    textAlign: TextAlign.center,
                    style: TabletAppstyle.login_text_style,
                  ),
                ),
                Stack(
                  children: [
                    TextFormField(
                      controller: variable.mobileNumberController.value,
                      onChanged: (value) {
                        variable.mobileNumber.value = value;
                      },
                      style: TabletAppstyle.mobilwNumber_text_style,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 58.w, top: 10.h, bottom: 10.h),
                        constraints:
                            BoxConstraints(maxHeight: 50.h, maxWidth: 300.w),
                        hintText: "Enter mobile Number",
                        hintStyle: TabletAppstyle.hint_text_style,
                        filled: true,
                        fillColor: textFiledColor,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: fillColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide:
                                BorderSide(color: fillColor, width: 1.w)),
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
                ),
                SizedBox(
                  height: 48.h,
                ),
                TabletCustomeButton(
                    title: "Send OTP",
                    onTap: () async {
                      if (variable.mobileNumberController.value.text.isEmpty &&
                          variable.mobileNumberController.value.text.length <
                              10) {
                        variable.isLoading.value = false;
                        Fluttertoast.showToast(
                            msg: "Please Enter Mobile Number",
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        await variable.loginWithNumber({
                          "countryCode":
                              "${variable.phoneCode.value.isEmpty ? 91 : variable.phoneCode.value}",
                          "phoneNumber": variable.mobileNumber.value
                        });
                        if (variable.baseResponse.value.responseCode == 200) {
                          Fluttertoast.showToast(
                              msg: variable.baseResponse.value.response);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OtpScreen(
                                      mobileNumber: variable.mobileNumber.value,
                                      phoneCode: variable.phoneCode.value)));
                        } else {
                          Fluttertoast.showToast(
                              msg: variable.baseResponse.value.response);
                        }
                      }
                    }),
                SizedBox(
                  height: 38.h,
                ),
                SvgPicture.asset(
                  "assets/images/login_bottom_image.svg",
                  height: 250.h,
                ),
                SizedBox(
                  height: 128.h,
                ),
                GestureDetector(
                  onTap: () {
                    _launchURLBrowser(
                        "https://www.turfheros.com/terms-and-conditions");
                    // https://www.turfheros.com/terms-and-conditions
                  },
                  child: RichText(
                      text: TextSpan(
                          text: "By continuing you agree to the  ",
                          style: TabletAppstyle.terms_text_style,
                          children: [
                        TextSpan(
                            text: "Terms & Condition",
                            style: TabletAppstyle.condition_text_style)
                      ])),
                )
              ],
            ),                  
          ),
        ),
      ),
    );
  }

  _launchURLBrowser(String urls) async {
    var url = Uri.parse(urls);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppBrowserView,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
     // try {
                              //   final response = await api.apiPostCall(
                              //       context, "send-otp-on-whatsapp",
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
                              //             variable.mobileNumber.value
                              //       });
                              //   ApiResponse data =
                              //       ApiResponse.fromJson(response);
                              //   if (data.responseCode == 200) {
                              //     loading.value = false;
                              //     Get.offNamed(otp_screen);
                              //     Fluttertoast.showToast(msg: data.response);
                              //   } else if ((data.responseCode == 401)) {
                              //     loading.value = false;

                              //     Fluttertoast.showToast(msg: data.response);
                              //   } else {
                              //     loading.value = false;
                              //   }
                              // } catch (e) {
                              //   loading.value = false;
                              //   print(e.toString());
                              // }