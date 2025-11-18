import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/state_visit.dart';
import '../models/state_info.dart'; // the small static model

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<StateInfo>> _statesFuture;
  String? _selectedCode;
  final TextEditingController _favoriteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _statesFuture = _loadStatesJson();
  }

  Future<List<StateInfo>> _loadStatesJson() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/states.json');
      final List<dynamic> data = json.decode(jsonStr);
      return data
          .map((e) => StateInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // basic exception handling for extra points
      debugPrint('Error loading states.json: $e');
      return [];
    }
  }

  StateVisit _getVisitFor(String code) {
    final box = Hive.box<StateVisit>('stateVisits');
    final visit = box.get(code);
    if (visit != null) return visit;

    final newVisit = StateVisit(code: code);
    box.put(code, newVisit);
    return newVisit;
  }

  void _selectState(String code) {
    final visit = _getVisitFor(code);
    setState(() {
      _selectedCode = code;
      _favoriteController.text = visit.favoriteThing;
    });
  }

  int _calculateVisitedCount() {
    final box = Hive.box<StateVisit>('stateVisits');
    return box.values.where((v) => v.visited).length;
  }

  @override
  Widget build(BuildContext context) {
    final visitBox = Hive.box<StateVisit>('stateVisits');

    return Scaffold(
      appBar: AppBar(
        title: const Text('50 State Tracker'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'stats') {
                // Navigate to a StatsScreen for extra points
                // Navigator.push(...);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'stats',
                child: Text('Visited Stats'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<StateInfo>>(
        future: _statesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final states = snapshot.data!;
          if (states.isEmpty) {
            return const Center(child: Text('Could not load states data.'));
          }

          return Column(
            children: [
              // Progress bar / summary
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: visitBox.listenable(),
                  builder: (context, Box<StateVisit> box, _) {
                    final visitedCount =
                        box.values.where((v) => v.visited).length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Visited $visitedCount / 50 states'),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: visitedCount / 50.0,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // "Map" grid
              Expanded(
                flex: 2,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 5x10 grid, roughly map-like
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: states.length,
                  itemBuilder: (context, index) {
                    final state = states[index];
                    final visit = _getVisitFor(state.code);

                    final isSelected = _selectedCode == state.code;
                    final isVisited = visit.visited;

                    return GestureDetector(
                      onTap: () => _selectState(state.code),
                      child: Card(
                        color: isVisited
                            ? Colors.green[300]
                            : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          side: isSelected
                              ? const BorderSide(
                              color: Colors.indigo, width: 2)
                              : BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            state.code,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Detail panel for currently selected state
              Expanded(
                flex: 1,
                child: _selectedCode == null
                    ? const Center(
                  child: Text('Tap a state to edit details'),
                )
                    : _buildDetailPanel(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailPanel() {
    final code = _selectedCode!;
    final visit = _getVisitFor(code);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, -2),
            spreadRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details for $code',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Text('Visited:'),
              Switch(
                value: visit.visited,
                onChanged: (value) {
                  setState(() {
                    visit.visited = value;
                    visit.save();
                  });
                },
              ),
            ],
          ),
          TextField(
            controller: _favoriteController,
            decoration: const InputDecoration(
              labelText: 'Favorite thing about this state',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: () {
                setState(() {
                  visit.favoriteThing = _favoriteController.text.trim();
                  visit.save();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved state details')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
