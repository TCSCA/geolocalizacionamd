class MenuModel {
  int id;
  String descripcion;
  String icon;
  String route;
  int parent;
  List<MenuModel> childrens;

  MenuModel(this.id, this.descripcion, this.icon, this.route, this.parent,
      this.childrens);
}
