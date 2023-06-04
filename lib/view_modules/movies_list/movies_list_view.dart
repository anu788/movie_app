import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo_movies_app/models/movie_info.dart';
import 'package:yolo_movies_app/services/size_config.dart';
import 'package:yolo_movies_app/view_modules/movies_list/bloc/bloc.dart';
import 'package:yolo_movies_app/view_modules/movies_list/widgets/movie_banner_widget.dart';
import 'package:yolo_movies_app/view_modules/movies_list/widgets/collapsible_item_widget.dart';

// MoviesListView is the main view of the app.
// It contains a SliverAppBar with a flexibleSpace that has a background image.
// It also contains a SliverList with CollapsibleItemView widgets.
// It is wrapped under a BlocProvider to provide BannerurlCubit to both CollapsibleHeader and CollapsibleItemView widget.
class MoviesListView extends StatelessWidget {
  const MoviesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MovieType> movieTypes = [
      MovieType.latest,
      MovieType.popular,
      MovieType.upcoming,
      MovieType.topRated,
    ];

    return Scaffold(
      body: SafeArea(
        top: false,
        child: BlocProvider<MovieBannerProvider>(
          create: (_) => MovieBannerProvider(),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: SizeConfig.screenHeight / 3,
                flexibleSpace: const FlexibleSpaceBar(
                  background: MovieBannerWidget(),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: movieTypes.length,
                  (_, int index) => CollapsibleItemWidget(
                    initiallyExpanded: index < 2,
                    movieType: movieTypes[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
