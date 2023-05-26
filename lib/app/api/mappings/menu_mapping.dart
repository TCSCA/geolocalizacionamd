class MenuMap {
  int id;
  String descripcionEs;
  String descripcionEn;
  String icon;
  String route;
  bool enable;
  int order;
  int parent;

  MenuMap(
      {required this.id,
      required this.descripcionEs,
      required this.descripcionEn,
      required this.icon,
      required this.route,
      required this.enable,
      required this.order,
      required this.parent});

  factory MenuMap.fromJson(Map<String, dynamic> json) => MenuMap(
      id: json['id'] ?? 0,
      descripcionEs: json['descripcionEs'] ?? '',
      descripcionEn: json['descripcionEn'] ?? '',
      icon: json['icon'] ?? '',
      route: json['route'] ?? '',
      enable: json['enable'] ?? false,
      order: json['order'] ?? 0,
      parent: json['parent'] ?? 0);
}
