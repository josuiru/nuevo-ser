/// Formatea [fecha] como `YYYY-MM-DD HH:MM:SS` en UTC, el shape que
/// espera el backend WordPress de Nuevo Ser para columnas DATETIME.
String aFechaMysql(DateTime fecha) {
  final utc = fecha.toUtc();
  String pad(int v, [int n = 2]) => v.toString().padLeft(n, '0');
  return '${utc.year}-${pad(utc.month)}-${pad(utc.day)} '
      '${pad(utc.hour)}:${pad(utc.minute)}:${pad(utc.second)}';
}
