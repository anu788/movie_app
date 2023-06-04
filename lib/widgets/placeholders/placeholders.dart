import 'package:flutter/material.dart';
import 'package:yolo_movies_app/services/size_config.dart';

// Placeholder for Specifc size list items. Used in MoviesListView
class ListItemPlaceholder extends StatelessWidget {
  const ListItemPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: 8.withHeightFactor),
        Flexible(
          flex: 1,
          child: Container(
            height: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Placeholder for Details page. Used in MovieDetailsPage
class DetailsPlaceholder extends StatelessWidget {
  const DetailsPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(20.withTextFactor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    height: SizeConfig.screenHeight / 6,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.withWidthFactor),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 20.withHeightFactor),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.withHeightFactor),
                      Expanded(
                        child: Container(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.withHeightFactor),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20.withHeightFactor),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
