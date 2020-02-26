import 'package:json_annotation/json_annotation.dart';

part 'doc_po.g.dart';

@JsonSerializable()
class DocPo {
  int id;
  @JsonKey(name: 'doc_no')
  String docNo;
  @JsonKey(name: 'doc_date')
  String docDate;
  @JsonKey(name: 'delivery_date')
  String deliveryDate;
  @JsonKey(name: 'company_id')
  int companyId;
  @JsonKey(name: 'company_code')
  String companyCode;
  @JsonKey(name: 'company_name')
  String companyName;
  @JsonKey(name: 'location_id')
  int locationId;
  @JsonKey(name: 'location_code')
  String locationCode;
  @JsonKey(name: 'location_name')
  String locationName;
  @JsonKey(name: 'supplier_id')
  int supplierId;
  @JsonKey(name: 'supplier_code')
  String supplierCode;
  @JsonKey(name: 'supplier_name')
  String supplierName;
  @JsonKey(name: 'doc_po_check_id')
  int docPoCheckId;
  @JsonKey(name: 'truck_no')
  String truckNo;
  @JsonKey(name: 'weight_bridge_no')
  String weightBridgeNo;
  String remark;

  DocPo({
    this.id,
    this.docNo,
    this.docDate,
    this.deliveryDate,
    this.companyId,
    this.companyCode,
    this.companyName,
    this.locationId,
    this.locationCode,
    this.locationName,
    this.supplierId,
    this.supplierCode,
    this.supplierName,
    this.docPoCheckId,
    this.truckNo,
    this.weightBridgeNo,
    this.remark,
  });

  factory DocPo.fromJson(Map<String, dynamic> json) => _$DocPoFromJson(json);

  Map<String, dynamic> toJson() => _$DocPoToJson(this);
}
