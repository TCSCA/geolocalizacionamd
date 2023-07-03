import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '/app/extensions/localization_ext.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/amd_history/amd_history_page.dart';
import '/app/pages/sources/amd_pending/amd_pending_page.dart';
import '/app/pages/sources/login/bloc/login_bloc.dart';
import '/app/pages/sources/main/main_page.dart';
import '/app/pages/sources/profile/profile_page.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/shared/loading/loading_builder.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPage = 0;
  final screens = [
    const MainPage(),
    const AmdPendingPage(),
    const AmdHistoryPage(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginShowLoadingState) {
            LoadingBuilder(context).showLoadingIndicator(
                context.appLocalization.titleLogoutLoading);
          }
          if (state is LogoutSuccessState) {
            LoadingBuilder(context).hideOpenDialog();
            context.go(GeoAmdRoutes.login);
          }
          if (state is LoginErrorState) {
            LoadingBuilder(context).hideOpenDialog();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                      title: AppMessages()
                          .getMessageTitle(context, AppConstants.statusError),
                      descriptions:
                          AppMessages().getMessage(context, state.message),
                      isConfirmation: false,
                      dialogAction: () {},
                      type: AppConstants.statusError,
                      isdialogCancel: false,
                      dialogCancel: () {});
                });
            context.go(GeoAmdRoutes.login);
          }
        },
        builder: (context, state) {
          return IndexedStack(
            index: currentPage,
            children: screens,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade700,
        //selectedLabelStyle: const TextStyle(color: Colors.black),
        //unselectedLabelStyle: TextStyle(color: Colors.grey.shade700),
        //backgroundColor: const Color(0xffD84835),
        items: [
          BottomNavigationBarItem(
              label: 'Inicio',
              icon: currentPage == 0
                  ? const Icon(
                      Icons.home,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.home_outlined,
                      color: Colors.grey.shade700,
                    )),
          BottomNavigationBarItem(
              icon: currentPage == 1
                  ? const Icon(Icons.work_history, color: Colors.black)
                  : Icon(Icons.work_history_outlined,
                      color: Colors.grey.shade700),
              label: 'Atención'),
          BottomNavigationBarItem(
              icon: currentPage == 2
                  ? const Icon(Icons.note_add, color: Colors.black)
                  : Icon(Icons.note_add_outlined, color: Colors.grey.shade700),
              label: 'Historial'),
          BottomNavigationBarItem(
              icon: currentPage == 3
                  ? const Icon(Icons.person_pin, color: Colors.black)
                  : Icon(Icons.person_pin_outlined,
                      color: Colors.grey.shade700),
              label: 'Perfil')
        ],
      ),
    );
  }
}
