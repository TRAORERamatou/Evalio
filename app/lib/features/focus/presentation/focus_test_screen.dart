import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'focus_guard_cubit.dart';

/// Écran de test du spike T04 : détection de focus et FLAG_SECURE.
///
/// À n'utiliser que pour valider le comportement sur téléphone réel.
class FocusTestScreen extends StatelessWidget {
  const FocusTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FocusGuardCubit()..start(),
      child: const _FocusTestView(),
    );
  }
}

class _FocusTestView extends StatelessWidget {
  const _FocusTestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spike T04 - Focus / FLAG_SECURE')),
      body: BlocBuilder<FocusGuardCubit, FocusGuardState>(
        builder: (context, state) {
          final cubit = context.read<FocusGuardCubit>();
          String status;
          IconData icon;
          Color color;

          if (state is FocusGuardInitial) {
            status = 'En attente...';
            icon = Icons.hourglass_empty;
            color = Colors.grey;
          } else if (state is FocusGuardFocused) {
            status = 'Application au premier plan';
            icon = Icons.check_circle;
            color = Colors.green;
          } else if (state is FocusGuardBlurred) {
            status = 'Application en arrière-plan (sortie #${state.exitCount})';
            icon = Icons.error_outline;
            color = Colors.orange;
          } else {
            status = 'Inconnu';
            icon = Icons.help;
            color = Colors.grey;
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 80, color: color),
                const SizedBox(height: 24),
                Text(
                  status,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nombre de sorties detectees : ${cubit.exitCount}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => cubit.stop(),
                  icon: const Icon(Icons.stop),
                  label: const Text('Arreter la surveillance'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
