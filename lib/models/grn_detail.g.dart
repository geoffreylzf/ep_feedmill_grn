// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grn_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrnDetail _$GrnDetailFromJson(Map<String, dynamic> json) {
  return GrnDetail(
    docDetailId: json['doc_detail_id'] as int,
    itemPackingId: json['item_packing_id'] as int,
    qty: (json['qty'] as num)?.toDouble(),
    weight: (json['weight'] as num)?.toDouble(),
    refWeight: (json['ref_weight'] as num)?.toDouble(),
    expiredDate: json['expired_date'] as String,
  );
}

Map<String, dynamic> _$GrnDetailToJson(GrnDetail instance) => <String, dynamic>{
      'doc_detail_id': instance.docDetailId,
      'item_packing_id': instance.itemPackingId,
      'qty': instance.qty,
      'weight': instance.weight,
      'ref_weight': instance.refWeight,
      'expired_date': instance.expiredDate,
    };
