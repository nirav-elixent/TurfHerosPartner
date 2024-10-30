// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';

class TurfManagerWidget extends StatelessWidget {
  VoidCallback onTap;
  String images, turfName;
  double rating;
  int totalRating;
  TurfManagerWidget(
      {super.key,
      required this.onTap,
      required this.images,
      required this.turfName,
      required this.rating,
      required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 210.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: whiteColor),
        child: Column(
          children: [
            /*${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index] ""}*/
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r)),
              child: Image.network(
                "${ApiService.baseUrl}/$images",
                fit: BoxFit.cover,
                height: 150.h,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/turf_details_image.png",
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        turfName,
                        style: detailsturfName_text_style,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/star_image.svg",
                              height: 23.h,
                              width: 23.w,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: rating.toStringAsFixed(1).toString(),
                                  style: dLocationBold_text_style,
                                  children: [
                                    TextSpan(
                                        text: "(${formatNumber(totalRating)})",
                                        style: locationAway_text_style)
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String formatNumber(int number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(2)} Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(2)} L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} k';
    } else {
      return number.toString();
    }
  }
}


class TabletTurfManagerWidget extends StatelessWidget {
  VoidCallback onTap;
  String images, turfName;
  double rating;
  int totalRating;
  TabletTurfManagerWidget(
      {super.key,
      required this.onTap,
      required this.images,
      required this.turfName,
      required this.rating,
      required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 230.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: whiteColor),
        child: Column(
          children: [
            /*${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index] ""}*/
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r)),
              child: Image.network(
                "${ApiService.baseUrl}/$images",
                fit: BoxFit.cover,
                height: 170.h,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/turf_details_image.png",
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        turfName,
                        style: TabletAppstyle.detailsturfName_text_style,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/star_image.svg",
                              height: 20.h,
                              width: 20.w,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: rating.toStringAsFixed(1).toString(),
                                  style: TabletAppstyle.dLocationBold_text_style,
                                  children: [
                                    TextSpan(
                                        text: "(${formatNumber(totalRating)})",
                                        style: TabletAppstyle.locationAway_text_style)
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String formatNumber(int number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(2)} Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(2)} L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} k';
    } else {
      return number.toString();
    }
  }
}