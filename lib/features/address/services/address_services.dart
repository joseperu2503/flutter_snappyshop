import 'package:flutter_snappyshop/config/api/api.dart';
import 'package:flutter_snappyshop/features/address/models/addresses_response.dart';
import 'package:flutter_snappyshop/features/address/models/create_address_response.dart';
import 'package:flutter_snappyshop/features/address/models/delete_address_response.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';

final api = Api();

class AddressService {
  static Future<AddressesResponse> getMyAddresses({
    int page = 1,
  }) async {
    Map<String, dynamic> queryParameters = {
      "page": page,
    };
    try {
      final response = await api.get('/v2/addresses/my-addresses',
          queryParameters: queryParameters);

      return AddressesResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the addresses.');
    }
  }

  static Future<Address> getAddress({required String addressId}) async {
    try {
      final response = await api.get('/v2/addresses/$addressId');

      return Address.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while loading the address.');
    }
  }

  static Future<DeleteAddressResponse> deleteAddress(
      {required int addressId}) async {
    try {
      final response = await api.delete('/v2/addresses/$addressId');

      return DeleteAddressResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while deleting the address.');
    }
  }

  static Future<CreateAddressResponse> markAsPrimary(
      {required int addressId}) async {
    try {
      final response =
          await api.delete('/v2/addresses/mark-as-primary/$addressId');

      return CreateAddressResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred while updating the address.');
    }
  }

  static Future<CreateAddressResponse> createAddress({
    required String? address,
    required String? detail,
    required String? name,
    required String? phone,
    required String? references,
    required double? latitude,
    required double? longitude,
  }) async {
    Map<String, dynamic> form = {
      "address": address,
      "detail": detail,
      "name": name,
      "phone": phone,
      "references": references,
      "latitude": latitude,
      "longitude": longitude,
    };

    try {
      final response = await api.post('/v2/addresses', data: form);

      return CreateAddressResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException(
          'An error occurred while registering the address.');
    }
  }
}
