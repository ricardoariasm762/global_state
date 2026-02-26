class Quotation {
  int id;
  String clientName;
  String product;
  int quantity;
  double unitPrice;
  String status; // pendiente, aprobada, cancelada

  Quotation({
    required this.id,
    required this.clientName,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.status,
  });

  double get total => quantity * unitPrice;
}