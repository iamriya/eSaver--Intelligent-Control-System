class Connection{
  final int id;
  final String connection_name;
  final int connection_pin;
    final String connection_url;

  final bool is_high;

  Connection(this.id, this.connection_name, this.connection_pin, this.connection_url, this.is_high);
}
class Changes {
  final bool is_high;

  Changes({
    this.is_high,
  });

  Map<String, dynamic> toJson() {
    return {"is_high": is_high};
  }
}