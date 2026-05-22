import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/reservation/my_reservations_controller.dart';

import '../../models/reservation_model.dart';

class MyReservationsPage
    extends StatelessWidget {

  const MyReservationsPage({
    super.key,
  });

  Color _statusColor(
      ReservationStatus status,
      ) {

    switch (status) {

      case ReservationStatus.confirmed:
        return Colors.green;

      case ReservationStatus.cancelled:
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  String _statusText(
      ReservationStatus status,
      ) {

    switch (status) {

      case ReservationStatus.confirmed:
        return 'Confirmed';

      case ReservationStatus.cancelled:
        return 'Cancelled';

      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {

    final controller =
    Get.put(
      MyReservationsController(),
    );

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'My Reservations',
        ),
      ),

      body: Obx(() {

        if (
        controller.isLoading.value
        ) {

          return const Center(

            child:
            CircularProgressIndicator(),
          );
        }

        if (
        controller.reservations.isEmpty
        ) {

          return const Center(

            child: Text(
              'No reservations found',
            ),
          );
        }

        return RefreshIndicator(

          onRefresh:
          controller.loadReservations,

          child: ListView.builder(

            padding:
            const EdgeInsets.all(20),

            itemCount:
            controller
                .reservations
                .length,

            itemBuilder:
                (context, index) {

              final reservation =
              controller
                  .reservations[index];

              return Container(

                margin:
                const EdgeInsets.only(
                  bottom: 18,
                ),

                padding:
                const EdgeInsets.all(
                  18,
                ),

                decoration:
                BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                      Colors.black
                          .withValues(
                        alpha: .05,
                      ),

                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        Expanded(

                          child: Text(

                            reservation
                                .apartmentTitle,

                            style:
                            const TextStyle(

                              fontSize: 18,

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ),

                        Container(

                          padding:
                          const EdgeInsets
                              .symmetric(

                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            _statusColor(
                              reservation
                                  .status,
                            ).withValues(
                              alpha: .12,
                            ),

                            borderRadius:
                            BorderRadius
                                .circular(
                              20,
                            ),
                          ),

                          child: Text(

                            _statusText(
                              reservation
                                  .status,
                            ),

                            style: TextStyle(

                              color:
                              _statusColor(
                                reservation
                                    .status,
                              ),

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Text(

                      'Dates: ${reservation.startDate.toString().split(' ')[0]} → ${reservation.endDate.toString().split(' ')[0]}',
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(

                      'Total: ${reservation.totalPrice.toInt()} MRU',

                      style:
                      const TextStyle(

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}