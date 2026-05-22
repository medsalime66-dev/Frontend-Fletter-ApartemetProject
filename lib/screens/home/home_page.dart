import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/apartment/apartment_controller.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../widgets/apartment/apartment_card.dart';

import '../../widgets/common/section_title.dart';

import '../detail/detail_page.dart';

import '../profile/profile_page.dart';

import '../search/search_page.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState
    extends State<HomePage> {

  final apartmentController =
  Get.find<ApartmentController>();

  int selectedIndex = 0;

  @override
  void initState() {

    super.initState();

    apartmentController
        .loadApartments();
  }

  @override
  Widget build(BuildContext context) {

    final pages = [

      const _HomeContent(),

      SearchPage(
        apartments:
        apartmentController
            .apartments,
      ),

      const ProfilePage(),
    ];

    return Obx(() {

      return Scaffold(

        body:
        apartmentController
            .isLoading
            .value

            ? const Center(
          child:
          CircularProgressIndicator(),
        )

            : pages[selectedIndex],

        bottomNavigationBar:
        NavigationBar(

          selectedIndex:
          selectedIndex,

          backgroundColor:
          AppColors.surface,

          indicatorColor:
          AppColors.primary
              .withValues(
            alpha: .15,
          ),

          onDestinationSelected:
              (value) {

            setState(() {

              selectedIndex =
                  value;
            });
          },

          destinations: const [

            NavigationDestination(

              icon: Icon(
                Icons.home_outlined,
              ),

              selectedIcon:
              Icon(Icons.home),

              label: 'Home',
            ),

            NavigationDestination(

              icon: Icon(
                Icons.search,
              ),

              selectedIcon:
              Icon(Icons.search),

              label: 'Search',
            ),

            NavigationDestination(

              icon: Icon(
                Icons.person_outline,
              ),

              selectedIcon:
              Icon(Icons.person),

              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}

class _HomeContent
    extends StatelessWidget {

  const _HomeContent();

  @override
  Widget build(BuildContext context) {

    final apartmentController =
    Get.find<
        ApartmentController>();

    return SafeArea(

      child: RefreshIndicator(

        onRefresh: () async {

          await apartmentController
              .loadApartments();
        },

        child: Obx(() {

          final apartments =
              apartmentController
                  .apartments;

          return ListView(

            padding:
            const EdgeInsets.all(
              AppSpacing.screen,
            ),

            children: [

              /// header
              Row(

                children: [

                  const Expanded(

                    child: Text(

                      'SAKAN \nFind your next stay',

                      style:
                      AppTextStyles.h1,
                    ),
                  ),

                  IconButton
                      .filledTonal(

                    onPressed: () {},

                    icon: const Icon(
                      Icons
                          .notifications_none,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              /// search box
              GestureDetector(

                onTap: () {

                  Get.to(
                        () => SearchPage(
                      apartments:
                      apartments,
                    ),
                  );
                },

                child: Container(

                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),

                  decoration:
                  BoxDecoration(

                    color:
                    AppColors
                        .surface,

                    borderRadius:
                    BorderRadius
                        .circular(
                      22,
                    ),

                    border:
                    Border.all(
                      color:
                      AppColors
                          .border,
                    ),
                  ),

                  child: const Row(

                    children: [

                      Icon(

                        Icons.search,

                        color:
                        AppColors
                            .muted,
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Text(

                        'Search city or district',

                        style:
                        TextStyle(
                          color:
                          AppColors
                              .muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 26,
              ),

              /// title
              const SectionTitle(

                title:
                'Available Apartments',

                actionText:
                'Refresh',
              ),

              const SizedBox(
                height: 14,
              ),

              /// empty
              if (apartments
                  .isEmpty)

                const Padding(

                  padding:
                  EdgeInsets.all(
                    40,
                  ),

                  child: Center(

                    child: Text(
                      'No apartments found',
                    ),
                  ),
                ),

              /// apartments
              ...apartments.map(
                    (apartment) {

                  return ApartmentCard(

                    apartment:
                    apartment,

                    onTap: () {

                      Get.to(
                            () =>
                            DetailPage(
                              apartment:
                              apartment,
                            ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}