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
  @JsonKey(name: 'manufacture_date', includeIfNull: true)
  String manufactureDate;
  @JsonKey(name: 'expire_date', includeIfNull: true)
  String expireDate;
  @JsonKey(name: 'sample_bag_ttl', includeIfNull: true)
  int sampleBagTtl;
  @JsonKey(name: 'pc_odour', includeIfNull: true)
  int pcOdour;
  @JsonKey(name: 'pc_colour', includeIfNull: true)
  int pcColour;
  @JsonKey(name: 'pc_sew', includeIfNull: true)
  int pcSew;
  @JsonKey(name: 'pc_label', includeIfNull: true)
  int pcLabel;
  @JsonKey(name: 'pc_appear', includeIfNull: true)
  int pcAppear;
  @JsonKey(name: 'pc_remark', includeIfNull: true)
  String pcRemark;

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
    this.sampleBagTtl,
    this.pcOdour,
    this.pcColour,
    this.pcSew,
    this.pcLabel,
    this.pcAppear,
    this.pcRemark,

    this.skuCode,
    this.skuName,
    this.uomDesc,
    this.uomCode,
  });

  factory GrnDetail.fromJson(Map<String, dynamic> json) => _$GrnDetailFromJson(json);

  Map<String, dynamic> toJson() => _$GrnDetailToJson(this);
}
