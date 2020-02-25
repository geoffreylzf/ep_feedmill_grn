// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_po_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocPODetail _$DocPODetailFromJson(Map<String, dynamic> json) {
  return DocPODetail(
    docDetailId: json['doc_detail_id'] as int,
    itemPackingId: json['item_packing_id'] as int,
    skuCode: json['sku_code'] as String,
    skuName: json['sku_name'] as String,
    uomCode: json['uom_code'] as String,
    uomDesc: json['uom_desc'] as String,
    factor: (json['factor'] as num)?.toDouble(),
    qty: (json['qty'] as num)?.toDouble(),
    weight: (json['weight'] as num)?.toDouble(),
    grnQty: (json['grn_qty'] as num)?.toDouble(),
    grnWeight: (json['grn_weight'] as num)?.toDouble(),
    balQty: (json['bal_qty'] as num)?.toDouble(),
    balWeight: (json['bal_weight'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$DocPODetailToJson(DocPODetail instance) =>
    <String, dynamic>{
      'doc_detail_id': instance.docDetailId,
      'item_packing_id': instance.itemPackingId,
      'sku_code': instance.skuCode,
      'sku_name': instance.skuName,
      'uom_code': instance.uomCode,
      'uom_desc': instance.uomDesc,
      'factor': instance.factor,
      'qty': instance.qty,
      'weight': instance.weight,
      'grn_qty': instance.grnQty,
      'grn_weight': instance.grnWeight,
      'bal_qty': instance.balQty,
      'bal_weight': instance.balWeight,
    };
