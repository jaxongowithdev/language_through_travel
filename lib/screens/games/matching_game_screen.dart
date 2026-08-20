import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/phrase.dart';
import '../../models/srs_card.dart';
import '../../state/app_state.dart';
import '../../widgets/game_result_view.dart';

/// Id dùng để lưu kỷ lục trong [AppState.gameBest].
const String matchingGameId = 'match';

/// Số cặp mỗi ván.
const int _pairsPerRound = 6;

class _Tile {
  const _Tile({
    required this.phraseId,
    required this.text,
    required this.isTarget,
  });

  final String phraseId;
  final String text;

  /// true = ô ngôn ngữ đích, false = ô nghĩa tiếng Việt.
  final bool isTarget;
}

/// Trò "Nối cặp": ghép câu ngôn ngữ đích với nghĩa tiếng Việt, tính giờ.
class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key, required this.phrases});

  final List<Phrase> phrases;

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  final Random _random = Random();

  late List<_Tile> _tiles;
  final Set<int> _matched = <int>{};
  final Set<String> _missedIds = <String>{};

  int? _selected;
  int? _wrongA;
  int? _wrongB;
  int _mistakes = 0;
  int _seconds = 0;
  bool _finished = false;
  bool _isRecord = false;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _deal();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _deal() {
    final List<Phrase> pool = List<Phrase>.of(widget.phrases)..shuffle(_random);
    final List<Phrase> picked = pool.take(_pairsPerRound).toList();

    final List<_Tile> tiles = <_Tile>[];
    for (final Phrase p in picked) {
      tiles.add(_Tile(phraseId: p.id, text: p.target, isTarget: true));
      tiles.add(_Tile(phraseId: p.id, text: p.vietnamese, isTarget: false));
    }
    tiles.shuffle(_random);

    _tiles = tiles;
    _matched.clear();
    _missedIds.clear();
    _selected = null;
    _wrongA = null;
    _wrongB = null;
    _mistakes = 0;
    _seconds = 0;
    _finished = false;
    _isRecord = false;

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer _) {
      if (!mounted || _finished) return;
      setState(() => _seconds += 1);
    });
  }

  Future<void> _tap(int index) async {
    if (_finished || _matched.contains(index) || _wrongA != null) return;

    final int? first = _selected;
    if (first == null) {
      setState(() => _selected = index);
      return;
    }
    if (first == index) {
      setState(() => _selected = null);
      return;
    }

    final _Tile a = _tiles[first];
    final _Tile b = _tiles[index];
    final bool ok = a.phraseId == b.phraseId && a.isTarget != b.isTarget;

    if (ok) {
      setState(() {
        _matched.addAll(<int>[first, index]);
        _selected = null;
      });
      // Ghép đúng ngay lần đầu tính là nhớ được; từng ghép sai thì cho ôn lại sớm.
      await context.read<AppState>().reviewPhrase(
            a.phraseId,
            _missedIds.contains(a.phraseId)
                ? RecallQuality.hard
                : RecallQuality.good,
          );
      if (!mounted) return;
      if (_matched.length == _tiles.length) {
        await _finish();
      }
      return;
    }

    _missedIds.add(a.phraseId);
    _missedIds.add(b.phraseId);
    setState(() {
      _mistakes += 1;
      _wrongA = first;
      _wrongB = index;
      _selected = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() {
      _wrongA = null;
      _wrongB = null;
    });
  }

  Future<void> _finish() async {
    _ticker?.cancel();
    final int score = _score();
    final bool record =
        await context.read<AppState>().recordGameScore(matchingGameId, score);
    if (!mounted) return;
    setState(() {
      _finished = true;
      _isRecord = record;
    });
  }

  /// Điểm 0–100: trừ dần theo số lần ghép sai và thời gian.
  int _score() {
    final int raw = 100 - _mistakes * 8 - (_seconds ~/ 2);
    return raw.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (widget.phrases.length < _pairsPerRound) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nối cặp')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Cần ít nhất 6 câu để chơi. Học thêm vài câu ở tab Hành trình nhé.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_finished) {
      final AppState state = context.watch<AppState>();
      return GameResultView(
        title: 'Nối cặp',
        score: _score(),
        scoreSuffix: ' điểm',
        detail: '$_seconds giây · $_mistakes lần ghép sai',
        best: state.gameBest(matchingGameId),
        isRecord: _isRecord,
        onRetry: () => setState(_deal),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nối cặp'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '⏱ $_seconds″',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          children: <Widget>[
            Text(
              'Chạm một câu rồi chạm nghĩa tiếng Việt tương ứng',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.35,
                ),
                itemCount: _tiles.length,
                itemBuilder: (BuildContext context, int i) =>
                    _TileView(
                  tile: _tiles[i],
                  matched: _matched.contains(i),
                  selected: _selected == i,
                  wrong: _wrongA == i || _wrongB == i,
                  onTap: () => _tap(i),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đã ghép ${_matched.length ~/ 2}/$_pairsPerRound cặp',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileView extends StatelessWidget {
  const _TileView({
    required this.tile,
    required this.matched,
    required this.selected,
    required this.wrong,
    required this.onTap,
  });

  final _Tile tile;
  final bool matched;
  final bool selected;
  final bool wrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Color background = tile.isTarget
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55)
        : theme.colorScheme.surfaceContainerHigh;
    Color border = theme.colorScheme.outlineVariant;

    if (selected) {
      border = theme.colorScheme.primary;
    }
    if (wrong) {
      background = const Color(0xFFEF4444).withValues(alpha: 0.18);
      border = const Color(0xFFEF4444);
    }
    if (matched) {
      background = const Color(0xFF10B981).withValues(alpha: 0.16);
      border = const Color(0xFF10B981);
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: matched ? 0.45 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: matched ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: border,
              width: selected || wrong || matched ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              tile.text,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: tile.isTarget ? FontWeight.w700 : FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
