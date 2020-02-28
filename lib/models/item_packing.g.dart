// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_packing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPacking _$ItemPackingFromJson(Map<String, dynamic> json) {
  return ItemPacking(
    id: json['id'] as int,
    skuCode: json['sku_code'] as String,
    skuName: json['sku_name'] as String,
    uomDesc: json['uom_desc'] as String,
    factor: (json['factor'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ItemPackingToJson(ItemPacking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku_code': instance.skuCode,
      'sku_name': instance.skuName,
      'uom_desc': instance.uomDesc,
      'factor': instance.factor,
    };
