// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';

class CalenderBookingWidget extends StatelessWidget {
  String images, turfName, address, sportName, totalAmount, date, turfPitchName;
  bool isPaid;
  CalenderBookingWidget({
    super.key,
    required this.images,
    required this.turfName,
    required this.address,
    required this.sportName,
    required this.totalAmount,
    required this.date,
    required this.turfPitchName,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  /*  ${variable.turfBookingList[index].documents![0].turfDetail![0].images != null ? variable.turfBookingList[index].documents![0].turfDetail![0].images![0] : variable.turfBookingList[index].documents![0].turfDetail![0].images == null ? "assets/images/turf_image.png" : variable.turfBookingList[index].documents![0].turfDetail![index].images![0]}*/
                  "${ApiService.baseUrl}/$images}",
                  fit: BoxFit.fill,
                  width: 130.w,
                  height: 133.h,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/images/turfbox_total_image.png",
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
                  Text(
                    /*${variable.turfCalenderBookingList[index].documents![0].turfDetail![0].name}*/
                    turfName,
                    style: turfName_text_style,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/location_image.svg"),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: Text(
                        /*${variable.turfCalenderBookingList[index].documents![0].turfDetail![0].address!.line1},${variable.turfCalenderBookingList[index].documents![0].turfDetail![0].address!.line2},${variable.turfBookingList[index].documents![0].turfDetail![0].address!.city},${variable.turfBookingList[0].documents![0].turfDetail![0].address!.state},${variable.turfBookingList[0].documents![0].turfDetail![0].address!.pinCode}*/
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
                        /*${variable.turfBookingList[index].documents![0].sportDetail![0].name}*/
                        sportName,
                        style: turfName_text_style,
                      ),
                      Text(
                        /*${variable.turfBookingList[index].documents![0].payAmount! + variable.turfBookingList[index].documents![0].payableAtTurf!}*/
                        "₹ $totalAmount",
                        style: turfName_text_style,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: locationAway_text_style,
                      ),
                      Text(
                        /*${variable.turfBookingList[index].documents![0].date}*/
                        date,
                        style: locationAway_text_style,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
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
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment Status ",
                        style: paymentStatus_text_style,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        isPaid ? "Success" : "Pending",
                        style: isPaid ? success_text_style : pending_text_style,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
               /*  variable
                                      .turfBookingList[index]
                                      .documents![0]
                                      .isPaid! ==
                                  false
                              ? Container()
                              :*/
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Rate",
                  //       style:
                  //           turfName_text_style,
                  //     ),
                  //     RatingBar(
                  //       itemSize:
                  //           10.h,
                  //       initialRating: variable
                  //               .turfCalenderBookingList[
                  //                   index]
                  //               .documents![
                  //                   0]
                  //               .ratingDetail!
                  //               .isNotEmpty
                  //           ? variable
                  //               .turfBookingList[
                  //                   index]
                  //               .documents![
                  //                   0]
                  //               .ratingDetail![
                  //                   0]
                  //               .rating!
                  //               .toDouble()
                  //           : variable
                  //                   .turfCalenderBookingList[
                  //                       index]
                  //                   .documents![
                  //                       0]
                  //                   .ratingDetail!
                  //                   .isEmpty
                  //               ? 0.0
                  //               : variable
                  //                   .turfCalenderBookingList[index]
                  //                   .documents![0]
                  //                   .ratingDetail![0]
                  //                   .rating!
                  //                   .toDouble(),
                  //       /*variable
                  //         .turfBookingList[
                  //             index]
                  //         .documents![0]
                  //         .ratingDetail!
                  //         .isNotEmpty
                  //     ? variable
                  //         .turfBookingList[
                  //             index]
                  //         .documents![0]
                  //         .ratingDetail![
                  //             0]
                  //         .rating!
                  //         .toDouble()
                  //     : variable
                  //             .turfBookingList[
                  //                 index]
                  //             .documents![
                  //                 0]
                  //             .ratingDetail!
                  //             .isEmpty
                  //         ? 0.0
                  //         : variable
                  //             .turfBookingList[
                  //                 index]
                  //             .documents![
                  //                 0]
                  //             .ratingDetail![
                  //                 0]
                  //             .rating!
                  //             .toDouble(),*/
                  //       direction: Axis
                  //           .horizontal,
                  //       allowHalfRating:
                  //           true,
                  //       itemCount: 5,
                  //       ratingWidget:
                  //           RatingWidget(
                  //         full: SvgPicture
                  //             .asset(
                  //                 'assets/images/ratin_star.svg'),
                  //         half: SvgPicture
                  //             .asset(
                  //                 'assets/images/ratin_star.svg'),
                  //         empty: SvgPicture
                  //             .asset(
                  //                 'assets/images/emtpy_star.svg'),
                  //       ),
                  //       itemPadding: const EdgeInsets
                  //           .symmetric(
                  //           horizontal:
                  //               4.0),
                  //       onRatingUpdate:
                  //           (rating) {
                  //         print(
                  //             "print123 $rating");
                  //         // /*  variable.turfBookingList[index].documents![0].ratingDetail!.isNotEmpty ? */ applyRating(variable.turfBookingList[index].documents![0].turfId!, variable.turfBookingList[index].documents![0].bookingId!, rating.toInt()) /* : null*/;
                  //       },
                  //     ),
                  //   ],
                  // ),