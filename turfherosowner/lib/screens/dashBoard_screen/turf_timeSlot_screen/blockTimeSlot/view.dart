// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'dart:async';

import 'package:calendar_timeline_sbk/calendar_timeline.dart';
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
import 'package:turf_heros_owner/customWidget/CustomSelectPitch.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

import 'blockTimeSlotWidget.dart';

class BlockTimeSlot extends StatefulWidget {
  TurfList turfListDetails;
  String slotType;
  BlockTimeSlot(
      {required this.turfListDetails, required this.slotType, super.key});

  @override
  State<BlockTimeSlot> createState() => _BlockTimeSlotState();
}

class _BlockTimeSlotState extends State<BlockTimeSlot> {
  var variable = Get.put(BlockTimeSlotDataViewModel());

  DateTime dateTime = DateTime.now();

  RxString turfPitch = "".obs;

  late SharedPreferences prefs;

  var authToken = "";

  int currentWeekDay = DateTime.now().weekday;

  RxList<String> reorderedWeekdays = <String>[].obs;

  final RxList<String> weekdays =
      DateFormat.E().dateSymbols.STANDALONESHORTWEEKDAYS.obs;

  List<TurfAvailableSlotList> selectTimeSlotPriceList = [];

  RxList<TurfAvailableSlotList> availableSlotList =
      <TurfAvailableSlotList>[].obs;
  _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void dispose() {
    Get.delete<BlockTimeSlotDataViewModel>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _loadPreferences();

    variable.formattedDate.value = DateFormat('yyyy-MM-dd').format(dateTime);

    turfPitch.value = widget.turfListDetails.turfPitchDetail![0].sId!;

    reorderedWeekdays.value = [
      ...weekdays.sublist(currentWeekDay), // Days from today onwards
      ...weekdays.sublist(0, currentWeekDay) // Days before today
    ];

    Timer(const Duration(seconds: 1), () {
      _manageTimeSlotData(variable.formattedDate.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayLoaderWithAppIcon(
          isLoading: variable.isLoading.value,
          circularProgressColor: appColor,
          appIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/loader_image.png",
              fit: BoxFit.fill,
            ),
          ),
          // ignore: deprecated_member_use
          child: WillPopScope(
            onWillPop: () {
              Get.back();
              //  Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //           builder: (co) => const TurfGorundsScreen()));
              return Future.value(false);
            },
            child: ScreenUtil().screenWidth < 600
                ? moblieView(context)
                : tabletView(context),
          )),
    );
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
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (co) => DashBoardSreen()));
              },
              title: "${widget.turfListDetails.name}"),
          SizedBox(
            height: 8.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.slotType == "DATE" ? "Select Date" : "Select  Day",
                  style: detailDesp_text_style,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          widget.slotType == "DATE"
              ? CalendarTimeline(
                  initialDate: DateTime.parse(variable.formattedDate.value),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 15)),
                  onDateSelected: (date) {
                    variable.formattedDate.value =
                        DateFormat('yyyy-MM-dd').format(date);
                    _manageTimeSlotData(variable.formattedDate.value);
                  },
                  shrink: true,
                  leftMargin: 16.r,
                  monthColor: Colors.blueGrey,
                  dayColor: black_color,
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: appColor,
                  dotsColor: const Color(0xFF333A47),
                  locale: 'en_ISO',
                )
              : SizedBox(
                  height: 50.h,
                  child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.r),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            variable.selectDay.value = index;
                            DateTime updatedDateTime = dateTime
                                .add(Duration(days: variable.selectDay.value));

                            variable.formattedDate.value =
                                DateFormat('yyyy-MM-dd')
                                    .format(updatedDateTime);
                            _manageTimeSlotData(variable.formattedDate.value);
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.r),
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
            height: 8.h,
          ),
          widget.slotType == "DATE"
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.r, vertical: 8.r),
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
                                variable.startDateTime.value =
                                    DateFormat('yyyy-MM-dd hh:mm a')
                                        .format(expiresAt);
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.r, vertical: 8.r),
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
                                variable.endDateTime.value =
                                    DateFormat('yyyy-MM-dd hh:mm a')
                                        .format(expiresAt);
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
          widget.slotType == "DATE"
              ? const SizedBox()
              : SizedBox(
                  height: 8.h,
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
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
            child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Obx(
                    () => SelectPitch(
                        name: widget
                            .turfListDetails.turfPitchDetail![index].name
                            .toString(),
                        onTap: () {
                          variable.selectPitch.value = index;
                          turfPitch.value = widget
                              .turfListDetails.turfPitchDetail![index].sId!;
                          // _manageTimeSlotData(
                          //     variable.formattedDate.value);
                        },
                        index: index,
                        variable: variable.selectPitch.value),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 15.w,
                  );
                },
                itemCount: widget.turfListDetails.turfPitchDetail!.length),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 4.r),
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
          Expanded(
            child: Obx(
              () => availableSlotList.isEmpty
                  ? const Center(child: ErrorScreen())
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return Obx(
                          () => BlockTimeSlotWidget(
                            selected: availableSlotList[index].isSelected.value,
                            time:
                                '${availableSlotList[index].startTime} - ${availableSlotList[index].endTime}',
                            onTap: () {
                              availableSlotList[index].isSelected.value =
                                  !availableSlotList[index].isSelected.value;
                              var timeMap = {
                                "startTime":
                                    "${availableSlotList[index].startTime}",
                                "endTime":
                                    "${availableSlotList[index].endTime}",
                                "slotPrice":
                                    "${availableSlotList[index].slotPrice}",
                                "id": "${availableSlotList[index].sId}"
                              };
                              if (availableSlotList[index].isSelected.value) {
                                selectTimeSlotPriceList.add(
                                    TurfAvailableSlotList(
                                        startTime:
                                            availableSlotList[index].startTime,
                                        sId: availableSlotList[index].sId,
                                        endTime:
                                            availableSlotList[index].endTime,
                                        slotPrice: availableSlotList[index]
                                            .slotPrice));
                              } else {
                                selectTimeSlotPriceList.removeWhere((map) =>
                                    map.startTime == timeMap["startTime"] &&
                                    map.endTime == timeMap["endTime"] &&
                                    map.slotPrice.toString() ==
                                        timeMap["slotPrice"] &&
                                    map.sId == timeMap["id"]);
                              }
                            },
                            price:
                                availableSlotList[index].slotPrice.toString(),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 8.h,
                        );
                      },
                      itemCount: availableSlotList.length),
            ),
          ),
          CustomeButton(
              title:
                  widget.slotType == "DATE" ? "Block Selected Slots" : "Submit",
              onTap: () {
                // DateTime startDate = DateTime(2023, 9, 1);
                // DateTime endDate = DateTime(2023, 9, 18);

                // // Specify the day you want (e.g., Monday)
                // String targetDay = 'Monday';

                // Call the function to get specific day names
                // List<DateTime> specificDays =
                //     getSpecificDaysBetween(
                //         startDate, endDate, targetDay);

                // if (selectTimeSlotList.isEmpty) {
                //   Fluttertoast.showToast(
                //       msg: "Please select slot");
                // } else {
                //   // widget.slotType == "DATE"
                //   //     ? deleteSlot(context)
                //   //     : null;
                // }
              }),
          SizedBox(
            height: 16.h,
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
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (co) => DashBoardSreen()));
              },
              title: "${widget.turfListDetails.name}"),
          SizedBox(
            height: 8.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.slotType == "DATE" ? "Select Date" : "Select  Day",
                  style: TabletAppstyle.detailDesp_text_style,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          widget.slotType == "DATE"
              ? CalendarTimeline(
                  initialDate: DateTime.parse(variable.formattedDate.value),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 15)),
                  onDateSelected: (date) {
                    variable.formattedDate.value =
                        DateFormat('yyyy-MM-dd').format(date);
                    _manageTimeSlotData(variable.formattedDate.value);
                  },
                  shrink: true,
                  leftMargin: 16.r,
                  monthColor: Colors.blueGrey,
                  dayColor: black_color,
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: appColor,
                  dotsColor: const Color(0xFF333A47),
                  locale: 'en_ISO',
                )
              : SizedBox(
                  height: 36.h,
                  child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.r),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            variable.selectDay.value = index;
                            DateTime updatedDateTime = dateTime
                                .add(Duration(days: variable.selectDay.value));

                            variable.formattedDate.value =
                                DateFormat('yyyy-MM-dd')
                                    .format(updatedDateTime);
                            _manageTimeSlotData(variable.formattedDate.value);
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.r),
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
          widget.slotType == "DATE"
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.r, vertical: 8.r),
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
                                variable.startDateTime.value =
                                    DateFormat('yyyy-MM-dd hh:mm a')
                                        .format(expiresAt);
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.r, vertical: 8.r),
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
                                  "End Date",
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
                                variable.endDateTime.value =
                                    DateFormat('yyyy-MM-dd hh:mm a')
                                        .format(expiresAt);
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
          widget.slotType == "DATE"
              ? const SizedBox()
              : SizedBox(
                  height: 8.h,
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
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
            child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Obx(
                    () => SelectPitch(
                        name: widget
                            .turfListDetails.turfPitchDetail![index].name
                            .toString(),
                        onTap: () {
                          variable.selectPitch.value = index;
                          turfPitch.value = widget
                              .turfListDetails.turfPitchDetail![index].sId!;
                          _manageTimeSlotData(
                              variable.formattedDate.value);
                        },
                        index: index,
                        variable: variable.selectPitch.value),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 15.w,
                  );
                },
                itemCount: widget.turfListDetails.turfPitchDetail!.length),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 4.r),
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
          Expanded(
            child: Obx(
              () => availableSlotList.isEmpty
                  ? const Center(child: ErrorScreen())
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return Obx(
                          () => TabletBlockTimeSlotWidget(
                            selected: availableSlotList[index].isSelected.value,
                            time:
                                '${availableSlotList[index].startTime} - ${availableSlotList[index].endTime}',
                            onTap: () {
                              availableSlotList[index].isSelected.value =
                                  !availableSlotList[index].isSelected.value;
                              var timeMap = {
                                "startTime":
                                    "${availableSlotList[index].startTime}",
                                "endTime":
                                    "${availableSlotList[index].endTime}",
                                "slotPrice":
                                    "${availableSlotList[index].slotPrice}",
                                "id": "${availableSlotList[index].sId}"
                              };
                              if (availableSlotList[index].isSelected.value) {
                                selectTimeSlotPriceList.add(
                                    TurfAvailableSlotList(
                                        startTime:
                                            availableSlotList[index].startTime,
                                        sId: availableSlotList[index].sId,
                                        endTime:
                                            availableSlotList[index].endTime,
                                        slotPrice: availableSlotList[index]
                                            .slotPrice));
                              } else {
                                selectTimeSlotPriceList.removeWhere((map) =>
                                    map.startTime == timeMap["startTime"] &&
                                    map.endTime == timeMap["endTime"] &&
                                    map.slotPrice.toString() ==
                                        timeMap["slotPrice"] &&
                                    map.sId == timeMap["id"]);
                              }
                            },
                            price:
                                availableSlotList[index].slotPrice.toString(),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 8.h,
                        );
                      },
                      itemCount: availableSlotList.length),
            ),
          ),
          TabletCustomeButton(
              title:
                  widget.slotType == "DATE" ? "Block Selected Slots" : "Submit",
              onTap: () {
                DateFormat format = DateFormat('yyyy-MM-dd hh:mm a');
                DateTime startDate = format.parse(variable.startDateTime.value);
                DateTime endDate = format.parse(variable.endDateTime.value);
                DateFormat dayFormat = DateFormat('yyyy-MM-dd');
                DateTime dayNameDate =
                    dayFormat.parse(variable.formattedDate.value);
                String dayName = DateFormat('EEEE')
                    .format(dayNameDate); // Full name of the day (e.g., Monday)

                List<DateTime> specificDays =
                    getSpecificDaysBetween(startDate, endDate, dayName);

                List<String> formattedDates = specificDays.map((date) {
                  return DateFormat('yyyy-MM-dd').format(date);
                }).toList();
                print("PRINT DATE $formattedDates");

                if (selectTimeSlotPriceList.isEmpty) {
                  Fluttertoast.showToast(msg: "Please select slot");
                } else {
                  List date = [variable.formattedDate.value];
                  widget.slotType == "DATE"
                      ? blockTimeSlot(date)
                      : dayBlockTimeSlot(formattedDates);
                }
              }),
          SizedBox(
            height: 16.h,
          )
        ],
      )),
    );
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

  List<DateTime> getSpecificDaysBetween(
      DateTime start, DateTime end, String targetDay) {
    List<DateTime> daysList = [];
    Map<String, int> dayMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    int targetDayNumber =
        dayMap[targetDay] ?? 1; // Default to Monday if invalid input

    // Iterate through the dates
    for (DateTime date = start;
        date.isBefore(end) || date.isAtSameMomentAs(end);
        date = date.add(const Duration(days: 1))) {
      if (date.weekday == targetDayNumber) {
        daysList.add(date);
      }
    }
    return daysList;
  }

  _manageTimeSlotData(String date) async {
    var body = {
      "turfId": "${widget.turfListDetails.sId}",
      "turfPitchId": turfPitch.value.toString(),
      "date": date
    };

    await variable.managetimeSlotDaate(authToken, body);
    availableSlotList.clear();

    if (variable.baseResponse.value.responseCode == 200) {
      // Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      List<dynamic> turfListJson =
          variable.baseResponse.value.data!["turfAvailableSlotList"];
      availableSlotList.value = turfListJson
          .map((json) => TurfAvailableSlotList.fromJson(json))
          .toList();
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
  }

  blockTimeSlot(List dateArray) async {
    List<Map<String, String>> slotsMapList =
        selectTimeSlotPriceList.map((slot) {
      return {
        "startTime": "${slot.startTime}",
        "endTime": "${slot.endTime}",
      };
    }).toList();

    var body = {
      "turfId": "${widget.turfListDetails.sId}",
      "turfPitchId": turfPitch.value.toString(),
      "dateArray": dateArray,
      "selectedSlot": slotsMapList
    };

    print("PRINT BODY $body");

    await variable.blockTimeSlotData(authToken, body);

    selectTimeSlotPriceList.clear();

    if (variable.baseResponseBlockTime.value.responseCode == 200) {
      Fluttertoast.showToast(
          msg: variable.baseResponseBlockTime.value.response);
      _manageTimeSlotData(variable.formattedDate.value);
      // List<dynamic> turfListJson =
      //     variable.baseResponseBlockTime.value.data!["turfAvailableSlotList"];
      // availableSlotList.value = turfListJson
      //     .map((json) => TurfAvailableSlotList.fromJson(json))
      //     .toList();
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseBlockTime.value.response);
    }
  }

  dayBlockTimeSlot(List dateArray) async {
    List<Map<String, String>> slotsMapList =
        selectTimeSlotPriceList.map((slot) {
      return {
        "startTime": "${slot.startTime}",
        "endTime": "${slot.endTime}",
      };
    }).toList();

    var body = {
      "turfId": "${widget.turfListDetails.sId}",
      "turfPitchId": turfPitch.value.toString(),
      "dateArray": dateArray,
      "selectedSlot": slotsMapList
    };

    print("PRINT BODY $body");

    await variable.blockTimeSlotData(authToken, body);

    selectTimeSlotPriceList.clear();

    if (variable.baseResponseBlockTime.value.responseCode == 200) {
      Fluttertoast.showToast(
          msg: variable.baseResponseBlockTime.value.response);
      _manageTimeSlotData(variable.formattedDate.value);
      // List<dynamic> turfListJson =
      //     variable.baseResponseBlockTime.value.data!["turfAvailableSlotList"];
      // availableSlotList.value = turfListJson
      //     .map((json) => TurfAvailableSlotList.fromJson(json))
      //     .toList();
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseBlockTime.value.response);
    }
  }
}

