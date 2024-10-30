// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class ManageTimeSlotWidget extends StatelessWidget {
  final String? time;
  VoidCallback onTap;
  var selected;
   TextEditingController controller;
   Function(String) onFieldSubmitted;
  ManageTimeSlotWidget({
    super.key,
    required this.selected,
    required this.time,
    required this.onTap,
    required this.controller,
    required this.onFieldSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
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
              flex: 1,
              child: TextFormField(
                controller:controller ,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: selected ? selectedManageTime_text_style : unselectedManageTime_text_style,
                onFieldSubmitted: onFieldSubmitted,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor:selected ? appColor.withRed(60): greyColor.withAlpha(60),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  constraints: BoxConstraints(maxHeight: 35.h),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
          ],
        ),
      ),
    );
  }
}
