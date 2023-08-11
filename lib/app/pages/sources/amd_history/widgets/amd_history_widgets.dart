import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/app/core/models/menu_model.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/sources/login/bloc/login_bloc.dart';
import '/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import '/app/pages/widgets/common_widgets.dart';

class AmdHistoryWidgets {
  PreferredSizeWidget generateAppBarWithTabBar(
      {required BuildContext context}) {
    final int currentIndex =
        BlocProvider.of<NavigationBloc>(context).currentIndex;
    final List<MenuModel> lista = BlocProvider.of<LoginBloc>(context).listMenu;
    final String menuOpTitle = lista[currentIndex].descripcion;
    //final String menuOpIcon = lista[currentIndex].icon;
    return AppBar(
      backgroundColor: const Color(0xff2B5178),
      toolbarHeight: 140.0,
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
      bottom: const TabBar(
          labelColor: Color(0xffD84835),
          unselectedLabelColor: Colors.white,
          indicatorColor: Color(0xffD84835),
          indicatorWeight: 5,
          /* indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), // Creates border
                    color: Colors.greenAccent), */
          tabs: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.houseMedicalCircleCheck, size: 30.0),
                  SizedBox(
                    width: 17.0,
                  ),
                  Text(
                    "Finalizadas",
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.houseMedicalCircleXmark, size: 30.0),
                SizedBox(
                  width: 17.0,
                ),
                Text(
                  "Rechazadas",
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ]),
    );
  }
}
