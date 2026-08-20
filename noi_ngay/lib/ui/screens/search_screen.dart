import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/reference.dart';
import '../../models/spoken_line.dart';
import '../../models/word_card.dart';
import '../../state/learn_state.dart';
import '../../theme/palette.dart';
import '../widgets/aurora_background.dart';
import '../widgets/common.dart';
import '../widgets/glass_card.dart';
import '../widgets/line_tile.dart';
import 'reference_screen.dart';

/// Tìm kiếm trên toàn bộ nội dung: câu, từ vựng và sổ tay cùng lúc.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.watch<LearnState>();

    final List<SpokenLine> lines = state.library.searchLines(_query);
    final List<WordCard> words = state.library.searchWords(_query);
    final List<RefEntry> refs = state.library.searchReference(_query);
    final int total = lines.length + words.length + refs.length;

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 16, 8),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        onChanged: (String value) =>
                            setState(() => _query = value),
                        decoration: InputDecoration(
                          hintText: 'Tìm câu, từ vựng hoặc mục sổ tay',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _controller.clear();
                                    setState(() => _query = '');
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _query.trim().isEmpty
                    ? EmptyHint(
                        icon: Icons.search_rounded,
                        title: 'Tìm trong toàn bộ nội dung',
                        body: '${state.library.totalItemCount} mục đang có sẵn '
                            'trên máy bạn. Gõ tiếng Việt hoặc tiếng Anh đều '
                            'được.',
                      )
                    : total == 0
                        ? const EmptyHint(
                            icon: Icons.search_off_rounded,
                            title: 'Không tìm thấy gì',
                            body: 'Thử một từ khoá ngắn hơn, ví dụ chỉ một từ.',
                          )
                        : ListView(
                            padding:
                                const EdgeInsets.fromLTRB(16, 4, 16, 28),
                            children: <Widget>[
                              if (lines.isNotEmpty) ...<Widget>[
                                SectionHeader(
                                  title: 'Câu giao tiếp',
                                  subtitle: '${lines.length} kết quả',
                                ),
                                for (final SpokenLine line
                                    in lines.take(30)) ...<Widget>[
                                  LineTile(
                                    line: line,
                                    tint: state.library
                                        .topic(line.topicCode)
                                        .tint,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                const SizedBox(height: 10),
                              ],
                              if (words.isNotEmpty) ...<Widget>[
                                SectionHeader(
                                  title: 'Từ vựng',
                                  subtitle: '${words.length} kết quả',
                                ),
                                for (final WordCard word
                                    in words.take(20)) ...<Widget>[
                                  _WordResult(word: word),
                                  const SizedBox(height: 10),
                                ],
                                const SizedBox(height: 10),
                              ],
                              if (refs.isNotEmpty) ...<Widget>[
                                SectionHeader(
                                  title: 'Sổ tay',
                                  subtitle: '${refs.length} kết quả',
                                ),
                                for (final RefEntry entry
                                    in refs.take(20)) ...<Widget>[
                                  RefEntryCard(
                                    entry: entry,
                                    tint: Palette.violet,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ],
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordResult extends StatelessWidget {
  const _WordResult({required this.word});

  final WordCard word;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LearnState state = context.read<LearnState>();
    final Color tint = state.library.topic(word.topicCode).tint;

    return GlassCard(
      tint: tint,
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      onTap: () => state.say(word.word),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${word.word}  ${word.ipa}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(word.vietnamese, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          IconButton(
            onPressed: () => state.say(word.word),
            icon: const Icon(Icons.volume_up_rounded),
            color: tint,
          ),
        ],
      ),
    );
  }
}
