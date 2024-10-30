// ignore_for_file: prefer_collection_literals, prefer_typing_uninitialized_variables, file_names

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ApiResponse {
  final int responseCode;
  final String status;
  final String response;
  final dynamic data;

  ApiResponse({
    required this.responseCode,
    required this.status,
    required this.response,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      responseCode: json['responseCode'],
      status: json['status'],
      response: json['response'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCode': responseCode,
      'status': status,
      'response': response,
      'data': data,
    };
  }
}

// You can use specific classes for the data part where the structure is known.

//final String? deletedAt;

// You can use specific classes for the data part where the structure is known.
class UserData {
  final String id;
  final int phoneNumber;
  final int phoneCode;
  //final String createdAt;
//  final String updatedAt;
  //final int walletBalance;

  String? email;
  String? firstName;
  String? lastName;
  String? timeZone;
  //final String? deletedAt;

  UserData({
    required this.id,
    required this.phoneNumber,
    required this.phoneCode,
    // required this.walletBalance,
    //   required this.createdAt,
    //   required this.updatedAt,
    this.email,
    this.firstName,
    this.lastName,
    this.timeZone,
    // this.deletedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      phoneNumber: json['phoneNumber'],
      phoneCode: json["countryCode"],
      //walletBalance: json["walletBalance"],
      //  createdAt: json['createdAt'],
      //  updatedAt: json['updatedAt'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      timeZone: json['timeZone'],
      // deletedAt: json['deletedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phoneNumber': phoneNumber,
      "countryCode": phoneCode,
      //  "walletBalance": walletBalance,
      //'createdAt': createdAt,
      //'updatedAt': updatedAt,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'timeZone': timeZone,
      // 'deletedAt': deletedAt,
    };
  }
}

class TurfList {
  String? sId;
  String? userId;
  String? name;
  RxInt? rate;
  double? rating;
  int? totalRating;
  Address? address;
  int? area;
  Coordinates? coordinates;
  List<String>? sportIds;
  List<String>? facilityIds;
  int? advanceBookingAllowedWeeks;
  RateDayWise? rateDayWise;
  String? about;
  String? openingTime;
  String? closingTime;
  List<String>? images;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  double? coordinatesDistance;
  RxList<TurfPitchDetail>? turfPitchDetail;

  TurfList(
      {this.sId,
      this.userId,
      this.name,
      RxInt? rate,
      this.rating,
      this.totalRating,
      this.address,
      this.area,
      this.coordinates,
      this.sportIds,
      this.facilityIds,
      this.about,
      this.openingTime,
      this.advanceBookingAllowedWeeks,
      this.rateDayWise,
      this.closingTime,
      this.images,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.coordinatesDistance,
      this.turfPitchDetail})
      : rate = rate ?? 0.obs;

  TurfList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    name = json['name'];
    rate = (json['rate'] as int).obs;
    rating = json['rating'].toDouble();
    totalRating = json['totalRating'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    rateDayWise = json['rateDayWise'] != null
        ? RateDayWise.fromJson(json['rateDayWise'])
        : null;
    area = json['area'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    sportIds = json['sportIds'].cast<String>();
    facilityIds = json['facilityIds'].cast<String>();
    about = json['about'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    images = json['images']?.cast<String>();
    advanceBookingAllowedWeeks = json['advanceBookingAllowedWeeks'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    coordinatesDistance = json['coordinates_distance'].toDouble();
    if (json['turfPitchDetail'] != null) {
      turfPitchDetail = <TurfPitchDetail>[].obs;
      json['turfPitchDetail'].forEach((v) {
        turfPitchDetail!.add(TurfPitchDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['userId'] = userId;
    data['name'] = name;
    data['rate'] = rate?.value;
    data['rating'] = rating;
    data['totalRating'] = totalRating;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['area'] = area;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    if (rateDayWise != null) {
      data['rateDayWise'] = rateDayWise!.toJson();
    }
    data['sportIds'] = sportIds;
    data['facilityIds'] = facilityIds;
    data['about'] = about;
    data['openingTime'] = openingTime;
    data['closingTime'] = closingTime;
    if (images != null) {
      data['images'] = images;
    }
    data['advanceBookingAllowedWeeks'] = advanceBookingAllowedWeeks;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (coordinatesDistance != null) {
      data['coordinates_distance'] = coordinatesDistance;
    }
    if (turfPitchDetail != null) {
      data['turfPitchDetail'] =
          turfPitchDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RateDayWise {
  int? monday;
  int? tuesday;
  int? wednesday;
  int? thursday;
  int? friday;
  int? saturday;
  int? sunday;

  RateDayWise(
      {this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  RateDayWise.fromJson(Map<String, dynamic> json) {
    monday = json['monday'];
    tuesday = json['tuesday'];
    wednesday = json['wednesday'];
    thursday = json['thursday'];
    friday = json['friday'];
    saturday = json['saturday'];
    sunday = json['sunday'];
  }

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_new
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['monday'] = monday;
    data['tuesday'] = tuesday;
    data['wednesday'] = thursday;
    data['friday'] = friday;
    data['saturday'] = saturday;
    data['sunday'] = sunday;
    return data;
  }
}

class Address {
  String? line1;
  String? line2;
  String? country;
  String? state;
  String? city;
  dynamic pinCode;

  Address(
      {this.line1,
      this.line2,
      this.country,
      this.state,
      this.city,
      this.pinCode});

  Address.fromJson(Map<String, dynamic> json) {
    line1 = json['line1'];
    line2 = json['line2'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    pinCode = json['pin_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['line1'] = line1;
    data['line2'] = line2;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['pin_code'] = pinCode.toString();
    return data;
  }
}

class Coordinates {
  String? type;
  List<double>? coordinates;

  Coordinates({this.type, this.coordinates});

  Coordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class TurfPitchDetail {
  String? sId;
  String? turfId;
  String? name;
  List<String>? sportIds;

  TurfPitchDetail({this.sId, this.turfId, this.name, this.sportIds});

  TurfPitchDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    turfId = json['turfId'];
    name = json['name'];
    sportIds = json['sportIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['turfId'] = turfId;
    data['name'] = name;
    data['sportIds'] = sportIds;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': sId ?? '',
      'turfId': turfId ?? '',
      'name': name ?? '',
      'sportIds': sportIds ?? []
    };
  }
}

class SportList {
  String? sId;
  String? name;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  String? images;
  RxBool isSelected;
  // int? iV;

  SportList({
    this.sId,
    this.name,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.images,
    RxBool? isSelected,
    //  this.iV
  }) : isSelected = isSelected ?? false.obs;

  SportList.fromJson(Map<String, dynamic> json)
      : sId = json['_id'],
        name = json['name'],
        deletedAt = json['deletedAt'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        images = json["image"],
        isSelected = (json['isSelected'] as bool? ?? false).obs;
  // iV = json['__v'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    data['deletedAt'] = deletedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data["image"] = images;
    data['isSelected'] = isSelected.value;
    //  data['__v'] = this.iV;
    return data;
  }
}

class TurfAvailableSlotList {
  String? sId;
  String? startTime;
  String? endTime;
  RxBool isSelected;
  int? slotPrice;

  // Adjusted constructor
  TurfAvailableSlotList(
      {this.startTime,
      this.sId,
      this.endTime,
      this.slotPrice,
      RxBool? isSelected})
      : isSelected = isSelected ?? false.obs; // Correct default assignment

  TurfAvailableSlotList.fromJson(Map<String, dynamic> json)
      : startTime = json['startTime'],
        sId = json['_id'],
        endTime = json['endTime'],
        slotPrice = json['slotPrice'],
        isSelected = (json['isSelected'] as bool? ?? false)
            .obs; // Ensure RxBool initialization from JSON

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['slotPrice'] = slotPrice;
    data['isSelected'] =
        isSelected.value; // Serialize the underlying boolean value
    return data;
  }
}

class TurfBookingDetail {
  String? turfId;
  String? userId;
  String? sportId;
  String? bookingId;
  String? date;
  String? startTime;
  String? endTime;
  String? expireAt;
  int? slotPrice;
  int? bookingPrice;
  // Null couponCode;
  // int? offerDiscount;
  // int? advancePercentage;
  // int? advanceAmount;
  // int? payAmount;
  // int? payableAtTurf;
  bool? isPaid;
  Null deletedAt;
  String? sId;
  String? createdAt;
  String? updatedAt;
  // int? iV;

  TurfBookingDetail({
    this.turfId,
    this.userId,
    this.sportId,
    this.bookingId,
    this.date,
    this.startTime,
    this.endTime,
    this.expireAt,
    this.slotPrice,
    this.bookingPrice,
    // this.couponCode,
    // this.offerDiscount,
    // this.advancePercentage,
    // this.advanceAmount,
    // this.payAmount,
    // this.payableAtTurf,
    this.isPaid,
    this.deletedAt,
    this.sId,
    this.createdAt,
    this.updatedAt,
    //this.iV
  });

  TurfBookingDetail.fromJson(Map<String, dynamic> json) {
    turfId = json['turfId'];
    userId = json['userId'];
    sportId = json['sportId'];
    bookingId = json['bookingId'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    expireAt = json['expireAt'];
    slotPrice = json['slotPrice'];
    bookingPrice = json['bookingPrice'];
    // couponCode = json['couponCode'];
    // offerDiscount = json['offerDiscount'];
    // advancePercentage = json['advancePercentage'];
    // advanceAmount = json['advanceAmount'];
    // payAmount = json['payAmount'];
    // payableAtTurf = json['payableAtTurf'];
    isPaid = json['isPaid'];
    deletedAt = json['deletedAt'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['turfId'] = turfId;
    data['userId'] = userId;
    data['sportId'] = sportId;
    data['bookingId'] = bookingId;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['expireAt'] = expireAt;
    data['slotPrice'] = slotPrice;
    data['bookingPrice'] = bookingPrice;
    // data['couponCode'] = couponCode;
    // data['offerDiscount'] = offerDiscount;
    // data['advancePercentage'] = advancePercentage;
    // data['advanceAmount'] = advanceAmount;
    // data['payAmount'] = payAmount;
    // data['payableAtTurf'] = payableAtTurf;
    data['isPaid'] = isPaid;
    data['deletedAt'] = deletedAt;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    // data['__v'] = iV;
    return data;
  }
}

class CouponList {
  String? sId;
  String? code;
  String? discountType;
  int? discountValue;
  int? maxDiscountAmount;
  int? userLimit;
  String? startAt;
  String? expiresAt;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  String? description;

  CouponList(
      {this.sId,
      this.code,
      this.discountType,
      this.discountValue,
      this.maxDiscountAmount,
      this.userLimit,
      this.startAt,
      this.expiresAt,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.description});

  CouponList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    discountType = json['discountType'];
    discountValue = json['discountValue'];
    maxDiscountAmount = json['maxDiscountAmount'];
    startAt = json["startAt"];
    userLimit = json['userLimit'];
    expiresAt = json['expiresAt'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['code'] = code;
    data['discountType'] = discountType;
    data['discountValue'] = discountValue;
    data['maxDiscountAmount'] = maxDiscountAmount;
    data["startAt"] = startAt;
    data['userLimit'] = userLimit;
    data['expiresAt'] = expiresAt;
    data['deletedAt'] = deletedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['description'] = description;
    return data;
  }
}

class TurfBookingList {
  String? sId;
  List<Documents>? documents;

  TurfBookingList({this.sId, this.documents});

  TurfBookingList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  // String? sId;
  // String? turfId;
  // String? userId;
  // String? sportId;
  String? bookingId;
  String? date;
  String? startTime;
  String? endTime;
  // String? expireAt;
  // int? slotPrice;
  // int? bookingPrice;
  // int? offerDiscount;
  // int? advancePercentage;
  // int? advanceAmount;
  double? payAmount;
  double? payableAtTurf;
  double? ownerRewardPoint;
  bool? isPaid;
   bool? isBookedByOwner;
  // String? createdAt;
  // String? updatedAt;
  // int? iV;
  List<TurfList>? turfDetail;
  List<SportList>? sportDetail;
  List<RatingDetail>? ratingDetail;
  RxList<TurfPitchDetail>? turfPitchDetail;
  RxList<UserData>? userDetail;

  Documents(
      {
      //   this.sId,
      // this.turfId,
      // this.userId,
      // this.sportId,
      this.bookingId,
      this.date,
      this.startTime,
      this.endTime,
      // this.expireAt,
      // this.slotPrice,
      // this.bookingPrice,
      // this.offerDiscount,
      // this.advancePercentage,
      // this.advanceAmount,
      this.payAmount,
      this.payableAtTurf,
      this.isPaid,
      this.ownerRewardPoint,
       this.isBookedByOwner,
      // this.createdAt,
      // this.updatedAt,
      // this.iV,
      this.turfDetail,
      this.sportDetail,
      this.ratingDetail,
      this.turfPitchDetail,
      this.userDetail});

  Documents.fromJson(Map<String, dynamic> json) {
    // sId = json['_id'];
    // turfId = json['turfId'];
    // userId = json['userId'];
    // sportId = json['sportId'];
    bookingId = json['bookingId'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    // expireAt = json['expireAt'];
    // slotPrice = json['slotPrice'];
    // bookingPrice = json['bookingPrice'];

    // offerDiscount = json['offerDiscount'];
    // advancePercentage = json['advancePercentage'];
    // advanceAmount = json['advanceAmount'];
    payAmount = json['payAmount'].toDouble();
    payableAtTurf = json['payableAtTurf'].toDouble();
    isPaid = json['isPaid'];
    ownerRewardPoint = json['ownerRewardPoint'] != null
        ? json['ownerRewardPoint'].toDouble()
        : 0.0;
          isBookedByOwner = json['isBookedByOwner'];
    // createdAt = json['createdAt'];
    // updatedAt = json['updatedAt'];
    // iV = json['__v'];
    if (json['turfDetail'] != null) {
      turfDetail = <TurfList>[];
      json['turfDetail'].forEach((v) {
        turfDetail!.add(TurfList.fromJson(v));
      });
    }
    if (json['sportDetail'] != null) {
      sportDetail = <SportList>[];
      json['sportDetail'].forEach((v) {
        sportDetail!.add(SportList.fromJson(v));
      });
    }
    if (json['ratingDetail'] != null) {
      ratingDetail = <RatingDetail>[];
      json['ratingDetail'].forEach((v) {
        ratingDetail!.add(RatingDetail.fromJson(v));
      });
    }
    if (json['turfPitchDetail'] != null) {
      turfPitchDetail = <TurfPitchDetail>[].obs;
      json['turfPitchDetail'].forEach((v) {
        turfPitchDetail!.add(TurfPitchDetail.fromJson(v));
      });
    }
    if (json['userDetail'] != null) {
      userDetail = <UserData>[].obs;
      json['userDetail'].forEach((v) {
        userDetail!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    // data['_id'] = sId;
    // data['turfId'] = turfId;
    // data['userId'] = userId;
    // data['sportId'] = sportId;
    data['bookingId'] = bookingId;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    // data['expireAt'] = expireAt;
    // data['slotPrice'] = slotPrice;
    // data['bookingPrice'] = bookingPrice;

    // data['offerDiscount'] = offerDiscount;
    // data['advancePercentage'] = advancePercentage;
    // data['advanceAmount'] = advanceAmount;
    data['payAmount'] = payAmount;
    data['payableAtTurf'] = payableAtTurf;
    data['isPaid'] = isPaid;
    data['ownerRewardPoint'] = ownerRewardPoint;
      data['isBookedByOwner'] = isBookedByOwner;
    // data['createdAt'] = createdAt;
    // data['updatedAt'] = updatedAt;
    // data['__v'] = iV;
    if (turfDetail != null) {
      data['turfDetail'] = turfDetail!.map((v) => v.toJson()).toList();
    }
    if (sportDetail != null) {
      data['sportDetail'] = sportDetail!.map((v) => v.toJson()).toList();
    }
    if (ratingDetail != null) {
      data['ratingDetail'] = ratingDetail!.map((v) => v.toJson()).toList();
    }
    if (turfPitchDetail != null) {
      data['turfPitchDetail'] =
          turfPitchDetail!.map((v) => v.toJson()).toList();
    }
    if (userDetail != null) {
      data['userDetail'] = userDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingDetail {
  String? sId;
  String? bookingId;
  String? turfId;
  String? userId;
  // int? iV;
  String? createdAt;
  Null deletedAt;
  int? rating;
  String? updatedAt;

  RatingDetail(
      {this.sId,
      this.bookingId,
      this.turfId,
      this.userId,
      //   this.iV,
      this.createdAt,
      this.deletedAt,
      this.rating,
      this.updatedAt});

  RatingDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bookingId = json['bookingId'];
    turfId = json['turfId'];
    userId = json['userId'];
    //  iV = json['__v'];
    createdAt = json['createdAt'];
    deletedAt = json['deletedAt'];
    rating = json['rating'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['bookingId'] = bookingId;
    data['turfId'] = turfId;
    data['userId'] = userId;
    // data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['deletedAt'] = deletedAt;
    data['rating'] = rating;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
