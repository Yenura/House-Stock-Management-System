import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UsageChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> usageData;

  const UsageChartWidget({
    super.key,
    required this.usageData,
  });

  @override
  Widget build(BuildContext context) {
    final processedData = _processData(usageData);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Usage Over Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(_createLineChartData(processedData)),
          ),
          const SizedBox(height: 24),
          _buildSummaryStats(processedData),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _processData(List<Map<String, dynamic>> rawData) {
    final Map<String, int> weeklyUsage = {};

    for (var entry in rawData) {
      final timestamp = entry['timestamp'] as Timestamp?;
      if (timestamp == null) continue;

      final date = timestamp.toDate();
      final weekStart = _getWeekStartDate(date);
      final weekKey = DateFormat('yyyy-MM-dd').format(weekStart);

      final quantity = entry['quantity'] as int? ?? 0;
      weeklyUsage[weekKey] = (weeklyUsage[weekKey] ?? 0) + quantity;
    }

    final result = weeklyUsage.entries.map((e) {
      return {
        'week': e.key,
        'usage': e.value,
      };
    }).toList();

    result.sort((a, b) => (a['week'] as String).compareTo(b['week'] as String));
    return result;
  }

  DateTime _getWeekStartDate(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  LineChartData _createLineChartData(List<Map<String, dynamic>> processedData) {
    if (processedData.isEmpty) {
      return LineChartData();
    }

    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: const TextStyle(color: Colors.black54, fontSize: 10),
            ),
            reservedSize: 30,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < processedData.length) {
                final week = processedData[value.toInt()]['week'] as String;
                final date = DateFormat('yyyy-MM-dd').parse(week);
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('MMM d').format(date),
                    style: const TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
            reservedSize: 30,
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.black12),
      ),
      minX: 0,
      maxX: (processedData.length - 1).toDouble(),
      minY: 0,
      maxY: processedData.map((e) => e['usage'] as int).reduce((a, b) => a > b ? a : b) * 1.2,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(processedData.length, (index) {
            return FlSpot(index.toDouble(), (processedData[index]['usage'] as int).toDouble());
          }),
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStats(List<Map<String, dynamic>> processedData) {
    if (processedData.isEmpty) {
      return const SizedBox.shrink();
    }

    final usageValues = processedData.map((e) => e['usage'] as int).toList();
    final total = usageValues.reduce((a, b) => a + b);
    final average = total / usageValues.length;
    final max = usageValues.reduce((a, b) => a > b ? a : b);

    final highestWeekIndex = usageValues.indexOf(max);
    final highestWeek = processedData[highestWeekIndex]['week'] as String;
    final highestWeekDate = DateFormat('yyyy-MM-dd').parse(highestWeek);
    final highestWeekFormatted = DateFormat('MMM d, yyyy').format(highestWeekDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usage Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildStatRow('Total Usage', total.toString()),
            _buildStatRow('Average Weekly Usage', average.toStringAsFixed(1)),
            _buildStatRow('Highest Weekly Usage', max.toString()),
            _buildStatRow('Week of Highest Usage', highestWeekFormatted),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
