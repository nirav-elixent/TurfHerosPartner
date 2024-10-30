// ignore_for_file: unused_element, deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/CustomDrawerItem.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/customWidget/deleteAccount.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';
import 'package:turf_heros_owner/screens/Login_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_owner_account_screen/turf_owner_report_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_owner_account_screen/turf_owner_update_profile_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_owner_account_screen/turf_wallet_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../customWidget/AppTextFiled.dart';

class TurfOwnerAccountScreen extends StatefulWidget {
  const TurfOwnerAccountScreen({super.key});

  @override
  State<TurfOwnerAccountScreen> createState() => TurfOwnerAccountScreenState();
}

class TurfOwnerAccountScreenState extends State<TurfOwnerAccountScreen> {
  final variable = Get.put(LoadBookingAvailableSlotDataViewModel());

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
          child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          CustomToolbar(
              onTap: () {
                Get.back();
              },
              title: "Account Details"),
          SizedBox(
            height: 8.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  DrawerItem(
                    image: "assets/images/reports_image.svg",
                    title: "Reports",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (on) => const TurfOwnerReportScreen()));
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  DrawerItem(
                    image: "assets/images/wallet_image.svg",
                    title: "Wallet",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (on) => const TurfWalletScreen()));
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  DrawerItem(
                    image: "assets/images/payment_details_image.svg",
                    title: "Payment Details",
                    onTap: () {
                      showUserDetailsView(context);
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  DrawerItem(
                    image: "assets/images/person_color_image..svg",
                    title: "Profile",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (on) =>
                                  const TurfOwnerUpdateProfileScreen()));
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  DrawerItem(
                    image: "assets/images/privacy_policy_image.svg",
                    title: "Privacy Policy",
                    onTap: () {
                      // scaffoldKey.currentState!.closeDrawer();
                      launchURLBrowser("${ApiService.baseUrl}/privacy-policy");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  DrawerItem(
                    image: "assets/images/terms_and_conditions_image.svg",
                    title: "Terms & Conditions",
                    onTap: () {
                      // scaffoldKey.currentState!.closeDrawer();
                      launchURLBrowser(
                          "${ApiService.baseUrl}/terms-and-conditions");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  DrawerItem(
                    image: "assets/images/refund_policy_image.svg",
                    title: "Refund Policy",
                    onTap: () {
                      // scaffoldKey.currentState!.closeDrawer();
                      launchURLBrowser("${ApiService.baseUrl}/refund-policy");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  DrawerItem(
                    image: "assets/images/email_support_image.svg",
                    title: "Email Support",
                    onTap: () {
                      _sendingMails();
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  DrawerItem(
                    image: "assets/images/call_support_image.svg",
                    title: "Call Support",
                    onTap: () {
                      // _makingPhoneCall();
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      logOut(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 28.h,
                            width: 28.w,
                            child: Stack(
                              children: [
                                Positioned(
                                    left: 3.w,
                                    right: 3.w,
                                    top: 3.h,
                                    bottom: 3.h,
                                    child: SvgPicture.asset(
                                      "assets/images/logout_image.svg",
                                      color: redColor,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Logout",
                                  style: deleteAccount_text_style,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                                "assets/images/forward_grey_image.svg"),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => DeleteAccount(
                          onPressed: () {
                            Navigator.of(context).pop();
                            launchURLBrowser(
                                "${ApiService.baseUrl}/delete-account");
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 28.h,
                            width: 28.w,
                            child: Stack(
                              children: [
                                Positioned(
                                    left: 3.w,
                                    right: 3.w,
                                    top: 3.h,
                                    bottom: 3.h,
                                    child: SvgPicture.asset(
                                      "assets/images/delete_image.svg",
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Delete  account",
                                  style: deleteAccount_text_style,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                                "assets/images/forward_grey_image.svg"),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Scaffold tabletView(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          TabletCustomToolbar(
              onTap: () {
                Get.back();
              },
              title: "Account Details"),
          SizedBox(
            height: 8.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  TabletDrawerItem(
                    image: "assets/images/reports_image.svg",
                    title: "Reports",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (on) => const TurfOwnerReportScreen()));
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  TabletDrawerItem(
                    image: "assets/images/wallet_image.svg",
                    title: "Wallet",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (on) => const TurfWalletScreen()));
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  TabletDrawerItem(
                    image: "assets/images/payment_details_image.svg",
                    title: "Payment Details",
                    onTap: () {
                      tabletShowUserDetailsView(context);
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  TabletDrawerItem(
                    image: "assets/images/person_color_image..svg",
                    title: "Profile",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (on) =>
                                  const TurfOwnerUpdateProfileScreen()));
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  TabletDrawerItem(
                    image: "assets/images/privacy_policy_image.svg",
                    title: "Privacy Policy",
                    onTap: () {
                      // scaffoldKey.currentState!.closeDrawer();
                      launchURLBrowser("${ApiService.baseUrl}/privacy-policy");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  TabletDrawerItem(
                    image: "assets/images/terms_and_conditions_image.svg",
                    title: "Terms & Conditions",
                    onTap: () {
                      // scaffoldKey.currentState!.closeDrawer();
                      launchURLBrowser(
                          "${ApiService.baseUrl}/terms-and-conditions");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  TabletDrawerItem(
                    image: "assets/images/refund_policy_image.svg",
                    title: "Refund Policy",
                    onTap: () {
                      // scaffoldKey.currentState!.closeDrawer();
                      launchURLBrowser("${ApiService.baseUrl}/refund-policy");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  TabletDrawerItem(
                    image: "assets/images/email_support_image.svg",
                    title: "Email Support",
                    onTap: () {
                      _sendingMails();
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  TabletDrawerItem(
                    image: "assets/images/call_support_image.svg",
                    title: "Call Support",
                    onTap: () {
                      // _makingPhoneCall();
                      // scaffoldKey.currentState!.closeDrawer();
                      // _launchURLBrowser("https://elixenttech.com/contact-us");
                    },
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      logOut(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 28.h,
                            width: 28.w,
                            child: Stack(
                              children: [
                                Positioned(
                                    left: 3.w,
                                    right: 3.w,
                                    top: 3.h,
                                    bottom: 3.h,
                                    child: SvgPicture.asset(
                                      "assets/images/logout_image.svg",
                                      color: redColor,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Logout",
                                  style:
                                      TabletAppstyle.deleteAccount_text_style,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                              "assets/images/forward_grey_image.svg",
                              height: 12.h,
                              width: 12.w,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 2.h,
                    color: greyBColor,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => TabletDeleteAccount(
                          onPressed: () {
                            Navigator.of(context).pop();
                            launchURLBrowser(
                                "${ApiService.baseUrl}/delete-account");
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 28.h,
                            width: 28.w,
                            child: Stack(
                              children: [
                                Positioned(
                                    left: 3.w,
                                    right: 3.w,
                                    top: 3.h,
                                    bottom: 3.h,
                                    child: SvgPicture.asset(
                                      "assets/images/delete_image.svg",
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Delete  account",
                                  style:
                                      TabletAppstyle.deleteAccount_text_style,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: SvgPicture.asset(
                              "assets/images/forward_grey_image.svg",
                              height: 12.h,
                              width: 12.w,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  userData() async {
    await variable.myDetails(authToken);

    if (variable.baseResponseUserDetails.value.responseCode == 200) {
      //Fluttertoast.showToast(msg: variable.baseResponseUserDetails.value.response);
      variable.upiIdController.value.text =
          variable.baseResponseUserDetails.value.data["userDetail"]["upiId"]??"";
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseUserDetails.value.response);
    }
  }

  _sendingMails() async {
    var url = Uri.parse("mailto:nirav.d@elixenttech.com");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:9776765434");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchURLBrowser(String urls) async {
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

  Future<void> logOut(BuildContext contexts) async {
    return showDialog<void>(
      context: contexts,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext contextt) {
        return AlertDialog(
          title: Text(
            'Are you sure want to logout?',
            style: TabletAppstyle.logoutTitle_text_style,
          ),
          content: Text(
            'This action will be irreversible if you proceed.',
            style: TabletAppstyle.deteleAccountSecond_text_style,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        size: 20.h,
                      ),
                      Text(
                        'Cancel',
                        style: TabletAppstyle.deteleButton_text_style,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(contextt).pop();
                  },
                ),
                SizedBox(
                  width: 8.w,
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/delete_image.svg",
                        height: 16.h,
                        width: 16.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        'Logout',
                        style: TabletAppstyle.deleteAccount_text_style,
                      ),
                    ],
                  ),
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();

                    Navigator.of(contextt).pop();

                    Navigator.pushReplacement(
                        contextt,
                        MaterialPageRoute(
                            builder: (contextt) =>
                                const LoginScreen())); // Navigate to login
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showUserDetailsView(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          insetPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: whiteColor,
            ),
            height: 165.h,
            width: 330.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "Payment details",
                    style: dLocationBold_text_style,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Please enter valid Upi Id",
                            style: detailsAbout_text_style,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Obx(
                    () => AppTextFiled(
                      controller: variable.upiIdController.value,
                      focusNode: variable.upiIdFocusNode.value,
                      selected: variable.upiIdSelected.value,
                      lebel: "UPI ID",
                      keyboardType: TextInputType.emailAddress,
                      onSubmitt: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          variable.upiIdSelected.value = false;
                          return "Please Enter price";
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$")
                            .hasMatch(value)) {
                          variable.emailIDSelected.value = false;
                          return 'Please enter a valid upi id';
                        } else {
                          variable.upiIdSelected.value = true;
                          return null;
                        }
                      },
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: variable.advancePaymentSelected.value == true
                          ? 16.h
                          : 0.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 30.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: whiteColor,
                              border: Border.all(color: greyBColor, width: 1),
                            ),
                            child: const Center(
                              child: Text(
                                "Cancel",
                                // style: deteleButton_text_style,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (variable.upiIdController.value.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter upi id",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$")
                                .hasMatch(
                                    variable.upiIdController.value.text)) {
                              Fluttertoast.showToast(
                                  msg: "Please enter a valid upi id",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Navigator.of(context).pop();
                              updateDetails();
                            }
                          },
                          child: Container(
                            height: 30.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: whiteColor,
                              border: Border.all(color: greyBColor, width: 1),
                            ),
                            child: const Center(
                              child: Text(
                                "Submit",
                                //  style: deteleAccountButton_text_style,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void tabletShowUserDetailsView(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          insetPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: whiteColor,
            ),
            height: 175.h,
            width: 330.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "Payment details",
                    style: dLocationBold_text_style,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Please enter valid Upi Id",
                            style: detailsAbout_text_style,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Obx(
                    () => TabletAppTextFiled(
                      controller: variable.upiIdController.value,
                      focusNode: variable.upiIdFocusNode.value,
                      selected: variable.upiIdSelected.value,
                      lebel: "UPI ID",
                      keyboardType: TextInputType.emailAddress,
                      onSubmitt: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          variable.upiIdSelected.value = false;
                          return "Please Enter price";
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$")
                            .hasMatch(value)) {
                          variable.emailIDSelected.value = false;
                          return 'Please enter a valid upi id';
                        } else {
                          variable.upiIdSelected.value = true;
                          return null;
                        }
                      },
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: variable.advancePaymentSelected.value == true
                          ? 16.h
                          : 0.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 30.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: whiteColor,
                              border: Border.all(color: greyBColor, width: 1),
                            ),
                            child: const Center(
                              child: Text(
                                "Cancel",
                                // style: deteleButton_text_style,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (variable.upiIdController.value.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter upi id",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$")
                                .hasMatch(
                                    variable.upiIdController.value.text)) {
                              Fluttertoast.showToast(
                                  msg: "Please enter a valid upi id",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Navigator.of(context).pop();
                              updateDetails();
                            }
                          },
                          child: Container(
                            height: 30.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: whiteColor,
                              border: Border.all(color: greyBColor, width: 1),
                            ),
                            child: const Center(
                              child: Text(
                                "Submit",
                                //  style: deteleAccountButton_text_style,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  updateDetails() async {
    var body = {"upiId": variable.upiIdController.value.text.toString()};
    await variable.updateDetailsData(authToken, body);

    if (variable.baseResponseUpdateDetails.value.responseCode == 200) {
      Fluttertoast.showToast(
          msg: variable.baseResponseUpdateDetails.value.response);
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseUpdateDetails.value.response);
    }
  }
}
