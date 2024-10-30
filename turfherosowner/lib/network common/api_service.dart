// ignore_for_file: constant_identifier_names, use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:turf_heros_owner/flavor_config.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';

class ApiService {
  static String baseUrl = FlavorConfig.instance.apiUrl;

  // static String baseUrl = "https://turfheros.testbeta.app";

  Future<ApiResponse> loginWithWhatsappNumber(
      Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/send-otp-on-whatsapp'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);
    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> otpVerification(Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/verify-otp'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);
    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> sportListData() async {
    final response = await http.post(Uri.parse('$baseUrl/api/sport-list'),
        headers: {
          'Content-type': 'application/json',
          "app-version": "1.0",
          "app-platform": Platform.isIOS ? "ios" : "android",
        },
        body: jsonEncode({"pageNumber": "1", "perPage": "10"}));

    Map<String, dynamic> data = json.decode(response.body);
    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> facilitiesListData() async {
    final response = await http.post(Uri.parse('$baseUrl/api/facility-list'),
        headers: {
          'Content-type': 'application/json',
          "app-version": "1.0",
          "app-platform": Platform.isIOS ? "ios" : "android",
        },
        body: jsonEncode({"pageNumber": "1", "perPage": "10"}));

    Map<String, dynamic> data = json.decode(response.body);
    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> turfListData(
      String authToken, String searchString) async {
    final response = await http.post(Uri.parse('$baseUrl/api/owner/turf-list'),
        headers: {
          'Content-type': 'application/json',
          "app-version": "1.0",
          "app-platform": Platform.isIOS ? "ios" : "android",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({
          "pageNumber": "1",
          "perPage": "10",
          "searchString": searchString,
        }));

    Map<String, dynamic> data = json.decode(response.body);
    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> turfBookingListData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/booking-list'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> turfCouponListData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/coupon-list'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> turfCreateCouponData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/coupon-add-update'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> deleteCouponData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/coupon-delete'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> userDetailsData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/find-or-cerate-user'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> loadBookingAvailableSlotData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/booking-slot-list'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> bookSlotData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/book-now'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> bulkBookSlotData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/bulk-book'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> allBookingSlotData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/all-booking-slot-list'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> myDetailsData(String authToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/my-detail'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode({}),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> bookingTransactionListData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/booking-transaction-list'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> manageTimeSlotDateListData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/booking-slot-list'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> updatePriceData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/turf-booking-slot/update-price'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> deleteTimeSlotData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/turf-booking-slot/delete'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> editTurfDetailsData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/turf-add-update'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> deletePitchDetailsData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/turf-pitch/delete'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> userDetailsUpdateData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/update-user-profile'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> reportData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/booking-report'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> blockTimeSlotData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/block-booking-slot'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }

  Future<ApiResponse> deleteTurfData(
      String authToken, Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/owner/turf-delete'),
      headers: {
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> data = json.decode(response.body);

    print("ApiService Response: $data");

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 401) {
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed to send OTP on WhatsApp');
    }
  }
}


/*  Future<dynamic> apiGetCall(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    const CircularProgressIndicator();
    try {
      final Uri uri = Uri.parse(baseUrl + endpoint);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        return json.decode(response.body);
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      throw Exception('Failed to load data: $e');
    }
  }

  Future<dynamic> apiPostCall(
    BuildContext context,
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final Uri uri = Uri.parse(baseUrl + endpoint);
      final response =
          await http.post(uri, body: json.encode(body), headers: headers);
      print(uri);
      if (response.statusCode == 200) {
        print("print1234 $body");
        // If the server returns a 200 OK response, parse the JSON
        return json.decode(response.body);
      } else if (response.statusCode == 400) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (on) => const LoginScreen()),
            (route) => false);
        print("print1234 $body");
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load data: ${response.request}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print("print1234 ${e.toString()}");
      print("print1234 $headers");
      throw Exception('Failed to loads data: $body');
    }
    print("print1234 $body");
  }*/