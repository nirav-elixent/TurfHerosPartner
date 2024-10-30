// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class CouponDetailsWidget extends StatelessWidget {
  VoidCallback onTap;
  DateTime startTimeDeviceTime;
  int discountValue;
  String startTime,endTime;
  CouponDetailsWidget(
      {super.key,
      required this.onTap,
      required this.startTimeDeviceTime,
      required this.discountValue,
      required this.startTime,
      required this.endTime
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 12.w,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatTimeAgo(startTimeDeviceTime),
                    style: offerTime_text_style,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "Flat $discountValue% ",
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
              Row(
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
              )
            ],
          ),
        ),
      ),
    );
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
