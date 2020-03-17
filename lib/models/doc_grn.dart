import 'package:ep_grn/models/doc_grn_detail.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_grn.g.dart';

@JsonSerializable(explicitToJson: true)
class DocGrn {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'company_name')
  String companyName;
  @JsonKey(name: 'company_reg_no')
  String companyRegNo;
  @JsonKey(name: 'doc_no')
  String docNo;
  @JsonKey(name: 'doc_date')
  String docDate;
  @JsonKey(name: 'po_doc_no')
  String poDocNo;
  @JsonKey(name: 'supplier_name')
  String supplierName;
  @JsonKey(name: 'supplier_ref_no')
  String supplierRefNo;
  List<DocGrnDetail> details;

  DocGrn({
    this.id,
    this.companyName,
    this.companyRegNo,
    this.docNo,
    this.docDate,
    this.poDocNo,
    this.supplierName,
    this.supplierRefNo,
    this.details,
  });

  factory DocGrn.fromJson(Map<String, dynamic> json) => _$DocGrnFromJson(json);

  Map<String, dynamic> toJson() => _$DocGrnToJson(this);
}
