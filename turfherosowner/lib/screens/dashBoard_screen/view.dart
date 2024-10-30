// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appConstns/AppConstns.dart';
import 'package:turf_heros_owner/customWidget/customTurfGround.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_calendar_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_ground_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_myBooking_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_offer_details_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_owner_account_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_timeSlot_screen/view.dart';
import 'package:turf_heros_owner/test%20time%20list/time_list.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class DashBoardSreen extends StatefulWidget {
  const DashBoardSreen({super.key});
  @override
  State<DashBoardSreen> createState() => _DashBoardSreenState();
}

class _DashBoardSreenState extends State<DashBoardSreen> {
  final appVariable = Get.put(AppConstns());
  final turfhomeDetails = Get.put(DemoTimeList());
  @override
  void initState() {
    super.initState();
    loadSportData();
    loadFacilitesData();
    print("PRINT FLAVOR ${ApiService.baseUrl}");
  }

  @override
  void dispose() {
    Get.delete<AppConstns>();
    Get.delete<DemoTimeList>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtil().screenWidth < 600 ? moblieView() : tabletView();
  }

  Scaffold moblieView() {
    return Scaffold(
      backgroundColor: whiteColor,
      // bottomNavigationBar: Container(
      //   height: 55.h,
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //           color: black_color,
      //           offset: Offset.fromDirection(
      //             1,
      //           ),
      //           blurRadius: 0.9,
      //           spreadRadius: 0.1)
      //     ],
      //     color: whiteColor,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(20),
      //       topRight: Radius.circular(20),
      //     ),
      //   ),
      //   child: Obx(
      //     () => Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         IconButton(
      //           enableFeedback: false,
      //           onPressed: () {
      //             appVariable.selectedTab.value = 0;
      //           },
      //           icon: appVariable.selectedTab.value == 0
      //               ? SvgPicture.asset(
      //                   "assets/images/home_color_image.svg")
      //               : SvgPicture.asset(
      //                   "assets/images/home_image.svg"),
      //         ),
      //         IconButton(
      //           enableFeedback: false,
      //           onPressed: () {
      //             appVariable.selectedTab.value = 1;
      //           },
      //           icon: appVariable.selectedTab.value == 1
      //               ? SvgPicture.asset(
      //                   "assets/images/tropy_color_image.svg",
      //                 )
      //               : SvgPicture.asset(
      //                   "assets/images/tropy_image.svg"),
      //         ),
      //         IconButton(
      //           enableFeedback: false,
      //           onPressed: () {
      //             // appVariable.selectedTab.value = 2;
      //             // Navigator.push(
      //             //     context,
      //             //     MaterialPageRoute(
      //             //         builder: (on) =>
      //             //             const BookingListScreen()));
      //           },
      //           icon: appVariable.selectedTab.value == 2
      //               ? SvgPicture.asset(
      //                   "assets/images/person_color_image..svg",
      //                 )
      //               : SvgPicture.asset(
      //                   "assets/images/person_image.svg"),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
              title: "Home"),
          Expanded(
              child: GridView.builder(
            padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 158.h,
                mainAxisSpacing: 16.r,
                crossAxisSpacing: 16.r,
                childAspectRatio: 4.2.r / 4.5.r),
            itemBuilder: (context, index) {
              return TurfHomeWidget(
                image: turfhomeDetails.turfGorundDetails_screenList[index]
                    ["image"],
                onTap: () {
                  if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Turf Grounds") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (on) => const TurfGorundsScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "All Booking") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (on) => const TurfMyBookingScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Offers") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (on) => const TurfOfferScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Calendar") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (cot) => const TurfCalendarScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Account") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (con) => const TurfOwnerAccountScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Time Slot") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (con) => const TurfTimeSlotData()));
                  }
                },
                title: turfhomeDetails.turfGorundDetails_screenList[index]
                    ["title"],
              );
            },
            itemCount: turfhomeDetails.turfGorundDetails_screenList.length,
          ))
        ],
      )),
    );
  }

  Scaffold tabletView() {
    return Scaffold(
      backgroundColor: whiteColor,
      // bottomNavigationBar: Container(
      //   height: 55.h,
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //           color: black_color,
      //           offset: Offset.fromDirection(
      //             1,
      //           ),
      //           blurRadius: 0.9,
      //           spreadRadius: 0.1)
      //     ],
      //     color: whiteColor,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(20),
      //       topRight: Radius.circular(20),
      //     ),
      //   ),
      //   child: Obx(
      //     () => Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         IconButton(
      //           enableFeedback: false,
      //           onPressed: () {
      //             appVariable.selectedTab.value = 0;
      //           },
      //           icon: appVariable.selectedTab.value == 0
      //               ? SvgPicture.asset(
      //                   "assets/images/home_color_image.svg")
      //               : SvgPicture.asset(
      //                   "assets/images/home_image.svg"),
      //         ),
      //         IconButton(
      //           enableFeedback: false,
      //           onPressed: () {
      //             appVariable.selectedTab.value = 1;
      //           },
      //           icon: appVariable.selectedTab.value == 1
      //               ? SvgPicture.asset(
      //                   "assets/images/tropy_color_image.svg",
      //                 )
      //               : SvgPicture.asset(
      //                   "assets/images/tropy_image.svg"),
      //         ),
      //         IconButton(
      //           enableFeedback: false,
      //           onPressed: () {
      //             // appVariable.selectedTab.value = 2;
      //             // Navigator.push(
      //             //     context,
      //             //     MaterialPageRoute(
      //             //         builder: (on) =>
      //             //             const BookingListScreen()));
      //           },
      //           icon: appVariable.selectedTab.value == 2
      //               ? SvgPicture.asset(
      //                   "assets/images/person_color_image..svg",
      //                 )
      //               : SvgPicture.asset(
      //                   "assets/images/person_image.svg"),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
              title: "Home"),
          Expanded(
              child: GridView.builder(
            padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 158.h,
                mainAxisSpacing: 16.r,
                crossAxisSpacing: 16.r,
                childAspectRatio: 4.2.r / 4.5.r),
            itemBuilder: (context, index) {
              return TabletTurfHomeWidget(
                image: turfhomeDetails.turfGorundDetails_screenList[index]
                    ["image"],
                onTap: () {
                  if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Turf Grounds") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (on) => const TurfGorundsScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "All Booking") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (on) => const TurfMyBookingScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Offers") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (on) => const TurfOfferScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Calendar") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (cot) => const TurfCalendarScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Account") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (con) => const TurfOwnerAccountScreen()));
                  } else if (turfhomeDetails.turfGorundDetails_screenList[index]
                          ["title"] ==
                      "Time Slot") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (con) => const TurfTimeSlotData()));
                  }
                },
                title: turfhomeDetails.turfGorundDetails_screenList[index]
                    ["title"],
              );
            },
            itemCount: turfhomeDetails.turfGorundDetails_screenList.length,
          ))
        ],
      )),
    );
  }

  Future<void> saveModelList(List<SportList> modelList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(modelList.map((model) => model.toJson()).toList());
    await prefs.setString('modelList', encodedData);
  }

  loadSportData() async {
    final apiService = Get.put(SportDataViewModel());

    await apiService.sportData();

    if (apiService.baseResponse.value.responseCode == 200) {
      List<dynamic> sportListJson =
          apiService.baseResponse.value.data!["sportList"];

      saveModelList(
          sportListJson.map((json) => SportList.fromJson(json)).toList());
    } else {
      Fluttertoast.showToast(msg: apiService.baseResponse.value.response);
    }

    // try {
    //   final response = await api.apiPostCall(context, "sport-list", body: {
    //     "pageNumber": "1",
    //     "perPage": "10"
    //   }, headers: {
    //     'Content-type': 'application/json',
    //     "app-version": "1.0",
    //     "app-platform": Platform.isIOS ? "ios" : "android"
    //   });
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {
    //     print("ewew${responseData.data}");
    //     List<dynamic> sportListJson = responseData.data!["sportList"];
    //     //  SportList
    //     appVariable.SportsList.value =
    //         sportListJson.map((json) => SportList.fromJson(json)).toList();
    //     print(appVariable.SportsList[0]);
    //   } else if (responseData.responseCode == 401) {
    //     print("ewew${responseData.response}");
    //   } else {}
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  Future<void> saveFacilityModelList(List<SportList> modelList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(modelList.map((model) => model.toJson()).toList());
    await prefs.setString('facilitymodelList', encodedData);
  }

  loadFacilitesData() async {
    final apiService = Get.put(FacilityDataViewModel());

    await apiService.facilityData();

    if (apiService.baseResponse.value.responseCode == 200) {
      List<dynamic> sportListJson =
          apiService.baseResponse.value.data!["facilityList"];

      saveFacilityModelList(
          sportListJson.map((json) => SportList.fromJson(json)).toList());
    } else {
      Fluttertoast.showToast(msg: apiService.baseResponse.value.response);
    }
    // try {
    //   final response = await api.apiPostCall(context, "facility-list", body: {
    //     "pageNumber": "1",
    //     "perPage": "10"
    //   }, headers: {
    //     'Content-type': 'application/json',
    //     "app-version": "1.0",
    //     "app-platform": Platform.isIOS ? "ios" : "android"
    //   });
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {
    //     print("ewew${responseData.data}");
    //     List<dynamic> sportListJson = responseData.data!["facilityList"];
    //     //  SportList
    //     appVariable.facilityList.value =
    //         sportListJson.map((json) => SportList.fromJson(json)).toList();
    //     print(appVariable.facilityList[0].name);
    //   } else if (responseData.responseCode == 401) {
    //     print("ewew${responseData.response}");
    //   } else {}
    // } catch (e) {
    //   print(e.toString());
    // }
  }
}
