import 'package:ep_grn/animation/route_slide_right.dart';
import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/notifiers/po_list_notifier.dart';
import 'package:ep_grn/notifiers/po_view_notifier.dart';
import 'package:ep_grn/pages/doc_po/add_detail.dart';
import 'package:ep_grn/utils/table.dart';
import 'package:ep_grn/widgets/simple_alert_dialog.dart';
import 'package:ep_grn/widgets/simple_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'detail.dart';

class DocPOIndexPage extends StatefulWidget {
  final DocPo docPO;

  DocPOIndexPage(this.docPO);

  @override
  _DocPOIndexPageState createState() => _DocPOIndexPageState();
}

class _DocPOIndexPageState extends State<DocPOIndexPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PoViewNotifier(docPO: widget.docPO),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Purchase Order"),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Container(height: 8, color: Colors.grey[200]),
                POHeader(),
                Container(height: 8, color: Colors.grey[200]),
                POHeaderEntry(),
                Container(height: 8, color: Colors.grey[200]),
                PODetail(),
                Container(height: 8, color: Colors.grey[200]),
                NewGrnDetail(),
                Container(height: 8, color: Colors.grey[200]),
                ActionButton(),
                Container(height: 8, color: Colors.grey[200]),
              ],
            ),
            Consumer<PoViewNotifier>(
              builder: (ctx, povn, _) {
                return SimpleLoadingDialog(povn.isLoading);
              },
            ),
            _ErrorMessage(),
          ],
        ),
      ),
    );
  }
}

class POHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final po = Provider.of<PoViewNotifier>(context).docPO;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      po.docNo,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                          child: Icon(Icons.date_range, size: 12),
                        ),
                        Text(
                          po.docDate,
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
                          child: Icon(FontAwesomeIcons.truck, size: 12),
                        ),
                        Text(
                          po.deliveryDate,
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      po.supplierName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                            child: Icon(Icons.location_on, size: 12),
                          ),
                          Text(po.locationName,
                              style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(height: 8),
          Table(
            border: TableBorder.all(color: Colors.grey[300]),
            columnWidths: {
              0: FractionColumnWidth(0.2),
              1: FractionColumnWidth(0.25),
              2: FractionColumnWidth(0.55),
            },
            children: [
              TableRow(children: [
                TableHeaderCell('Truck No'),
                TableHeaderCell('Weight Bridge No'),
                TableHeaderCell('Weight Bridge Remark'),
              ]),
              TableRow(children: [
                TableDetailCell(po.truckNo),
                TableDetailCell(po.weightBridgeNo),
                TableDetailCell(po.remark),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class POHeaderEntry extends StatefulWidget {
  @override
  _POHeaderEntryState createState() => _POHeaderEntryState();
}

class _POHeaderEntryState extends State<POHeaderEntry> {
  final tecRefNo = TextEditingController();
  final tecContainerTtl = TextEditingController();
  final tecSampleBagTtl = TextEditingController();
  final tecRemark = TextEditingController();

  @override
  void dispose() {
    tecRefNo.dispose();
    tecContainerTtl.dispose();
    tecSampleBagTtl.dispose();
    tecRemark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tecRefNo.addListener(() {
      Provider.of<PoViewNotifier>(context, listen: false).refNo = tecRefNo.text;
    });

    tecContainerTtl.addListener(() {
      Provider.of<PoViewNotifier>(context, listen: false).containerTtl =
          int.tryParse(tecContainerTtl.text);
    });

    tecSampleBagTtl.addListener(() {
      Provider.of<PoViewNotifier>(context, listen: false).sampleBagTtl =
          int.tryParse(tecSampleBagTtl.text);
    });

    tecRemark.addListener(() {
      Provider.of<PoViewNotifier>(context, listen: false).remark = tecRemark.text;
    });

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text("Purchase Order Entry", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: tecRefNo,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Supp. Ref / DO',
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                ),
              ),
              Container(width: 8),
              Expanded(
                child: DropdownButton(
                  hint: Text("Store"),
                  isExpanded: true,
                  elevation: 16,
                  value: Provider.of<PoViewNotifier>(context).selectedStore,
                  onChanged: (v) {
                    Provider.of<PoViewNotifier>(context, listen: false).setSelectedStore(v);
                  },
                  items: Provider.of<PoViewNotifier>(context).storeList.map(
                    (store) {
                      return DropdownMenuItem(
                        value: store,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.storeName),
                            Text(store.storeCode,
                                style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: tecContainerTtl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Container Total',
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                ),
              ),
              Container(width: 8),
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: tecSampleBagTtl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sample Bag Total',
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
          Container(height: 8),
          TextField(
            controller: tecRemark,
            keyboardType: TextInputType.text,
            maxLength: 100,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Remark',
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class PODetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dtList = Provider.of<PoViewNotifier>(context).docPODetailList;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Text("Purchase Order Detail", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dtList.length,
            separatorBuilder: (ctx, index) {
              return Divider(height: 1, thickness: 1);
            },
            itemBuilder: (ctx, index) {
              final dt = dtList[index];
              final grnDt = Provider.of<PoViewNotifier>(context).getGrnDetail(dt);
              return InkWell(
                splashColor: Theme.of(context).accentColor,
                onTap: dt.balQty <= 0
                    ? null
                    : () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        Provider.of<PoViewNotifier>(
                          context,
                          listen: false,
                        ).setSelectedDocPODetail(dt);
                        Navigator.push(
                          context,
                          SlideRightRoute(
                            widget: DocPoDetailPage(
                              Provider.of<PoViewNotifier>(
                                context,
                                listen: false,
                              ),
                            ),
                          ),
                        );
                      },
                child: Container(
                  color:
                      dt.balQty <= 0 ? Colors.transparent : Colors.lightGreen[50].withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: new BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(dt.skuName ?? '',
                                          style: TextStyle(fontWeight: FontWeight.w700)),
                                      Text(dt.skuCode ?? '',
                                          style:
                                              TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                                      Text(dt.uomDesc ?? '',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12))
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                ),
                                Expanded(
                                  child: grnDt == null
                                      ? Container()
                                      : Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    grnDt.qty.toString() + ' ' + (dt.uomCode ?? ''),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.green[800],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    grnDt.weight.toString() + ' Kg',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.green[800],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: Container()),
                                                Expanded(
                                                  child: Text(
                                                    grnDt.expiredDate,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.green[800],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NewGrnDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dtList = Provider.of<PoViewNotifier>(context)
        .grnDetailList
        .where((d) => d.docDetailId == null)
        .toList();

    if (dtList.length == 0){
      return Container();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("New Item", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          ListView.separated(
            itemCount: dtList.length,
            shrinkWrap: true,
            separatorBuilder: (ctx, index) => Divider(height: 1, thickness: 1),
            itemBuilder: (ctx, index) {

              final dt = dtList[index];

              return Dismissible(
                key: PageStorageKey(dt),
                onDismissed: (direction) {
                  Provider.of<PoViewNotifier>(context, listen: false).removeGrnDetail(dt);
                },
                background: Container(
                  color: Colors.red,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: new BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(dt.skuName ?? '',
                                          style: TextStyle(fontWeight: FontWeight.w700)),
                                      Text(dt.skuCode ?? '',
                                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                                      Text(dt.uomDesc ?? '',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12))
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              dt.qty.toString() + ' ' + (dt.uomCode ?? ''),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green[800],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              dt.weight.toString() + ' Kg',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          Expanded(
                                            child: Text(
                                              dt.expiredDate,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Center(
            child: Text("Swipe left or right to delete", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: RaisedButton.icon(
              icon: Icon(Icons.add),
              label: Text("ADD NEW ITEM"),
              onPressed: () {
                Navigator.push(
                  context,
                  SlideRightRoute(
                    widget: DocPoAddDetailPage(
                      Provider.of<PoViewNotifier>(
                        context,
                        listen: false,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(width: 8),
          Expanded(
            child: RaisedButton(
              child: Text("CREATE GRN"),
              onPressed: () async {
                final check =
                    await Provider.of<PoViewNotifier>(context, listen: false).preSaveGrn();
                if (check) {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text('Create GRN'),
                          content: Text('Are you confirrm ?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: new Text('CANCEL'),
                            ),
                            FlatButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop(true);
                                final success =
                                    await Provider.of<PoViewNotifier>(context, listen: false)
                                        .saveGrn();

                                if (success) {
                                  Provider.of<POListNotifier>(context, listen: false).fetchPoList();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text('EXIT'),
                            ),
                          ],
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<PoViewNotifier>(context, listen: false).errMsgStream.listen((errMsg) {
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
