import 'package:ep_grn/models/grn_container.dart';
import 'package:ep_grn/notifiers/doc_po_view_notifier.dart';
import 'package:ep_grn/notifiers/grn_add_container_notifier.dart';
import 'package:ep_grn/widgets/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocPoAddContainerPage extends StatefulWidget {
  final DocPoViewNotifier poViewNotifier;

  const DocPoAddContainerPage(this.poViewNotifier);

  @override
  _DocPoAddContainerPageState createState() => _DocPoAddContainerPageState();
}

class _DocPoAddContainerPageState extends State<DocPoAddContainerPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.poViewNotifier),
        ChangeNotifierProvider(
          create: (_) => GrnAddContainerNotifier(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New Container"),
        ),
        body: Stack(
          children: [
            Row(
              children: [
                Expanded(child: ContainerSelection()),
                VerticalDivider(width: 0),
                Expanded(child: DetailForm()),
              ],
            ),
            _ErrorMessage(),
          ],
        ),
      ),
    );
  }
}

class ContainerSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedContainer = Provider.of<GrnAddContainerNotifier>(context).selectedContainer;
    final containerList = Provider.of<DocPoViewNotifier>(context).docPoContainerList;
    final bloc = Provider.of<GrnAddContainerNotifier>(context, listen: false);

    if (containerList.length == 0) {
      return Center(child: Text("No container "));
    }

    return ListView.separated(
      itemCount: containerList.length,
      separatorBuilder: (ctx, index) => Divider(height: 0),
      itemBuilder: (ctx, i) {
        final c = containerList[i];
        final isSelected = c == selectedContainer;
        final bgColor =
            isSelected ? Theme.of(ctx).primaryColorLight : Theme.of(ctx).scaffoldBackgroundColor;

        return Container(
          color: bgColor,
          child: ListTile(
            onTap: () {
              if (isSelected) {
                bloc.setSelectedContainer(null);
              } else {
                bloc.setSelectedContainer(c);
              }
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.containerName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text(
                  c.containerCode,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                )
              ],
            ),
            trailing: Checkbox(
              value: c == selectedContainer,
              onChanged: (b) {
                bloc.setSelectedContainer(c);
              },
            ),
          ),
        );
      },
    );
  }
}

class DetailForm extends StatefulWidget {
  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  final _formKey = GlobalKey<FormState>();
  final tecContainerNo = TextEditingController();

  @override
  void dispose() {
    tecContainerNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedContainer = Provider.of<GrnAddContainerNotifier>(context).selectedContainer;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: tecContainerNo,
              autofocus: true,
              maxLength: 20,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Container No",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Cannot blank";
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
                    final gc = GrnContainer(
                      containerId: selectedContainer?.containerId,
                      containerNo: tecContainerNo.text.toString(),
                      containerCode: selectedContainer?.containerCode,
                      containerName: selectedContainer?.containerName,
                    );
                    Provider.of<DocPoViewNotifier>(context, listen: false).addGrnContainer(gc);
                    Navigator.of(context).pop();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<GrnAddContainerNotifier>(context, listen: false).errMsgStream.listen((errMsg) {
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
