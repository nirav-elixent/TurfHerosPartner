// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';

class CustomSelcetSport extends StatelessWidget {
  String image, title;
  VoidCallback onTap;
  var selected;
  CustomSelcetSport({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            margin: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  "${ApiService.baseUrl}/$image",
                  height: 22.h,
                  width: 22.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(
                        "assets/images/detailsCricket_image.svg",
                        fit: BoxFit.contain);
                  },
                ),
                SizedBox(
                  width: 7.w,
                ),
                Text(
                  title,
                  style: selected
                      ? selectedTime_text_style
                      : unselectedTime_text_style,
                ),
              ],
            ),
          ),
          Positioned(
              top: -0,
              right: 0,
              child: selected
                  ? Container(
                      height: 14.h,
                      width: 14.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.r),
                          color: appColor,
                          border: Border.all(color: whiteColor, width: 1.r)),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: whiteColor,
                          size: 8.h,
                        ),
                      ),
                    )
                  : Container())
        ],
      ),
    );
  }
}


class TabletCustomSelcetSport extends StatelessWidget {
  String image, title;
  VoidCallback onTap;
  var selected;
  TabletCustomSelcetSport({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            margin: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  "${ApiService.baseUrl}/$image",
                  height: 22.h,
                  width: 22.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(
                        "assets/images/detailsCricket_image.svg",
                        fit: BoxFit.contain);
                  },
                ),
                SizedBox(
                  width: 7.w,
                ),
                Text(
                  title,
                  style: selected
                      ? selectedTime_text_style
                      : unselectedTime_text_style,
                ),
              ],
            ),
          ),
          Positioned(
              top: -0,
              right: 0,
              child: selected
                  ? Container(
                      height: 16.h,
                      width: 12.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.r),
                          color: appColor,
                          border: Border.all(color: whiteColor, width: 1.r)),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: whiteColor,
                          size: 8.h,
                        ),
                      ),
                    )
                  : Container())
        ],
      ),
    );
  }
}
