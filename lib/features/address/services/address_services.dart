import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/config/constants/api_routes.dart';
import 'package:flutter_snappyshop/features/address/models/place_details_response.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/models/autocomplete_response.dart';
import 'package:flutter_snappyshop/features/address/models/create_address_response.dart';
import 'package:flutter_snappyshop/features/address/models/delete_address_response.dart';
import 'package:flutter_snappyshop/features/address/models/geocode_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class AddressService {
  static Future<List<Address>> getAddresses() async {
    try {
      final response = await api.get(ApiRoutes.getMyAddresses);

      return List<Address>.from(response.data.map((x) => Address.fromJson(x)));
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while loading the addresses.');
    }
  }

  static Future<Address> getAddress({required String addressId}) async {
    try {
      final response = await api.get('${ApiRoutes.getAddress}/$addressId');

      return Address.fromJson(response.data);
    } catch (e) {
      throw ServiceException(e, 'An error occurred while loading the address.');
    }
  }

  static Future<DeleteAddressResponse> deleteAddress(
      {required int addressId}) async {
    try {
      final response =
          await api.delete('${ApiRoutes.deleteAddress}/$addressId');

      return DeleteAddressResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while deleting the address.');
    }
  }

  static Future<CreateAddressResponse> createAddress({
    required String address,
    required String detail,
    required String recipientName,
    required String phone,
    required String? references,
    required double latitude,
    required double longitude,
    required String country,
    required String locality,
    required String postalCode,
    required String plusCode,
  }) async {
    Map<String, dynamic> form = {
      "address": address,
      "detail": detail,
      "recipient_name": recipientName,
      "phone": phone,
      "references": references,
      "latitude": latitude,
      "longitude": longitude,
      "country": country,
      "locality": locality,
      "postal_code": postalCode,
      "plus_code": plusCode,
    };

    try {
      final response = await api.post(ApiRoutes.createAddress, data: form);

      return CreateAddressResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while registering the address.');
    }
  }

  static Future<List<AddressResult>> autocomplete({
    required String input,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "input": input,
      };

      final response = await api.get(
        '/addresses/autocomplete',
        queryParameters: queryParameters,
      );

      return List<AddressResult>.from(
          response.data.map((x) => AddressResult.fromJson(x)));
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while searching the address.');
    }
  }

  static Future<PlaceDetailsResponse> addressResultDetail({
    required String placeId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "place_id": placeId,
      };

      final response = await api.get(
        '/addresses/place-details',
        queryParameters: queryParameters,
      );

      return PlaceDetailsResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while searching the address.');
    }
  }

  static Future<GeocodeResponse> geocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "lat": latitude,
        "lng": longitude,
      };

      final response = await api.get(
        '/addresses/geocode',
        queryParameters: queryParameters,
      );

      return GeocodeResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          e, 'An error occurred while searching the address.');
    }
  }
}
