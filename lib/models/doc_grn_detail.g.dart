// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_grn_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocGrnDetail _$DocGrnDetailFromJson(Map<String, dynamic> json) {
  return DocGrnDetail(
    skuCode: json['sku_code'] as String,
    skuName: json['sku_name'] as String,
    uomCode: json['uom_code'] as String,
    uomDesc: json['uom_desc'] as String,
    factor: (json['factor'] as num)?.toDouble(),
    qty: (json['qty'] as num)?.toDouble(),
    weight: (json['weight'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$DocGrnDetailToJson(DocGrnDetail instance) =>
    <String, dynamic>{
      'sku_code': instance.skuCode,
      'sku_name': instance.skuName,
      'uom_code': instance.uomCode,
      'uom_desc': instance.uomDesc,
      'factor': instance.factor,
      'qty': instance.qty,
      'weight': instance.weight,
    };
