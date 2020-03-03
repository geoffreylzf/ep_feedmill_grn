import 'dart:async';

import 'package:ep_grn/animation/route_slide_right.dart';
import 'package:ep_grn/notifiers/doc_grn_list_notifier.dart';
import 'package:ep_grn/pages/print/index.dart';
import 'package:ep_grn/widgets/simple_alert_dialog.dart';
import 'package:ep_grn/widgets/simple_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocGrnIndexPage extends StatefulWidget {
  @override
  _DocGrnIndexPageState createState() => _DocGrnIndexPageState();
}

class _DocGrnIndexPageState extends State<DocGrnIndexPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DocGrnListNotifier(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Good Receive Note List"),
        ),
        body: Stack(children: [
          Column(
            children: [
              DocGrnFilter(),
              Expanded(child: DocGrnRefresher()),
            ],
          ),
          _ErrorMessage(),
          Consumer<DocGrnListNotifier>(
            builder: (ctx, bloc, _) {
              return SimpleLoadingDialog(bloc.isGeneratingReceipt);
            },
          ),
        ]),
      ),
    );
  }
}

class DocGrnFilter extends StatefulWidget {
  @override
  _DocGrnFilterState createState() => _DocGrnFilterState();
}

class _DocGrnFilterState extends State<DocGrnFilter> {
  final tecFilter = TextEditingController();
  Timer _debounce;
  DocGrnListNotifier bloc;
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
            bloc.fetchDocGrnList(filter: filterText);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<DocGrnListNotifier>(context, listen: false);
    return Padding(
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
    );
  }
}

class DocGrnRefresher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await Provider.of<DocGrnListNotifier>(context, listen: false).refreshDocGrnList();
      },
      child: DocGrnList(),
    );
  }
}


class DocGrnList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<DocGrnListNotifier>(context).isLoading;
    final docGrnList = Provider.of<DocGrnListNotifier>(context).docGrnList;
    return ListView.separated(
      itemCount: docGrnList.length + 1,
      separatorBuilder: (ctx, index) {
        return Divider(height: 1);
      },
      itemBuilder: (ctx, index) {
        if (index == docGrnList.length) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton.icon(
              icon: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(height: 36, width: 36, child: CircularProgressIndicator()),
                    )
                  : Icon(Icons.navigate_next, size: 56),
              label: Text("LOAD NEXT PAGE", style: TextStyle(fontSize: 20)),
              onPressed: isLoading
                  ? null
                  : () {
                      Provider.of<DocGrnListNotifier>(context, listen: false).fetchNextGrnList();
                    },
            ),
          );
        }
        final dt = docGrnList[index];
        return InkWell(
          onTap: () async {
            await Future.delayed(Duration(milliseconds: 100));
            final s = await Provider.of<DocGrnListNotifier>(context, listen: false).printGrn(dt.id);
            Navigator.push(
              context,
              SlideRightRoute(widget: PrintIndexPage(s)),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dt.docNo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(dt.docDate, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(dt.supplierName, textAlign: TextAlign.right),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<DocGrnListNotifier>(context, listen: false).errMsgStream.listen((errMsg) {
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
