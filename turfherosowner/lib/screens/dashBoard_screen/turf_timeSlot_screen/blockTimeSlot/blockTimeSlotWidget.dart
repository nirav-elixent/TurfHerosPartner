// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class BlockTimeSlotWidget extends StatelessWidget {
  final String? time,price;
  VoidCallback onTap;
  var selected;
  BlockTimeSlotWidget({
    required this.selected,
    required this.time,
    required this.onTap,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: onTap,
      child: Container(
        height: 30.h,
        margin: EdgeInsets.symmetric(horizontal: 16.r),
        padding: EdgeInsets.symmetric(horizontal: 2.r, vertical: 8.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                  color: greyColor.withAlpha(60),
                  offset: Offset.fromDirection(
                    1,
                  ),
                  blurRadius: 0.4,
                  spreadRadius: 1)
            ],
            color: selected ? appColor : whiteColor),
        child: Row(
          children: [
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              flex: 3,
              child: Text(
                time!,
                textAlign: TextAlign.center,
                style: selected
                    ? selectedManageTime_text_style
                    : unselectedManageTime_text_style,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "$price/-",
                textAlign: TextAlign.center,
                style: selected
                    ? selectedManageTime_text_style
                    : unselectedManageTime_text_style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabletBlockTimeSlotWidget extends StatelessWidget {
  final String? time,price;
  VoidCallback onTap;
  var selected;
  TabletBlockTimeSlotWidget({
    required this.selected,
    required this.time,
    required this.onTap,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
        margin: EdgeInsets.symmetric(horizontal: 16.r),
        padding: EdgeInsets.symmetric(horizontal: 2.r, vertical: 8.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                  color: greyColor.withAlpha(60),
                  offset: Offset.fromDirection(
                    1,
                  ),
                  blurRadius: 0.4,
                  spreadRadius: 1)
            ],
            color: selected ? appColor : whiteColor),
        child: Row(
          children: [
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              flex: 3,
              child: Text(
                time!,
                textAlign: TextAlign.center,
                style: selected
                    ? selectedManageTime_text_style
                    : unselectedManageTime_text_style,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "$price/-",
                textAlign: TextAlign.center,
                style: selected
                    ? selectedManageTime_text_style
                    : unselectedManageTime_text_style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}