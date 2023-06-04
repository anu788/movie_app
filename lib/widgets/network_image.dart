import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yolo_movies_app/constants/app_constants.dart';
import 'package:yolo_movies_app/constants/image_constants.dart';
import 'package:yolo_movies_app/widgets/placeholders/shimmer_widget.dart';

// Widget to display network image with placeholder and error builder
class NetworkImageWidget extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Widget Function(ImageProvider?)? imageBuilder;
  final Widget? placeholder;
  final Widget Function(String)? onError;
  final BoxFit? fit;

  const NetworkImageWidget({
    required this.url,
    this.height,
    this.width,
    this.borderRadius,
    this.imageBuilder,
    this.placeholder,
    this.onError,
    this.fit,
    super.key,
  });

  Widget _errorWidget(String error) {
    if (onError != null) return onError!(error);
    return Image.asset(
      ImagePathConstants.thumbnail,
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      fit: fit ?? BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) return _errorWidget("No Image found");

    return CachedNetworkImage(
      imageUrl: AppConstants.imageBaseUrl + url!,
      imageBuilder: (_, imageProvider) => imageBuilder != null
          ? imageBuilder!(imageProvider)
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit ?? BoxFit.cover,
                ),
              ),
            ),
      placeholder: (_, __) =>
          placeholder ??
          ShimmerWidget(
            child: Container(
              width: width ?? double.infinity,
              height: height ?? double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey,
              ),
            ),
          ),
      errorWidget: (context, url, error) => _errorWidget(error.toString()),
      fit: fit ?? BoxFit.cover,
      fadeOutDuration: const Duration(milliseconds: 100),
      fadeInDuration: const Duration(milliseconds: 300),
    );
  }
}
