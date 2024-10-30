// ignore_for_file: unnecessary_brace_in_string_interps, depend_on_referenced_packages

import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/customWidget/couponDetailsWidget.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_offer_details_screen/create_offer_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_offer_details_screen/offer_detail_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class TurfOfferScreen extends StatefulWidget {
  const TurfOfferScreen({super.key});

  @override
  State<TurfOfferScreen> createState() => _TurfOfferScreenState();
}

class _TurfOfferScreenState extends State<TurfOfferScreen> {
  final variable = Get.put(TurfCouponListDataViewModel());
  late SharedPreferences prefs;
  String authToken = "";
  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void dispose() {
    Get.delete<TurfCouponListDataViewModel>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    Timer(const Duration(milliseconds: 500), () {
      _loadBookingListData();
    });
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
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (con) => const CreateOfferScreen()));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 45.h, right: 8.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: appColor,
              border: Border.all(color: whiteColor, width: 5.w)),
          height: 52.h,
          width: 52.w,
          child: Center(
            child: Icon(
              Icons.add,
              color: whiteColor,
            ),
          ),
        ),
      ),
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
              title: "Offers"),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              variable.turfCouponList.isEmpty
                  ? const Center(child: ErrorScreen())
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await _loadBookingListData();
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                            itemBuilder: (context, index) {
                              variable.item =
                                  variable.apiSelectedSlotList[index];
                              Duration timeZoneOffset =
                                  DateTime.now().timeZoneOffset;

                              // Parse the start and end times
                              final DateTime startUtc =
                                  DateTime.parse(variable.item!["startAt"]!);
                              final DateTime endUtc =
                                  DateTime.parse(variable.item!["expiresAt"]!);

                              // Convert UTC to local time by subtracting the timeZoneOffset
                              DateTime startTimeDeviceTime =
                                  startUtc.add(timeZoneOffset);
                              DateTime endTimeDeviceTime =
                                  endUtc.add(timeZoneOffset);

                              // Format the dates as needed
                              final String startTimeFormatted =
                                  DateFormat('yyyy-MM-dd')
                                      .format(startTimeDeviceTime);
                              final String endTimeFormatted =
                                  DateFormat('yyyy-MM-dd')
                                      .format(endTimeDeviceTime);

                              return CouponDetailsWidget(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => OfferDetailsScreen(
                                                couponList: variable
                                                    .turfCouponList[index],
                                              )));
                                },
                                startTimeDeviceTime: startTimeDeviceTime,
                                discountValue: variable
                                    .turfCouponList[index].discountValue!,
                                startTime: startTimeFormatted,
                                endTime: endTimeFormatted,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 16.h,
                              );
                            },
                            itemCount: variable.turfCouponList.length),
                      ),
                    ),
            ],
          ))
        ],
      )),
    );
  }

  Scaffold tabletView(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (con) => const CreateOfferScreen()));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 36.h, right: 8.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              color: appColor,
              border: Border.all(color: whiteColor, width: 3.w)),
          height: 54.h,
          width: 40.w,
          child: Center(
            child: Icon(
              Icons.add,
              color: whiteColor,
            ),
          ),
        ),
      ),
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
              title: "Offers"),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              variable.turfCouponList.isEmpty
                  ? const Center(child: ErrorScreen())
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await _loadBookingListData();
                        },
                        child: ListView.separated(
                           padding: EdgeInsets.symmetric(vertical: 16.h),
                            itemBuilder: (context, index) {
                              variable.item =
                                  variable.apiSelectedSlotList[index];
                              Duration timeZoneOffset =
                                  DateTime.now().timeZoneOffset;

                              // Parse the start and end times
                              final DateTime startUtc =
                                  DateTime.parse(variable.item!["startAt"]!);
                              final DateTime endUtc =
                                  DateTime.parse(variable.item!["expiresAt"]!);

                              // Convert UTC to local time by subtracting the timeZoneOffset
                              DateTime startTimeDeviceTime =
                                  startUtc.add(timeZoneOffset);
                              DateTime endTimeDeviceTime =
                                  endUtc.add(timeZoneOffset);

                              // Format the dates as needed
                              final String startTimeFormatted =
                                  DateFormat('yyyy-MM-dd')
                                      .format(startTimeDeviceTime);
                              final String endTimeFormatted =
                                  DateFormat('yyyy-MM-dd')
                                      .format(endTimeDeviceTime);

                              return CouponDetailsWidget(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => OfferDetailsScreen(
                                                couponList: variable
                                                    .turfCouponList[index],
                                              )));
                                },
                                startTimeDeviceTime: startTimeDeviceTime,
                                discountValue: variable
                                    .turfCouponList[index].discountValue!,
                                startTime: startTimeFormatted,
                                endTime: endTimeFormatted,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 16.h,
                              );
                            },
                            itemCount: variable.turfCouponList.length),
                      ),
                    ),
            ],
          ))
        ],
      )),
    );
  }

  _loadBookingListData() async {
    var body = {
      "pageNumber": "1",
      "perPage": "10",
    };

    await variable.turfCouponListData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      List<dynamic> turfListJson =
          variable.baseResponse.value.data!["couponList"];

      variable.turfCouponList.value =
          turfListJson.map((json) => CouponList.fromJson(json)).toList();
      for (int i = 0; i < variable.turfCouponList.length; i++) {
        // Extract start time and end time from the current document
        var startTime = variable.turfCouponList[i].startAt;
        var endTime = variable.turfCouponList[i].expiresAt;
        var createdAt = variable.turfCouponList[i].createdAt;

        // Check for null values before adding to the map
        if (startTime != null && endTime != null) {
          // Create a map containing the start time and end time
          var timeMap = {
            "startAt": startTime,
            "expiresAt": endTime,
            "createdAt": createdAt
          };

          // Add the timeMap to variable.apiSelectedSlotList
          variable.apiSelectedSlotList.add(timeMap);
        }
      }
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
  }
}
    // try {
    //   final response = await api.apiPostCall(
    //     context,
    //     "owner/coupon-list",
    //     body: {
    //       "pageNumber": "1",
    //       "perPage": "10",
    //     },
    //     headers: {
    //       'Content-type': 'application/json',
    //       "Authorization": "Bearer $authToken",
    //       "app-version": "1.0",
    //       "app-platform": Platform.isIOS ? "ios" : "android"
    //     },
    //   );
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {

    //     List<dynamic> turfListJson = responseData.data!["couponList"];

    //     variable.turfCouponList.value =
    //         turfListJson.map((json) => CouponList.fromJson(json)).toList();
    //     // Assuming variable.turfBookingList[index].documents is a List<dynamic>
    //     for (int i = 0; i < variable.turfCouponList.length; i++) {
    //       // Extract start time and end time from the current document
    //       var startTime = variable.turfCouponList[i].startAt;
    //       var endTime = variable.turfCouponList[i].expiresAt;
    //       var createdAt = variable.turfCouponList[i].createdAt;

    //       // Check for null values before adding to the map
    //       if (startTime != null && endTime != null) {
    //         // Create a map containing the start time and end time
    //         var timeMap = {
    //           "startAt": startTime,
    //           "expiresAt": endTime,
    //           "createdAt": createdAt
    //         };

    //         // Add the timeMap to variable.apiSelectedSlotList
    //         variable.apiSelectedSlotList.add(timeMap);
    //       }
    //     }

    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;

    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {

    //   loading.value = false;
    // }