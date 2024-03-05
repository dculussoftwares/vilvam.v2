// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/component/add_consultation.dart';
import 'package:material_3_demo/component/show_consultations.dart';
import 'package:material_3_demo/modal/ClinicDetail.dart';
import 'package:material_3_demo/pages/add_clinic_page.dart';
import 'package:material_3_demo/pages/add_patient_page.dart';
import 'package:material_3_demo/pages/patient_detail_page.dart';
import 'package:material_3_demo/pages/search_patients_page.dart';
import 'package:material_3_demo/service/DataRepository.dart';
import 'package:material_3_demo/service/locale_logic.dart';
import 'package:material_3_demo/service/settings_logic.dart';
import 'package:material_3_demo/styles.dart';
import 'package:sized_context/sized_context.dart';
import 'package:uuid/uuid.dart';
import 'package:web_startup_analyzer/web_startup_analyzer.dart';

import 'constants.dart';
import 'home.dart';
import 'modal/Patients.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pages/manage_clinic_page.dart';

var uuid = const Uuid();

Future<int> addPatients() async {
  Patients firstPlanet = Patients(
      name: "Mercury",
      age: 24,
      id: uuid.v4().toString(),
      address: "omm",
      gender: "male",
      phoneNumber: 12345678);
  Patients secondPlanet = Patients(
      name: "Venus",
      age: 31,
      phoneNumber: 12345678,
      id: uuid.v4().toString(),
      address: "omm",
      gender: "female");
  Patients thirdPlanet = Patients(
      id: uuid.v4().toString(),
      name: 'Earth',
      age: 4,
      phoneNumber: 12345678,
      address: "omm",
      gender: "trans_gender");
  Patients fourthPlanet = Patients(
      id: uuid.v4().toString(),
      name: 'Mars',
      age: 5,
      phoneNumber: 12345678,
      address: "omm",
      gender: "other_gender");

  List<Patients> planets = [
    firstPlanet,
    secondPlanet,
    thirdPlanet,
    fourthPlanet
  ];
  return await dataRepository.addPatients(planets);
}

Future<void> addClinics() async {
  List<ClinicDetail> clinicDetails = [
    ClinicDetail(
        id: "1", name: "Chennai", location: "TamilNadu", isEnabled: true),
    ClinicDetail(id: "2", name: "Trichy", location: "Trichy", isEnabled: true),
    ClinicDetail(id: "3", name: "Salem", location: "Salem", isEnabled: true)
  ];
  for (var clinicDetail in clinicDetails) {
    var u = await dataRepository.addClinic(clinicDetail);
    var x = 9;
  }
}

void main() async {
  var analyzer = WebStartupAnalyzer(additionalFrameCount: 10);
  debugPrint(json.encode(analyzer.startupTiming));
  analyzer.onFirstFrame.addListener(() {
    debugPrint(json.encode({'firstFrame': analyzer.onFirstFrame.value}));
  });
  analyzer.onFirstPaint.addListener(() {
    debugPrint(json.encode({
      'firstPaint': analyzer.onFirstPaint.value?.$1,
      'firstContentfulPaint': analyzer.onFirstPaint.value?.$2,
    }));
  });
  analyzer.onAdditionalFrames.addListener(() {
    debugPrint(json.encode({
      'additionalFrames': analyzer.onAdditionalFrames.value,
    }));
  });
  registerSingletons();
  runApp(
    const App(),
  );
  await dataRepository.initializedDB().whenComplete(() async {
    await addPatients();
    await addClinics();
    var x = await dataRepository.getAllClinic();
    var c = 99;
  });
}

void registerSingletons() {
  GetIt.I.registerLazySingleton<DataRepository>(() => DataRepository());
  GetIt.I.registerLazySingleton<LocaleLogic>(() => LocaleLogic());
  GetIt.I.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static AppStyle get style => _style;
  static AppStyle _style = AppStyle();
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;
  ColorImageProvider imageSelected = ColorImageProvider.leaves;
  ColorScheme? imageColorScheme = const ColorScheme.light();
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.colorSeed;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelectionMethod = ColorSelectionMethod.colorSeed;
      colorSelected = ColorSeed.values[value];
    });
  }

  void handleImageSelect(int value) {
    final String url = ColorImageProvider.values[value].url;
    ColorScheme.fromImageProvider(provider: NetworkImage(url))
        .then((newScheme) {
      setState(() {
        colorSelectionMethod = ColorSelectionMethod.image;
        imageSelected = ColorImageProvider.values[value];
        imageColorScheme = newScheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _style = AppStyle(screenSize: context.sizePx);
    final GoRouter _router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return Home(
              useLightMode: useLightMode,
              useMaterial3: useMaterial3,
              colorSelected: colorSelected,
              imageSelected: imageSelected,
              handleBrightnessChange: handleBrightnessChange,
              handleMaterialVersionChange: handleMaterialVersionChange,
              handleColorSelect: handleColorSelect,
              handleImageSelect: handleImageSelect,
              colorSelectionMethod: colorSelectionMethod,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'addConsultation/:patientId',
              builder: (BuildContext context, GoRouterState state) {
                var patientId = state.pathParameters['patientId'] ?? "";
                return AddConsultation(
                  patientId: patientId,
                );
              },
            ),
            GoRoute(
              path: 'showConsultation/:patientId',
              builder: (BuildContext context, GoRouterState state) {
                var patientId = state.pathParameters['patientId'] ?? "";
                return ShowConsultation(
                  patientId: patientId,
                );
              },
            ),
            GoRoute(
              path: 'searchPatientPage',
              builder: (BuildContext context, GoRouterState state) {
                return const SearchPatientPage();
              },
            ),
            GoRoute(
              path: 'patientDetailPage/:patientId',
              builder: (BuildContext context, GoRouterState state) {
                var patientId = state.pathParameters['patientId'] ?? "";
                return PatientDetailPage(
                  patientId: patientId,
                );
              },
            ),
            GoRoute(
              path: 'manageClinicPage',
              builder: (BuildContext context, GoRouterState state) {
                return ManageClinicPage();
              },
            ),
            GoRoute(
              path: 'addPatientPage',
              builder: (BuildContext context, GoRouterState state) {
                return AddPatientPage();
              },
            ),
            GoRoute(
              path: 'editPatientPage/:patientId',
              builder: (BuildContext context, GoRouterState state) {
                var patientId = state.pathParameters['patientId'] ?? "";
                return AddPatientPage(
                  patientId: patientId,
                  isEdit: true,
                );
              },
            ),
            GoRoute(
              path: 'addClinicPage',
              builder: (BuildContext context, GoRouterState state) {
                return AddClinicPage();
              },
            )
          ],
        ),
      ],
    );

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Material 3',
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelectionMethod == ColorSelectionMethod.colorSeed
            ? colorSelected.color
            : null,
        colorScheme: colorSelectionMethod == ColorSelectionMethod.image
            ? imageColorScheme
            : null,
        useMaterial3: useMaterial3,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelectionMethod == ColorSelectionMethod.colorSeed
            ? colorSelected.color
            : imageColorScheme!.primary,
        useMaterial3: useMaterial3,
        brightness: Brightness.dark,
      ),
      routerConfig: _router,
    );
  }
}

AppStyle get $styles => _AppState.style;

DataRepository get dataRepository => GetIt.I.get<DataRepository>();

SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();

LocaleLogic get localeLogic => GetIt.I.get<LocaleLogic>();

AppLocalizations get $strings => localeLogic.strings;
