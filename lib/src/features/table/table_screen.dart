
// lib/src/features/table/table_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';

class TableScreen extends StatefulWidget {
  final Partie partie;

  const TableScreen({super.key, required this.partie});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  int score1 = 0;
  int score2 = 0;

  void _incrementScore(int team) {
    setState(() {
      if (team == 1) {
        score1++;
      } else {
        score2++;
      }
    });
  }

  void _decrementScore(int team) {
    setState(() {
      if (team == 1 && score1 > 0) {
        score1--;
      } else if (team == 2 && score2 > 0) {
        score2--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final team1Name = widget.partie.team1Players.map((p) => p.name).join(', ');
    final team2Name = widget.partie.team2Players.map((p) => p.name).join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.partie.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildScoreCard(team: 1, name: team1Name, score: score1),
            const Text('VS', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey)),
            _buildScoreCard(team: 2, name: team2Name, score: score2),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard({required int team, required String name, required int score}) {
    return Expanded(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: team == 1 ? Colors.blue[50] : Colors.red[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: team == 1 ? Colors.blue[800] : Colors.red[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              '$score',
              style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _incrementScore(team),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  child: const Icon(Icons.add, size: 30, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () => _decrementScore(team),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  child: const Icon(Icons.remove, size: 30, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
