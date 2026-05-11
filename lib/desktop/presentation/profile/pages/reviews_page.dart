import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../desktop/presentation/profile/widgets/review_card.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MyProfileError) {
          return Center(child: Text(state.message));
        } else if (state is MyProfileLoaded) {
          final reviews = state.profile.reviews;

          if (reviews.isEmpty) {
            return Center(
              child: Text(
                "No reviews found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: reviews
                  .map(
                    (review) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ReviewCard(
                        name: review.reviewer.name,
                        review: review.review,
                        rating: review.rating,
                        image: review.reviewer.userImage.secureUrl,
                        role: review.reviewer.role,
                        time: review.createdAt,
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        } else {
          return const SizedBox(); // initial state
        }
      },
    );
  }
}
