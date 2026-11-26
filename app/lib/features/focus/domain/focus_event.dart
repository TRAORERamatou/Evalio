/// Événement de focus produit par le moniteur de plateforme.
///
/// [hasFocus] vaut true quand l'application retrouve le focus, false quand elle le perd.
class FocusEvent {
  const FocusEvent({required this.hasFocus, required this.timestampMs});

  final bool hasFocus;
  final int timestampMs;
}
