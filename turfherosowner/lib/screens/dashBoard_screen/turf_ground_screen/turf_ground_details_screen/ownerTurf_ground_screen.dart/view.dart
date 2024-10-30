// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, unnecessary_string_interpolations, use_build_context_synchronously, unused_element

import 'dart:async';
import 'dart:convert';
import 'package:calendar_timeline_sbk/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/CustomSelectPitch.dart';
import 'package:turf_heros_owner/customWidget/SelectTime.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/customWidget/selectSport.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:intl/intl.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_myBooking_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

// ignore: must_be_immutable
class OwnerTurfGroundScreen extends StatefulWidget {
  TurfList turfListDetails;
  String userId;
  OwnerTurfGroundScreen(
      {required this.turfListDetails, required this.userId, super.key});

  @override
  State<OwnerTurfGroundScreen> createState() => _OwnerTurfGroundScreenState();
}

class _OwnerTurfGroundScreenState extends State<OwnerTurfGroundScreen> {
  final variable = Get.put(LoadBookingAvailableSlotDataViewModel());

  DateTime dateTime = DateTime.now();

  RxList<SportList> sportsList = <SportList>[].obs;

  RxList<SportList> turfSportsList = <SportList>[].obs;

  RxList<TurfPitchDetail> turfPitchList = <TurfPitchDetail>[].obs;

  late SharedPreferences prefs;

  String turfSportID = "";

  RxString turfPitch = "".obs;

  RxInt slotPrice = 0.obs;

  RxList<TurfAvailableSlotList> availableSelectedSlotList =
      <TurfAvailableSlotList>[].obs;

  var authToken = "";

  _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void dispose() {
    Get.delete<LoadBookingAvailableSlotDataViewModel>();
    super.dispose();
  }

