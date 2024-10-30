// ignore_for_file: depend_on_referenced_packages,unnecessary_brace_in_string_interps, deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/customWidget/bookingDetailsWidget.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/view.dart';
import 'package:turf_heros_owner/test%20time%20list/time_list.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class TurfMyBookingScreen extends StatefulWidget {
  const TurfMyBookingScreen({super.key});

  @override
  State<TurfMyBookingScreen> createState() => _TurfMyBookingScreenState();
}

class _TurfMyBookingScreenState extends State<TurfMyBookingScreen>
    with SingleTickerProviderStateMixin {
  final variable = Get.put(TurfBookingListDataViewModel());

  late SharedPreferences prefs;

  late TabController _tabController;

  final ScrollController _scrollController = ScrollController();

  final bookingFuture = Get.put(DemoTimeList());

  String authToken = "";

  DateTime dateTime = DateTime.now();

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        variable.hasMoreData.value) {
      _loadMoreData();
    } else {}
  }

  Future<void> _loadMoreData() async {
    if (!variable.isLoading.value) {
      variable.isLoading.value = true;
      variable.pageNumber.value++;
      if (variable.tabNumber.value == 1) {
        await _loadBookingListData(
          variable.formattedDate.value,
          variable.formattedDate.value,
        );
      } else if (variable.tabNumber.value == 2) {
        variable.endDate.value = DateFormat('yyyy-MM-dd')
            .format(dateTime.add(const Duration(days: 1)));
        await _loadBookingListData(
          variable.endDate.value,
          "",
        );
      } else {
        variable.startDate.value = DateFormat('yyyy-MM-dd')
            .format(dateTime.subtract(const Duration(days: 1)));
        await _loadBookingListData(
          "",
          variable.startDate.value,
        );
      }
      variable.isLoading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _tabController = TabController(length: 3, vsync: this);

    variable.formattedDate.value = DateFormat('yyyy-MM-dd').format(dateTime);
    // loadTurfList();
    // _scrollController.addListener(_onScroll);
    // variable.currentPosition.latitude == 0.0 ? _getCurrentLocation() : null;
    // checkInternet(context);
    _scrollController.addListener(_onScroll);
    _tabController.index = 1;
    variable.tabNumber.value = 1;
    Timer(const Duration(seconds: 1), () {
      _loadBookingListData(
          variable.formattedDate.value, variable.formattedDate.value,
          isInitialLoad: true);
    });
  }

  @override
  void dispose() {
    Get.delete<TurfBookingListDataViewModel>();
    Get.delete<DemoTimeList>();
    _tabController.dispose();
    _scrollController.dispose();
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
        child: WillPopScope(
          onWillPop: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (co) => const DashBoardSreen()));
            return Future.value(false);
          },
          child: ScreenUtil().screenWidth < 600
              ? moblieView(context)
              : tabletView(context),
        ),
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (co) => const DashBoardSreen()));
              },
              title: "My Booking "),
          timeTabView(),

          // Container(
          //   height: 35.h,
          //   width: double.maxFinite,
          //   margin: EdgeInsets.symmetric(horizontal: 16.r,vertical: 8.r),
          //   decoration: BoxDecoration(
          //       border: Border.all(color: appColor),
          //       borderRadius: BorderRadius.circular(10.r)),
          //   child: ListView.separated(
          //     scrollDirection: Axis.horizontal,
          //       itemBuilder: (context, index) {
          //         return Container(
          //           color: appColor,
          //           child: Text(
          //             bookingFuture.bookingFuture_list[index].title!,
          //             style: bookingFuture.bookingFuture_list[0]
          //                         .isSelected.value ==
          //                     false
          //                 ? bookingFutureUn_text_style
          //                 : bookingFuture_text_style,
          //           ),
          //         );
          //       },
          //       separatorBuilder: (context, index) {
          //         return Container(
          //           width: 2.w,
          //           color: appColor,
          //         );
          //       },
          //       itemCount: bookingFuture.bookingFuture_list.length),
          // ),
          Expanded(
              child: variable.turfBookingList.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorScreen(),
                      ],
                    )
                  : Obx(
                      () => ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                          ),
                          itemBuilder: (context, index) {
                            List<Map<String, dynamic>> apiSelectedSlotList = [];
                            // Assuming variable.turfBookingList[index].documents is a List<dynamic>
                            for (int i = 0;
                                i <
                                    variable.turfBookingList[index].documents!
                                        .length;
                                i++) {
                              // Extract start time and end time from the current document
                              var startTime = variable.turfBookingList[index]
                                  .documents![i].startTime;
                              var endTime = variable
                                  .turfBookingList[index].documents![i].endTime;

                              // Check for null values before adding to the map
                              if (startTime != null && endTime != null) {
                                // Create a map containing the start time and end time
                                var timeMap = {
                                  "startTime": startTime,
                                  "endTime": endTime
                                };

                                // Add the timeMap to variable.apiSelectedSlotList
                                apiSelectedSlotList.add(timeMap);
                              }
                            }
                            return BookingDetailsWidget(
                              apiSelectedSlotList: apiSelectedSlotList,
                              images: variable
                                          .turfBookingList[index]
                                          .documents![0]
                                          .turfDetail![0]
                                          .images !=
                                      null
                                  ? variable.turfBookingList[index]
                                      .documents![0].turfDetail![0].images![0]
                                  : variable
                                              .turfBookingList[index]
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
                              turfName: variable.turfBookingList[index]
                                  .documents![0].turfDetail![0].name!,
                              isBookedByOwner: variable.turfBookingList[index]
                                  .documents![0].isBookedByOwner!,
                              address:
                                  "${variable.turfBookingList[index].documents![0].turfDetail![0].address!.line1},${variable.turfBookingList[index].documents![0].turfDetail![0].address!.line2},${variable.turfBookingList[index].documents![0].turfDetail![0].address!.city},${variable.turfBookingList[0].documents![0].turfDetail![0].address!.state},${variable.turfBookingList[0].documents![0].turfDetail![0].address!.pinCode}",
                              sportName: variable.turfBookingList[index]
                                  .documents![0].sportDetail![0].name!,
                              payAmount: variable.turfBookingList[index]
                                  .documents![0].payAmount!,
                              payAtTurf: variable.turfBookingList[index]
                                  .documents![0].payableAtTurf!,
                              date: variable
                                  .turfBookingList[index].documents![0].date!,
                              turfPitchName: variable.turfBookingList[index]
                                  .documents![0].turfPitchDetail![0].name!,
                              bookingId: variable.turfBookingList[index]
                                  .documents![0].bookingId!,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 12.h, bottom: 8.h),
                                child: DottedDashedLine(
                                    height: 1.h,
                                    width: double.infinity,
                                    axis: Axis.horizontal),
                              ),
                            );
                          },
                          itemCount: variable.turfBookingList.length),
                    ))
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (co) => const DashBoardSreen()));
              },
              title: "My Booking "),
          timeTabView(),

          // Container(
          //   height: 35.h,
          //   width: double.maxFinite,
          //   margin: EdgeInsets.symmetric(horizontal: 16.r,vertical: 8.r),
          //   decoration: BoxDecoration(
          //       border: Border.all(color: appColor),
          //       borderRadius: BorderRadius.circular(10.r)),
          //   child: ListView.separated(
          //     scrollDirection: Axis.horizontal,
          //       itemBuilder: (context, index) {
          //         return Container(
          //           color: appColor,
          //           child: Text(
          //             bookingFuture.bookingFuture_list[index].title!,
          //             style: bookingFuture.bookingFuture_list[0]
          //                         .isSelected.value ==
          //                     false
          //                 ? bookingFutureUn_text_style
          //                 : bookingFuture_text_style,
          //           ),
          //         );
          //       },
          //       separatorBuilder: (context, index) {
          //         return Container(
          //           width: 2.w,
          //           color: appColor,
          //         );
          //       },
          //       itemCount: bookingFuture.bookingFuture_list.length),
          // ),
          Expanded(
              child: variable.turfBookingList.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorScreen(),
                      ],
                    )
                  : Obx(
                      () => ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                          ),
                          itemBuilder: (context, index) {
                            List<Map<String, dynamic>> apiSelectedSlotList = [];
                            // Assuming variable.turfBookingList[index].documents is a List<dynamic>
                            for (int i = 0;
                                i <
                                    variable.turfBookingList[index].documents!
                                        .length;
                                i++) {
                              // Extract start time and end time from the current document
                              var startTime = variable.turfBookingList[index]
                                  .documents![i].startTime;
                              var endTime = variable
                                  .turfBookingList[index].documents![i].endTime;

                              // Check for null values before adding to the map
                              if (startTime != null && endTime != null) {
                                // Create a map containing the start time and end time
                                var timeMap = {
                                  "startTime": startTime,
                                  "endTime": endTime
                                };

                                // Add the timeMap to variable.apiSelectedSlotList
                                apiSelectedSlotList.add(timeMap);
                              }
                            }
                            return TabletBookingDetailsWidget(
                              apiSelectedSlotList: apiSelectedSlotList,
                              images: variable
                                          .turfBookingList[index]
                                          .documents![0]
                                          .turfDetail![0]
                                          .images !=
                                      null
                                  ? variable.turfBookingList[index]
                                      .documents![0].turfDetail![0].images![0]
                                  : variable
                                              .turfBookingList[index]
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
                              turfName: variable.turfBookingList[index]
                                  .documents![0].turfDetail![0].name!,
                              isBookedByOwner: variable.turfBookingList[index]
                                  .documents![0].isBookedByOwner!,
                              address:
                                  "${variable.turfBookingList[index].documents![0].turfDetail![0].address!.line1},${variable.turfBookingList[index].documents![0].turfDetail![0].address!.line2},${variable.turfBookingList[index].documents![0].turfDetail![0].address!.city},${variable.turfBookingList[0].documents![0].turfDetail![0].address!.state},${variable.turfBookingList[0].documents![0].turfDetail![0].address!.pinCode}",
                              sportName: variable.turfBookingList[index]
                                  .documents![0].sportDetail![0].name!,
                              payAmount: variable.turfBookingList[index]
                                  .documents![0].payAmount!,
                              payAtTurf: variable.turfBookingList[index]
                                  .documents![0].payableAtTurf!,
                              date: variable
                                  .turfBookingList[index].documents![0].date!,
                              turfPitchName: variable.turfBookingList[index]
                                  .documents![0].turfPitchDetail![0].name!,
                              bookingId: variable.turfBookingList[index]
                                  .documents![0].bookingId!,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 12.h, bottom: 8.h),
                                child: DottedDashedLine(
                                    height: 1.h,
                                    width: double.infinity,
                                    axis: Axis.horizontal),
                              ),
                            );
                          },
                          itemCount: variable.turfBookingList.length),
                    ))
        ],
      )),
    );
  }

  Container timeTabView() {
    return Container(
      height: 34.h,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
      decoration: BoxDecoration(
        border: Border.all(color: appColor),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (value) {
          variable.tabNumber.value = value;
          variable.turfBookingList.clear();
          if (variable.tabNumber.value == 1) {
            _loadBookingListData(
                variable.formattedDate.value, variable.formattedDate.value,
                isInitialLoad: true);
          } else if (variable.tabNumber.value == 2) {
            variable.endDate.value = DateFormat('yyyy-MM-dd')
                .format(dateTime.add(const Duration(days: 1)));
            _loadBookingListData(variable.endDate.value, "",
                isInitialLoad: true);
          } else {
            variable.startDate.value = DateFormat('yyyy-MM-dd')
                .format(dateTime.subtract(const Duration(days: 1)));
            _loadBookingListData("", variable.startDate.value,
                isInitialLoad: true);
          }
        },
        indicatorColor: appColor,
        indicator: BoxDecoration(
            color: appColor,
            borderRadius: variable.tabNumber.value == 0
                ? BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  )
                : _tabController.index == 2
                    ? BorderRadius.only(
                        topRight: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(0.r),
                        bottomRight: Radius.circular(0.r),
                      )
            //
            ),

        unselectedLabelStyle: bookingFuture_text_style,
        labelStyle: bookingFutureUn_text_style,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        isScrollable: false, // Make sure tabs are not scrollable
        tabs: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              bottomLeft: Radius.circular(10.r),
            ),
            child: Container(
              width: double.infinity, // Full width for equal distribution
              // Background color for Tab 1

              alignment: Alignment.center,
              child: Text(
                bookingFuture.bookingFuture_list[0].title!,
              ),
            ),
          ),
          Container(
            width: double.infinity, // Full width for equal distribution
            // Background color for Tab 2
            alignment: Alignment.center,

            child: Text(
              bookingFuture.bookingFuture_list[1].title!,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r),
            ),
            child: Container(
              width: double.infinity, // Full width for equal distribution
              // Background color for Tab 3
              alignment: Alignment.center,

              child: Text(
                bookingFuture.bookingFuture_list[2].title!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _loadBookingListData(String startDate, String endDate,
      {bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      variable.pageNumber.value = 1; // Reset to the first page on initial load
      variable.turfBookingList
          .clear(); // Clear the current list for initial load
    }
    var body = {
      "pageNumber": variable.pageNumber.value,
      "perPage": "5",
      "searchString": "",
      "startDate": startDate,
      "endDate": endDate
    };

    await variable.turfBookingListData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      List<dynamic> turfListJson =
          variable.baseResponse.value.data!["turfBookingList"];
      if (isInitialLoad) {
        variable.hasMoreData.value = true;
        if (turfListJson.isEmpty) {
          variable.hasMoreData.value = false;
          // appVariable.turfList.value =
          //     turfListJson.map((json) => TurfList.fromJson(json)).toList();
        } else {
          variable.turfBookingList.value = turfListJson
              .map((json) => TurfBookingList.fromJson(json))
              .toList();
          /*  appVariable.turfList.value =
                turfListJson.map((json) => TurfList.fromJson(json)).toList();*/
        }
      } else {
        if (turfListJson.isEmpty) {
          variable.hasMoreData.value = false;
          // appVariable.turfList.value =
          //     turfListJson.map((json) => TurfList.fromJson(json)).toList();
        } else {
          /*  appVariable.searchController.value.text.isEmpty
                ? */
          variable.turfBookingList.addAll(turfListJson
                  .map((json) => TurfBookingList.fromJson(json))
                  .toList())
              /*  : appVariable.turfList.value = turfListJson
                    .map((json) => TurfList.fromJson(json))
                    .toList()*/
              ;
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
    //     "owner/booking-list",
    //     body: {
    //       "pageNumber": "1",
    //       "perPage": "10",
    //       "searchString": "",
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

    //     List<dynamic> turfListJson = responseData.data!["turfBookingList"];

    //     variable.turfBookingList.value =
    //         turfListJson.map((json) => TurfBookingList.fromJson(json)).toList();

    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;

    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {

    //   loading.value = false;
    // }