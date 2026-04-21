/// Configuración de conexión al backend. En desarrollo apunta al
/// Local WP local por IP+puerto con cabecera `Host: uno-roto.local`.
/// En producción se usará la URL real del sitio WordPress.
///
/// Para cambiar el puerto: mirar el my.cnf del sitio en
/// `~/.config/Local/run/<id>/conf/nginx/site.conf` → listen <puerto>.
class ConfigApi {
  /// Local WP en Ubuntu: el router de Local resuelve `uno-roto.local`
  /// internamente pero fuera (Flutter) no siempre — apuntamos al
  /// nginx del sitio directamente con cabecera Host.
  static const String urlBaseLocal = 'http://127.0.0.1:10063';
  static const String hostLocal = 'uno-roto.local';
}
