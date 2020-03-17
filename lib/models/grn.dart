import 'package:ep_grn/models/grn_container.dart';
import 'package:json_annotation/json_annotation.dart';

import 'grn_detail.dart';

part 'grn.g.dart';

@JsonSerializable(explicitToJson: true)
class Grn {
  @JsonKey(name: 'company_id')
  int companyId;
  @JsonKey(name: 'doc_po_id')
  int docPoId;
  @JsonKey(name: 'doc_po_check_id')
  int docPoCheckId;
  @JsonKey(name: 'store_id')
  int storeId;
  @JsonKey(name: 'ref_no')
  String refNo;
  @JsonKey(name: 'remark', includeIfNull: true)
  String remark;
  List<GrnDetail> details;
  List<GrnContainer> containers;

  Grn({
    this.companyId,
    this.docPoId,
    this.docPoCheckId,
    this.storeId,
    this.refNo,
    this.remark,
    this.details,
    this.containers,
  });

  factory Grn.fromJson(Map<String, dynamic> json) => _$GrnFromJson(json);

  Map<String, dynamic> toJson() => _$GrnToJson(this);
}
