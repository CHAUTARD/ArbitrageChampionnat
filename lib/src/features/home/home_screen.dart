import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/home/add_match_screen.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/src/widgets/match_card.dart';
import 'package:myapp/src/widgets/theme_toggle_button.dart';
import 'package:myapp/src/core/theme/theme_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final matchesStream = ref.watch(matchServiceProvider).getMatches();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Scores'),
        actions: [ThemeToggleButton(themeProvider: themeNotifier)],
      ),
      body: StreamBuilder<List<Match>>(
        stream: matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No matches found.'));
          }

          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return MatchCard(match: matches[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMatchScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
