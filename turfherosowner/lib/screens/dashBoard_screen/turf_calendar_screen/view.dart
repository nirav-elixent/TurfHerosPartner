// ignore_for_file: depend_on_referenced_packages, avoid_print, unnecessary_string_interpolations

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:calendar_timeline_sbk/calendar_timeline.dart';
import 'package:turf_heros_owner/customWidget/calenderBookingWidget.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class TurfCalendarScreen extends StatefulWidget {
  const TurfCalendarScreen({super.key});

  @override
  State<TurfCalendarScreen> createState() => _TurfCalendarScreenState();
}

class _TurfCalendarScreenState extends State<TurfCalendarScreen> {
  final variable = Get.put(TurfBookingListDataViewModel());
  DateTime dateTime = DateTime.now();
  late SharedPreferences prefs;
  String authToken = "";

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
    print("print123 $authToken");
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    variable.formattedDate.value =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    variable.formatDays.value =
        DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    Timer( Duration(milliseconds: 500), () {
      _loadBookingListData(DateTime.now());
    });
  }

  @override
  void dispose() {
    Get.delete<TurfBookingListDataViewModel>();
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
            padding:  EdgeInsets.all(8.r),
            child: Image.asset(
              "assets/images/loader_image.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        child: Scaffold(
          body: SafeArea(
              top: false,
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: const Color(0xff2254B2),
                child: Stack(
                  children: [
                    calenderTitle(),
                    calenederView(),
                    Padding(
                      padding: EdgeInsets.only(top: 250.h),
                      child: Container(
                        padding: EdgeInsets.only(top: 16.h),
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.r),
                                topRight: Radius.circular(30.r)),
                            color: whiteColor),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            variable.turfBookingList.isEmpty
                                ? const Center(child: ErrorScreen())
                                : Expanded(
                                    child: ListView.separated(
                                        padding: EdgeInsets.only(top: 16.h),
                                        itemBuilder: (context, index) {
                                          return CalenderBookingWidget(
                                            images: variable
                                                        .turfBookingList[index]
                                                        .documents![0]
                                                        .turfDetail![0]
                                                        .images !=
                                                    null
                                                ? variable
                                                    .turfBookingList[index]
                                                    .documents![0]
                                                    .turfDetail![0]
                                                    .images![0]
                                                : variable
                                                            .turfBookingList[
                                                                index]
                                                            .documents![0]
                                                            .turfDetail![0]
                                                            .images ==
                                                        null
                                                    ? "assets/images/turf_image.png"
                                                    : variable
                                                        .turfBookingList[index]
                                                        .documents![0]
                                                        .turfDetail![index]
                                                        .images![0],
                                            turfName: variable
                                                .turfBookingList[index]
                                                .documents![0]
                                                .turfDetail![0]
                                                .name!,
                                            address:
                                                "${variable.turfBookingList[index].documents![0].turfDetail![0].address!.line1},${variable.turfBookingList[index].documents![0].turfDetail![0].address!.line2},${variable.turfBookingList[index].documents![0].turfDetail![0].address!.city},${variable.turfBookingList[0].documents![0].turfDetail![0].address!.state},${variable.turfBookingList[0].documents![0].turfDetail![0].address!.pinCode}",
                                            sportName: variable
                                                .turfBookingList[index]
                                                .documents![0]
                                                .sportDetail![0]
                                                .name!,
                                            totalAmount:
                                                "${variable.turfBookingList[index].documents![0].payAmount! + variable.turfBookingList[index].documents![0].payableAtTurf!}",
                                            date: variable
                                                .turfBookingList[index]
                                                .documents![0]
                                                .date!,
                                            turfPitchName: variable
                                                .turfBookingList[index]
                                                .documents![0]
                                                .turfPitchDetail![0]
                                                .name!,
                                            isPaid: variable
                                                .turfBookingList[index]
                                                .documents![0]
                                                .isPaid!,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 16.h,
                                          );
                                        },
                                        itemCount:
                                            variable.turfBookingList.length),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Padding calenderTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 48.h),
      child: SizedBox(
        width: double.infinity,
        height: 35.h,
        child: Stack(
          children: [
            Positioned(
              left: 16.w,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 33.h,
                  width: 33.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: whiteColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff000000),
                            blurRadius: 2,
                            spreadRadius: 0.1)
                      ]),
                  child: Center(
                      child: SvgPicture.asset("assets/images/back_image.svg")),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Calendar",
                    style: title_white_style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding calenederView() {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Column(
        children: [
          CalendarTimeline(
            initialDate: DateTime.parse(variable.formattedDate.value),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)),
            onDateSelected: (date) {
              _loadBookingListData(date);
              variable.formattedDate.value =
                  DateFormat('yyyy-MM-dd').format(date);
              variable.formatDays.value =
                  DateFormat('EEEE, dd MMMM yyyy').format(date);
              // loading.value = true;
              // if (variable.formattedDate.value ==
              //     DateFormat('yyyy-MM-dd').format(dateTime)) {
              //   _loadBookingSlotData(variable.turfPitch.value);
              // } else {
              //   _loadBookingAvailableSlotData(
              //       DateFormat('yyyy-MM-dd').format(date));
              // }
            },
            leftMargin: 16.w,
            monthColor: Colors.white,
            inactiveDayNameColor: whiteColor,
            dayColor: whiteColor,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: const Color(0xff2254B2),
            dotsColor: const Color(0xFF333A47),
            locale: 'en_ISO',
          ),
          SizedBox(
            height: 16.h,
          ),
          Obx(
            () => Text(
              variable.formatDays.value,
              style: calendar_text_style,
            ),
          )
        ],
      ),
    );
  }

  _loadBookingListData(DateTime dateTime) async {
    print("print123 $authToken");
    var body = {
      "pageNumber": "1",
      "perPage": "10",
      "searchString": "",
      "bookingDate": "${DateFormat('yyyy-MM-dd').format(dateTime)}"
    };

    await variable.turfBookingListData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      // Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      List<dynamic> turfListJson =
          variable.baseResponse.value.data!["turfBookingList"];

      variable.turfBookingList.value =
          turfListJson.map((json) => TurfBookingList.fromJson(json)).toList();
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }

    // try {
    //   final response = await api.apiPostCall(
    //     context,
    //     "owner/booking-list",
    //     body: {
    //       "pageNumber": "1",
    //       "perPage": "10",
    //       "searchString": "",
    //       "bookingDate": "${DateFormat('yyyy-MM-dd').format(dateTime)}"
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
    //     print("ewew$authToken");
    //     print("ewew${responseData.data}");
    //     List<dynamic> turfListJson = responseData.data!["turfBookingList"];
    //     variable.turfCalenderBookingList.value =
    //         turfListJson.map((json) => TurfBookingList.fromJson(json)).toList();
    //     print("print123 $turfListJson");
    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;
    //     print("ewew$authToken");
    //     print("ewew${responseData.response}");
    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {
    //   print("ptint1234 ${e.toString()}");
    //   loading.value = false;
    // }
  }
}
