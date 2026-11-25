import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleLogout(BuildContext context) async {
    final auth = context.read<AuthState>();
    if (!auth.isLoggedIn) {
      _showSnackBar(context, 'Kamu belum login.');
      return;
    }
    await auth.logout();
    if (!context.mounted) return;
    _showSnackBar(context, 'Kamu berhasil logout.');
  }

  Future<void> _handleTap(BuildContext context) async {
    if (item.isLogout) {
      await _handleLogout(context);
      return;
    }

    final pageBuilder = item.pageBuilder;
    if (pageBuilder != null) {
      if (item.requiresAuth) {
        final loggedIn = await ensureLoggedIn(context);
        if (!loggedIn || !context.mounted) return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: pageBuilder),
      );
      return;
    }

    _showSnackBar(context, "Kamu telah menekan tombol ${item.name}!");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
