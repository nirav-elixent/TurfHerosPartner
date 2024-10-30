// ignore_for_file: must_be_immutable, deprecated_member_use, use_build_context_synchronously, unused_element, depend_on_referenced_packages,  unnecessary_string_interpolations

import 'dart:async';
import 'dart:convert';
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
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/CustomSelectPitch.dart';
import 'package:turf_heros_owner/customWidget/SelectTime.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/customWidget/selectSport.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_myBooking_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class OwnerTurfBulkBookingScreen extends StatefulWidget {
  TurfList turfListDetails;
  String userId;
  OwnerTurfBulkBookingScreen(
      {required this.turfListDetails, required this.userId, super.key});

  @override
  State<OwnerTurfBulkBookingScreen> createState() =>
      _OwnerTurfBulkBookingScreenState();
}

class _OwnerTurfBulkBookingScreenState
    extends State<OwnerTurfBulkBookingScreen> {
  var variable = Get.put(LoadBulkBookingAvailableSlotDataViewModel());

  late SharedPreferences prefs;

  DateTime dateTime = DateTime.now();

  int currentDayIndex = DateTime.now().weekday % 7;

  RxList<SportList> sportsList = <SportList>[].obs;

  RxList<SportList> turfSportsList = <SportList>[].obs;

  RxList<TurfPitchDetail> turfPitchList = <TurfPitchDetail>[].obs;

  int currentWeekDay =
      DateTime.now().weekday; // This returns 1 for Monday, 7 for Sunday

  // List of weekdays (Starting from Sunday in intl package)
  final RxList<String> weekdays =
      DateFormat.E().dateSymbols.STANDALONESHORTWEEKDAYS.obs;

  var authToken = "";

  String turfSportID = "";

  RxString turfPitch = "".obs;

  RxInt slotPrice = 0.obs;

  RxList<String> reorderedWeekdays = <String>[].obs;

  RxList<String> daysList = <String>[].obs;

  RxList<TurfAvailableSlotList> availableSelectedSlotList =
      <TurfAvailableSlotList>[].obs;

  _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
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
  void dispose() {
    Get.delete<LoadBulkBookingAvailableSlotDataViewModel>();
    reorderedWeekdays.clear();

    daysList.clear();

    availableSelectedSlotList.clear();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    turfSportID = widget.turfListDetails.sportIds![0];

    reorderedWeekdays.value = [
      ...weekdays.sublist(currentWeekDay), // Days from today onwards
      ...weekdays.sublist(0, currentWeekDay) // Days before today
    ];

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
    return OverlayLoaderWithAppIcon(
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
              : tabletView(context)),
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
                            // _loadBookingAvailableSlotData(
                            //     variable.formattedDate.value);
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
                                DateFormat('yyyy-MM-dd').format(DateTime.parse(
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
                  "Select Booking Day",
                  style: detailDesp_text_style,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          SizedBox(
            height: 50.h,
            child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      DateTime tomorrow = dateTime.add(Duration(days: index));
                      variable.selectDay.value = index;
                      variable.formattedDate.value =
                          DateFormat('yyyy-MM-dd').format(tomorrow);
                      _loadBookingAvailableSlotData(
                          DateFormat('yyyy-MM-dd').format(tomorrow));
                    },
                    child: Obx(
                      () => Container(
                        height: 40.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: variable.selectDay.value == index
                              ? appColor
                              : Colors.transparent,
                          border: Border.all(
                            color: appColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              reorderedWeekdays[index],
                              style: TextStyle(
                                  color: variable.selectDay.value == index
                                      ? whiteColor
                                      : Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 8.w,
                  );
                },
                itemCount: reorderedWeekdays.length),
          ),
          SizedBox(
            height: 4.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: textFiledColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start Date",
                            style: label_text_style,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(
                            () => Text(
                              variable.startDate.value,
                              style: labelDate_text_style,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          var expiresAt = await _selectDate(context);
                          variable.startDate.value =
                              DateFormat('yyyy-MM-dd').format(expiresAt!);
                          // variable.startDateTime.value =
                          //     DateFormat('yyyy-MM-dd hh:mm a')
                          //         .format(expiresAt);
                        },
                        child: SvgPicture.asset(
                            "assets/images/calender_image.svg"),
                      )
                    ],
                  ),
                )),
                SizedBox(
                  width: 8.h,
                ),
                Expanded(
                    child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: textFiledColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expired Date",
                            style: label_text_style,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(
                            () => Text(
                              variable.endDate.value,
                              style: labelDate_text_style,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          var expiresAt = await _selectDate(context);
                          variable.endDate.value =
                              DateFormat('yyyy-MM-dd').format(expiresAt!);
                          var detail = getDayName(
                              DateTime.parse(variable.formattedDate.value));
                          //  setUserSlotData();
                          List<DateTime> list = getSpecificDaysList(
                              DateTime.parse(variable.startDate.value),
                              DateTime.parse(variable.endDate.value),
                              detail);

                          // Print the list of days
                          for (DateTime day in list) {
                            daysList.add(DateFormat('yyyy-MM-dd').format(day));
                          }
                          // variable.endDateTime.value =
                          //     DateFormat('yyyy-MM-dd hh:mm a')
                          //         .format(expiresAt);
                        },
                        child: SvgPicture.asset(
                            "assets/images/calender_image.svg"),
                      )
                    ],
                  ),
                )),
              ],
            ),
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
          Obx(
            () => Expanded(
              child: variable.availableSlotList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ErrorScreen(),
                      ],
                    )
                  : GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
                                    map["startTime"] == timeMap["startTime"] &&
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
                          childAspectRatio: 2.1 / .7),
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
                } else if (variable.startDate.value.isEmpty ||
                    variable.endDate.value.isEmpty) {
                  Fluttertoast.showToast(msg: "Please select date");
                } else {
                  showUserDetailsView(context);
                }
              }),
          SizedBox(
            height: 16.h,
          ),
        ],
      )),
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
                            // _loadBookingAvailableSlotData(
                            //     variable.formattedDate.value);
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
                                DateFormat('yyyy-MM-dd').format(DateTime.parse(
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
                  "Select Booking Day",
                  style: TabletAppstyle.detailDesp_text_style,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          SizedBox(
            height: 35.h,
            child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      DateTime tomorrow = dateTime.add(Duration(days: index));
                      variable.selectDay.value = index;
                      variable.formattedDate.value =
                          DateFormat('yyyy-MM-dd').format(tomorrow);
                      _loadBookingAvailableSlotData(
                          DateFormat('yyyy-MM-dd').format(tomorrow));
                    },
                    child: Obx(
                      () => Container(
                        height: 40.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: variable.selectDay.value == index
                              ? appColor
                              : Colors.transparent,
                          border: Border.all(
                            color: appColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              reorderedWeekdays[index],
                              style: TextStyle(
                                  color: variable.selectDay.value == index
                                      ? whiteColor
                                      : Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 8.w,
                  );
                },
                itemCount: reorderedWeekdays.length),
          ),
          SizedBox(
            height: 8.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: textFiledColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start Date",
                            style: label_text_style,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(
                            () => Text(
                              variable.startDate.value,
                              style: labelDate_text_style,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          var expiresAt = await _selectDate(context);
                          variable.startDate.value =
                              DateFormat('yyyy-MM-dd').format(expiresAt!);
                          // variable.startDateTime.value =
                          //     DateFormat('yyyy-MM-dd hh:mm a')
                          //         .format(expiresAt);
                        },
                        child: SvgPicture.asset(
                          "assets/images/calender_image.svg",
                          height: 16.h,
                          width: 16.w,
                        ),
                      )
                    ],
                  ),
                )),
                SizedBox(
                  width: 8.h,
                ),
                Expanded(
                    child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: textFiledColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expired Date",
                            style: label_text_style,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(
                            () => Text(
                              variable.endDate.value,
                              style: labelDate_text_style,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          var expiresAt = await _selectDate(context);
                          variable.endDate.value =
                              DateFormat('yyyy-MM-dd').format(expiresAt!);
                          var detail = getDayName(
                              DateTime.parse(variable.formattedDate.value));
                          //  setUserSlotData();
                          List<DateTime> list = getSpecificDaysList(
                              DateTime.parse(variable.startDate.value),
                              DateTime.parse(variable.endDate.value),
                              detail);

                          // Print the list of days
                          for (DateTime day in list) {
                            daysList.add(DateFormat('yyyy-MM-dd').format(day));
                          }
                          // variable.endDateTime.value =
                          //     DateFormat('yyyy-MM-dd hh:mm a')
                          //         .format(expiresAt);
                        },
                        child: SvgPicture.asset(
                          "assets/images/calender_image.svg",
                          height: 16.h,
                          width: 16.w,
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
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
          Obx(
            () => Expanded(
              child: variable.availableSlotList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ErrorScreen(),
                      ],
                    )
                  : GridView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
                                    map["startTime"] == timeMap["startTime"] &&
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
                } else if (variable.startDate.value.isEmpty ||
                    variable.endDate.value.isEmpty) {
                  Fluttertoast.showToast(msg: "Please select date");
                } else {
                  tabletShowUserDetailsView(context);
                }
              }),
          SizedBox(
            height: 16.h,
          ),
        ],
      )),
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
                            child: Center(
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
                            child: Center(
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

  String getDayName(DateTime date) {
    // Use DateFormat to get the full day name
    return DateFormat('EEEE').format(date);
  }

  List<DateTime> getSpecificDaysList(
      DateTime startDate, DateTime endDate, String targetDay) {
    List<DateTime> specificDays = [];

    // Map string day names to integer values (1-7)
    Map<String, int> dayMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    // Check if the target day is valid
    if (!dayMap.containsKey(targetDay)) {
      return specificDays; // Return empty list if invalid day
    }

    // Get the integer representation of the target day
    int targetDayInt = dayMap[targetDay]!;

    if (endDate.isBefore(startDate)) {
      return specificDays; // Return empty list if invalid range
    }

    for (DateTime date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      if (date.weekday == targetDayInt) {
        specificDays.add(date);
      }
    }
    return specificDays;
  }

  setUserSlotData() async {
    var body = {
      "userId": "${widget.userId}",
      "turfId": "${widget.turfListDetails.sId}",
      "sportId": "$turfSportID",
      "turfPitchId": turfPitch.value,
      "dateArray": daysList,
      "selectedSlot": variable.selectedSlotList.toList(),
      "advanceAmount": "${variable.advancePaymentController.value.text}",
      "offerDiscount": "${variable.offerAmountController.value.text}"
    };
    await variable.bulkBookSlotData(authToken, body);

    if (variable.baseResponseBooking.value.responseCode == 200) {
      Fluttertoast.showToast(msg: variable.baseResponseBooking.value.response);

      Navigator.push(context,
          MaterialPageRoute(builder: (on) => const TurfMyBookingScreen()));
    } else {
      Fluttertoast.showToast(msg: variable.baseResponseBooking.value.response);
    }
  }

  _loadBookingAvailableSlotData(String date) async {
    var body = {"turfId": "${widget.turfListDetails.sId}", "date": date};

    await variable.allBookingSlotData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      List<dynamic> turfListJson =
          variable.baseResponse.value.data!["slotList"];
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
  }

  void _onWeekdayTap(int index) {
    int diffFromToday =
        index - currentDayIndex; // Calculate difference from the current day
    setState(() {
      dateTime = DateTime.now()
          .add(Duration(days: diffFromToday)); // Update selected date
    });
  }

  double calculateTotalPrice(List<Map<String, dynamic>> slots) {
    double total = 0;
    for (var slot in slots) {
      // Convert slotPrice to num using double.parse() or int.parse()
      total += double.parse(slot['slotPrice']);
    }
    return total;
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: variable.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != variable.selectedDate) {
      variable.selectedDate = picked;
    }
    return picked;
  }
}

// class WeekDayNames extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Get the current day index (0 for Sunday, 1 for Monday, ..., 6 for Saturday)
//     int currentWeekDay =
//         DateTime.now().weekday; // This returns 1 for Monday, 7 for Sunday

//     // List of weekdays (Starting from Sunday in intl package)
//     final List<String> weekdays =
//         DateFormat.E().dateSymbols.STANDALONESHORTWEEKDAYS;

//     // Adjust the list to start from the current day
//     final List<String> reorderedWeekdays = [
//       ...weekdays.sublist(currentWeekDay), // Days from today onwards
//       ...weekdays.sublist(0, currentWeekDay) // Days before today
//     ];

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: reorderedWeekdays.map((day) {
//         return Container(
//           height: 50.h,
//           width: 50.w,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: appColor,
//               width: 1,
//             ),
//             borderRadius: BorderRadius.circular(25.r),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 8.r),
//           margin: EdgeInsets.symmetric(horizontal: 8.r),
//           child: Center(
//             child: Text(
//               day, // Display each day starting from current day
//               style: TextStyle(
//                 color: Colors.blueGrey,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
