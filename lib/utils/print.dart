import 'package:ep_grn/models/doc_grn.dart';
import 'package:ep_grn/modules/user_credential.dart';
import 'package:ep_grn/utils/date_time.dart';

const _lineLimit = 45;
//const _halfLineLimit = 22;
const _lineSeparator = "---------------------------------------------";
//const _halfLineSeparator = "----------------------|----------------------";
const _endLine = "--------------------END----------------------";

class PrintUtil {
  String generateGrnReceipt(DocGrn grn) {
    String s = "";

    s += _fmtLeftLine(grn.companyName);
    s += _fmtLeftLine(grn.companyRegNo);
    s += _fmtLeftLine();
    s += _fmtLeftLine("Good Receive Note");
    s += _fmtLeftLine('Doc No      : ' + grn.docNo);
    s += _fmtLeftLine('Date        : ' + grn.docDate);
    s += _fmtLeftLine('Po Doc No   : ' + (grn.poDocNo ?? ''));
    s += _fmtLeftLine('Supplier    : ' + grn.supplierName);
    s += _fmtLeftLine('Supp Ref No : ' + grn.supplierRefNo);
    s += _fmtLeftLine();
    s += _fmtLeftLine(_lineSeparator);
    s += _fmtLeftLine("Item                       Qty         Weight");
    s += _fmtLeftLine(_lineSeparator);

    double totalWeight = 0;

    grn.details.forEach((d) {
      s += _fmtLeftLine(d.skuCode);
      s += _fmtLeftLine(d.skuName);
      final qty = d.qty.toStringAsFixed(3).padLeft(15, " ");
      final weight = d.weight.toStringAsFixed(3).padLeft(15, " ");

      s += _fmtLeftLine("".padLeft(15, " ") + qty + weight);

      totalWeight += d.weight;
    });
    s += _fmtLeftLine(_lineSeparator);
    s += _fmtLeftLine("Total".padRight(30, " ") + totalWeight.toStringAsFixed(3).padLeft(15, " "));
    s += _fmtLeftLine(_lineSeparator);

    s += _fmtLeftLine("Printed by: " + UserCredentialModule().username);
    s += _fmtLeftLine("Date: " + DateTimeUtil().getCurrentDate());
    s += _fmtLeftLine("Time: " + DateTimeUtil().getCurrentTime());
    s += _fmtLeftLine("-");
    s += _fmtLeftLine("-");
    s += _fmtLeftLine("-");
    s += _fmtLeftLine("-");
    s += _fmtLeftLine("   ---------------        ---------------");
    s += _fmtLeftLine("     Received By            Verified By");
    s += _fmtLeftLine();
    s += _fmtLeftLine(_endLine);
    s += _fmtLeftLine();
    s += _fmtLeftLine();
    s += _fmtLeftLine();

    return s;
  }

  String _fmtLeftLine([String text = ""]) {
    if (text.length > _lineLimit) {
      String s = "";
      final count = (text.length / _lineLimit).ceil();

      for (int i = 0; i < count; i++) {
        int start = i * _lineLimit;
        int end = (i + 1) * _lineLimit;

        if (end > text.length) {
          end = text.length;
        }
        s += text.substring(start, end) + "\n";
      }
      return s;
    } else {
      return text.padRight(_lineLimit) + "\n";
    }
  }

//  String _halfLine([String text = ""]) {
//    if (text.length > _halfLineLimit) {
//      return text.substring(0, _halfLineLimit);
//    } else {
//      return text.padRight(_halfLineLimit);
//    }
//  }
//
//  String _halfRightLine([String text = ""]) {
//    if (text.length > _halfLineLimit) {
//      return text.substring(0, _halfLineLimit);
//    } else {
//      return text.padLeft(_halfLineLimit);
//    }
//  }
}
