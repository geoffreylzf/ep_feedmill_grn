// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_po.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocPO _$DocPOFromJson(Map<String, dynamic> json) {
  return DocPO(
    id: json['id'] as int,
    docNo: json['doc_no'] as String,
    docDate: json['doc_date'] as String,
    deliveryDate: json['delivery_date'] as String,
    companyId: json['company_id'] as int,
    companyCode: json['company_code'] as String,
    companyName: json['company_name'] as String,
    locationId: json['location_id'] as int,
    locationCode: json['location_code'] as String,
    locationName: json['location_name'] as String,
    supplierId: json['supplier_id'] as int,
    supplierCode: json['supplier_code'] as String,
    supplierName: json['supplier_name'] as String,
    docPoCheckId: json['doc_po_check_id'] as int,
    truckNo: json['truck_no'] as String,
    weightBridgeNo: json['weight_bridge_no'] as String,
    remark: json['remark'] as String,
  );
}

Map<String, dynamic> _$DocPOToJson(DocPO instance) => <String, dynamic>{
      'id': instance.id,
      'doc_no': instance.docNo,
      'doc_date': instance.docDate,
      'delivery_date': instance.deliveryDate,
      'company_id': instance.companyId,
      'company_code': instance.companyCode,
      'company_name': instance.companyName,
      'location_id': instance.locationId,
      'location_code': instance.locationCode,
      'location_name': instance.locationName,
      'supplier_id': instance.supplierId,
      'supplier_code': instance.supplierCode,
      'supplier_name': instance.supplierName,
      'doc_po_check_id': instance.docPoCheckId,
      'truck_no': instance.truckNo,
      'weight_bridge_no': instance.weightBridgeNo,
      'remark': instance.remark,
    };
