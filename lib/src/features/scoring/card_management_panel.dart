// lib/src/features/scoring/card_management_panel.dart

// Ce widget affiche une table de gestion des cartons pour les joueurs d'une partie.
// Il permet de visualiser et de modifier l'état des cartons blancs, jaunes, orange (jaune+rouge+) et rouges pour chaque joueur.
// Le widget interagit avec le `CardSanctionService` pour récupérer et mettre à jour
// les données de cartons, et notifie les changements à travers des callbacks.


import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/card_sanction_service.dart';

class CardManagementPanel extends StatefulWidget {
  final Partie partie;
  final List<Player> team1Players;
  final List<Player> team2Players;
  final ValueChanged<bool>? onWhiteCardStateChanged;
  final ValueChanged<Map<String, bool>>? onWhiteByTeamChanged;
  final ValueChanged<Map<String, PlayerPersistentCards>>?
  onPersistentCardsChanged;

  const CardManagementPanel({
    super.key,
    required this.partie,
    required this.team1Players,
    required this.team2Players,
    this.onWhiteCardStateChanged,
    this.onWhiteByTeamChanged,
    this.onPersistentCardsChanged,
  });

  @override
  State<CardManagementPanel> createState() => _CardManagementPanelState();
}

class _CardManagementPanelState extends State<CardManagementPanel> {
  final CardSanctionService _cardService = CardSanctionService();
  bool _isLoading = true;

  Map<String, PlayerPersistentCards> _persistentByPlayer = {};
  Map<String, bool> _whiteByPlayer = {};
  bool _whiteTeam1Given = false;
  bool _whiteTeam2Given = false;

  bool get _isDouble => widget.partie.isDouble;

  List<Player> get _allPlayers => [
    ...widget.team1Players,
    ...widget.team2Players,
  ];

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final partieId = widget.partie.id;
    if (partieId == null) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final playerIds = _allPlayers.map((player) => player.id).toList();
    final persistent = await _cardService.getPlayersPersistentCards(playerIds);
    final whiteByPlayer = <String, bool>{};
    for (final player in _allPlayers) {
      whiteByPlayer[player.id] = await _cardService.hasWhiteForPlayer(partieId, player.id);
    }

    final whiteTeam1 = await _cardService.hasWhiteForTeam(partieId, 1);
    final whiteTeam2 = await _cardService.hasWhiteForTeam(partieId, 2);
    final hasAnyWhite = whiteTeam1 || whiteTeam2 || whiteByPlayer.values.any((value) => value);

    final bool whiteByTeam1ForDisplay = _isDouble
      ? whiteTeam1
      : widget.team1Players.any((player) => whiteByPlayer[player.id] == true);
    final bool whiteByTeam2ForDisplay = _isDouble
      ? whiteTeam2
      : widget.team2Players.any((player) => whiteByPlayer[player.id] == true);

