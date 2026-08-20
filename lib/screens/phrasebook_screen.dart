import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/phrase.dart';
import '../models/scenario.dart';
import '../models/srs_card.dart';
import '../state/app_state.dart';

/// Bộ lọc theo trạng thái học của câu.
enum _StatusFilter {
  all('Tất cả', Icons.list_rounded),
  favourite('Yêu thích', Icons.star_rounded),
  learned('Đã học', Icons.check_circle_rounded),
  unlearned('Chưa học', Icons.fiber_new_rounded),
  mastered('Đã thuộc', Icons.workspace_premium_rounded);

  const _StatusFilter(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Bộ lọc theo loại nội dung.
enum _TypeFilter { all, sentence, word }

/// Tab "Sổ tay": tra cứu toàn bộ câu và từ của ngôn ngữ đang học.
///
/// Khác với tab Hành trình (đi theo thứ tự chặng), đây là nơi tìm nhanh một
/// câu cụ thể khi đang đứng giữa sân bay — nên có ô tìm kiếm, bộ lọc và danh
/// sách yêu thích.
class PhrasebookScreen extends StatefulWidget {
  const PhrasebookScreen({super.key});

  @override
  State<PhrasebookScreen> createState() => _PhrasebookScreenState();
}

class _PhrasebookScreenState extends State<PhrasebookScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String _scenarioCode = '';
  _StatusFilter _status = _StatusFilter.all;
  _TypeFilter _type = _TypeFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesQuery(Phrase p) {
    if (_query.isEmpty) return true;
    final String q = _query.toLowerCase();
    return p.target.toLowerCase().contains(q) ||
        p.vietnamese.toLowerCase().contains(q) ||
        p.romanization.toLowerCase().contains(q);
  }

  bool _matchesStatus(Phrase p, AppState state) {
    switch (_status) {
      case _StatusFilter.all:
        return true;
      case _StatusFilter.favourite:
        return state.isFavourite(p.id);
      case _StatusFilter.learned:
        return state.isLearned(p.id);
      case _StatusFilter.unlearned:
        return !state.isLearned(p.id);
      case _StatusFilter.mastered:
        return state.isLearned(p.id) && state.cardFor(p.id).isMastered;
    }
  }

  bool _matchesType(Phrase p) {
    switch (_type) {
      case _TypeFilter.all:
        return true;
      case _TypeFilter.sentence:
        return p.isSentence;
      case _TypeFilter.word:
        return !p.isSentence;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);
    final List<Scenario> scenarios = state.scenarios;

    final List<Phrase> results = state.allPhrases
        .where((Phrase p) =>
            (_scenarioCode.isEmpty || p.scenarioCode == _scenarioCode) &&
            _matchesQuery(p) &&
            _matchesStatus(p, state) &&
            _matchesType(p))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ tay'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Chỉ xem câu yêu thích',
            onPressed: () => setState(() {
              _status = _status == _StatusFilter.favourite
                  ? _StatusFilter.all
                  : _StatusFilter.favourite;
            }),
            icon: Icon(
              _status == _StatusFilter.favourite
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: _status == _StatusFilter.favourite
                  ? const Color(0xFFEAB308)
                  : null,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (String value) => setState(() => _query = value.trim()),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Tìm câu, nghĩa tiếng Việt hoặc phiên âm…',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                _Chip(
                  label: 'Mọi chặng',
                  selected: _scenarioCode.isEmpty,
                  onSelected: () => setState(() => _scenarioCode = ''),
                ),
                ...scenarios.map(
                  (Scenario s) => _Chip(
                    label: s.title,
                    color: s.color,
                    selected: _scenarioCode == s.code,
                    onSelected: () => setState(
                      () => _scenarioCode = _scenarioCode == s.code ? '' : s.code,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                for (final _StatusFilter filter in _StatusFilter.values)
                  _Chip(
                    label: filter.label,
                    icon: filter.icon,
                    selected: _status == filter,
                    onSelected: () => setState(() => _status = filter),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${results.length} kết quả'
                    '${state.favouriteCount > 0 ? '  ·  ⭐ ${state.favouriteCount}' : ''}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SegmentedButton<_TypeFilter>(
                  showSelectedIcon: false,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStatePropertyAll<TextStyle>(
                      theme.textTheme.labelSmall ?? const TextStyle(fontSize: 11),
                    ),
                  ),
                  segments: const <ButtonSegment<_TypeFilter>>[
                    ButtonSegment<_TypeFilter>(
                      value: _TypeFilter.all,
                      label: Text('Tất cả'),
                    ),
                    ButtonSegment<_TypeFilter>(
                      value: _TypeFilter.sentence,
                      label: Text('Câu'),
                    ),
                    ButtonSegment<_TypeFilter>(
                      value: _TypeFilter.word,
                      label: Text('Từ'),
                    ),
                  ],
                  selected: <_TypeFilter>{_type},
                  onSelectionChanged: (Set<_TypeFilter> value) =>
                      setState(() => _type = value.first),
                ),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? _EmptyResult(status: _status)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int i) {
                      final Phrase p = results[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _PhraseRow(
                          phrase: p,
                          state: state,
                          onTap: () => _showDetail(context, p),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Phrase phrase) {
    showModalBottomSheet<void>(
      context: context,
      // Navigator gốc: nếu không, sheet sẽ nổi bên trên thanh tab.
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext _) => _PhraseDetailSheet(phraseId: phrase.id),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color accent = color ?? Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        avatar: icon == null
            ? null
            : Icon(icon, size: 16, color: selected ? accent : null),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: accent.withValues(alpha: 0.16),
        checkmarkColor: accent,
        showCheckmark: icon == null,
        side: BorderSide(
          color: selected
              ? accent.withValues(alpha: 0.6)
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}

class _PhraseRow extends StatelessWidget {
  const _PhraseRow({
    required this.phrase,
    required this.state,
    required this.onTap,
  });

  final Phrase phrase;
  final AppState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool showRomanization =
        state.language.hasRomanization && phrase.romanization.isNotEmpty;
    final bool favourite = state.isFavourite(phrase.id);
    final bool learned = state.isLearned(phrase.id);
    final bool mastered = learned && state.cardFor(phrase.id).isMastered;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 6,
                height: 40,
                decoration: BoxDecoration(
                  color: mastered
                      ? const Color(0xFF10B981)
                      : learned
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      phrase.target,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    if (showRomanization)
                      Text(
                        phrase.romanization,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    Text(
                      phrase.vietnamese,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: favourite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích',
                onPressed: () => state.toggleFavourite(phrase.id),
                icon: Icon(
                  favourite ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 20,
                  color: favourite ? const Color(0xFFEAB308) : null,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Nghe phát âm',
                onPressed: () => state.speak(phrase.target),
                icon: const Icon(Icons.volume_up_rounded, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chi tiết một câu, mở từ Sổ tay.
class _PhraseDetailSheet extends StatelessWidget {
  const _PhraseDetailSheet({required this.phraseId});

  final String phraseId;

  @override
  Widget build(BuildContext context) {
    final AppState state = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);
    final Phrase? phrase = state.repository.phraseById(phraseId);

    if (phrase == null) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('Không tìm thấy câu này.')),
      );
    }

    final SrsCard card = state.cardFor(phrase.id);
    final bool learned = state.isLearned(phrase.id);
    final bool showRomanization =
        state.language.hasRomanization && phrase.romanization.isNotEmpty;
    final Scenario scenario =
        state.repository.scenario(state.language.code, phrase.scenarioCode);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(scenario.icon, size: 18, color: scenario.color),
                const SizedBox(width: 8),
                Text(
                  scenario.title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scenario.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  phrase.isSentence ? 'Câu giao tiếp' : 'Từ vựng',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              phrase.target,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            if (showRomanization) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                phrase.romanization,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              phrase.vietnamese,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (phrase.note.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '💡 ${phrase.note}',
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Icon(
                  learned ? Icons.schedule_rounded : Icons.fiber_new_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    !learned
                        ? 'Chưa học lần nào'
                        : card.isDue
                            ? 'Đang đến hạn ôn'
                            : 'Ôn lại sau ${card.intervalDays} ngày'
                                '${card.isMastered ? ' · đã thuộc' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => state.speak(phrase.target),
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Nghe'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => state.toggleFavourite(phrase.id),
                  icon: Icon(
                    state.isFavourite(phrase.id)
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: state.isFavourite(phrase.id)
                        ? const Color(0xFFEAB308)
                        : null,
                  ),
                  label: Text(
                    state.isFavourite(phrase.id) ? 'Đã lưu' : 'Lưu',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.status});

  final _StatusFilter status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String message = status == _StatusFilter.favourite
        ? 'Chưa có câu yêu thích nào. Chạm ngôi sao ⭐ ở bất kỳ câu nào để lưu.'
        : 'Không có câu nào khớp bộ lọc. Thử xoá bớt điều kiện xem sao.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('🔍', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
