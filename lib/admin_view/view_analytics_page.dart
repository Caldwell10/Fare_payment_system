import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ViewAnalyticsPage extends StatefulWidget {
  const ViewAnalyticsPage({super.key});

  @override
  _ViewAnalyticsPageState createState() => _ViewAnalyticsPageState();
}

class _ViewAnalyticsPageState extends State<ViewAnalyticsPage> {
  final List<String> collections = [
    'users',
    'transactions',
    'support_tickets',
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Analytics'),
        backgroundColor: const Color.fromARGB(255, 188, 179, 179),
      ),
      body: ListView.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          return _buildCollectionChart(collections[index]);
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildCollectionChart(String collectionName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data found.'));
        }

        final data = snapshot.data!.docs;
        final pieData = _createPieData(data);
        final lineData = _createLineData(data);

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                collectionName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: pieData,
                  centerSpaceRadius: 50,
                  sectionsSpace: 4,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  lineBarsData: lineData,
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  lineTouchData: LineTouchData(enabled: true),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _createPieData(List<QueryDocumentSnapshot> data) {
    return List.generate(data.length, (index) {
      final doc = data[index];
      final metric = doc['metric'] ?? 'Metric $index';
      final value = doc['value'] ?? 0;
      print('Pie data - metric: $metric, value: $value');
      return PieChartSectionData(
        value: (value is int ? value.toDouble() : value) ?? 0.0,
        title: '$metric: $value',
        color: Colors.primaries[index % Colors.primaries.length],
        radius: 100,
      );
    });
  }

  List<LineChartBarData> _createLineData(List<QueryDocumentSnapshot> data) {
    final spots = data.map((doc) {
      final date = (doc['date'] as Timestamp?)?.toDate() ?? DateTime.now();
      final value = doc['value'] ?? 0;
      print('Line data - date: $date, value: $value');
      return FlSpot(date.millisecondsSinceEpoch.toDouble(), (value is int ? value.toDouble() : value) ?? 0.0);
    }).toList();

    return [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: const Color.fromARGB(255, 89, 104, 117),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
      ),
    ];
  }
}
