// ignore_for_file: must_be_immutable, file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';

class BookingDetailsWidget extends StatelessWidget {
  String images, turfName, address, sportName, date, turfPitchName, bookingId;
  bool isBookedByOwner;
  double payAmount, payAtTurf;

  BookingDetailsWidget(
      {super.key,
      required this.apiSelectedSlotList,
      required this.images,
      required this.turfName,
      required this.isBookedByOwner,
      required this.address,
      required this.sportName,
      required this.payAmount,
      required this.payAtTurf,
      required this.date,
      required this.turfPitchName,
      required this.bookingId});

  final List<Map<String, dynamic>> apiSelectedSlotList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shadowColor: black_color,
          surfaceTintColor: whiteColor,
          color: whiteColor,
          elevation: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: -1,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      bottomLeft: Radius.circular(10.r),
                    ),
                    child: Image.network(
                      "${ApiService.baseUrl}/$images",
                      fit: BoxFit.fill,
                      width: 130.w,
                      height: 120.h,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                            "assets/images/turfbox_total_image.png",
                            fit: BoxFit.cover);
                      },
                    )),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#",
                            style: locationAway_text_style,
                          ),
                          Expanded(
                            child: Text(
                              bookingId,
                              style: locationAway_text_style,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            turfName,
                            style: turfName_text_style,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "#",
                                style: locationAway_text_style,
                              ),
                              Text(
                                isBookedByOwner == true ? "Offline" : "Online",
                                style: isBookedByOwner == true
                                    ? bookingTypeOffline_text_style
                                    : bookingType_text_style,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/images/location_image.svg"),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                              child: Text(
                            address,
                            style: locationAway_text_style,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sportName,
                            style: turfName_text_style,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Paid : ₹ $payAmount/-",
                                style: success_text_style,
                              ),
                              Text(
                                "Pending : ₹ $payAtTurf/-",
                                style: pending_text_style,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date :- ",
                            style: locationAway_text_style,
                          ),
                          Expanded(
                            child: Text(
                              date,
                              style: locationAway_text_style,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pitch",
                            style: locationAway_text_style,
                          ),
                          Text(
                            turfPitchName,
                            style: locationAway_text_style,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25.h,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              Map<String, dynamic> item = apiSelectedSlotList[index];
              Duration timeZoneOffset = DateTime.now().timeZoneOffset;
              // Parse the start and end times
              final DateTime startUtc = DateTime.parse(item["startTime"]!);
              final DateTime endUtc = DateTime.parse(item["endTime"]!);
              DateTime startTimeDeviceTime = startUtc.add(timeZoneOffset);
              DateTime endTimeDeviceTime = endUtc.add(timeZoneOffset);
              // Format the time in the local timezone
              final String formattedStartTime =
                  DateFormat("hh:mm a").format(startTimeDeviceTime);
              final String formattedEndTime =
                  DateFormat("hh:mm a").format(endTimeDeviceTime);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color:
                    //           black_color.withAlpha(100),
                    //       offset: Offset.fromDirection(
                    //         1,
                    //       ),
                    //       blurRadius: 0.9,
                    //       spreadRadius: 1.5)
                    // ],
                    color: appColor),
                child: Center(
                  child: Text("$formattedStartTime - $formattedEndTime",
                      textAlign: TextAlign.center,
                      style: selectedTime_text_style),
                ),
              );
            },
            itemCount: apiSelectedSlotList.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 120.r,
                mainAxisSpacing: 4.r,
                crossAxisSpacing: 4.r,
                childAspectRatio: .8.r / 3.2.r),
          ),
        ),
      ],
    );
  }
}

class TabletBookingDetailsWidget extends StatelessWidget {
  String images, turfName, address, sportName, date, turfPitchName, bookingId;
  bool isBookedByOwner;
  double payAmount, payAtTurf;

  TabletBookingDetailsWidget(
      {super.key,
      required this.apiSelectedSlotList,
      required this.images,
      required this.turfName,
      required this.isBookedByOwner,
      required this.address,
      required this.sportName,
      required this.payAmount,
      required this.payAtTurf,
      required this.date,
      required this.turfPitchName,
      required this.bookingId});

  final List<Map<String, dynamic>> apiSelectedSlotList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shadowColor: black_color,
          surfaceTintColor: whiteColor,
          color: whiteColor,
          elevation: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: -1,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      bottomLeft: Radius.circular(10.r),
                    ),
                    child: Image.network(
                      "${ApiService.baseUrl}/$images",
                      fit: BoxFit.fill,
                      width: 130.w,
                      height: 160.h,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                            "assets/images/turfbox_total_image.png",
                            fit: BoxFit.cover);
                      },
                    )),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#",
                            style: locationAway_text_style,
                          ),
                          Expanded(
                            child: Text(
                              bookingId,
                              style: locationAway_text_style,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            turfName,
                            style: turfName_text_style,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "#",
                                style: locationAway_text_style,
                              ),
                              Text(
                                isBookedByOwner == true ? "Offline" : "Online",
                                style: isBookedByOwner == true
                                    ? bookingTypeOffline_text_style
                                    : bookingType_text_style,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/images/location_image.svg"),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                              child: Text(
                            address,
                            style: locationAway_text_style,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sportName,
                            style: turfName_text_style,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Paid : ₹ $payAmount/-",
                                style: success_text_style,
                              ),
                              Text(
                                "Pending : ₹ $payAtTurf/-",
                                style: pending_text_style,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date :- ",
                            style: locationAway_text_style,
                          ),
                          Expanded(
                            child: Text(
                              date,
                              style: locationAway_text_style,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pitch",
                            style: locationAway_text_style,
                          ),
                          Text(
                            turfPitchName,
                            style: locationAway_text_style,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              Map<String, dynamic> item = apiSelectedSlotList[index];
              Duration timeZoneOffset = DateTime.now().timeZoneOffset;
              // Parse the start and end times
              final DateTime startUtc = DateTime.parse(item["startTime"]!);
              final DateTime endUtc = DateTime.parse(item["endTime"]!);
              DateTime startTimeDeviceTime = startUtc.add(timeZoneOffset);
              DateTime endTimeDeviceTime = endUtc.add(timeZoneOffset);
              // Format the time in the local timezone
              final String formattedStartTime =
                  DateFormat("hh:mm a").format(startTimeDeviceTime);
              final String formattedEndTime =
                  DateFormat("hh:mm a").format(endTimeDeviceTime);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color:
                    //           black_color.withAlpha(100),
                    //       offset: Offset.fromDirection(
                    //         1,
                    //       ),
                    //       blurRadius: 0.9,
                    //       spreadRadius: 1.5)
                    // ],
                    color: appColor),
                child: Center(
                  child: Text("$formattedStartTime - $formattedEndTime",
                      textAlign: TextAlign.center,
                      style: TabletAppstyle.selectedTime_text_style),
                ),
              );
            },
            itemCount: apiSelectedSlotList.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140.r,
                mainAxisSpacing: 5.r,
                crossAxisSpacing: 5.r,
                childAspectRatio: .8.r / 3.2.r),
          ),
        ),
      ],
    );
  }
}