  Future<List<SportList>> loadModelList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('modelList');

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);

      // Explicitly convert each item in the list to SportList
      return decodedData.map((item) => SportList.fromJson(item)).toList();
    }
    return [];
  }

  void fetchSportsList() async {
    List<SportList> loadedList = await loadModelList();
    sportsList.addAll(loadedList);
    turfSportsList.value = sportsList.where((sport) {
      return widget.turfListDetails.sportIds!.contains(sport.sId);
    }).toList(); // Assign the loaded list to the RxList
  }

  @override
  void initState() {
    super.initState();

    turfSportID = widget.turfListDetails.sportIds![0];
    _loadPreferences();
    fetchSportsList();
    variable.formattedDate.value = DateFormat('yyyy-MM-dd').format(dateTime);

    variable.selectedTurfPitch.value =
        widget.turfListDetails.turfPitchDetail![0].name!;

    turfPitchList.value = widget.turfListDetails.turfPitchDetail!
        .where((item) => item.sportIds!.contains(turfSportID))
        .toList();

    if (turfPitchList.isEmpty) {
    } else {
      turfPitch.value = widget.turfListDetails.turfPitchDetail![0].sId!;
      Timer(const Duration(milliseconds: 500), () {
        _loadBookingAvailableSlotData(variable.formattedDate.value);
      });
    }
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
            variable.selectedSlotList.clear();
            Navigator.pop(context);
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
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 16.h,
            ),
            CustomToolbar(
                onTap: () {
                  Navigator.pop(context);
                  variable.selectedSlotList.clear();
                },
                title: widget.turfListDetails.name!),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Select Sport",
                    style: detailDesp_text_style,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              height: 35.h,
              width: double.maxFinite,
              child: Obx(
                () => ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => SelectSport(
                          index: index,
                          image: turfSportsList[index].images!,
                          title: turfSportsList[index].name!,
                          onTap: () {
                            variable.selectSport.value = index;
                            turfSportID = turfSportsList[index].sId!;

                            turfPitchList.clear();

                            turfPitchList.value = widget
                                .turfListDetails.turfPitchDetail!
                                .where((item) =>
                                    item.sportIds!.contains(turfSportID))
                                .toList();

                            if (turfPitchList.isEmpty) {
                              variable.availableSlotList.clear();
                            } else {
                              variable.selectedPitch.value = 0;
                              turfPitch.value = turfPitchList[0].sId!;
                              _loadBookingAvailableSlotData(
                                  variable.formattedDate.value);
                            }

                            // appVariable
                            //     .turfSportsSelectList
                            //     .add(sportsList[index]
                            //         .sId!
                            //         .toString());
                          },
                          variable: variable.selectSport.value,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 8.w,
                      );
                    },
                    itemCount: turfSportsList.length),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Select Pitch",
                    style: detailDesp_text_style,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              height: 30.h,
              child: Obx(
                () => turfPitchList.isEmpty
                    ? Text(
                        "Not found",
                        style: labelDate_text_style,
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return SelectPitch(
                            index: index,
                            name: turfPitchList[index].name!,
                            variable: variable.selectedPitch.value,
                            onTap: () {
                              variable.selectedPitch.value = index;
                              turfPitch.value = turfPitchList[index].sId!;
                              variable.selectedTurfPitch.value =
                                  turfPitchList[index].name!;
                              _loadBookingAvailableSlotData(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          variable.formattedDate.value)));
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 15.w,
                          );
                        },
                        itemCount: turfPitchList.length),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Select Booking Date",
                    style: detailDesp_text_style,
                  ),
                ],
              ),
            ),
            CalendarTimeline(
              initialDate: DateTime.parse(variable.formattedDate.value),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 15)),
              onDateSelected: (date) {
                variable.formattedDate.value =
                    DateFormat('yyyy-MM-dd').format(date);
                if (turfPitchList.isEmpty) {
                  variable.availableSlotList.clear();
                } else {
                  _loadBookingAvailableSlotData(
                      DateFormat('yyyy-MM-dd').format(date));
                }
              },
              shrink: true,
              leftMargin: 16.w,
              monthColor: Colors.blueGrey,
              dayColor: black_color,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: appColor,
              dotsColor: const Color(0xFF333A47),
              locale: 'en_ISO',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Time",
                    style: detailDesp_text_style,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
              child: Obx(
                () => ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => SelectPitch(
                          index: index,
                          name:
                              "₹ ${variable.availableSlotList[index][0].slotPrice}",
                          variable: variable.selectedSlotPrice.value,
                          onTap: () {
                            variable.selectedSlotPrice.value = index;
                            slotPrice.value =
                                variable.availableSlotList[index][0].slotPrice!;
                            availableSelectedSlotList.clear();
                            availableSelectedSlotList
                                .addAll(variable.availableSlotList[index]);
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 15.w,
                      );
                    },
                    itemCount: variable.availableSlotList.length),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            // variable.availableSlotList.isEmpty
            //     ? const
            //     :
            Expanded(
              child: variable.availableSlotList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ErrorScreen(),
                      ],
                    )
                  : Obx(
                      () => GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        //  physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, innerIndex) {
                          return Obx(
                            () => SelectTime(
                              selected: availableSelectedSlotList[innerIndex]
                                  .isSelected
                                  .value,
                              Time:
                                  "${availableSelectedSlotList[innerIndex].startTime} - ${availableSelectedSlotList[innerIndex].endTime}",
                              onTap: () {
                                availableSelectedSlotList[innerIndex]
                                        .isSelected
                                        .value =
                                    !availableSelectedSlotList[innerIndex]
                                        .isSelected
                                        .value;
                                // Define timeMap inside the block to ensure it's a new instance every time
                                var timeMap = {
                                  "startTime":
                                      "${availableSelectedSlotList[innerIndex].startTime}",
                                  "endTime":
                                      "${availableSelectedSlotList[innerIndex].endTime}",
                                  "slotPrice":
                                      "${availableSelectedSlotList[innerIndex].slotPrice}"
                                };

                                if (availableSelectedSlotList[innerIndex]
                                    .isSelected
                                    .value) {
                                  // Directly add the new map
                                  variable.selectedSlotList.add(timeMap);
                                } else {
                                  // More robust removal using a condition that matches the map to remove
                                  variable.selectedSlotList.removeWhere((map) =>
                                      map["startTime"] ==
                                          timeMap["startTime"] &&
                                      map["endTime"] == timeMap["endTime"]);
                                }
                              },
                            ),
                          );
                        },
                        itemCount: availableSelectedSlotList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 130.r,
                            mainAxisSpacing: 5.r,
                            crossAxisSpacing: 5.r,
                            childAspectRatio: 2.1.r / .7.r),
                      ),
                    ),
            ),
            Column(
              children: [
                Text(
                  "Grand Total",
                  style: total_style,
                ),
                //slotPrice.value * variable.selectedSlotList.length
                Obx(
                  () => Text(
                    "₹ ${variable.selectedSlotList.isEmpty ? 0.0 : calculateTotalPrice(variable.selectedSlotList)}",
                    style: totalPrice_style,
                  ),
                ),
              ],
            ),
            CustomeButton(
                title: "Proceed",
                onTap: () {
                  if (variable.selectedSlotList.isEmpty) {
                    Fluttertoast.showToast(msg: "Please select slot");
                  } else {
                    showUserDetailsView(context);
                  }
                }),
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }

  Scaffold tabletView(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 16.h,
            ),
            TabletCustomToolbar(
                onTap: () {
                  Navigator.pop(context);
                  variable.selectedSlotList.clear();
                },
                title: widget.turfListDetails.name!),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Select Sport",
                    style: TabletAppstyle.detailDesp_text_style,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              height: 40.h,
              width: double.maxFinite,
              child: Obx(
                () => ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => TabletSelectSport(
                          index: index,
                          image: turfSportsList[index].images!,
                          title: turfSportsList[index].name!,
                          onTap: () {
                            variable.selectSport.value = index;
                            turfSportID = turfSportsList[index].sId!;

                            turfPitchList.clear();

                            turfPitchList.value = widget
                                .turfListDetails.turfPitchDetail!
                                .where((item) =>
                                    item.sportIds!.contains(turfSportID))
                                .toList();

                            if (turfPitchList.isEmpty) {
                              variable.availableSlotList.clear();
                            } else {
                              variable.selectedPitch.value = 0;
                              turfPitch.value = turfPitchList[0].sId!;
                              _loadBookingAvailableSlotData(
                                  variable.formattedDate.value);
                            }

                            // appVariable
                            //     .turfSportsSelectList
                            //     .add(sportsList[index]
                            //         .sId!
                            //         .toString());
                          },
                          variable: variable.selectSport.value,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 8.w,
                      );
                    },
                    itemCount: turfSportsList.length),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Select Pitch",
                    style: TabletAppstyle.detailDesp_text_style,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              height: 36.h,
              child: Obx(
                () => turfPitchList.isEmpty
                    ? Text(
                        "Not found",
                        style: labelDate_text_style,
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return SelectPitch(
                            index: index,
                            name: turfPitchList[index].name!,
                            variable: variable.selectedPitch.value,
                            onTap: () {
                              variable.selectedPitch.value = index;
                              turfPitch.value = turfPitchList[index].sId!;
                              variable.selectedTurfPitch.value =
                                  turfPitchList[index].name!;
                              _loadBookingAvailableSlotData(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          variable.formattedDate.value)));
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 15.w,
                          );
                        },
                        itemCount: turfPitchList.length),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Select Booking Date",
                    style: TabletAppstyle.detailDesp_text_style,
                  ),
                ],
              ),
            ),
            CalendarTimeline(
              initialDate: DateTime.parse(variable.formattedDate.value),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 15)),
              onDateSelected: (date) {
                variable.formattedDate.value =
                    DateFormat('yyyy-MM-dd').format(date);
                if (turfPitchList.isEmpty) {
                  variable.availableSlotList.clear();
                } else {
                  _loadBookingAvailableSlotData(
                      DateFormat('yyyy-MM-dd').format(date));
                }
              },
              shrink: true,
              leftMargin: 16.w,
              monthColor: Colors.blueGrey,
              dayColor: black_color,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: appColor,
              dotsColor: const Color(0xFF333A47),
              locale: 'en_ISO',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Time",
                    style: TabletAppstyle.detailDesp_text_style,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 36.h,
              child: Obx(
                () => ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => SelectPitch(
                          index: index,
                          name:
                              "₹ ${variable.availableSlotList[index][0].slotPrice}",
                          variable: variable.selectedSlotPrice.value,
                          onTap: () {
                            variable.selectedSlotPrice.value = index;
                            slotPrice.value =
                                variable.availableSlotList[index][0].slotPrice!;
                            availableSelectedSlotList.clear();
                            availableSelectedSlotList
                                .addAll(variable.availableSlotList[index]);
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 15.w,
                      );
                    },
                    itemCount: variable.availableSlotList.length),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            // variable.availableSlotList.isEmpty
            //     ? const
            //     :
            Expanded(
              child: variable.availableSlotList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ErrorScreen(),
                      ],
                    )
                  : Obx(
                      () => GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        //  physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, innerIndex) {
                          return Obx(
                            () => TabletSelectTime(
                              selected: availableSelectedSlotList[innerIndex]
                                  .isSelected
                                  .value,
                              Time:
                                  "${availableSelectedSlotList[innerIndex].startTime} - ${availableSelectedSlotList[innerIndex].endTime}",
                              onTap: () {
                                availableSelectedSlotList[innerIndex]
                                        .isSelected
                                        .value =
                                    !availableSelectedSlotList[innerIndex]
                                        .isSelected
                                        .value;
                                // Define timeMap inside the block to ensure it's a new instance every time
                                var timeMap = {
                                  "startTime":
                                      "${availableSelectedSlotList[innerIndex].startTime}",
                                  "endTime":
                                      "${availableSelectedSlotList[innerIndex].endTime}",
                                  "slotPrice":
                                      "${availableSelectedSlotList[innerIndex].slotPrice}"
                                };

                                if (availableSelectedSlotList[innerIndex]
                                    .isSelected
                                    .value) {
                                  // Directly add the new map
                                  variable.selectedSlotList.add(timeMap);
                                } else {
                                  // More robust removal using a condition that matches the map to remove
                                  variable.selectedSlotList.removeWhere((map) =>
                                      map["startTime"] ==
                                          timeMap["startTime"] &&
                                      map["endTime"] == timeMap["endTime"]);
                                }
                              },
                            ),
                          );
                        },
                        itemCount: availableSelectedSlotList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 130.r,
                            mainAxisSpacing: 8.r,
                            crossAxisSpacing: 8.r,
                            childAspectRatio: 1.3.r / .5.r),
                      ),
                    ),
            ),
            Column(
              children: [
                Text(
                  "Grand Total",
                  style: total_style,
                ),
                //slotPrice.value * variable.selectedSlotList.length
                Obx(
                  () => Text(
                    "₹ ${variable.selectedSlotList.isEmpty ? 0.0 : calculateTotalPrice(variable.selectedSlotList)}",
                    style: totalPrice_style,
                  ),
                ),
              ],
            ),
            TabletCustomeButton(
                title: "Proceed",
                onTap: () {
                  if (variable.selectedSlotList.isEmpty) {
                    Fluttertoast.showToast(msg: "Please select slot");
                  } else {
                    tabletShowUserDetailsView(context);
                  }
                }),
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
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
            height: 245.h,
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
                            "Please enter advance payment and offer amount",
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
                      controller: variable.advancePaymentController.value,
                      focusNode: variable.advancePaymentFocusNode.value,
                      selected: variable.advancePaymentSelected.value,
                      lebel: "Advance Payment",
                      keyboardType: TextInputType.number,
                      onSubmitt: (value) {
                        FocusScope.of(context)
                            .requestFocus(variable.offerAmountFocusNode.value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          variable.advancePaymentSelected.value = false;
                          return "Please Enter price";
                        } else if (variable.advancePaymentController.value.text
                                    .length <
                                2 &&
                            value.length < 2) {
                          variable.advancePaymentSelected.value = false;
                          return "Please enter 2 digit";
                        } else {
                          variable.advancePaymentSelected.value = true;
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
                  Obx(
                    () => AppTextFiled(
                      controller: variable.offerAmountController.value,
                      focusNode: variable.offerAmountFocusNode.value,
                      selected: variable.offerAmountSelected.value,
                      lebel: "offer Amount",
                      keyboardType: TextInputType.number,
                      onSubmitt: (value) {
                        // FocusScope.of(context)
                        //     .requestFocus(variable.tuesdayFocusNode.value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          variable.offerAmountSelected.value = false;
                          return "Please Enter price";
                        } else if (variable
                                    .offerAmountController.value.text.length <
                                2 &&
                            value.length < 2) {
                          variable.offerAmountSelected.value = false;
                          return "Please enter 2 digit";
                        } else {
                          variable.offerAmountSelected.value = true;
                          return null;
                        }
                      },
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: variable.offerAmountSelected.value == true
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
                            if (variable
                                .advancePaymentController.value.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter advance payment",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (variable
                                .offerAmountController.value.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter offer amount",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Navigator.of(context).pop();
                              setUserSlotData();
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
            height: 245.h,
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
                            "Please enter advance payment and offer amount",
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
                      controller: variable.advancePaymentController.value,
                      focusNode: variable.advancePaymentFocusNode.value,
                      selected: variable.advancePaymentSelected.value,
                      lebel: "Advance Payment",
                      keyboardType: TextInputType.number,
                      onSubmitt: (value) {
                        FocusScope.of(context)
                            .requestFocus(variable.offerAmountFocusNode.value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          variable.advancePaymentSelected.value = false;
                          return "Please Enter price";
                        } else if (variable.advancePaymentController.value.text
                                    .length <
                                2 &&
                            value.length < 2) {
                          variable.advancePaymentSelected.value = false;
                          return "Please enter 2 digit";
                        } else {
                          variable.advancePaymentSelected.value = true;
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
                  Obx(
                    () => TabletAppTextFiled(
                      controller: variable.offerAmountController.value,
                      focusNode: variable.offerAmountFocusNode.value,
                      selected: variable.offerAmountSelected.value,
                      lebel: "offer Amount",
                      keyboardType: TextInputType.number,
                      onSubmitt: (value) {
                        // FocusScope.of(context)
                        //     .requestFocus(variable.tuesdayFocusNode.value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          variable.offerAmountSelected.value = false;
                          return "Please Enter price";
                        } else if (variable
                                    .offerAmountController.value.text.length <
                                2 &&
                            value.length < 2) {
                          variable.offerAmountSelected.value = false;
                          return "Please enter 2 digit";
                        } else {
                          variable.offerAmountSelected.value = true;
                          return null;
                        }
                      },
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: variable.offerAmountSelected.value == true
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
                            child:  Center(
                              child: Text(
                                "Cancel",
                              style: TabletAppstyle.deteleButton_text_style,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (variable
                                .advancePaymentController.value.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter advance payment",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (variable
                                .offerAmountController.value.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter offer amount",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Navigator.of(context).pop();
                              setUserSlotData();
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
                            child:  Center(
                              child: Text(
                                "Submit",
                                 style: TabletAppstyle.deteleButton_text_style,
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
 
 
  double calculateTotalPrice(List<Map<String, dynamic>> slots) {
    double total = 0;
    for (var slot in slots) {
      // Convert slotPrice to num using double.parse() or int.parse()
      total += double.parse(slot['slotPrice']);
    }
    return total;
  }

//7801809533
  setUserSlotData() async {
    var body = {
      "userId": "${widget.userId}",
      "turfId": "${widget.turfListDetails.sId}",
      "sportId": "$turfSportID",
      "turfPitchId": turfPitch.value,
      "date": variable.formattedDate.value,
      "selectedSlot": variable.selectedSlotList.toList(),
      "advanceAmount": "${variable.advancePaymentController.value.text}",
      "offerDiscount": "${variable.offerAmountController.value.text}"
    };

    await variable.bookSlotData(authToken, body);

    if (variable.baseResponseBooking.value.responseCode == 200) {
      Fluttertoast.showToast(msg: variable.baseResponseBooking.value.response);

      Navigator.push(context,
          MaterialPageRoute(builder: (on) => const TurfMyBookingScreen()));
    } else {
      Fluttertoast.showToast(msg: variable.baseResponseBooking.value.response);
    }
  }

  _loadBookingAvailableSlotData(String date) async {
    var body = {
      "turfId": "${widget.turfListDetails.sId}",
      "turfPitchId": turfPitch.value.toString(),
      "date": date
    };

    await variable.loadBookingAvailableSlotData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      List<dynamic> turfListJson =
          variable.baseResponse.value.data!["turfAvailableSlotList"];
      List<TurfAvailableSlotList> groupedEventsList = turfListJson
          .map((json) => TurfAvailableSlotList.fromJson(json))
          .toList();

      var slotsByPrices = <double, List<TurfAvailableSlotList>>{};

// Iterate over the list of slots
      for (var slot in groupedEventsList) {
        if (!slotsByPrices.containsKey(slot.slotPrice)) {
          slotsByPrices[slot.slotPrice!.toDouble()] = [];
        }
        slotsByPrices[slot.slotPrice]!.add(slot);
      }

      variable.availableSlotList.value = (slotsByPrices.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key))) // Sort by price
          .map((entry) {
        double price = entry.key; // Get price
        List<TurfAvailableSlotList> slotLists = entry.value; // Get slot list
        return slotLists.map((slot) {
          return TurfAvailableSlotList(
            startTime: slot.startTime,
            endTime: slot.endTime,
            slotPrice: price.toInt(), // Convert price to int
          );
        }).toList();
      }).toList();
      availableSelectedSlotList.clear();

      variable.selectedSlotPrice.value = 0;

      if (variable.availableSlotList.isEmpty) {
      } else {
        availableSelectedSlotList.addAll(variable.availableSlotList[0]);
        slotPrice.value = variable.availableSlotList[0][0].slotPrice!;
      }
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }

    // try {
    //   final response =
    //       await api.apiPostCall(context, "user/booking-slot-list", body: {
    //     "turfId": "${widget.turfListDetails.sId}",
    //     "turfPitchId": variable.turfPitch.value,
    //     "date": date
    //   }, headers: {
    //     "Authorization": "Bearer $authToken",
    //     'Content-type': 'application/json',
    //     "app-version": "1.0",
    //     "app-platform": Platform.isIOS ? "ios" : "android"
    //   });
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {

    //     List<dynamic> turfListJson =
    //         responseData.data!["turfAvailableSlotList"];
    //     variable.availableSlotList.value = turfListJson
    //         .map((json) => TurfAvailableSlotList.fromJson(json))
    //         .toList();
    //     loading.value = false;
    //     variable.selectedSlotList.clear();

    //   } else if (responseData.responseCode == 401) {

    //     loading.value = false;
    //     variable.selectedSlotList.clear();
    //   } else {
    //     loading.value = false;
    //     variable.selectedSlotList.clear();
    //   }
    // } catch (e) {
    //   loading.value = false;

    //   variable.selectedSlotList.clear();
    // }
  }

  _loadBookingSlotData(String pitchId) async {}

  List<TurfAvailableSlotList> slotsAfterCurrentTimePlus2Hours(
      List<TurfAvailableSlotList> slots) {
    DateTime twoHoursLater = dateTime.add(const Duration(hours: 1));

    // Filter the slots based on the start time
    List<TurfAvailableSlotList> filteredSlots = slots.where((slot) {
      // Convert the startTime string to DateTime object
      DateTime slotStartTime = _parseStartTime(slot.startTime!);

      // Compare the slot's start time with two hours later
      return slotStartTime.isAfter(twoHoursLater) ||
          slotStartTime.isAtSameMomentAs(twoHoursLater);
    }).toList();
    return filteredSlots;
  }

  DateTime _parseStartTime(String startTime) {
    // Splitting the startTime string to get hours and minutes
    List<String> parts = startTime.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1].split(' ')[0]);

    // Checking if it's PM and converting to 24-hour format if necessary
    if (startTime.contains('PM') && hours < 12) {
      hours += 12;
    } else if (startTime.contains('AM') && hours == 12) {
      hours = 0;
    }

    // Returning the DateTime object
    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hours, minutes);
  }
}
// try {
//   final response =
//       await api.apiPostCall(context, "user/booking-slot-list", body: {
//     "turfId": "${widget.turfListDetails.sId}",
//     "turfPitchId": pitchId,
//     "date": variable.formattedDate.value
//   }, headers: {
//     "Authorization": "Bearer $authToken",
//     'Content-type': 'application/json',
//     "app-version": "1.0",
//     "app-platform": Platform.isIOS ? "ios" : "android"
//   });
//   ApiResponse responseData = ApiResponse.fromJson(response);
//   if (responseData.responseCode == 200) {

//     List<dynamic> turfListJson =
//         responseData.data!["turfAvailableSlotList"];
//     var data = turfListJson
//         .map((json) => TurfAvailableSlotList.fromJson(json))
//         .toList();

//     variable.availableSlotList.value =
//         slotsAfterCurrentTimePlus2Hours(data);

//     variable.selectedSlotList.clear();
//     loading.value = false;
//   } else if (responseData.responseCode == 400) {

//     loading.value = false;
//   } else if (responseData.responseCode == 401) {
//     loading.value = false;
//   } else {
//     loading.value = false;
//     variable.selectedSlotList.clear();
//   }
// } catch (e) {

//   loading.value = false;
//   variable.selectedSlotList.clear();
// }

// try {
//   final response = await api.apiPostCall(context, "owner/book-now", body: {
//     "userId": "${widget.userId}",
//     "turfId": "${widget.turfListDetails.sId}",
//     "sportId": "661f7b717beb6bcd822b26b4",
//     "turfPitchId": variable.turfPitch.value,
//     "date": variable.formattedDate.value,
//     "selectedSlot": variable.selectedSlotList.toList()
//   }, headers: {
//     "Authorization": "Bearer $authToken",
//     'Content-type': 'application/json',
//     "app-version": "1.0",
//     "app-platform": Platform.isIOS ? "ios" : "android"
//   });
//   ApiResponse responseData = ApiResponse.fromJson(response);
//   if (responseData.responseCode == 200) {

//     Fluttertoast.showToast(msg: responseData.response);

//     var turfBookingDetailJson =
//         responseData.data!["turfBookingDetail"] as Map<String, dynamic>;
//     var turfBookingDetail =
//         TurfBookingDetail.fromJson(turfBookingDetailJson);
//     loading.value = false;
//     Navigator.push(context,
//         MaterialPageRoute(builder: (on) => const TurfMyBookingScreen()));

//     Get.delete<ownerBooking>();
//   } else if (responseData.responseCode == 400) {
//     loading.value = false;
//     variable.selectedSlotList.clear();

//     Fluttertoast.showToast(msg: responseData.response);
//     for (int i = 0; i < variable.availableSlotList.length; i++) {
//       // Update the item in some way
//       variable.availableSlotList[i].isSelected = false.obs;
//     }
//   } else {
//     loading.value = false;
//     variable.selectedSlotList.clear();

//   }
// } catch (e) {
//   loading.value = false;

//   variable.selectedSlotList.clear();
// }
