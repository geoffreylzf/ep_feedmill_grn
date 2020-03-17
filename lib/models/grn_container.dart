import 'package:json_annotation/json_annotation.dart';

part 'grn_container.g.dart';

@JsonSerializable()
class GrnContainer {
  @JsonKey(name: 'container_id', includeIfNull: true)
  int containerId;
  @JsonKey(name: 'container_no')
  String containerNo;

  @JsonKey(ignore: true)
  String containerCode;
  @JsonKey(ignore: true)
  String containerName;

  GrnContainer({
    this.containerId,
    this.containerNo,
    this.containerCode,
    this.containerName,
  });

  factory GrnContainer.fromJson(Map<String, dynamic> json) => _$GrnContainerFromJson(json);

  Map<String, dynamic> toJson() => _$GrnContainerToJson(this);
}
