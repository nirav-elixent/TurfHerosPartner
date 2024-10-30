// ignore_for_file: must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_offer_details_screen/edit_offer_screen/view.dart';
import 'package:intl/intl.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_offer_details_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class OfferDetailsScreen extends StatefulWidget {
  CouponList couponList;
  OfferDetailsScreen({required this.couponList, super.key});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  List<Map<String, dynamic>> apiSelectedSlotList = [];
  String endTime = "";
  String startTime = "";
  DateTime? startTimeDeviceTime;
  late SharedPreferences prefs;
  String authToken = "";
  final variable = Get.put(DeleteCouponDataViewModel());

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void dispose() {
    Get.delete<DeleteCouponDataViewModel>();
    apiSelectedSlotList.clear();
    endTime = "";
    startTime = "";
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    getDateTime();
    getDateTime2();
  }

  @override
  Widget build(BuildContext context) {
    // Extract start time and end time from the current document
    return Obx(
      () => OverlayLoaderWithAppIcon(
        isLoading: variable.isLoading.value,
        circularProgressColor: appColor,
        appIcon: SizedBox(
          height: 30.h,
          width: 30.w,
          child: Padding(
            padding:  EdgeInsets.all(8.r),
            child: Image.asset(
              "assets/images/loader_image.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        child:ScreenUtil().screenWidth < 600
            ? moblieView(context)
            : tabletView(context),
      ),
    );
  }

  Scaffold moblieView(BuildContext context) {
    return Scaffold(
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
                title: "Offers Details "),
            SizedBox(
              height: 16.h,
            ),
            Card(
              margin: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formatTimeAgo(startTimeDeviceTime!),
                          style: offerTime_text_style,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                text:
                                    "Flat ${widget.couponList.discountValue}% ",
                                style: offerPer_text_style,
                                children: [
                                  TextSpan(
                                      text: "off on your first Booking ",
                                      style: offerDes_text_style)
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Start: ",
                                  style: offerStart_text_style,
                                  children: [
                                    TextSpan(
                                        text: startTime,
                                        style: offerStartTime_text_style)
                                  ]),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Expired : ",
                                  style: offerStart_text_style,
                                  children: [
                                    TextSpan(
                                        text: endTime,
                                        style: offerStartTime_text_style)
                                  ]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8.h),
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: const Color(0xffF1F1F1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (gf) => EditOfferScreen(
                                          couponList: widget.couponList,
                                        )));
                          },
                          child: SizedBox(
                            child: SvgPicture.asset(
                                "assets/images/edit_image.svg",height: 24.h,width: 24.w,),
                          ),
                        )),
                        Container(
                          height: 15.h,
                          width: 1.5.w,
                          color: greyBColor,
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Timer(const Duration(milliseconds: 500), () {
                              _deleteCouponData();
                            });
                          },
                          child: SizedBox(
                            child: SvgPicture.asset(
                                "assets/images/delete_image.svg",height: 24.h,width: 24.w,),
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      );
  }

    Scaffold tabletView(BuildContext context) {
    return Scaffold(
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
                title: "Offers Details "),
            SizedBox(
              height: 16.h,
            ),
            Card(
              margin: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formatTimeAgo(startTimeDeviceTime!),
                          style: offerTime_text_style,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                text:
                                    "Flat ${widget.couponList.discountValue}% ",
                                style: offerPer_text_style,
                                children: [
                                  TextSpan(
                                      text: "off on your first Booking ",
                                      style: offerDes_text_style)
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Start: ",
                                  style: offerStart_text_style,
                                  children: [
                                    TextSpan(
                                        text: startTime,
                                        style: offerStartTime_text_style)
                                  ]),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Expired : ",
                                  style: offerStart_text_style,
                                  children: [
                                    TextSpan(
                                        text: endTime,
                                        style: offerStartTime_text_style)
                                  ]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8.h),
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: const Color(0xffF1F1F1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (gf) => EditOfferScreen(
                                          couponList: widget.couponList,
                                        )));
                          },
                          child: SizedBox(
                            child: SvgPicture.asset(
                                "assets/images/edit_image.svg"),
                          ),
                        )),
                        Container(
                          height: 15.h,
                          width: 1.5.w,
                          color: greyBColor,
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Timer(const Duration(milliseconds: 500), () {
                              _deleteCouponData();
                            });
                          },
                          child: SizedBox(
                            child: SvgPicture.asset(
                                "assets/images/delete_image.svg"),
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      );
  }

  _deleteCouponData() async {
    var body = {
      "couponId": widget.couponList.sId,
    };

    await variable.deleteCouponData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (co) => const TurfOfferScreen()));
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
  }

  getDateTime2() {
    Map<String, dynamic> item = apiSelectedSlotList[0];
    Duration timeZoneOffset = DateTime.now().timeZoneOffset;
    // Parse the start and end times
    final DateTime startUtc = DateTime.parse(item["startAt"].toString());
    final DateTime endUtc = DateTime.parse(item["expiresAt"]);
    final DateTime createUtc = DateTime.parse(item["createdAt"]);

    startTimeDeviceTime = createUtc.add(timeZoneOffset);
    // Duration difference = startTimeDeviceTime.difference(DateTime.now());
    // Format the time in the local timezone
    startTime = DateFormat('yyyy-MM-dd').format(startUtc);
    endTime = DateFormat('yyyy-MM-dd').format(endUtc);
  }

  getDateTime() {
    var startTime = widget.couponList.startAt;
    var endTime = widget.couponList.expiresAt;
    var createdAt = widget.couponList.createdAt;

    // Check for null values before adding to the map
    if (startTime != null && endTime != null) {
      // Create a map containing the start time and end time
      var timeMap = {
        "startAt": startTime,
        "expiresAt": endTime,
        "createdAt": createdAt
      };

      // Add the timeMap to appVariable.apiSelectedSlotList
      apiSelectedSlotList.add(timeMap);
    }
  }

  String formatTimeAgo(DateTime pastTime) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(pastTime);

    int hoursAgo = difference.inHours;
    int minutesAgo = difference.inMinutes.remainder(60);
    int days = difference.inDays;
    int months = (difference.inDays / 30).floor();

    if (difference.inMinutes < 60) {
      return "$minutesAgo minute${minutesAgo == 1 ? '' : 's'} ago";
    } else if (hoursAgo < 24) {
      return "$hoursAgo hour${hoursAgo == 1 ? '' : 's'} $minutesAgo minute${minutesAgo == 1 ? '' : 's'} ago";
    } else if (days < 30) {
      return "$days day${days == 1 ? '' : 's'} ago";
    } else {
      return "$months month${months == 1 ? '' : 's'} ago";
    }
  }
}

  // try {
    //   final response = await api.apiPostCall(
    //     context,
    //     "owner/coupon-delete",
    //     body: {"couponId": "${widget.couponList.sId}"},
    //     headers: {
    //       'Content-type': 'application/json',
    //       "Authorization": "Bearer $authToken",
    //       "app-version": "1.0",
    //       "app-platform": Platform.isIOS ? "ios" : "android"
    //     },
    //   );
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {
 
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (co) => const TurfOfferScreen()));
    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;

    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {

    //   loading.value = false;
    // }