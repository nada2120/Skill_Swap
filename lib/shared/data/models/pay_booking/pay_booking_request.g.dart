// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayBookingRequest _$PayBookingRequestFromJson(Map<String, dynamic> json) =>
    PayBookingRequest(
      successUrl: json['successUrl'] as String,
      cancelUrl: json['cancelUrl'] as String,
      voucherId: json['voucherId'] as String?,
    );

Map<String, dynamic> _$PayBookingRequestToJson(PayBookingRequest instance) =>
    <String, dynamic>{
      'successUrl': instance.successUrl,
      'cancelUrl': instance.cancelUrl,
      'voucherId': instance.voucherId
    };
