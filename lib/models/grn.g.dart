// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grn _$GrnFromJson(Map<String, dynamic> json) {
  return Grn(
    companyId: json['company_id'] as int,
    docPoId: json['doc_po_id'] as int,
    docPoCheckId: json['doc_po_check_id'] as int,
    storeId: json['store_id'] as int,
    refNo: json['ref_no'] as String,
    remark: json['remark'] as String,
    details: (json['details'] as List)
        ?.map((e) =>
            e == null ? null : GrnDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GrnToJson(Grn instance) => <String, dynamic>{
      'company_id': instance.companyId,
      'doc_po_id': instance.docPoId,
      'doc_po_check_id': instance.docPoCheckId,
      'store_id': instance.storeId,
      'ref_no': instance.refNo,
      'remark': instance.remark,
      'details': instance.details?.map((e) => e?.toJson())?.toList(),
    };
