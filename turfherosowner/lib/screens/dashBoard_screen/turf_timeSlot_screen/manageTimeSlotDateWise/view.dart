// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages, unnecessary_brace_in_string_interps

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
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/CustomSelectPitch.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_timeSlot_screen/manageTimeSlotDateWise/manageTimeSlotWidget.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class ManageTimeSlotDateWiseScreen extends StatefulWidget {
  TurfList turfListDetails;
  String slotType;
  ManageTimeSlotDateWiseScreen(
      {required this.turfListDetails, required this.slotType, super.key});

  @override
  State<ManageTimeSlotDateWiseScreen> createState() =>
      _ManageTimeSlotDateWiseScreenState();
}

class _ManageTimeSlotDateWiseScreenState
    extends State<ManageTimeSlotDateWiseScreen> {
  var variable = Get.put(ManageTimeSlotDateDataViewModel());

  DateTime dateTime = DateTime.now();

  RxString turfPitch = "".obs;

  late SharedPreferences prefs;

  var authToken = "";

  TurfAvailableSlotList? maxPriceSlot;

  int currentWeekDay = DateTime.now().weekday;

  RxList<String> reorderedWeekdays = <String>[].obs;

  final RxList<String> weekdays =
      DateFormat.E().dateSymbols.STANDALONESHORTWEEKDAYS.obs;

  List<String> selectTimeSlotList = [];

  List<TurfAvailableSlotList> selectTimeSlotPriceList = [];

  RxList<TurfAvailableSlotList> availableSlotList =
      <TurfAvailableSlotList>[].obs;

  @override
  void dispose() {
    Get.delete<ManageTimeSlotDateDataViewModel>();
    selectTimeSlotList.clear();
    selectTimeSlotPriceList.clear();
    availableSlotList.clear();
    reorderedWeekdays.clear();
    super.dispose();
  }

  _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
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

    Timer(const Duration(milliseconds: 500), () {
      _manageTimeSlotData(variable.formattedDate.value);
    });
  }

  void _initializeControllers(int position) {
    variable.textControllers.value = List.generate(
      position,
      (index) => TextEditingController(),
    );
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
          child: WillPopScope(
            onWillPop: () {
              Get.back();
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
                          _manageTimeSlotData(variable.formattedDate.value);
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
                        variable.textControllers[index].text =
                            availableSlotList[index].slotPrice.toString();
                        return Obx(
                          () => ManageTimeSlotWidget(
                            onFieldSubmitted: (value) {
                              if (variable.textControllers[index].text == "") {
                                Fluttertoast.showToast(
                                    msg: "Please enter slot price");
                                FocusScope.of(context).unfocus();
                              } else {
                                widget.slotType == "DATE"
                                    ? _updatePrice(
                                        availableSlotList[index].sId!,
                                        variable.textControllers[index].text)
                                    : _updateDayPrice(
                                        availableSlotList[index].sId!,
                                        variable.textControllers[index].text);
                              }
                            },
                            selected: availableSlotList[index].isSelected.value,
                            time:
                                '${availableSlotList[index].startTime} - ${availableSlotList[index].endTime}',
                            onTap: () {
                              availableSlotList[index].isSelected.value =
                                  !availableSlotList[index].isSelected.value;

                              var id = availableSlotList[index].sId!;
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
                                // Directly add the new map
                                selectTimeSlotList
                                    .add(availableSlotList[index].sId!);

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
                                selectTimeSlotList
                                    .removeWhere((map) => map == id);
                                selectTimeSlotPriceList.removeWhere((map) =>
                                    map.startTime == timeMap["startTime"] &&
                                    map.endTime == timeMap["endTime"] &&
                                    map.slotPrice.toString() ==
                                        timeMap["slotPrice"] &&
                                    map.sId == timeMap["id"]);
                              }
                            },
                            controller: variable.textControllers[index],
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
              title: widget.slotType == "DATE"
                  ? "Delete Selected Slots"
                  : "Change Selected Slots Price",
              onTap: () {
                if (selectTimeSlotList.isEmpty) {
                  Fluttertoast.showToast(msg: "Please select slot");
                } else {
                  if (widget.slotType == "DATE") {
                    deleteSlot(context);
                  } else {
                    maxPriceSlot = selectTimeSlotPriceList
                        .reduce((a, b) => a.slotPrice! > b.slotPrice! ? a : b);
                    variable.priceController.value.text =
                        maxPriceSlot!.slotPrice.toString();
                    bottomPriceSheet();
                  }
                }
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
                  height: 35.h,
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
            height: 35.h,
            child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          _manageTimeSlotData(variable.formattedDate.value);
                        },
                        index: index,
                        variable: variable.selectPitch.value),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 16.w,
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
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemBuilder: (context, index) {
                        variable.textControllers[index].text =
                            availableSlotList[index].slotPrice.toString();
                        return Obx(
                          () => ManageTimeSlotWidget(
                            onFieldSubmitted: (value) {
                              if (variable.textControllers[index].text == "") {
                                Fluttertoast.showToast(
                                    msg: "Please enter slot price");
                                FocusScope.of(context).unfocus();
                              } else {
                                widget.slotType == "DATE"
                                    ? _updatePrice(
                                        availableSlotList[index].sId!,
                                        variable.textControllers[index].text)
                                    : _updateDayPrice(
                                        availableSlotList[index].sId!,
                                        variable.textControllers[index].text);
                              }
                            },
                            selected: availableSlotList[index].isSelected.value,
                            time:
                                '${availableSlotList[index].startTime} - ${availableSlotList[index].endTime}',
                            onTap: () {
                              availableSlotList[index].isSelected.value =
                                  !availableSlotList[index].isSelected.value;

                              var id = availableSlotList[index].sId!;
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
                                // Directly add the new map
                                selectTimeSlotList
                                    .add(availableSlotList[index].sId!);

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
                                selectTimeSlotList
                                    .removeWhere((map) => map == id);
                                selectTimeSlotPriceList.removeWhere((map) =>
                                    map.startTime == timeMap["startTime"] &&
                                    map.endTime == timeMap["endTime"] &&
                                    map.slotPrice.toString() ==
                                        timeMap["slotPrice"] &&
                                    map.sId == timeMap["id"]);
                              }
                            },
                            controller: variable.textControllers[index],
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
              title: widget.slotType == "DATE"
                  ? "Delete Selected Slots"
                  : "Change Selected Slots Price",
              onTap: () {
                if (selectTimeSlotList.isEmpty) {
                  Fluttertoast.showToast(msg: "Please select slot");
                } else {
                  if (widget.slotType == "DATE") {
                    deleteSlot(context);
                  } else {
                    maxPriceSlot = selectTimeSlotPriceList
                        .reduce((a, b) => a.slotPrice! > b.slotPrice! ? a : b);
                    variable.priceController.value.text =
                        maxPriceSlot!.slotPrice.toString();
                    tabletBottomPriceSheet();
                  }
                }
              }),
          SizedBox(
            height: 16.h,
          )
        ],
      )),
    );
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

      _initializeControllers(availableSlotList.length);
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
  }

  _updatePrice(String id, String price) async {
    var body = {"id": id, "slotPrice": price, "type": "single"};

    await variable.updatePrice(authToken, body);

    if (variable.baseResponseUpdatePrice.value.responseCode == 200) {
      Fluttertoast.showToast(msg: "update successful");
      _manageTimeSlotData(variable.formattedDate.value);
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseUpdatePrice.value.response);
    }
  }

  _updateDayPrice(String id, String price) async {
    var body = {"id": id, "slotPrice": price, "type": "day"};

    await variable.updatePrice(authToken, body);

    if (variable.baseResponseUpdatePrice.value.responseCode == 200) {
      Fluttertoast.showToast(msg: "update successful");
      _manageTimeSlotData(variable.formattedDate.value);
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseUpdatePrice.value.response);
    }
  }

  _deleteTimeSlot(List<String> id) async {
    var body = {"ids": id};

    await variable.deleteTimeSlot(authToken, body);

    if (variable.baseResponseDeleteTimeSlot.value.responseCode == 200) {
      Fluttertoast.showToast(
          msg: variable.baseResponseDeleteTimeSlot.value.response);
      _manageTimeSlotData(variable.formattedDate.value);
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseDeleteTimeSlot.value.response);
    }
  }

  void deleteSlot(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.r),
          insetPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: whiteColor,
            ),
            height: 135.h,
            width: 300.w,
            child: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  "Are you sure want to delete",
                  style: dLocationBold_text_style,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "This action will be irreversible if you proceed",
                          textAlign: TextAlign.center,
                          style: slotDelete_text_style,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Divider(
                  color: greyColor,
                  height: 1.w,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.close),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                "Cancel",
                                textAlign: TextAlign.center,
                                style: deteleButton_text_style,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 1.w,
                        color: greyColor,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _deleteTimeSlot(selectTimeSlotList);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/delete_image.svg"),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                "Delete",
                                textAlign: TextAlign.center,
                                style: deteleAccountButton_text_style,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bottomPriceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 180.h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "Change Selected Slots Price",
                    textAlign: TextAlign.center,
                    style: dLocationBold_text_style,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Divider(
                    height: 1.h,
                    color: greyBoldColor,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextFiled(
                    controller: variable.priceController.value,
                    focusNode: variable.priceFocusNode.value,
                    selected: variable.priceSelected.value,
                    lebel: "Price",
                    enable: true,
                    onSubmitt: (value) {},
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "this is required";
                      } else if (variable.priceController.value.text.length <
                              4 &&
                          value.length < 4) {
                        return 'Please enter a valid street';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Divider(
                    height: 1.h,
                    color: greyBoldColor,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  CustomeButton(
                      title: "Submit",
                      onTap: () {
                        if (selectTimeSlotList.isEmpty) {
                          Fluttertoast.showToast(msg: "Please select slot");
                        } else {
                          //  maxPriceSlot =
                          //       selectTimeSlotPriceList.reduce((a, b) =>
                          //           a.slotPrice! > b.slotPrice! ? a : b);
                          // bottomPriceSheet(
                          //     "" /*maxPriceSlot!.slotPrice.toString()*/);
                          // for (var slot in selectTimeSlotList) {
                          //   _updateDayPrice(slot,
                          //       maxPriceSlot!.slotPrice.toString());
                          // }
                          Navigator.pop(context);
                          for (var slot in selectTimeSlotList) {
                            _updateDayPrice(
                                slot, variable.priceController.value.text);
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  tabletBottomPriceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 180.h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "Change Selected Slots Price",
                    textAlign: TextAlign.center,
                    style: TabletAppstyle.dLocationBold_text_style,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Divider(
                    height: 1.h,
                    color: greyBoldColor,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  TabletAppTextFiled(
                    controller: variable.priceController.value,
                    focusNode: variable.priceFocusNode.value,
                    selected: variable.priceSelected.value,
                    lebel: "Price",
                    enable: true,
                    onSubmitt: (value) {},
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "this is required";
                      } else if (variable.priceController.value.text.length <
                              4 &&
                          value.length < 4) {
                        return 'Please enter a valid street';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Divider(
                    height: 1.h,
                    color: greyBoldColor,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TabletCustomeButton(
                      title: "Submit",
                      onTap: () {
                        if (selectTimeSlotList.isEmpty) {
                          Fluttertoast.showToast(msg: "Please select slot");
                        } else {
                          //  maxPriceSlot =
                          //       selectTimeSlotPriceList.reduce((a, b) =>
                          //           a.slotPrice! > b.slotPrice! ? a : b);
                          // bottomPriceSheet(
                          //     "" /*maxPriceSlot!.slotPrice.toString()*/);
                          // for (var slot in selectTimeSlotList) {
                          //   _updateDayPrice(slot,
                          //       maxPriceSlot!.slotPrice.toString());
                          // }
                          Navigator.pop(context);
                          for (var slot in selectTimeSlotList) {
                            _updateDayPrice(
                                slot, variable.priceController.value.text);
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



/*  void _initializeControllers() {
    controllers.value = List.generate(
      itemCount.value,
      (index) => TextEditingController(),
    );
  }*/
