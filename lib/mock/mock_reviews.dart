import '../config/mock_config.dart';

/// Mock Reviews Repository
/// Provides realistic mock review data for contact timeline
class MockReviews {
  static final List<Review> _reviews = [
    Review(
      id: 'review_1',
      contactId: '1',
      contactName: 'John Smith',
      source: ReviewSource.google,
      rating: 5,
      reviewText: 'Excellent service! Very professional and on time. The boiler repair was completed quickly and efficiently.',
      reviewerName: 'John Smith',
      reviewDate: DateTime.now().subtract(const Duration(days: 2)),
      responded: true,
      responseText: 'Thank you for your kind words, John! We\'re glad we could help.',
      responseDate: DateTime.now().subtract(const Duration(days: 1)),
      externalUrl: 'https://maps.google.com/review/123',
    ),
    Review(
      id: 'review_2',
      contactId: '3',
      contactName: 'Mike Johnson',
      source: ReviewSource.facebook,
      rating: 5,
      reviewText: 'Amazing experience from start to finish! The team was professional and the quality of work was outstanding.',
      reviewerName: 'Mike Johnson',
      reviewDate: DateTime.now().subtract(const Duration(days: 5)),
      responded: false,
      externalUrl: 'https://facebook.com/review/456',
    ),
    Review(
      id: 'review_3',
      contactId: '1',
      contactName: 'John Smith',
      source: ReviewSource.internal,
      rating: 4,
      reviewText: 'Good work on the radiator replacement. Everything works well.',
      reviewerName: 'John Smith',
      reviewDate: DateTime.now().subtract(const Duration(days: 10)),
      responded: false,
    ),
    Review(
      id: 'review_4',
      contactId: '5',
      contactName: 'David Brown',
      source: ReviewSource.google,
      rating: 5,
      reviewText: 'Fast response and excellent quality work. Highly recommend!',
      reviewerName: 'David Brown',
      reviewDate: DateTime.now().subtract(const Duration(days: 14)),
      responded: true,
      responseText: 'Thank you for choosing Swiftlead, David!',
      responseDate: DateTime.now().subtract(const Duration(days: 13)),
      externalUrl: 'https://maps.google.com/review/789',
    ),
  ];

  /// Fetch all reviews for a contact
  static Future<List<Review>> fetchReviewsForContact(String contactId) async {
    await simulateDelay();
    final reviews = _reviews.where((r) => r.contactId == contactId).toList();
    reviews.sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
    logMockOperation('Fetched ${reviews.length} reviews for contact: $contactId');
    return reviews;
  }

  /// Fetch all reviews
  static Future<List<Review>> fetchAllReviews() async {
    await simulateDelay();
    logMockOperation('Fetched ${_reviews.length} reviews');
    return List.from(_reviews);
  }

  /// Add a new review
  static Future<Review> addReview({
    required String contactId,
    required String contactName,
    required ReviewSource source,
    required int rating,
    required String reviewText,
    required String reviewerName,
    String? externalUrl,
  }) async {
    await simulateDelay();
    final review = Review(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      contactId: contactId,
      contactName: contactName,
      source: source,
      rating: rating,
      reviewText: reviewText,
      reviewerName: reviewerName,
      reviewDate: DateTime.now(),
      responded: false,
      externalUrl: externalUrl,
    );
    _reviews.add(review);
    logMockOperation('Added review from $reviewerName');
    return review;
  }
}

/// Review model
class Review {
  final String id;
  final String contactId;
  final String contactName;
  final ReviewSource source;
  final int rating; // 1-5
  final String reviewText;
  final String reviewerName;
  final DateTime reviewDate;
  final bool responded;
  final String? responseText;
  final DateTime? responseDate;
  final String? externalUrl;

  Review({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.source,
    required this.rating,
    required this.reviewText,
    required this.reviewerName,
    required this.reviewDate,
    this.responded = false,
    this.responseText,
    this.responseDate,
    this.externalUrl,
  });
}

enum ReviewSource {
  internal,
  google,
  facebook,
  yelp,
}
