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
    manufactureDate: json['manufacture_date'] as String,
    expireDate: json['expire_date'] as String,
    sampleBagTtl: json['sample_bag_ttl'] as int,
    pcOdour: json['pc_odour'] as int,
    pcColour: json['pc_colour'] as int,
    pcSew: json['pc_sew'] as int,
    pcLabel: json['pc_label'] as int,
    pcAppear: json['pc_appear'] as int,
    pcRemark: json['pc_remark'] as String,
  );
}

Map<String, dynamic> _$GrnDetailToJson(GrnDetail instance) => <String, dynamic>{
      'doc_detail_id': instance.docDetailId,
      'item_packing_id': instance.itemPackingId,
      'qty': instance.qty,
      'weight': instance.weight,
      'manufacture_date': instance.manufactureDate,
      'expire_date': instance.expireDate,
      'sample_bag_ttl': instance.sampleBagTtl,
      'pc_odour': instance.pcOdour,
      'pc_colour': instance.pcColour,
      'pc_sew': instance.pcSew,
      'pc_label': instance.pcLabel,
      'pc_appear': instance.pcAppear,
      'pc_remark': instance.pcRemark,
    };
