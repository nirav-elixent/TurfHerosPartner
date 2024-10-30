// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

class DemoTimeList extends GetxController {
  List turfGorundDetails_screenList = [
    {
      "image": "assets/images/turfGround_1.svg",
      "title": "Turf Grounds",
    },
    {
      "image": "assets/images/turfGround_2.svg",
      "title": "Time Slot",
    },
    {
      "image": "assets/images/turfGround_3.svg",
      "title": "All Booking",
    },
    {
      "image": "assets/images/turfGround_4.svg",
      "title": "Offers",
    },
    {
      "image": "assets/images/turfGround_5.svg",
      "title": "Account",
    },
    // {
    //   "image": "assets/images/turfGround_6.svg",
    //   "title": "Calendar",
    // },
  ];

  List<Facilities> bookingFuture_list = [
    Facilities(title: "Past"),
    Facilities(title: "Today"),
    Facilities(title: "Upcoming"),
  ];


}

class Facilities {
  String? title;
  RxBool isSelected;
  Facilities({
    required this.title,
    RxBool? isSelected,
  }) : isSelected = isSelected ?? false.obs;
}
