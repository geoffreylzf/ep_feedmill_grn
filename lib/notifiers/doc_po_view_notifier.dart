import 'dart:convert';

import 'package:ep_grn/models/doc_grn.dart';
import 'package:ep_grn/models/doc_po.dart';
import 'package:ep_grn/models/doc_po_container.dart';
import 'package:ep_grn/models/doc_po_detail.dart';
import 'package:ep_grn/models/grn.dart';
import 'package:ep_grn/models/grn_container.dart';
import 'package:ep_grn/models/grn_detail.dart';
import 'package:ep_grn/models/store.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:ep_grn/utils/mixin.dart';
import 'package:ep_grn/utils/print.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DocPoViewNotifier with ChangeNotifier {
  final DocPo docPO;

  bool _isLoading = true;
  List<DocPoDetail> _docPoDetailList = [];
  List<DocPoContainer> _docPoContainerList = [];
  DocPoDetail _selectedDocPODetail;
  List<Store> _storeList = [];
  Store _selectedStore;
  List<GrnDetail> _grnDetailList = [];
  List<GrnContainer> _grnContainerList = [];
  int _docGrnId;

  String refNo = '', remark = '';

  bool get isLoading => _isLoading;

  List<DocPoDetail> get docPODetailList => _docPoDetailList;

  List<DocPoContainer> get docPoContainerList => _docPoContainerList;

  DocPoDetail get selectedDocPODetail => _selectedDocPODetail;

  List<Store> get storeList => _storeList;

  Store get selectedStore => _selectedStore;

  List<GrnDetail> get grnDetailList => _grnDetailList;

  List<GrnContainer> get grnContainerList => _grnContainerList;

  final SimpleAlertDialogMixin mixin;

  DocPoViewNotifier(this.mixin, {@required this.docPO}) {
    _init();
  }

  _init() async {
    try {
      final resPODetailList = await Api().dio.get('', queryParameters: {
        'r': 'apiMobileFmGrn/getdata',
        'type': 'po_detail_container_list',
        'id': docPO.id
      });
      final rpdl = Map<String, dynamic>.from(resPODetailList.data);
      _docPoDetailList =
          List<DocPoDetail>.from(rpdl['detail_list'].map((r) => DocPoDetail.fromJson(r)));

      _docPoContainerList = List<DocPoContainer>.from(rpdl['container'
              '_list']
          .map((r) => DocPoContainer.fromJson(r)));

      final resStoreList = await Api()
          .dio
          .get('', queryParameters: {'r': 'apiMobileFmGrn/lookup', 'type': 'store_list'});
      final rsl = Map<String, dynamic>.from(resStoreList.data);
      _storeList = List<Store>.from(rsl['list'].map((r) => Store.fromJson(r)));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      mixin.onDialogMessage('Error', formatApiErrorMsg(e));
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

  addGrnContainer(GrnContainer grnContainer) {
    _grnContainerList.removeWhere((g) {
      return g.containerNo == grnContainer.containerNo;
    });

    _grnContainerList.add(grnContainer);
    notifyListeners();
  }

  removeGrnContainer(GrnContainer grnContainer) {
    _grnContainerList.removeWhere((g) {
      return g.containerNo == grnContainer.containerNo;
    });

    notifyListeners();
  }

  Future<bool> preSaveGrn() async {
    if (refNo == '' || refNo == null) {
      mixin.onDialogMessage('Error', 'Please enter supplier ref / DO');
      return false;
    }

    if (_selectedStore == null) {
      mixin.onDialogMessage('Error', 'Please Please select store');
      return false;
    }

    if (_grnDetailList.length == 0) {
      mixin.onDialogMessage('Error', 'Please receive atleast 1 item');
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
      remark: remark,
      details: _grnDetailList,
      containers: _grnContainerList
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
      print(data['doc_grn_id'].runtimeType.toString());
      _docGrnId = data['doc_grn_id'];
      Fluttertoast.showToast(msg: "GRN saved");
      return true;
    } catch (e) {
      mixin.onDialogMessage('Error', formatApiErrorMsg(e));
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
