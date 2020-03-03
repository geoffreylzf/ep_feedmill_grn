import 'dart:convert';

import 'package:ep_grn/models/doc_grn.dart';
import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/models/doc_po_detail.dart';
import 'package:ep_grn/models/grn.dart';
import 'package:ep_grn/models/grn_detail.dart';
import 'package:ep_grn/models/store.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:ep_grn/utils/print.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class DocPoViewNotifier with ChangeNotifier {
  final DocPo docPO;
  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  bool _isLoading = true;
  List<DocPoDetail> _docPODetailList = [];
  DocPoDetail _selectedDocPODetail;
  List<Store> _storeList = [];
  Store _selectedStore;
  List<GrnDetail> _grnDetailList = [];
  int _docGrnId;

  String refNo = '', remark = '';
  int containerTtl, sampleBagTtl;

  bool get isLoading => _isLoading;

  List<DocPoDetail> get docPODetailList => _docPODetailList;

  DocPoDetail get selectedDocPODetail => _selectedDocPODetail;

  List<Store> get storeList => _storeList;

  Store get selectedStore => _selectedStore;

  List<GrnDetail> get grnDetailList => _grnDetailList;

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _errMsgSubject.close();
    super.dispose();
  }

  DocPoViewNotifier({@required this.docPO}) {
    _init();
  }

  _init() async {
    try {
      final resPODetailList = await Api().dio.get('', queryParameters: {
        'r': 'apiMobileFmGrn/getdata',
        'type': 'po_detail_list',
        'id': docPO.id
      });
      final rpdl = Map<String, dynamic>.from(resPODetailList.data);
      _docPODetailList = List<DocPoDetail>.from(rpdl['list'].map((r) => DocPoDetail.fromJson(r)));

      final resStoreList = await Api()
          .dio
          .get('', queryParameters: {'r': 'apiMobileFmGrn/lookup', 'type': 'store_list'});
      final rsl = Map<String, dynamic>.from(resStoreList.data);
      _storeList = List<Store>.from(rsl['list'].map((r) => Store.fromJson(r)));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
    }
  }

  setSelectedStore(Store store) {
    this._selectedStore = store;
    notifyListeners();
  }

  setSelectedDocPODetail(DocPoDetail docPODetail) {
    this._selectedDocPODetail = docPODetail;
    notifyListeners();
  }

  GrnDetail getGrnDetail(DocPoDetail p) {
    final grn = _grnDetailList.singleWhere((g) {
      return g.docDetailId == p.docDetailId && g.itemPackingId == p.itemPackingId;
    }, orElse: () => null);

    return grn;
  }

  addGrnDetail(GrnDetail grnDetail) {
    _grnDetailList.removeWhere((g) {
      return g.docDetailId == grnDetail.docDetailId && g.itemPackingId == grnDetail.itemPackingId;
    });

    _grnDetailList.add(grnDetail);
    notifyListeners();
  }

  removeGrnDetail(GrnDetail grnDetail) {
    _grnDetailList.removeWhere((g) {
      return g.docDetailId == grnDetail.docDetailId && g.itemPackingId == grnDetail.itemPackingId;
    });
    notifyListeners();
  }

  Future<bool> preSaveGrn() async {
    if (refNo == '' || refNo == null) {
      _errMsgSubject.add('Please enter supplier ref / DO');
      _errMsgSubject.add(null);
      return false;
    }

    if (_selectedStore == null) {
      _errMsgSubject.add('Please select store');
      _errMsgSubject.add(null);
      return false;
    }

    if (containerTtl == 0 || containerTtl == null) {
      _errMsgSubject.add('Please enter container total');
      _errMsgSubject.add(null);
      return false;
    }

    if (sampleBagTtl == 0 || sampleBagTtl == null) {
      _errMsgSubject.add('Please enter container total');
      _errMsgSubject.add(null);
      return false;
    }

    if (remark == '' || remark == null) {
      _errMsgSubject.add('Please enter remark');
      _errMsgSubject.add(null);
      return false;
    }

    if (_grnDetailList.length == 0) {
      _errMsgSubject.add('Please receive atleast 1 item');
      _errMsgSubject.add(null);
      return false;
    }
    return true;
  }

  Future<bool> saveGrn() async {
    final check = await preSaveGrn();
    if (!check) {
      return false;
    }

    final grn = Grn(
      companyId: docPO.companyId,
      docPoId: docPO.id,
      docPoCheckId: docPO.docPoCheckId,
      refNo: refNo,
      storeId: _selectedStore.id,
      containerTtl: containerTtl,
      sampleBagTtl: sampleBagTtl,
      remark: remark,
      details: _grnDetailList,
    );

    _isLoading = true;
    notifyListeners();
    try {
      final grnJson = {'grn': grn.toJson()};
      print(json.encode(grnJson));
      final res = await Api().dio.post(
            '',
            queryParameters: {'r': 'apiMobileFmGrn/saveGrn'},
            data: grnJson,
          );
      final data = Map<String, dynamic>.from(res.data);
      _docGrnId = data['doc_grn_id'];
      Fluttertoast.showToast(msg: "GRN saved");
      return true;
    } catch (e) {
      _errMsgSubject.add(formatApiErrorMsg(e));
      _errMsgSubject.add(null);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> printGrn() async {
    _isLoading = true;
    notifyListeners();
    final response = await Api().dio.get('', queryParameters: {
      'r': 'apiMobileFmGrn/lookup',
      'type': 'grn',
      'id': _docGrnId,
    });
    String s = PrintUtil().generateGrnReceipt(DocGrn.fromJson(response.data));
    _isLoading = false;
    notifyListeners();
    return s;
  }
}
