import 'package:share_plus/share_plus.dart';

class ShareService {
  ShareService._();
  static final ShareService instance = ShareService._();

  Future<void> shareAchievement({
    required String title,
    required String emoji,
    required String username,
  }) async {
    final text = '''
$emoji I just unlocked "$title" on CodeQuest!

🚀 Join me on the ultimate gamified coding adventure.
Code. Level Up. Conquer. 🏆

#CodeQuest #LearnToCode #Coding
''';
    await Share.share(text.trim(), subject: 'Achievement Unlocked on CodeQuest!');
  }

  Future<void> shareRank({
    required String rank,
    required String rankIcon,
    required int xp,
    required String username,
  }) async {
    final text = '''
$rankIcon I just reached "$rank" on CodeQuest with $xp XP!

Can you beat my rank? 💪
#CodeQuest #CodingChallenge #${rank.replaceAll(' ', '')}
''';
    await Share.share(text.trim(), subject: 'My CodeQuest Rank');
  }

  Future<void> shareLessonComplete({
    required String lessonTitle,
    required int xp,
    required String language,
  }) async {
    final text = '''
✅ Just completed "$lessonTitle" in $language on CodeQuest and earned $xp XP!

Learn to code the fun way 🎮
#CodeQuest #$language #LearnToCode
''';
    await Share.share(text.trim(), subject: 'Lesson Complete on CodeQuest!');
  }

  Future<void> shareStreak({required int streak}) async {
    final text = '''
🔥 $streak day coding streak on CodeQuest!

Consistency is the key to mastery. Join me!
#CodeQuest #CodingStreak #LearnToCode
''';
    await Share.share(text.trim(), subject: 'My CodeQuest Streak');
  }

  Future<void> shareCertificate({
    required String language,
    required String username,
  }) async {
    final text = '''
🏆 I just completed the full $language track on CodeQuest!

Certificate earned. Next language loading... 😎
#CodeQuest #$language #Certificate #LearnToCode
''';
    await Share.share(text.trim(), subject: 'CodeQuest Certificate — $language');
  }
}
