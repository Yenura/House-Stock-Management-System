import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockorra/services/inventory_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'edit_inventory_screen.dart';

class InventoryListScreen extends StatefulWidget {
  final InventoryService inventoryService;

  const InventoryListScreen({
    super.key,
    required this.inventoryService,
  });

  @override
  _InventoryListScreenState createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  String searchQuery = "";
  String selectedCategory = "All Items";

  Future<void> _generateReport(List<QueryDocumentSnapshot> items) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Storage permission is required to save the report')),
        );
      }
      return;
    }

    final reportData = await widget.inventoryService.getInventoryReport();
    final pdf = pw.Document();

    // Create PDF content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Inventory Report',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text('Total Items: ${reportData['totalItems']}',
                    style: pw.TextStyle(fontSize: 16)),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Category Summary Section
          pw.Header(level: 1, text: 'Category Summary'),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: ['Category', 'Total Items'],
            data: (reportData['categorySummary'] as Map<String, int>)
                .entries
                .map((entry) => [entry.key, entry.value.toString()])
                .toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellHeight: 25,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
            },
          ),
          pw.SizedBox(height: 30),

          // Detailed Items Section
          pw.Header(level: 1, text: 'Detailed Items List'),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: ['Item Name', 'Category', 'Quantity', 'Expiration Date'],
            data: items.map((item) {
              final data = item.data() as Map<String, dynamic>;
              return [
                data['name'] ?? '',
                data['category'] ?? '',
                data['quantity']?.toString() ?? '0',
                data['expiration'] ?? 'N/A',
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
            },
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Report generated on: ${reportData['generatedAt'].toString().split('.')[0]}',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    try {
      // Get the downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory == null) {
        throw Exception('Could not access the downloads directory');
      }

      final fileName =
          'inventory_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      // Save the PDF
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Report saved successfully!'),
                Text('Location: ${file.path}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OUR INVENTORY'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final snapshot = await FirebaseFirestore.instance
                  .collection('inventory')
                  .get();
              await _generateReport(snapshot.docs);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryButton('All Items',
                          isSelected: selectedCategory == 'All Items'),
                      _buildCategoryButton('Groceries'),
                      _buildCategoryButton('Household'),
                      _buildCategoryButton('Electronics'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('inventory')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data['name'].toString().toLowerCase();
                  final category = data['category'].toString();
                  final matchesSearch =
                      name.contains(searchQuery.toLowerCase());
                  final matchesCategory = selectedCategory == "All Items" ||
                      category == selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                return ListView(
                  children: items.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildInventoryItem(doc.id, data);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = text;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildInventoryItem(String docId, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(data['name'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            "Category: ${data['category']}\nQuantity: ${data['quantity']}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditInventoryScreen(
                      docId: docId,
                      initialData: data,
                      inventoryService: widget.inventoryService,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('inventory')
                    .doc(docId)
                    .delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
