import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';

class ApartmentGallery extends StatefulWidget {

  final List<String> images;

  const ApartmentGallery({
    super.key,
    required this.images,
  });

  @override
  State<ApartmentGallery> createState() =>
      _ApartmentGalleryState();
}

class _ApartmentGalleryState
    extends State<ApartmentGallery> {

  final controller = PageController();

  int current = 0;

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  String buildImageUrl(String path) {

    if (path.isEmpty) {
      return '';
    }

    /// already full url
    if (path.startsWith('http')) {
      return path;
    }

    final serverUrl =
        AppConfig.serverUrl;

    if (path.startsWith('/')) {
      return '$serverUrl$path';
    }

    return '$serverUrl/$path';
  }

  @override
  Widget build(BuildContext context) {

    // empty images
    if (widget.images.isEmpty) {

      return Container(

        height: 320,

        color: AppColors.border,

        child: const Center(

          child: Icon(

            Icons.apartment,

            size: 90,

            color: AppColors.muted,
          ),
        ),
      );
    }

    return SizedBox(

      height: 320,

      child: Stack(

        children: [

          /// gallery
          PageView.builder(

            controller: controller,

            physics:
            const BouncingScrollPhysics(),

            itemCount:
            widget.images.length,

            onPageChanged: (value) {

              setState(() {

                current = value;
              });
            },

            itemBuilder: (_, index) {

              final image =
              buildImageUrl(
                widget.images[index],
              );

              return Image.network(

                image,

                fit: BoxFit.cover,

                width: double.infinity,

                loadingBuilder:
                    (
                    context,
                    child,
                    progress,
                    ) {

                  if (progress == null) {
                    return child;
                  }

                  return Container(

                    color: AppColors.border,

                    child: const Center(

                      child:
                      CircularProgressIndicator(),
                    ),
                  );
                },

                errorBuilder:
                    (_, __, ___) {

                  return Container(

                    color: AppColors.border,

                    child: const Center(

                      child: Icon(

                        Icons.broken_image_outlined,

                        size: 70,

                        color:
                        AppColors.muted,
                      ),
                    ),
                  );
                },
              );
            },
          ),

          /// gradient overlay
          Positioned(

            bottom: 0,
            left: 0,
            right: 0,

            child: Container(

              height: 120,

              decoration: BoxDecoration(

                gradient: LinearGradient(

                  begin:
                  Alignment.topCenter,

                  end:
                  Alignment.bottomCenter,

                  colors: [

                    Colors.transparent,

                    Colors.black.withValues(
                      alpha: .45,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// counter
          Positioned(

            top: 50,
            right: 18,

            child: Container(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),

              decoration: BoxDecoration(

                color:
                Colors.black.withValues(
                  alpha: .45,
                ),

                borderRadius:
                BorderRadius.circular(100),
              ),

              child: Text(

                "${current + 1}/${widget.images.length}",

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),

          /// indicators
          Positioned(

            bottom: 22,
            left: 0,
            right: 0,

            child: Row(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: List.generate(

                widget.images.length,

                    (index) {

                  final isActive =
                      current == index;

                  return AnimatedContainer(

                    duration:
                    const Duration(
                      milliseconds: 250,
                    ),

                    margin:
                    const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),

                    width:
                    isActive ? 24 : 8,

                    height: 8,

                    decoration: BoxDecoration(

                      color:

                      isActive

                          ? Colors.white

                          : Colors.white.withValues(
                        alpha: .45,
                      ),

                      borderRadius:
                      BorderRadius.circular(50),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}