import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class POListNotifier with ChangeNotifier {
  bool _isLoading = false;
  List<DocPO> _docPOList = [];

  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  bool get isLoading => _isLoading;

  List<DocPO> get docPOList => _docPOList;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _errMsgSubject.close();
    super.dispose();
  }

  POListNotifier() {
    refreshPOList();
  }

  refreshPOList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await Api().dio.get('', queryParameters: {
        'r': 'apiMobileFmGrn/getdata',
        'type': 'po',
      });
      final data = Map<String, dynamic>.from(response.data);
      final poList = List<DocPO>.from(data['list'].map((r) => DocPO.fromJson(r)));
      _docPOList = poList;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }
}
