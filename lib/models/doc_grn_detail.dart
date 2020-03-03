import 'package:json_annotation/json_annotation.dart';

part 'doc_grn_detail.g.dart';

@JsonSerializable()
class DocGrnDetail {
  @JsonKey(name: 'sku_code')
  String skuCode;
  @JsonKey(name: 'sku_name')
  String skuName;
  @JsonKey(name: 'uom_code')
  String uomCode;
  @JsonKey(name: 'uom_desc')
  String uomDesc;
  double factor;
  double qty;
  double weight;

  DocGrnDetail({
    this.skuCode,
    this.skuName,
    this.uomCode,
    this.uomDesc,
    this.factor,
    this.qty,
    this.weight,
  });

  factory DocGrnDetail.fromJson(Map<String, dynamic> json) => _$DocGrnDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DocGrnDetailToJson(this);
}
