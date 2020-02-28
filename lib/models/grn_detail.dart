import 'package:json_annotation/json_annotation.dart';

part 'grn_detail.g.dart';

@JsonSerializable()
class GrnDetail {
  @JsonKey(name: 'doc_detail_id')
  int docDetailId;
  @JsonKey(name: 'item_packing_id')
  int itemPackingId;
  double qty;
  double weight;
  @JsonKey(name: 'expired_date')
  String expiredDate;

  @JsonKey(ignore: true)
  String skuCode;
  @JsonKey(ignore: true)
  String skuName;

  GrnDetail({
    this.docDetailId,
    this.itemPackingId,
    this.qty,
    this.weight,
    this.expiredDate,
    this.skuCode,
    this.skuName,
  });

  factory GrnDetail.fromJson(Map<String, dynamic> json) => _$GrnDetailFromJson(json);

  Map<String, dynamic> toJson() => _$GrnDetailToJson(this);
}
