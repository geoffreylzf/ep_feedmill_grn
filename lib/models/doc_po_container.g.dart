// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_po_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocPoContainer _$DocPoContainerFromJson(Map<String, dynamic> json) {
  return DocPoContainer(
    containerId: json['container_id'] as int,
    containerCode: json['container_code'] as String,
    containerName: json['container_name'] as String,
  );
}

Map<String, dynamic> _$DocPoContainerToJson(DocPoContainer instance) =>
    <String, dynamic>{
      'container_id': instance.containerId,
      'container_code': instance.containerCode,
      'container_name': instance.containerName,
    };
