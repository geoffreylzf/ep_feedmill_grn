import 'package:ep_grn/animation/route_slide_right.dart';
import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/notifiers/doc_po_list_notifier.dart';
import 'package:ep_grn/notifiers/doc_po_view_notifier.dart';
import 'package:ep_grn/pages/doc_po/add_container.dart';
import 'package:ep_grn/pages/doc_po/add_detail.dart';
import 'package:ep_grn/pages/print/index.dart';
import 'package:ep_grn/utils/mixin.dart';
import 'package:ep_grn/utils/table.dart';
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

class _DocPOIndexPageState extends State<DocPOIndexPage>
    with SingleTickerProviderStateMixin, SimpleAlertDialogMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DocPoViewNotifier(this, docPO: widget.docPO),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Purchase Order"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.assignment)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(FontAwesomeIcons.boxes)),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: [
                    Container(height: 8, color: Colors.grey[200]),
                    POHeader(),
                    Container(height: 8, color: Colors.grey[200]),
                    POHeaderEntry(),
                    Container(height: 8, color: Colors.grey[200]),
                    HeadButtonDiv(),
                    Container(height: 8, color: Colors.grey[200]),
                  ],
                ),
                ListView(
                  children: [
                    Container(height: 8, color: Colors.grey[200]),
                    PODetail(),
                    Container(height: 8, color: Colors.grey[200]),
                    NewGrnDetail(),
                    Container(height: 8, color: Colors.grey[200]),
                    DetailButtonDiv(),
                  ],
                ),
                ListView(
                  children: [
                    Container(height: 8, color: Colors.grey[200]),
                    GrnNewContainer(),
                    Container(height: 8, color: Colors.grey[200]),
                    ContainerButtonDiv(),
                  ],
                )
              ],
            ),
            Consumer<DocPoViewNotifier>(
              builder: (ctx, povn, _) {
                return SimpleLoadingDialog(povn.isLoading);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class POHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final po = Provider.of<DocPoViewNotifier>(context).docPO;
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 2, bottom: 2),
                          child: Icon(Icons.location_on, size: 12),
                        ),
                        Text(po.locationName,
                            style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 2, bottom: 2),
                          child: Icon(Icons.timer, size: 12),
                        ),
                        Text(po.tripNo.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ],
                ),
              )
            ],
          ),
          if (po.tripNo % 10 == 1)
            Container(
              margin: const EdgeInsets.all(4),
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  "Trip : " + po.tripNo.toString() + " ~ Sample Needed",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
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
                TableDetailCell(po.truckNo ?? ''),
                TableDetailCell(po.weightBridgeNo ?? ''),
                TableDetailCell(po.remark ?? ''),
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
  final tecRemark = TextEditingController();

  DocPoViewNotifier bloc;

  @override
  void initState() {
    super.initState();
    tecRefNo.addListener(() {
      if (bloc != null) {
        bloc.refNo = tecRefNo.text;
      }
    });

    tecRemark.addListener(() {
      if (bloc != null) {
        bloc.remark = tecRemark.text;
      }
      Provider.of<DocPoViewNotifier>(context, listen: false).remark = tecRemark.text;
    });
  }

  @override
  void dispose() {
    tecRefNo.dispose();
    tecRemark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<DocPoViewNotifier>(context, listen: false);
    if (bloc.refNo != null) {
      tecRefNo.text = bloc.refNo;
    }
    if (bloc.remark != null) {
      tecRemark.text = bloc.remark.toString();
    }

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
                  value: Provider.of<DocPoViewNotifier>(context).selectedStore,
                  onChanged: (v) {
                    Provider.of<DocPoViewNotifier>(context, listen: false).setSelectedStore(v);
                  },
                  items: Provider.of<DocPoViewNotifier>(context).storeList.map(
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
    final dtList = Provider.of<DocPoViewNotifier>(context).docPODetailList;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Purchase Order Detail", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text("* Require Sample", style: TextStyle(fontSize: 10, color: Colors.red)),
                  ],
                ),
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
              final grnDt = Provider.of<DocPoViewNotifier>(context).getGrnDetail(dt);
              return InkWell(
                splashColor: Theme.of(context).accentColor,
                onTap: dt.balQty <= 0
                    ? null
                    : () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        Provider.of<DocPoViewNotifier>(
                          context,
                          listen: false,
                        ).setSelectedDocPODetail(dt);
                        Navigator.push(
                          context,
                          SlideRightRoute(
                            widget: DocPoDetailPage(
                              Provider.of<DocPoViewNotifier>(
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
                                      Text((dt.skuName ?? '') + (dt.isSampleNeed ? " *" : ''),
                                          style: TextStyle(fontWeight: FontWeight.w700,
                                          color: dt.isSampleNeed ? Colors.red : Colors.black)),
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
                                  child: dt.balQty <= 0
                                      ? Center(
                                          child: Container(
                                            color: Colors.red[100],
                                            padding: const EdgeInsets.all(8),
                                            child: Text('Fully Received'),
                                          ),
                                        )
                                      : (grnDt == null
                                          ? Container()
                                          : Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        grnDt.qty.toString() +
                                                            ' ' +
                                                            (dt.uomCode ?? ''),
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
                                                    Expanded(
                                                      child: Text(
                                                        grnDt.manufactureDate,
                                                        textAlign: TextAlign.right,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.green[800],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        grnDt.expireDate,
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
                                                    Expanded(
                                                      child: Text(
                                                        grnDt.sampleBagTtl.toString() + ' S.Bg',
                                                        textAlign: TextAlign.right,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.green[800],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
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
    final dtList = Provider.of<DocPoViewNotifier>(context)
        .grnDetailList
        .where((d) => d.docDetailId == null)
        .toList();

    if (dtList.length == 0) {
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
                  Provider.of<DocPoViewNotifier>(context, listen: false).removeGrnDetail(dt);
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
                                          style:
                                              TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
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
                                          Expanded(
                                            child: Text(
                                              dt.manufactureDate,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green[800],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              dt.expireDate,
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
                                          Expanded(
                                            child: Text(
                                              dt.sampleBagTtl.toString() + ' S.Bg',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green[800],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(),
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
            child: Text("Swipe left or right to delete",
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class HeadButtonDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              child: Text("CREATE GRN"),
              onPressed: () async {
                final check =
                    await Provider.of<DocPoViewNotifier>(context, listen: false).preSaveGrn();
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
                                    await Provider.of<DocPoViewNotifier>(context, listen: false)
                                        .saveGrn();

                                if (success) {
                                  Provider.of<DocPoListNotifier>(context, listen: false)
                                      .fetchPoList();

                                  final s =
                                      await Provider.of<DocPoViewNotifier>(context, listen: false)
                                          .printGrn();

                                  Navigator.pushReplacement(
                                    context,
                                    SlideRightRoute(widget: PrintIndexPage(s)),
                                  );
                                }
                              },
                              child: Text('CREATE'),
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

class DetailButtonDiv extends StatelessWidget {
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
                      Provider.of<DocPoViewNotifier>(
                        context,
                        listen: false,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerButtonDiv extends StatelessWidget {
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
              label: Text("ADD NEW CONTAINER"),
              onPressed: () {
                Navigator.push(
                  context,
                  SlideRightRoute(
                    widget: DocPoAddContainerPage(
                      Provider.of<DocPoViewNotifier>(
                        context,
                        listen: false,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GrnNewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cList = Provider.of<DocPoViewNotifier>(context).grnContainerList;

    if (cList.length == 0) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("New Container", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          ListView.separated(
            itemCount: cList.length,
            shrinkWrap: true,
            separatorBuilder: (ctx, index) => Divider(height: 1, thickness: 1),
            itemBuilder: (ctx, index) {
              final c = cList[index];

              return Dismissible(
                key: PageStorageKey(c),
                onDismissed: (direction) {
                  Provider.of<DocPoViewNotifier>(context, listen: false).removeGrnContainer(c);
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(c.containerName ?? '',
                                      style: TextStyle(fontWeight: FontWeight.w700)),
                                  Text(c.containerCode ?? '',
                                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            Expanded(
                              child: Center(child: Text(c.containerNo ?? '', style: TextStyle())),
                            )
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
            child: Text("Swipe left or right to delete",
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
