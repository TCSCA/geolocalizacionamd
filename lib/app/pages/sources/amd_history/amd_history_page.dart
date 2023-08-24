import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:geolocalizacionamd/app/core/controllers/amd_history_controller.dart';
import 'package:geolocalizacionamd/app/core/models/home_service_model.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_history/bloc/amd_history_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_history/widgets/expansion_title_widget.dart';
import '../../../shared/dialog/custom_dialog_box.dart';
import '../../../shared/loading/loading_builder.dart';
import '../../../shared/method/back_button_action.dart';
import '../../constants/app_constants.dart';
import '../../messages/app_messages.dart';
import '/app/pages/widgets/common_widgets.dart';
import 'widgets/amd_history_widgets.dart';

class AmdHistoryPage extends StatefulWidget {
  const AmdHistoryPage({super.key});

  @override
  State<AmdHistoryPage> createState() => _AmdHistoryPageState();
}

class _AmdHistoryPageState extends State<AmdHistoryPage>
    with AmdHistoryWidgets {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: WillPopScope(
          onWillPop: () => backButtonActions(),
          child: Scaffold(
            appBar: generateAppBarWithTabBar(context: context),
            body: MultiBlocListener(
              listeners: [
                //NavigationBloc y LogoutBloc comunes en todas las paginas.
                AppCommonWidgets.listenerNavigationBloc(),
                AppCommonWidgets.listenerLogoutBloc()
              ],
              child: BlocProvider(
                create: (context) =>
                    AmdHistoryBloc(amdHistoryController: AmdHistoryController())
                      ..add(GetAmdHistoryEvent()),
                child: const TabBarViewWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AmdHistoryBloc, AmdHistoryState>(
      listener: (context, state) {
        if (state is AmdHistoryLoadingState) {
          LoadingBuilder(context).showLoadingIndicator('Cargando historial');
        } else if (state is AmdHistorySuccessDataState) {
          LoadingBuilder(context).hideOpenDialog();
        }
        if (state is AmdHistoryErrorState) {
          LoadingBuilder(context).hideOpenDialog();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusError),
                  descriptions:
                      AppMessages().getMessage(context, state.messageError),
                  isConfirmation: false,
                  dialogAction: () {},
                  type: AppConstants.statusError,
                  isdialogCancel: false,
                  dialogCancel: () {},
                );
              });
        }
      },
      builder: (context, state) {
        if (state is AmdHistorySuccessDataState) {
          return TabBarView(
            children: [
              ListViewHistoryAmd(
                homeService: state.homeServiceF,
              ),
              ListViewHistoryAmd(
                homeService: state.homeServiceP,
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class ListViewHistoryAmd extends StatelessWidget {
  final List<HomeServiceModel>? homeService;

  const ListViewHistoryAmd({
    super.key,
    this.homeService,
  });

  @override
  Widget build(BuildContext context) {
    if (homeService!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/gps_doctor_image.png',
            width: 300,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            context.appLocalization.appMsg137,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'TitlesHighlight',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: homeService?.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTitleWidget(
            orderNumber: homeService?[index].orderNumber,
            dateOrderDay: homeService?[index].registerDate.day,
            dateOrderMonth: homeService?[index].registerDate.month,
            dateOrderYear: homeService?[index].registerDate.year,
            fullNamePatient: homeService?[index].fullNamePatient,
            identificationDocument: homeService?[index].identificationDocument,
            phoneNumberPatient: homeService?[index].phoneNumberPatient,
            address: homeService?[index].address,
            applicantDoctor: homeService?[index].applicantDoctor,
            phoneNumberDoctor: homeService?[index].phoneNumberDoctor,
            typeService: homeService?[index].typeService,
            linkAmd: homeService?[index].linkAmd,
            statusHomeService: homeService?[index].statusHomeService,
              statusLinkAmd: homeService?[index].statusLinkAmd
          );
        },
      );
    }
  }
}
