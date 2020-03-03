import 'package:json_annotation/json_annotation.dart';

part 'grn_detail.g.dart';

@JsonSerializable()
class GrnDetail {
  @JsonKey(name: 'doc_detail_id', includeIfNull: true)
  int docDetailId;
  @JsonKey(name: 'item_packing_id')
  int itemPackingId;
  double qty;
  double weight;
  @JsonKey(name: 'manufacture_date')
  String manufactureDate;
  @JsonKey(name: 'expire_date')
  String expireDate;

  @JsonKey(ignore: true)
  String skuCode;
  @JsonKey(ignore: true)
  String skuName;
  @JsonKey(ignore: true)
  String uomDesc;
  @JsonKey(ignore: true)
  String uomCode;

  GrnDetail({
    this.docDetailId,
    this.itemPackingId,
    this.qty,
    this.weight,
    this.manufactureDate,
    this.expireDate,
    this.skuCode,
    this.skuName,
    this.uomDesc,
    this.uomCode,
  });

  factory GrnDetail.fromJson(Map<String, dynamic> json) => _$GrnDetailFromJson(json);

  Map<String, dynamic> toJson() => _$GrnDetailToJson(this);
}
