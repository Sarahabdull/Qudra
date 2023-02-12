import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OccasionsListShimmer extends StatelessWidget {
  const OccasionsListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: colorBaseShimmer,
        highlightColor: colorHighlightColorShimmer,
        child: Padding(
          padding:
              const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
          child: Container(
            width: 80,
            height: 80,
            // margin: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, top: 8.w),
            // padding: EdgeInsetsDirectional.all(16.w),
            decoration: BoxDecoration(
                color: colorGreyForShimmerItem,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  // margin: EdgeInsetsDirectional.only(start: 3.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorGreyForShimmerItem,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width) - 175,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width) - 175,
                          height: 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: colorGreyForShimmerItem),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width) - 200,
                          height: 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: colorGreyForShimmerItem),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width) - 175,
                          height: 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: colorGreyForShimmerItem),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 18,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: colorGreyForShimmerItem),
                ),
                // SizedBox(width: 5,)
              ],
            ),
          ),
        ),
      ),
      itemCount: 10,
    );
  }
}

// var colorBaseShimmer = MyColors.primary.withOpacity(.6);
// var colorHighlightColorShimmer = MyColors.primary.withOpacity(.8);

var colorBaseShimmer = Colors.black12.withOpacity(0.4);
var colorHighlightColorShimmer = Colors.black12.withOpacity(0.75);

var colorGreyForShimmerItem = Colors.grey.withOpacity(.2);
