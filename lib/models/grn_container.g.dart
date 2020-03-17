// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grn_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrnContainer _$GrnContainerFromJson(Map<String, dynamic> json) {
  return GrnContainer(
    containerId: json['container_id'] as int,
    containerNo: json['container_no'] as String,
  );
}

Map<String, dynamic> _$GrnContainerToJson(GrnContainer instance) =>
    <String, dynamic>{
      'container_id': instance.containerId,
      'container_no': instance.containerNo,
    };
