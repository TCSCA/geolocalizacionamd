import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/core/models/menu_model.dart';
import 'package:geolocalizacionamd/app/core/models/user_model.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/constants/app_constants.dart';
import 'package:geolocalizacionamd/app/pages/sources/login/bloc/login_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import 'package:geolocalizacionamd/app/pages/styles/app_styles.dart';
import 'package:geolocalizacionamd/app/shared/dialog/custom_dialog_box.dart';
import 'package:go_router/go_router.dart';

class AppCommonWidgets {
  static Drawer generateMenu({required BuildContext context}) {
    final List<MenuModel> opcionesMenu =
        BlocProvider.of<LoginBloc>(context).listMenu;
    return Drawer(
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        final user = (state as LoginSuccessState).user;
        return ListView(
          padding: EdgeInsets.zero,
          children: _getInfoMenu(context, opcionesMenu, user),
        );
      }),
    );
  }

  static List<Widget> _getInfoMenu(
      BuildContext context, List<MenuModel> opcionesMenu, UserModel datosUser) {
    List<Widget> listaMenu = [], listaSubMenu = [];
    UserAccountsDrawerHeader infoUser;
    late Widget opcionMenu;

    infoUser = UserAccountsDrawerHeader(
      accountName: Text(datosUser.name, style: AppStyles.textStyleMenuUser),
      accountEmail: const Text("", style: AppStyles.textStyleMenuUser),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: AssetImage(AppConstants.profileDefaultImage),
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppConstants.backgroundHeaderMenuImage),
          fit: BoxFit.fill,
        ),
      ),
    );
    listaMenu.add(infoUser);

    for (var index = 0; index < opcionesMenu.length; index++) {
      var opcion = opcionesMenu[index];
      listaSubMenu = [];

      listaSubMenu = _getSubMenu(context, opcion, opcionesMenu);

      if (opcion.parent == 0) {
        if (listaSubMenu.isEmpty) {
          opcionMenu = ListTile(
            onTap: () {
              context.pop();
              BlocProvider.of<NavigationBloc>(context).add(
                  NavigationPageEvent(page: index, pagesMenu: opcionesMenu));
            },
            leading: getIcon(opcion.icon),
            horizontalTitleGap: 0.0,
            title: Text(
              opcion.descripcion,
              style: AppStyles.textStyleMenuDynamic,
            ),
            hoverColor: AppStyles.colorRedPrimary,
          );
        } else {
          opcionMenu = ListTileTheme(
              horizontalTitleGap: 0.0,
              dense: true,
              child: ExpansionTile(
                leading: getIcon(opcion.icon),
                title: Text(opcion.descripcion,
                    style: AppStyles.textStyleMenuDynamic),
                childrenPadding: const EdgeInsets.only(left: 20.0),
                children: listaSubMenu,
              ));
        }

        listaMenu.add(opcionMenu);
      }
    }
//Opcion Menu cerrar sesion
    opcionMenu = ListTile(
      onTap: () {
        context.pop();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: context.appLocalization.titleWarning,
                descriptions: context.appLocalization.messageLogout,
                isConfirmation: true,
                dialogAction: () => BlocProvider.of<LoginBloc>(context)
                    .add(const ProcessLogoutEvent()),
                type: AppConstants.statusWarning,
              );
            });
      },
      leading: getIcon('logout'),
      horizontalTitleGap: 0.0,
      title: Text(context.appLocalization.titleLogout,
          style: AppStyles.textStyleMenuDynamic),
      hoverColor: AppStyles.colorRedPrimary,
    );
    listaMenu.add(opcionMenu);
//Opcion Menu Acerca de app
    listaMenu.add(Column(
      children: [
        const Divider(),
        ListTile(
          onTap: () {
            context.pop();
          },
          leading: getIcon('aboutApp'),
          horizontalTitleGap: 0.0,
          title: Text(context.appLocalization.titleAboutApp,
              style: AppStyles.textStyleMenuStatic),
          hoverColor: AppStyles.colorRedPrimary,
          focusColor: AppStyles.colorRedPrimary,
        ),
//Opcion Cerrar menu
        ListTile(
          onTap: () {
            context.pop();
          },
          leading: getIcon('closeMenu'),
          horizontalTitleGap: 0.0,
          title: Text(
            context.appLocalization.titleCloseMenu,
            style: AppStyles.textStyleMenuStatic,
          ),
          hoverColor: AppStyles.colorRedPrimary,
          focusColor: AppStyles.colorRedPrimary,
        ),
      ],
    ));

    return listaMenu;
  }

  static List<Widget> _getSubMenu(
      BuildContext context, MenuModel opcion, List<MenuModel> subOpcionesMenu) {
    List<Widget> listaSubMenu = [];
    Widget opcionSubMenu;

    for (var subIndex = 0; subIndex < subOpcionesMenu.length; subIndex++) {
      var subOpcion = subOpcionesMenu[subIndex];

      if (opcion.id == subOpcion.parent) {
        opcionSubMenu = ListTile(
          onTap: () {
            context.pop();
            BlocProvider.of<NavigationBloc>(context).add(NavigationPageEvent(
                page: subIndex, pagesMenu: subOpcionesMenu));
          },
          title: Text(
            subOpcion.descripcion,
            style: AppStyles.textStyleMenuDynamic,
          ),
          leading: getIcon(subOpcion.icon),
        );
        listaSubMenu.add(opcionSubMenu);
      }
    }
    return listaSubMenu;
  }

  static Icon getIcon(String nombreIcono) {
    return Icon(
      AppConstants.iconsMenu[nombreIcono],
    );
  }
}
