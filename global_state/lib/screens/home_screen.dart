import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_state/controllers/quotation_controller.dart';
import 'package:global_state/models/quotation.dart';

class HomeScreen extends StatelessWidget {
  final QuotationController controller =
      Get.put(QuotationController());

  HomeScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'aprobada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Cotizaciones'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.quotations.isEmpty) {
          return const Center(
            child: Text(
              "No hay cotizaciones registradas",
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.quotations.length,
          itemBuilder: (context, index) {
            final quotation = controller.quotations[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(
                  quotation.clientName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text("Producto: ${quotation.product}"),
                    Text("Cantidad: ${quotation.quantity}"),
                    Text(
                        "Total: \$${quotation.total.toStringAsFixed(2)}"),
                    Row(
                      children: [
                        const Text("Estado: "),
                        DropdownButton<String>(
                          value: quotation.status,
                          items: const [
                            DropdownMenuItem(
                                value: "pendiente",
                                child: Text("Pendiente")),
                            DropdownMenuItem(
                                value: "aprobada",
                                child: Text("Aprobada")),
                            DropdownMenuItem(
                                value: "cancelada",
                                child: Text("Cancelada")),
                          ],
                          onChanged: (value) {
                            controller.updateStatus(
                                quotation.id, value!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _statusColor(
                            quotation.status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () => controller
                          .deleteQuotation(
                              quotation.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final clientController = TextEditingController();
    final productController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    Get.defaultDialog(
      title: "Nueva Cotización",
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: clientController,
              decoration:
                  const InputDecoration(labelText: "Cliente"),
            ),
            TextField(
              controller: productController,
              decoration:
                  const InputDecoration(labelText: "Producto"),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Cantidad"),
            ),
            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration:
                  const InputDecoration(labelText: "Precio Unitario"),
            ),
          ],
        ),
      ),
      textConfirm: "Guardar",
      textCancel: "Cancelar",
      onConfirm: () {
        final newQuotation = Quotation(
          id: DateTime.now().millisecondsSinceEpoch,
          clientName: clientController.text,
          product: productController.text,
          quantity: int.parse(quantityController.text),
          unitPrice: double.parse(priceController.text),
          status: "pendiente",
        );

        controller.addQuotation(newQuotation);
        Get.back();
      },
    );
  }
}