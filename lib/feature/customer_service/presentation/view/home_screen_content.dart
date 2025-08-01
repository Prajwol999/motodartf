// lib/feature/review/presentation/view/service_reviews_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motofix_app/core/common/app_colors.dart';
import 'package:motofix_app/feature/review/domain/entity/review_entity.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_event.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_state.dart';
import 'package:motofix_app/feature/review/presentation/view_model/review_view_model.dart';

class ServiceReviewsDialog extends StatelessWidget {
  final String serviceId;
  final String serviceName;

  const ServiceReviewsDialog({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    // Use BlocProvider to provide the ReviewBloc specifically to this dialog.
    // This ensures that the BLoC is created when the dialog is shown
    // and disposed of when it's closed.
    return BlocProvider.value(
      value: context.read<ReviewBloc>()..add(FetchServiceReviews(serviceId)),
      child: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          return AlertDialog(
            backgroundColor: AppColors.neutralDarkGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.neutralLightGrey),
            ),
            title: Text(
              'Reviews for "$serviceName"',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.5,
              child: _buildContent(context, state),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Reset state before closing to ensure it's fresh next time
                  context.read<ReviewBloc>().add(ReviewReset());
                  Navigator.of(context).pop();
                },
                child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReviewState state) {
    if (state is ServiceReviewsLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.brandPrimary));
    } else if (state is ServiceReviewsError) {
      return _buildErrorState(context, state.message);
    } else if (state is ServiceReviewsLoaded) {
      if (state.reviews.isEmpty) {
        return _buildEmptyState();
      }
      return _buildReviewsList(state.reviews);
    }
    // Initial or other states
    return const Center(child: CircularProgressIndicator(color: AppColors.brandPrimary));
  }

  Widget _buildReviewsList(List<ReviewEntity> reviews) {
    return ListView.separated(
      itemCount: reviews.length,
      separatorBuilder: (context, index) => Divider(
        color: AppColors.neutralLightGrey.withOpacity(0.5),
        height: 24,
      ),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _ReviewListItem(review: review);
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.commentSlash, color: AppColors.textSecondary, size: 32),
          SizedBox(height: 16),
          Text(
            'No reviews yet',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            'Be the first to share your experience!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.triangleExclamation, color: AppColors.statusError, size: 32),
          const SizedBox(height: 16),
          Text(
            'Failed to load reviews',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => context.read<ReviewBloc>().add(FetchServiceReviews(serviceId)),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary,
              foregroundColor: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewListItem extends StatelessWidget {
  final ReviewEntity review;

  const _ReviewListItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // User avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.neutralDark,
              child: Text(
                review.user?.fullName[0] ?? 'U',
                style: const TextStyle(color: AppColors.brandPrimary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            // User name and rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.user?.fullName ?? 'Anonymous',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _StarRating(rating: review.rating),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Comment
        Text(
          review.comment,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
          color: Colors.amber,
          size: 14,
        );
      }),
    );
  }
}