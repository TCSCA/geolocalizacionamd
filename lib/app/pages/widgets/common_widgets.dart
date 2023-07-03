import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '/app/core/models/menu_model.dart';
import '/app/extensions/localization_ext.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/login/bloc/login_bloc.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';
import '/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import '/app/pages/styles/app_styles.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/shared/loading/loading_builder.dart';

class AppCommonWidgets {
  static PreferredSizeWidget generateAppBar(
      {required BuildContext context, required double appBarHeight}) {
    final int currentIndex =
        BlocProvider.of<NavigationBloc>(context).currentIndex;
    final List<MenuModel> lista = BlocProvider.of<LoginBloc>(context).listMenu;
    final String menuOpTitle = lista[currentIndex].descripcion;
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color(0xff2B5178),
      toolbarHeight: appBarHeight > 0 ? appBarHeight : 56.0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //const SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Image.asset(
                AppConstants.logoImageWhite,
                width: 270,
                height: 90,
              )),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      //isDismissible: false,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppCommonWidgets.generateMenuInfo(
                                context: context),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 35.0,
                    color: Colors.white,
                  ))
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              //const Icon(FontAwesomeIcons.houseMedical, color: Colors.white),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                menuOpTitle,
                style: const TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  static List<Widget> generateMenuInfo({required BuildContext context}) {
    List<Widget> listaMenu = [];
    late Widget opcionMenu;
    final List<MenuModel> opcionesMenu =
        BlocProvider.of<LoginBloc>(context).listMenu;

    listaMenu.add(Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "MENÚ DE OPCIONES",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600),
        )
      ],
    ));

    for (var index = 0; index < opcionesMenu.length; index++) {
      var opcion = opcionesMenu[index];
      opcionMenu = ListTile(
        onTap: () {
          context.pop();
          BlocProvider.of<NavigationBloc>(context)
              .add(NavigationPageEvent(page: index, pagesMenu: opcionesMenu));
        },
        leading: getIcon(opcion.icon),
        horizontalTitleGap: 0.0,
        title: Text(
          opcion.descripcion,
          style: AppStyles.textStyleMenuDynamic,
        ),
        hoverColor: AppStyles.colorRedPrimary,
      );
      listaMenu.add(opcionMenu);
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
                  isdialogCancel: false,
                  dialogCancel: () {});
            });
      },
      leading: getIcon('logout'),
      horizontalTitleGap: 0.0,
      title: Text(context.appLocalization.titleLogout,
          style: AppStyles.textStyleMenuDynamic),
      hoverColor: AppStyles.colorRedPrimary,
    );
    listaMenu.add(opcionMenu);

    listaMenu.add(Column(
      children: [
        const Divider(),
//Opcion Menu Acerca de app
        /* ListTile(
          onTap: () {
            context.pop();
          },
          leading: getIcon('aboutApp'),
          horizontalTitleGap: 0.0,
          title: Text(context.appLocalization.titleAboutApp,
              style: AppStyles.textStyleMenuStatic),
          hoverColor: AppStyles.colorRedPrimary,
          focusColor: AppStyles.colorRedPrimary,
        ), */
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

  static Icon getIcon(String nombreIcono) {
    return Icon(
      AppConstants.iconsMenu[nombreIcono],
    );
  }

  static BlocListener listenerNavigationBloc() {
    return BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
      if (state is NavigationCurrentChangedState) {
        context.go(state.currentPage.routeName);
      }
    });
  }

  static BlocListener listenerLogoutBloc() {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginShowLoadingState) {
        LoadingBuilder(context)
            .showLoadingIndicator(context.appLocalization.titleLogoutLoading);
      } else if (state is LogoutSuccessState) {
        BlocProvider.of<MainBloc>(context).doctorAvailableSwitch = false;
        LoadingBuilder(context).hideOpenDialog();
        context.go(GeoAmdRoutes.login);
      } else if (state is LoginErrorState) {
        LoadingBuilder(context).hideOpenDialog();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: AppMessages()
                    .getMessageTitle(context, AppConstants.statusError),
                descriptions: AppMessages().getMessage(context, state.message),
                isConfirmation: false,
                dialogAction: () {},
                type: AppConstants.statusError,
                isdialogCancel: false,
                dialogCancel: () {},
              );
            });
        context.go(GeoAmdRoutes.login);
      } else if (state is LogoutDoctorInAttentionState) {
        LoadingBuilder(context).hideOpenDialog();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: AppMessages()
                    .getMessageTitle(context, AppConstants.statusWarning),
                descriptions: AppMessages().getMessage(context, state.message),
                isConfirmation: false,
                dialogAction: () {},
                type: AppConstants.statusWarning,
                isdialogCancel: false,
                dialogCancel: () {},
              );
            });
      }
    });
  }

  static int getIndexMenu(
      {required BuildContext context, required String routeParam}) {
    int valor = 0;
    final List<MenuModel> opcionesMenu =
        BlocProvider.of<LoginBloc>(context).listMenu;
    for (var index = 0; index < opcionesMenu.length; index++) {
      var opcion = opcionesMenu[index];
      if (opcion.route == routeParam) {
        valor = index;
        break;
      }
    }
    return valor;
  }

  static void pageCurrentChanged(
      {required BuildContext context, required String routeParam}) {
    final List<MenuModel> opcionesMenu =
        BlocProvider.of<LoginBloc>(context).listMenu;
    for (var index = 0; index < opcionesMenu.length; index++) {
      var opcion = opcionesMenu[index];
      if (opcion.route == routeParam) {
        BlocProvider.of<NavigationBloc>(context)
            .add(NavigationPageEvent(page: index, pagesMenu: opcionesMenu));
        break;
      }
    }
  }
}
