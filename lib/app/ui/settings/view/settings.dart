import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tada/app/controller/todo_controller.dart';
import 'package:tada/app/controller/isar_contoller.dart';
import 'package:tada/app/data/db.dart';
import 'package:tada/app/ui/settings/widgets/settings_card.dart';
import 'package:tada/main.dart';
import 'package:tada/theme/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final todoController = Get.put(TodoController());
  final isarController = Get.put(IsarController());
  final themeController = Get.put(ThemeController());
  String? appVersion;

  Future<void> infoVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  void updateLanguage(Locale locale) {
    settings.language = '$locale';
    isar.writeTxnSync(() => isar.settings.putSync(settings));
    Get.updateLocale(locale);
    Get.back();
  }

  void urlLauncher(String uri) async {
    final Uri url = Uri.parse(uri);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  String firstDayOfWeek(newValue) {
    if (newValue == 'monday'.tr) {
      return 'monday';
    } else if (newValue == 'tuesday'.tr) {
      return 'tuesday';
    } else if (newValue == 'wednesday'.tr) {
      return 'wednesday';
    } else if (newValue == 'thursday'.tr) {
      return 'thursday';
    } else if (newValue == 'friday'.tr) {
      return 'friday';
    } else if (newValue == 'saturday'.tr) {
      return 'saturday';
    } else if (newValue == 'sunday'.tr) {
      return 'sunday';
    } else {
      return 'monday';
    }
  }

  @override
  void initState() {
    infoVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'settings'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingCard(
              icon: const Icon(IconsaxPlusLinear.brush_1),
              text: 'appearance'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Text(
                                    'appearance'.tr,
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon: const Icon(IconsaxPlusLinear.moon),
                                  text: 'theme'.tr,
                                  dropdown: true,
                                  dropdownName: settings.theme?.tr,
                                  dropdownList: <String>[
                                    'system'.tr,
                                    'dark'.tr,
                                    'light'.tr
                                  ],
                                  dropdownCange: (String? newValue) {
                                    ThemeMode themeMode =
                                        newValue?.tr == 'system'.tr
                                            ? ThemeMode.system
                                            : newValue?.tr == 'dark'.tr
                                                ? ThemeMode.dark
                                                : ThemeMode.light;
                                    String theme = newValue?.tr == 'system'.tr
                                        ? 'system'
                                        : newValue?.tr == 'dark'.tr
                                            ? 'dark'
                                            : 'light';
                                    themeController.saveTheme(theme);
                                    themeController.changeThemeMode(themeMode);
                                    setState(() {});
                                  },
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon: const Icon(IconsaxPlusLinear.mobile),
                                  text: 'amoledTheme'.tr,
                                  switcher: true,
                                  value: settings.amoledTheme,
                                  onChange: (value) {
                                    themeController.saveOledTheme(value);
                                    MyApp.updateAppState(context,
                                        newAmoledTheme: value);
                                  },
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon:
                                      const Icon(IconsaxPlusLinear.colorfilter),
                                  text: 'materialColor'.tr,
                                  switcher: true,
                                  value: settings.materialColor,
                                  onChange: (value) {
                                    themeController.saveMaterialTheme(value);
                                    MyApp.updateAppState(context,
                                        newMaterialColor: value);
                                  },
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon: const Icon(IconsaxPlusLinear.image),
                                  text: 'isImages'.tr,
                                  switcher: true,
                                  value: settings.isImage,
                                  onChange: (value) {
                                    isar.writeTxnSync(() {
                                      settings.isImage = value;
                                      isar.settings.putSync(settings);
                                    });
                                    MyApp.updateAppState(context,
                                        newIsImage: value);
                                  },
                                ),
                                const Gap(10),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(IconsaxPlusLinear.code_1),
              text: 'functions'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Text(
                                    'functions'.tr,
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon: const Icon(IconsaxPlusLinear.clock_1),
                                  text: 'timeformat'.tr,
                                  dropdown: true,
                                  dropdownName: settings.timeformat.tr,
                                  dropdownList: <String>['12'.tr, '24'.tr],
                                  dropdownCange: (String? newValue) {
                                    isar.writeTxnSync(() {
                                      settings.timeformat =
                                          newValue == '12'.tr ? '12' : '24';
                                      isar.settings.putSync(settings);
                                    });
                                    MyApp.updateAppState(context,
                                        newTimeformat:
                                            newValue == '12'.tr ? '12' : '24');
                                    setState(() {});
                                  },
                                ),
                                // SettingCard(
                                //   elevation: 4,
                                //   icon: const Icon(
                                //       IconsaxPlusLinear.calendar_edit),
                                //   text: 'firstDayOfWeek'.tr,
                                //   dropdown: true,
                                //   dropdownName: settings
                                //       .firstDay, // Use the internal, untranslated value
                                //   dropdownList: const <String>[
                                //     'monday',
                                //     'tuesday',
                                //     'wednesday',
                                //     'thursday',
                                //     'friday',
                                //     'saturday',
                                //     'sunday',
                                //   ].map((day) => day.tr).toList(),
                                //   dropdownCange: (String? newValue) {
                                //     // Convert the translated value back to its original key
                                //     String internalValue;
                                //     if (newValue == 'monday'.tr) {
                                //       internalValue = 'monday';
                                //     } else if (newValue == 'tuesday'.tr) {
                                //       internalValue = 'tuesday';
                                //     } else if (newValue == 'wednesday'.tr) {
                                //       internalValue = 'wednesday';
                                //     } else if (newValue == 'thursday'.tr) {
                                //       internalValue = 'thursday';
                                //     } else if (newValue == 'friday'.tr) {
                                //       internalValue = 'friday';
                                //     } else if (newValue == 'saturday'.tr) {
                                //       internalValue = 'saturday';
                                //     } else if (newValue == 'sunday'.tr) {
                                //       internalValue = 'sunday';
                                //     } else {
                                //       internalValue =
                                //           'monday'; // Default fallback, just in case
                                //     }

                                //     // Save the value without translation
                                //     isar.writeTxnSync(() {
                                //       settings.firstDay = internalValue;
                                //       isar.settings.putSync(settings);
                                //     });

                                //     // Update the UI state and app
                                //     MyApp.updateAppState(context,
                                //         newTimeformat: internalValue);
                                //     setState(() {});
                                //   },
                                // ),
                                SettingCard(
                                  elevation: 4,
                                  icon:
                                      const Icon(IconsaxPlusLinear.cloud_plus),
                                  text: 'backup'.tr,
                                  onPressed: isarController.createBackUp,
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon: const Icon(IconsaxPlusLinear.cloud_add),
                                  text: 'restore'.tr,
                                  onPressed: isarController.restoreDB,
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon:
                                      const Icon(IconsaxPlusLinear.cloud_minus),
                                  text: 'deleteAllBD'.tr,
                                  onPressed: () => showAdaptiveDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog.adaptive(
                                      title: Text(
                                        'deleteAllBDTitle'.tr,
                                        style: context.textTheme.titleLarge,
                                      ),
                                      content: Text(
                                        'deleteAllBDQuery'.tr,
                                        style: context.textTheme.titleMedium,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Get.back(),
                                            child: Text('cancel'.tr,
                                                style: context
                                                    .theme.textTheme.titleMedium
                                                    ?.copyWith(
                                                        color: Colors
                                                            .blueAccent))),
                                        TextButton(
                                            onPressed: () {
                                              isar.writeTxnSync(() {
                                                isar.todos.clearSync();
                                                isar.tasks.clearSync();
                                                todoController.tasks.clear();
                                                todoController.todos.clear();
                                              });
                                              EasyLoading.showSuccess(
                                                  'deleteAll'.tr);
                                              Get.back();
                                            },
                                            child: Text('delete'.tr,
                                                style: context
                                                    .theme.textTheme.titleMedium
                                                    ?.copyWith(
                                                        color: Colors.red))),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(10),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(IconsaxPlusLinear.language_square),
              text: 'language'.tr,
              info: true,
              infoSettings: true,
              textInfo: appLanguages.firstWhere(
                  (element) => (element['locale'] == locale),
                  orElse: () => appLanguages.first)['name'],
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  'language'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: appLanguages.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: ListTile(
                                      title: Text(
                                        appLanguages[index]['name'],
                                        style: context.textTheme.labelLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: () {
                                        MyApp.updateAppState(context,
                                            newLocale: appLanguages[index]
                                                ['locale']);
                                        updateLanguage(
                                            appLanguages[index]['locale']);
                                      },
                                    ),
                                  );
                                },
                              ),
                              const Gap(10),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(IconsaxPlusLinear.dollar_square),
              text: 'support'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Text(
                                    'support'.tr,
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon: const Icon(IconsaxPlusLinear.card),
                                  text: 'Ko-Fi',
                                  onPressed: () => urlLauncher(
                                      'https://ko-fi.com/pranaykiran'),
                                ),
                                SettingCard(
                                  elevation: 4,
                                  icon: const Icon(IconsaxPlusLinear.wallet),
                                  text: 'PayPal',
                                  onPressed: () => urlLauncher(
                                      'https://www.paypal.com/paypalme/pranaykiran'),
                                ),
                                const Gap(10),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(IconsaxPlusLinear.link_square),
              text: 'groups'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Text(
                                    'groups'.tr,
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                // SettingCard(
                                //   elevation: 4,
                                //   icon: const Icon(LineAwesomeIcons.discord),
                                //   text: 'Discord',
                                //   onPressed: () => urlLauncher(
                                //       'https://discord.gg/JMMa9aHh8f'),
                                // ),
                                SettingCard(
                                  elevation: 4,
                                  icon: const Icon(LineAwesomeIcons.instagram),
                                  text: 'Instagran',
                                  onPressed: () => urlLauncher(
                                      'https://instagram.com/pranay_kiran'),
                                ),
                                const Gap(10),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(IconsaxPlusLinear.document),
              text: 'license'.tr,
              onPressed: () => Get.to(
                () => LicensePage(
                  applicationIcon: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                            image: AssetImage('assets/icons/icon.png'))),
                  ),
                  applicationName: 'TaDa',
                  applicationVersion: appVersion,
                ),
                transition: Transition.downToUp,
              ),
            ),
            SettingCard(
              icon: const Icon(IconsaxPlusLinear.hierarchy_square_2),
              text: 'version'.tr,
              info: true,
              textInfo: '$appVersion',
            ),
            SettingCard(
              icon: const Icon(LineAwesomeIcons.github),
              text: '${'project'.tr} GitHub',
              onPressed: () =>
                  urlLauncher('https://github.com/KiranPranay/TaDa'),
            ),
            SettingCard(
              icon: const Icon(LineAwesomeIcons.book_open_solid),
              text: 'Privacy Policy',
              onPressed: () => urlLauncher(
                  'https://weber.cottonseeds.org/privacypolicies/tada'),
            ),
          ],
        ),
      ),
    );
  }
}
