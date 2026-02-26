import 'package:get/get.dart';
import 'package:global_state/models/quotation.dart';


class QuotationController extends GetxController {
  var quotations = <Quotation>[].obs;

  void addQuotation(Quotation quotation) {
    quotations.add(quotation);
  }

  void deleteQuotation(int id) {
    quotations.removeWhere((q) => q.id == id);
  }

  void updateStatus(int id, String newStatus) {
    var quotation = quotations.firstWhere((q) => q.id == id);
    quotation.status = newStatus;
    quotations.refresh();
  }
}