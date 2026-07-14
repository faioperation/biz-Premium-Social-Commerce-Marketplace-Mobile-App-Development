import '../../live/models/live_session_data.dart';
import '../../live/models/live_comment_model.dart';

/// A model representing a recorded/past live stream session for a seller.
class PastLiveStreamModel {
  final String id;
  final String title;
  final DateTime date;
  final Duration duration;
  final int totalViewers;
  final int totalLikes;
  final LiveType liveType;
  final List<LiveStreamProduct> products;
  final List<PlaybackCommentModel> comments; // Customized for timeline playback
  final String? coverImagePath;
  final double estimatedRevenue;

  const PastLiveStreamModel({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    required this.totalViewers,
    required this.totalLikes,
    required this.liveType,
    required this.products,
    required this.comments,
    this.coverImagePath,
    required this.estimatedRevenue,
  });

  /// Generates a realistic set of mock past live streams for testing.
  static List<PastLiveStreamModel> getMockPastLives() {
    final now = DateTime.now();
    
    return [
      PastLiveStreamModel(
        id: 'past_1',
        title: 'Summer Fashion Live Sale 👗✨',
        date: now.subtract(const Duration(days: 1, hours: 3)),
        duration: const Duration(minutes: 2, seconds: 30), // Kept compact for easy testing
        totalViewers: 1240,
        totalLikes: 8400,
        liveType: LiveType.sell,
        coverImagePath: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?q=80&w=600',
        estimatedRevenue: 1850.50,
        products: const [
          LiveStreamProduct(
            id: 'p_sell_1',
            title: 'Floral Summer Dress',
            price: 49.99,
            image: '👗',
          ),
          LiveStreamProduct(
            id: 'p_sell_2',
            title: 'Designer Sun Hats',
            price: 24.99,
            image: '👒',
          ),
          LiveStreamProduct(
            id: 'p_sell_3',
            title: 'Polarized Sunglasses',
            price: 19.99,
            image: '🕶️',
          ),
        ],
        comments: [
          PlaybackCommentModel(
            timelineSeconds: 3,
            comment: LiveCommentModel(
              id: 'c_1_1',
              userName: 'Ayesha Rahman',
              message: 'Assalamu Alaikum! Exciting stream 😍',
              timestamp: now.subtract(const Duration(days: 1)),
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 7,
            comment: LiveCommentModel(
              id: 'c_1_2',
              userName: 'Imran Khan',
              message: 'Is the summer dress fabric pure cotton?',
              timestamp: now.subtract(const Duration(days: 1)),
              replies: [
                LiveCommentModel(
                  id: 'c_1_2_r1',
                  userName: 'Admin Shop (Seller)',
                  message: 'Yes! It is 100% premium breathable organic cotton.',
                  timestamp: now.subtract(const Duration(days: 1)),
                  parentId: 'c_1_2',
                  isLiked: true,
                  likeCount: 5,
                )
              ],
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 15,
            comment: LiveCommentModel(
              id: 'c_1_3',
              userName: 'Nusrat Jahan',
              message: 'Wow, I absolutely love the pink color variation! Order placed!',
              timestamp: now.subtract(const Duration(days: 1)),
              likeCount: 4,
              isLiked: true,
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 28,
            comment: LiveCommentModel(
              id: 'c_1_4',
              userName: 'Sabbir Ahmed',
              message: 'Are there any discount codes running today?',
              timestamp: now.subtract(const Duration(days: 1)),
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 42,
            comment: LiveCommentModel(
              id: 'c_1_5',
              userName: 'Tamim Iqbal',
              message: 'The sunglasses look sick! Gonna cop one.',
              timestamp: now.subtract(const Duration(days: 1)),
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 65,
            comment: LiveCommentModel(
              id: 'c_1_6',
              userName: 'Farhana Yasmin',
              message: 'Can you show the sun hat details closely?',
              timestamp: now.subtract(const Duration(days: 1)),
              replies: [
                LiveCommentModel(
                  id: 'c_1_6_r1',
                  userName: 'Admin Shop (Seller)',
                  message: 'Sure! Showing the inner lining details right now in playback.',
                  timestamp: now.subtract(const Duration(days: 1)),
                  parentId: 'c_1_6',
                )
              ],
            ),
          ),
        ],
      ),
      PastLiveStreamModel(
        id: 'past_2',
        title: 'Luxury Watch Auction 🔨⌚',
        date: now.subtract(const Duration(days: 3, hours: 5)),
        duration: const Duration(minutes: 3, seconds: 0),
        totalViewers: 3250,
        totalLikes: 19400,
        liveType: LiveType.bidding,
        coverImagePath: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=600',
        estimatedRevenue: 4900.00,
        products: const [
          LiveStreamProduct(
            id: 'p_bid_1',
            title: 'Automatic Chronograph Silver',
            price: 450.00,
            image: '⌚',
          ),
          LiveStreamProduct(
            id: 'p_bid_2',
            title: 'Vintage Leather Dress Watch',
            price: 290.00,
            image: '🕒',
          ),
        ],
        comments: [
          PlaybackCommentModel(
            timelineSeconds: 2,
            comment: LiveCommentModel(
              id: 'c_2_1',
              userName: 'Adnan Sami',
              message: 'Ready for the watch auction! Let the bids begin!',
              timestamp: now.subtract(const Duration(days: 3)),
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 9,
            comment: LiveCommentModel(
              id: 'c_2_2',
              userName: 'Zamil Hossain',
              message: 'Is the Silver Chronograph waterproof?',
              timestamp: now.subtract(const Duration(days: 3)),
              replies: [
                LiveCommentModel(
                  id: 'c_2_2_r1',
                  userName: 'Admin Shop (Seller)',
                  message: 'Yes! Rated up to 100 meters (10 ATM) water resistance.',
                  timestamp: now.subtract(const Duration(days: 3)),
                  parentId: 'c_2_2',
                )
              ],
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 18,
            comment: LiveCommentModel(
              id: 'c_2_3',
              userName: 'Mahbub Alom',
              message: 'Bid placed: \$480 for the Chronograph!',
              timestamp: now.subtract(const Duration(days: 3)),
              likeCount: 8,
              isLiked: true,
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 29,
            comment: LiveCommentModel(
              id: 'c_2_4',
              userName: 'Kazi Farhan',
              message: 'Bidding \$500!',
              timestamp: now.subtract(const Duration(days: 3)),
              likeCount: 3,
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 45,
            comment: LiveCommentModel(
              id: 'c_2_5',
              userName: 'Tasnia Farin',
              message: 'Wow, that silver dial is stunning in high light!',
              timestamp: now.subtract(const Duration(days: 3)),
            ),
          ),
        ],
      ),
      PastLiveStreamModel(
        id: 'past_3',
        title: 'Organic Skin Care Showroom 🌸🧴',
        date: now.subtract(const Duration(days: 7)),
        duration: const Duration(minutes: 2, seconds: 0),
        totalViewers: 890,
        totalLikes: 4200,
        liveType: LiveType.sell,
        coverImagePath: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=600',
        estimatedRevenue: 640.20,
        products: const [
          LiveStreamProduct(
            id: 'p_skin_1',
            title: 'Aloe Vera Moisturizer Gel',
            price: 14.99,
            image: '🧴',
          ),
          LiveStreamProduct(
            id: 'p_skin_2',
            title: 'Rosewater Cleansing Tonic',
            price: 12.50,
            image: '🌹',
          ),
        ],
        comments: [
          PlaybackCommentModel(
            timelineSeconds: 4,
            comment: LiveCommentModel(
              id: 'c_3_1',
              userName: 'Sultana Khatun',
              message: 'Love your organic product collections!',
              timestamp: now.subtract(const Duration(days: 7)),
            ),
          ),
          PlaybackCommentModel(
            timelineSeconds: 12,
            comment: LiveCommentModel(
              id: 'c_3_2',
              userName: 'Mariam Begum',
              message: 'Is the Rosewater suitable for sensitive skin?',
              timestamp: now.subtract(const Duration(days: 7)),
              replies: [
                LiveCommentModel(
                  id: 'c_3_2_r1',
                  userName: 'Admin Shop (Seller)',
                  message: 'Absolutely! It is alcohol-free and 100% natural organic rose extract.',
                  timestamp: now.subtract(const Duration(days: 7)),
                  parentId: 'c_3_2',
                  isLiked: true,
                  likeCount: 2,
                )
              ],
            ),
          ),
        ],
      ),
    ];
  }
}

/// A wrapper class pairing a historical comment with its specific second in the stream timeline.
class PlaybackCommentModel {
  final int timelineSeconds;
  final LiveCommentModel comment;

  const PlaybackCommentModel({
    required this.timelineSeconds,
    required this.comment,
  });

  PlaybackCommentModel copyWith({
    int? timelineSeconds,
    LiveCommentModel? comment,
  }) {
    return PlaybackCommentModel(
      timelineSeconds: timelineSeconds ?? this.timelineSeconds,
      comment: comment ?? this.comment,
    );
  }
}
