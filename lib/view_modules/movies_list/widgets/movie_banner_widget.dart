import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo_movies_app/view_modules/movies_list/bloc/bloc.dart';
import 'package:yolo_movies_app/widgets/placeholders/shimmer_widget.dart';

// CollapsibleHeader widget is used in MoviesListView.
// The background image is provided by BannerUrlCubit.
// It creates a fade animation when the image is changed.
class MovieBannerWidget extends StatelessWidget {
  const MovieBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: BlocBuilder<MovieBannerProvider, Uint8List?>(
        builder: (context, data) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _WidgetBuilder(
              data: data,
              key: ValueKey(data),
            ),
          );
        },
      ),
    );
  }
}

class _WidgetBuilder extends StatelessWidget {
  final Uint8List? data;
  const _WidgetBuilder({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return ShimmerWidget(
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
    return Stack(
      children: [
        Positioned.fill(
          child: Image.memory(
            data!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }
}
