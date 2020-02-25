import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/models/doc_po_detail.dart';
import 'package:ep_grn/models/store.dart';
import 'package:ep_grn/notifiers/po_view_notifier.dart';
import 'package:ep_grn/utils/node.dart';
import 'package:ep_grn/utils/table.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DocPOIndexPage extends StatefulWidget {
  final DocPO docPO;

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
          create: (_) => POViewNotifier(docPO: widget.docPO),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Purchase Order"),
        ),
        body: Container(
          color: Colors.grey[200],
          child: ListView(
            children: [
              Container(height: 8),
              POHeader(),
              Container(height: 8),
              POHeaderEntry(),
              Container(height: 8),
              PODetail(),
              Container(height: 8),
              ActionButton(),
              Container(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class POHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final po = Provider.of<POViewNotifier>(context).docPO;
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
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
  final remarkTec = TextEditingController();
  final refNoTec = TextEditingController();
  final storeTec = TextEditingController();

  @override
  void dispose() {
    remarkTec.dispose();
    refNoTec.dispose();
    storeTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: refNoTec,
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
                  value: Provider.of<POViewNotifier>(context).selectedStore,
                  onChanged: (v) {
                    Provider.of<POViewNotifier>(context, listen: false).setSelectedStore(v);
                  },
                  items: Provider.of<POViewNotifier>(context).storeList.map(
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
          TextField(
            controller: remarkTec,
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
    final dtList = Provider.of<POViewNotifier>(context).docPODetailList;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dtList.length,
        separatorBuilder: (ctx, index) {
          return Divider();
        },
        itemBuilder: (ctx, index) {
          final dt = dtList[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
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
                            child: Text(
                              dt.skuName,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              dt.uomDesc,
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: PODetailCalculation(dt),
                            ),
                            Container(width: 8),
                            Expanded(
                              flex: 2,
                              child: PODetailEntry(dt),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PODetailCalculation extends StatelessWidget {
  final DocPODetail docPODetail;

  PODetailCalculation(this.docPODetail);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey[300]),
      columnWidths: {
        0: FractionColumnWidth(0.2),
        1: FractionColumnWidth(0.4),
        2: FractionColumnWidth(0.4),
      },
      children: [
        TableRow(children: [
          TableHeaderCell(''),
          TableHeaderCell('Qty (${docPODetail.uomCode})'),
          TableHeaderCell('Weight (Kg)'),
        ]),
        TableRow(children: [
          TableDetailCell("PO"),
          TableDetailCell(docPODetail.qty.toString(), textAlign: TextAlign.right),
          TableDetailCell(docPODetail.weight.toString(), textAlign: TextAlign.right),
        ]),
        TableRow(children: [
          TableDetailCell("GRN"),
          TableDetailCell(docPODetail.grnQty.toString(), textAlign: TextAlign.right),
          TableDetailCell(docPODetail.grnWeight.toString(), textAlign: TextAlign.right),
        ]),
        TableRow(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black))),
          children: [
            TableDetailCell("Bal."),
            TableDetailCell(docPODetail.balQty.toString(), textAlign: TextAlign.right),
            TableDetailCell(docPODetail.balWeight.toString(), textAlign: TextAlign.right),
          ],
        ),
      ],
    );
  }
}

class PODetailEntry extends StatefulWidget {
  final DocPODetail docPODetail;

  PODetailEntry(this.docPODetail);

  @override
  _PODetailEntryState createState() => _PODetailEntryState();
}

class _PODetailEntryState extends State<PODetailEntry> {
  final dateFormat = DateFormat('yyyy-MM-dd');

  final qtyTec = TextEditingController();
  final weightTec = TextEditingController();
  final refWeightTec = TextEditingController();
  final expiredDateTec = TextEditingController();

  @override
  void dispose() {
    qtyTec.dispose();
    weightTec.dispose();
    refWeightTec.dispose();
    expiredDateTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.docPODetail.balQty <= 0) {
      return Container();
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: qtyTec,
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Received Qty",
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            Container(width: 8),
            Expanded(
              child: TextField(
                controller: weightTec,
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Received Weight",
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
        Container(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiredDateTec,
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Expired Date",
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            Container(width: 8),
            Expanded(
              child: TextField(
                controller: refWeightTec,
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ref Weight",
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: RaisedButton(
          child: Text("CONFIRM"),
          onPressed: () {
            print("asasa");
          }),
    );
  }
}
