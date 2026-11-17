import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

enum LeaderboardTab { global, weekly, friends }

class LeaderboardState {
  final List<LeaderboardEntryModel> entries;
  final bool isLoading;
  final bool hasMore;
  final LeaderboardTab tab;

  const LeaderboardState({
    this.entries = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.tab = LeaderboardTab.global,
  });

  LeaderboardState copyWith({
    List<LeaderboardEntryModel>? entries,
    bool? isLoading,
    bool? hasMore,
    LeaderboardTab? tab,
  }) {
    return LeaderboardState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      tab: tab ?? this.tab,
    );
  }
}

class LeaderboardNotifier extends Notifier<LeaderboardState> {
  static const _pageSize = 50;

  @override
  LeaderboardState build() {
    Future.microtask(() => loadLeaderboard(LeaderboardTab.global));
    return const LeaderboardState();
  }

  Future<void> loadLeaderboard(LeaderboardTab tab) async {
    state = state.copyWith(isLoading: true, tab: tab, entries: []);
    try {
      final repo = ref.read(leaderboardRepositoryProvider);
      final userId = ref.read(currentUserProvider)?.id ?? '';
      List<LeaderboardEntryModel> entries;

      switch (tab) {
        case LeaderboardTab.global:
          entries = (await repo.getGlobalLeaderboard(limit: _pageSize))
              .cast<LeaderboardEntryModel>();
          break;
        case LeaderboardTab.weekly:
          entries = (await repo.getWeeklyLeaderboard(limit: _pageSize))
              .cast<LeaderboardEntryModel>();
          break;
        case LeaderboardTab.friends:
          entries = (await repo.getFriendsLeaderboard(userId))
              .cast<LeaderboardEntryModel>();
          break;
      }
      state = state.copyWith(
        entries: entries,
        isLoading: false,
        hasMore: entries.length == _pageSize,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    if (state.tab != LeaderboardTab.global) return;
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(leaderboardRepositoryProvider);
      final more = (await repo.getGlobalLeaderboard(
        limit: _pageSize,
        offset: state.entries.length,
      )).cast<LeaderboardEntryModel>();
      state = state.copyWith(
        entries: [...state.entries, ...more],
        isLoading: false,
        hasMore: more.length == _pageSize,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final leaderboardProvider =
    NotifierProvider<LeaderboardNotifier, LeaderboardState>(
  LeaderboardNotifier.new,
);

// ─── FRIENDS ──────────────────────────────────────────────────────────────────

final friendsProvider = FutureProvider<List>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];
  final ds = ref.read(supabaseDatasourceProvider);
  return ds.getFriends(userId);
});

// ─── GUILDS ───────────────────────────────────────────────────────────────────

final publicGuildsProvider = FutureProvider<List>((ref) async {
  final ds = ref.read(supabaseDatasourceProvider);
  return ds.getPublicGuilds();
});

final userGuildProvider = FutureProvider<dynamic>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return null;
  final ds = ref.read(supabaseDatasourceProvider);
  return ds.getUserGuild(userId);
});