    if (!mounted) return;
    setState(() {
      _persistentByPlayer = persistent;
      _whiteByPlayer = whiteByPlayer;
      _whiteTeam1Given = whiteTeam1;
      _whiteTeam2Given = whiteTeam2;
      _isLoading = false;
    });
    widget.onWhiteCardStateChanged?.call(hasAnyWhite);
    widget.onWhiteByTeamChanged?.call({
      'team1': whiteByTeam1ForDisplay,
      'team2': whiteByTeam2ForDisplay,
    });
    widget.onPersistentCardsChanged?.call(Map<String, PlayerPersistentCards>.from(persistent));
  }

  Future<void> _giveWhiteToPlayer(Player player) async {
    final partieId = widget.partie.id;
    if (partieId == null) return;
    await _cardService.giveWhiteToPlayer(partieId, player.id);
    await _loadState();
  }

  Future<void> _giveWhiteToTeam(int teamNumber) async {
    final partieId = widget.partie.id;
    if (partieId == null) return;
    await _cardService.giveWhiteToTeam(partieId, teamNumber);
    await _loadState();
  }

  Future<void> _givePersistentCard(Player player, PersistentCardType cardType) async {
    await _cardService.givePersistentCard(player.id, cardType);
    await _loadState();
  }

  Future<void> _removePersistentCard(
    Player player,
    PersistentCardType cardType,
  ) async {
    await _cardService.removePersistentCard(player.id, cardType);
    await _loadState();
  }

  Future<void> _removeWhiteForPlayer(Player player) async {
    final partieId = widget.partie.id;
    if (partieId == null) return;
    await _cardService.removeWhiteForPlayer(partieId, player.id);
    await _loadState();
  }

  Future<void> _removeWhiteForTeam(int teamNumber) async {
    final partieId = widget.partie.id;
    if (partieId == null) return;
    await _cardService.removeWhiteForTeam(partieId, teamNumber);
    await _loadState();
  }

  String _persistentCardLabel(PersistentCardType type) {
    switch (type) {
      case PersistentCardType.yellow:
        return 'Jaune';
      case PersistentCardType.yellowRedPlus:
        return 'Jaune + Rouge';
      case PersistentCardType.red:
        return 'Rouge';
    }
  }

  PersistentCardType? _highestGivenPersistentCard(PlayerPersistentCards state) {
    if (state.red) return PersistentCardType.red;
    if (state.yellowRedPlus) return PersistentCardType.yellowRedPlus;
    if (state.yellow) return PersistentCardType.yellow;
    return null;
  }

  bool _canRemovePersistentCard(
    PlayerPersistentCards state,
    PersistentCardType cardType,
  ) {
    switch (cardType) {
      case PersistentCardType.red:
        return state.red;
      case PersistentCardType.yellowRedPlus:
        return state.yellowRedPlus && !state.red;
      case PersistentCardType.yellow:
        return state.yellow && !state.red && !state.yellowRedPlus;
    }
  }

  bool _isLowerRankDisabled(
    PlayerPersistentCards state,
    PersistentCardType cardType,
  ) {
    switch (cardType) {
      case PersistentCardType.red:
        return false;
      case PersistentCardType.yellowRedPlus:
        return state.red;
      case PersistentCardType.yellow:
        return state.red || state.yellowRedPlus;
    }
  }

  Future<bool> _confirmRemoval({
    required String cardLabel,
    required String targetLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text('Supprimer le carton $cardLabel de $targetLabel ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
    return result == true;
  }

  Future<void> _handleWhiteCardTap(Player player) async {
    final isTeam1 = _isPlayerInTeam1(player);
    final isGiven = _isDouble
        ? (isTeam1 ? _whiteTeam1Given : _whiteTeam2Given)
        : (_whiteByPlayer[player.id] == true);

    if (!isGiven) {
      if (_isDouble) {
        await _giveWhiteToTeam(isTeam1 ? 1 : 2);
      } else {
        await _giveWhiteToPlayer(player);
      }
      return;
    }

    final targetLabel = _isDouble
        ? 'équipe ${isTeam1 ? 1 : 2}'
        : player.name;
    final confirmed = await _confirmRemoval(
      cardLabel: 'Blanc',
      targetLabel: targetLabel,
    );
    if (!confirmed) return;

    if (_isDouble) {
      await _removeWhiteForTeam(isTeam1 ? 1 : 2);
    } else {
      await _removeWhiteForPlayer(player);
    }
  }

  Future<void> _handlePersistentCardTap(
    Player player,
    PersistentCardType cardType,
  ) async {
    final state = _persistentByPlayer[player.id] ?? const PlayerPersistentCards();
    final isGiven = state.isGiven(cardType);

    if (!isGiven) {
      await _givePersistentCard(player, cardType);
      return;
    }

    if (!_canRemovePersistentCard(state, cardType)) {
      final highest = _highestGivenPersistentCard(state);
      final nextAllowed = highest == null ? '' : _persistentCardLabel(highest);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Suppression autorisée du plus grave au moins grave. Retirez d\'abord $nextAllowed.',
          ),
        ),
      );
      return;
    }

    final confirmed = await _confirmRemoval(
      cardLabel: _persistentCardLabel(cardType),
      targetLabel: player.name,
    );
    if (!confirmed) return;

    await _removePersistentCard(player, cardType);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Gestion des cartons',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            _buildPersistentCardsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersistentCardsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 18,
        horizontalMargin: 8,
        headingRowHeight: 0,
        columns: const [
          DataColumn(label: Text('Joueur')),
          DataColumn(label: Text('Blanc')),
          DataColumn(label: Text('Jaune')),
          DataColumn(label: Text('Orange')),
          DataColumn(label: Text('Rouge')),
        ],
        rows: _allPlayers.map((player) {
          final state =
              _persistentByPlayer[player.id] ?? const PlayerPersistentCards();

          return DataRow(
            cells: [
              DataCell(Text(player.name)),
              DataCell(
                _buildCardRectangle(
                  assetPath: 'assets/icon/Blanc.png',
                  isGiven: _isDouble
                      ? (_isPlayerInTeam1(player)
                          ? _whiteTeam1Given
                          : _whiteTeam2Given)
                      : (_whiteByPlayer[player.id] == true),
                  onTap: () => _handleWhiteCardTap(player),
                  tooltip: 'Blanc',
                ),
              ),
              DataCell(
                _buildCardRectangle(
                  assetPath: 'assets/icon/Jaune.png',
                  isGiven: state.yellow,
                  onTap: _isLowerRankDisabled(state, PersistentCardType.yellow)
                      ? null
                      : () => _handlePersistentCardTap(
                        player,
                        PersistentCardType.yellow,
                      ),
                  tooltip: 'Jaune',
                ),
              ),
              DataCell(
                _buildCardRectangle(
                  assetPath: 'assets/icon/Orange.png',
                  isGiven: state.yellowRedPlus,
                  onTap: _isLowerRankDisabled(
                    state,
                    PersistentCardType.yellowRedPlus,
                  )
                      ? null
                      : () => _handlePersistentCardTap(
                        player,
                        PersistentCardType.yellowRedPlus,
                      ),
                  tooltip: 'Jaune+Rouge+',
                ),
              ),
              DataCell(
                _buildCardRectangle(
                  assetPath: 'assets/icon/Rouge.png',
                  isGiven: state.red,
                  onTap: () =>
                      _handlePersistentCardTap(player, PersistentCardType.red),
                  tooltip: 'Rouge',
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  bool _isPlayerInTeam1(Player player) {
    return widget.team1Players.any((teamPlayer) => teamPlayer.id == player.id);
  }

  Widget _buildCardRectangle({
    required String assetPath,
    required bool isGiven,
    required VoidCallback? onTap,
    required String tooltip,
  }) {
    final isDisabled = onTap == null;
    return Tooltip(
      message: isDisabled
          ? '$tooltip désactivé (carton supérieur actif)'
          : (isGiven
              ? '$tooltip déjà donné (appuyer pour supprimer)'
              : 'Donner $tooltip'),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 44,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87, width: 1.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: isDisabled ? 0.35 : (isGiven ? 0.75 : 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                  ),
                )
              ),
              if (isGiven)
                const Center(
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
