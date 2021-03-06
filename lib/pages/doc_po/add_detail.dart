import 'dart:async';

import 'package:ep_grn/models/grn_detail.dart';
import 'package:ep_grn/models/item_packing.dart';
import 'package:ep_grn/notifiers/grn_add_detail_notifier.dart';
import 'package:ep_grn/notifiers/doc_po_view_notifier.dart';
import 'package:ep_grn/widgets/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DocPoAddDetailPage extends StatefulWidget {
  final DocPoViewNotifier poViewNotifier;

  const DocPoAddDetailPage(this.poViewNotifier);

  @override
  _DocPoAddDetailPageState createState() => _DocPoAddDetailPageState();
}

class _DocPoAddDetailPageState extends State<DocPoAddDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.poViewNotifier),
        ChangeNotifierProvider(
          create: (_) => GrnAddDetailNotifier(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New Item"),
        ),
        body: Stack(
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: ItemPackingSelection()),
                VerticalDivider(width: 0),
                Expanded(
                  flex: 2,
                  child: DetailForm(),
                ),
              ],
            ),
            _ErrorMessage(),
          ],
        ),
      ),
    );
  }
}

class ItemPackingSelection extends StatefulWidget {
  @override
  _ItemPackingSelectionState createState() => _ItemPackingSelectionState();
}

class _ItemPackingSelectionState extends State<ItemPackingSelection> {
  final tecFilter = TextEditingController();
  Timer _debounce;
  GrnAddDetailNotifier bloc;
  String filterText = '';

  @override
  void initState() {
    super.initState();
    tecFilter.addListener(() {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (filterText != tecFilter.text) {
          filterText = tecFilter.text;
          if (bloc != null) {
            bloc.fetchItemPackingList(filter: filterText);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    tecFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<GrnAddDetailNotifier>(context).isLoading;
    final itemPackingList = Provider.of<GrnAddDetailNotifier>(context).itemPackingList;
    final itemPackingCount = Provider.of<GrnAddDetailNotifier>(context).itemPackingCount;
    final selectedItemPacking = Provider.of<GrnAddDetailNotifier>(context).selectedItemPacking;
    bloc = Provider.of<GrnAddDetailNotifier>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: tecFilter,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Filter",
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Total Item : ${itemPackingCount.toString()}',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Divider(),
        isLoading
            ? Expanded(child: Center(child: CircularProgressIndicator()))
            : itemPackingList.length == 0
                ? Expanded(child: Center(child: Text("No item found")))
                : Expanded(
                    child: ListView.separated(
                      itemCount: itemPackingList.length,
                      separatorBuilder: (ctx, index) => Divider(height: 0),
                      itemBuilder: (ctx, i) {
                        final ip = itemPackingList[i];
                        final bgColor = ip == selectedItemPacking
                            ? Theme.of(ctx).primaryColorLight
                            : Theme.of(ctx).scaffoldBackgroundColor;

                        return Container(
                          color: bgColor,
                          child: ListTile(
                            onTap: () {
                              bloc.setSelectedItemPacking(ip);
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ip.skuName,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  ip.skuCode,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                                )
                              ],
                            ),
                            subtitle: Text(
                              ip.uomDesc,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            trailing: Checkbox(
                              value: ip == selectedItemPacking,
                              onChanged: (b) {
                                bloc.setSelectedItemPacking(ip);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<GrnAddDetailNotifier>(context, listen: false).errMsgStream.listen((errMsg) {
      if (errMsg != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleAlertDialog(
              title: 'Error',
              message: errMsg,
            );
          },
        );
      }
    });
    return Container();
  }
}

class DetailForm extends StatefulWidget {
  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');

  final tecQty = TextEditingController();
  final tecWeight = TextEditingController();
  final tecManufactureDate = TextEditingController();
  final tecExpireDate = TextEditingController();
  final tecSampleBagTtl = TextEditingController();

  ItemPacking selectedItemPacking;

  @override
  void initState() {
    super.initState();
    tecQty.addListener(() {
      final qty = double.tryParse(tecQty.text);
      if (qty != null) {
        if (selectedItemPacking != null) {
          tecWeight.text = (qty * selectedItemPacking.factor).toString();
        }
      } else {
        tecWeight.text = "";
      }
    });
  }

  @override
  void dispose() {
    tecQty.dispose();
    tecWeight.dispose();
    tecManufactureDate.dispose();
    tecExpireDate.dispose();
    tecSampleBagTtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedItemPacking = Provider.of<GrnAddDetailNotifier>(context).selectedItemPacking;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: tecQty,
              autofocus: true,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Received Qty",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Cannot blank";
                }
                if (double.tryParse(value) == null) {
                  return "Number only";
                }
                return null;
              },
            ),
            Container(height: 12),
            TextFormField(
              controller: tecWeight,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Received Weight",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Cannot blank";
                }
                if (double.tryParse(value) == null) {
                  return "Number only";
                }
                return null;
              },
            ),
            Container(height: 12),GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().add(Duration(days: -365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                if (selectedDate != null) {
                  tecManufactureDate.text = dateFormat.format(selectedDate);
                }
              },
              child: TextFormField(
                controller: tecManufactureDate,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Manufacture Date",
                  errorStyle: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ),
            ),
            Container(height: 12),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().add(Duration(days: -365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                if (selectedDate != null) {
                  tecExpireDate.text = dateFormat.format(selectedDate);
                }
              },
              child: TextFormField(
                controller: tecExpireDate,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Expire Date",
                  errorStyle: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ),
            ),
            Container(height: 12),
            TextFormField(
              controller: tecSampleBagTtl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Total Sample Qty",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Cannot blank";
                }
                if (int.tryParse(value) == null) {
                  return "Number only";
                }
                return null;
              },
            ),
            Container(height: 12),
            SizedBox(
              width: double.infinity,
              child: RaisedButton.icon(
                icon: Icon(Icons.save),
                label: Text("SAVE"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (selectedItemPacking == null) {
                      Provider.of<GrnAddDetailNotifier>(context, listen: false)
                          .showError("Please select item");
                      return;
                    }

                    final grnDetail = GrnDetail(
                      itemPackingId: selectedItemPacking.id,
                      qty: double.tryParse(tecQty.text),
                      weight: double.tryParse(tecWeight.text),
                      manufactureDate: tecManufactureDate.text,
                      expireDate: tecExpireDate.text,
                      sampleBagTtl: int.tryParse(tecSampleBagTtl.text),
                      skuCode: selectedItemPacking.skuCode,
                      skuName: selectedItemPacking.skuName,
                      uomCode: selectedItemPacking.uomCode,
                      uomDesc: selectedItemPacking.uomDesc,
                    );
                    Provider.of<DocPoViewNotifier>(context, listen: false).addGrnDetail(grnDetail);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
