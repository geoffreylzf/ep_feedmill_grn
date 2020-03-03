// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_grn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocGrn _$DocGrnFromJson(Map<String, dynamic> json) {
  return DocGrn(
    id: json['id'] as int,
    companyName: json['company_name'] as String,
    companyRegNo: json['company_reg_no'] as String,
    docNo: json['doc_no'] as String,
    docDate: json['doc_date'] as String,
    supplierName: json['supplier_name'] as String,
    details: (json['details'] as List)
        ?.map((e) =>
            e == null ? null : DocGrnDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DocGrnToJson(DocGrn instance) => <String, dynamic>{
      'id': instance.id,
      'company_name': instance.companyName,
      'company_reg_no': instance.companyRegNo,
      'doc_no': instance.docNo,
      'doc_date': instance.docDate,
      'supplier_name': instance.supplierName,
      'details': instance.details?.map((e) => e?.toJson())?.toList(),
    };
