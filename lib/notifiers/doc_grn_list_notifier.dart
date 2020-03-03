import 'package:ep_grn/models/doc_grn.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:ep_grn/utils/print.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

class DocGrnListNotifier with ChangeNotifier {
  bool _isLoading = false;
  bool _isGeneratingReceipt = false;
  int _page = 1;
  String _filter = "";
  List<DocGrn> _docGrnList = [];
  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  bool get isLoading => _isLoading;

  bool get isGeneratingReceipt => _isGeneratingReceipt;

  int get page => _page;

  List<DocGrn> get docGrnList => _docGrnList;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _errMsgSubject.close();
    super.dispose();
  }

  DocGrnListNotifier() {
    fetchDocGrnList();
  }

  fetchDocGrnList({String filter = ''}) async {
    try {
      _docGrnList = [];
      _isLoading = true;
      _filter = filter;
      notifyListeners();
      final response = await Api().dio.get('', queryParameters: {
        'r': 'apiMobileFmGrn/lookup',
        'type': 'grn_list',
        'filter': _filter,
      });
      final data = Map<String, dynamic>.from(response.data);
      _docGrnList = List<DocGrn>.from(data['list'].map((r) => DocGrn.fromJson(r)));
      _page = 1;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }

  refreshDocGrnList() async {
    try {
      _isLoading = true;
      notifyListeners();
      _page = 1;
      final response = await Api().dio.get('', queryParameters: {
        'r': 'apiMobileFmGrn/lookup',
        'type': 'grn_list',
        'page': _page,
        'filter': _filter,
      });
      final data = Map<String, dynamic>.from(response.data);
      _docGrnList = List<DocGrn>.from(data['list'].map((r) => DocGrn.fromJson(r)));
      _page = 1;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }

  fetchNextGrnList() async {
    try {
      _isLoading = true;
      notifyListeners();
      _page++;
      final response = await Api().dio.get('', queryParameters: {
        'r': 'apiMobileFmGrn/lookup',
        'type': 'grn_list',
        'page': _page,
        'filter': _filter,
      });
      final data = Map<String, dynamic>.from(response.data);
      _docGrnList = [
        ..._docGrnList,
        ...List<DocGrn>.from(data['list'].map((r) => DocGrn.fromJson(r)))
      ];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }

  Future<String> printGrn(int id) async {
    _isGeneratingReceipt = true;
    notifyListeners();
    final response = await Api().dio.get('', queryParameters: {
      'r': 'apiMobileFmGrn/lookup',
      'type': 'grn',
      'id': id,
    });
    String s = PrintUtil().generateGrnReceipt(DocGrn.fromJson(response.data));
    _isGeneratingReceipt = false;
    notifyListeners();
    return s;
  }
}
