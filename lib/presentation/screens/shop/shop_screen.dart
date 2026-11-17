import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHOP'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: context.cqCard, border: Border.all(color: AppColors.neonYellow.withOpacity(0.3))),
              child: Row(children: [
                const Text('🪙', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                const Text('1,250', style: TextStyle(fontFamily: 'Orbitron', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.neonYellow)),
              ]),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: AppColors.neonCyan,
          tabs: const [Tab(text: 'FEATURED'), Tab(text: 'SKINS'), Tab(text: 'POWERUPS'), Tab(text: 'LOOT')],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _ShopTab(items: _featuredItems),
          _ShopTab(items: _skinItems),
          _ShopTab(items: _powerupItems),
          _ShopTab(items: _lootItems),
        ],
      ),
    );
  }

  final _featuredItems = [
    {'name': 'Battle Pass', 'desc': 'Unlock exclusive rewards', 'price': null, 'priceReal': '4.99', 'icon': '🎫', 'color': 0xFFFFD700, 'premium': true},
    {'name': 'XP Boost (2x)', 'desc': 'Double XP for 1 hour', 'price': '200', 'icon': '⚡', 'color': 0xFF00F5FF},
    {'name': 'Life Refill', 'desc': 'Restore all 5 lives', 'price': '50', 'icon': '❤️', 'color': 0xFFFF006E},
    {'name': 'Streak Shield', 'desc': 'Protect streak for 1 day', 'price': '150', 'icon': '🛡️', 'color': 0xFF7B2FBE},
  ];

  final _skinItems = [
    {'name': 'Dev Phantom Gold', 'desc': 'Legendary gold skin', 'price': '1000', 'icon': '👻', 'color': 0xFFFFD700},
    {'name': 'Cyber Ninja Red', 'desc': 'Red variant skin', 'price': '800', 'icon': '🥷', 'color': 0xFFFF006E},
    {'name': 'Neon Purple Theme', 'desc': 'Change app theme', 'price': '500', 'icon': '🎨', 'color': 0xFFBF00FF},
  ];

  final _powerupItems = [
    {'name': 'XP Boost (2x)', 'desc': '1 hour multiplier', 'price': '200', 'icon': '⚡', 'color': 0xFF00F5FF},
    {'name': 'XP Boost (3x)', 'desc': '30 min ultra boost', 'price': '400', 'icon': '🚀', 'color': 0xFFBF00FF},
    {'name': 'Hint Pass', 'desc': 'Free hints x5', 'price': '100', 'icon': '💡', 'color': 0xFFFFE600},
    {'name': 'Streak Shield', 'desc': 'Protect 1 day', 'price': '150', 'icon': '🛡️', 'color': 0xFF7B2FBE},
  ];

  final _lootItems = [
    {'name': 'Mystery Box', 'desc': 'Random rewards inside!', 'price': '300', 'icon': '📦', 'color': 0xFF39FF14},
    {'name': 'Premium Box', 'desc': 'Guaranteed rare item', 'price': null, 'priceReal': '1.99', 'icon': '👑', 'color': 0xFFFFD700, 'premium': true},
  ];
}

class _ShopTab extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _ShopTab({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final color = Color(item['color'] as int? ?? 0xFF00F5FF);
        final isPremium = item['premium'] == true;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.cqCard,
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 12)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item['icon'] as String, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              Text(item['name'] as String, style: TextStyle(fontFamily: 'Orbitron', fontSize: 12, fontWeight: FontWeight.bold, color: context.cqTextPrimary), textAlign: TextAlign.center),
              SizedBox(height: 4),
              Text(item['desc'] as String, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: isPremium ? AppColors.goldGradient : LinearGradient(colors: [color.withOpacity(0.8), color]),
                  ),
                  child: Text(
                    isPremium ? '\$${item['priceReal']}' : '🪙 ${item['price']}',
                    style: TextStyle(fontFamily: 'Orbitron', fontSize: 12, fontWeight: FontWeight.bold, color: isPremium ? Colors.black : AppColors.bgDark),
                  ),
                ),
              ),
            ],
          ),
        ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().scale(begin: const Offset(0.9, 0.9));
      },
    );
  }
}
