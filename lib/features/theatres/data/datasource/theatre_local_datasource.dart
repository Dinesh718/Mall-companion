import '../../domain/entities/theatre_entities.dart';
import '../models/theatre_models.dart';

abstract class TheatreLocalDataSource {
  Future<List<MovieEntity>> getMovies();
  Future<List<TheatreEntity>> getTheatres();
  Future<void> toggleFavoriteMovie(String id);
  Future<void> bookTicket(String showTimeId);
}

class TheatreLocalDataSourceImpl implements TheatreLocalDataSource {
  // Hardcoded in-memory state to allow bookmarking / simulated ticket booking
  static final List<TheatreEntity> _theatres = [
    const TheatreModel(
      id: 'pvr_cinemas',
      name: 'PVR Cinemas',
      floorText: 'Level 4, South Wing',
      screenText: 'Screen 03',
      facilities: ['Dolby Atmos', 'Recliners', 'IMAX', '4K'],
      mapImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBea_SRBteVYGeiKgMpa8dVy7PcL8W7f--i7AU0vmgqWLPZmIGSdnIPeE5KtBPFv9yCTj8w7Jy6RbQDGC-qNcdgBaassAeWHgIFijaee5Byl7ip8rhFdoKmW3W3a_1rrrPgTVEBTmDEo79uw0Yq9ydwh7shqfp44Nuy7vJQRqTbxqbjDfY43C2ZPmdqZrSsQqwSIjtRnns30K3OgCRRlMIJ3cXNpx7Jtyb4_YN0zxYASVY7kJT_BkZsQXEvttrDhfhxpiraw5IOxw',
      distanceWalkText: '5 mins walk',
    ),
    const TheatreModel(
      id: 'pvr_luxe',
      name: 'PVR LUXE',
      floorText: 'Level 4',
      screenText: 'Screen 01',
      facilities: ['Dolby Atmos', 'Recliner Seats', 'VIP Lounge', '3D'],
      mapImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBea_SRBteVYGeiKgMpa8dVy7PcL8W7f--i7AU0vmgqWLPZmIGSdnIPeE5KtBPFv9yCTj8w7Jy6RbQDGC-qNcdgBaassAeWHgIFijaee5Byl7ip8rhFdoKmW3W3a_1rrrPgTVEBTmDEo79uw0Yq9ydwh7shqfp44Nuy7vJQRqTbxqbjDfY43C2ZPmdqZrSsQqwSIjtRnns30K3OgCRRlMIJ3cXNpx7Jtyb4_YN0zxYASVY7kJT_BkZsQXEvttrDhfhxpiraw5IOxw',
      distanceWalkText: '4 mins walk',
    ),
  ];

  static final List<MovieEntity> _movies = [
    // 1. Featured Movie
    const MovieModel(
      id: 'kingdom_planet_apes',
      title: 'Kingdom of the Planet of the Apes',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBdVz9VFbpWwI8VY911COPidkLC022i3uRCtRWAWmNBQHjtmujV90ziUbKdH8fa5hRqaUBb5oNSSkYbWrOf_ktiFzSneqaVDdSf1w7utVxHeOkMB0-aBImjnqlr3R25QhKXFC2D0ikoq2pIIvOIHXohb-OaxQCqbzwidTklrYtK7K4L0OBsfytw9Ol5oWOuPOKTlRPZfVB_uetrgbCPceEC8PGAkIegEJcHZmbBPuNQ-3jO_axf7PGlKkmJ3LWp7I2GefVi-inlcg',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBdVz9VFbpWwI8VY911COPidkLC022i3uRCtRWAWmNBQHjtmujV90ziUbKdH8fa5hRqaUBb5oNSSkYbWrOf_ktiFzSneqaVDdSf1w7utVxHeOkMB0-aBImjnqlr3R25QhKXFC2D0ikoq2pIIvOIHXohb-OaxQCqbzwidTklrYtK7K4L0OBsfytw9Ol5oWOuPOKTlRPZfVB_uetrgbCPceEC8PGAkIegEJcHZmbBPuNQ-3jO_axf7PGlKkmJ3LWp7I2GefVi-inlcg',
      rating: 8.2,
      genre: 'Sci-Fi/Action',
      language: 'English',
      duration: '2h 25m',
      ageRestriction: 'UA',
      synopsis:
          'In a future where humanity has colonized the rings of Saturn, a renegade navigator uncovers a signal that could change the course of human history. A visually stunning journey through space and the human heart.',
      releaseDate: 'Saturday, 22 June',
      cast: [
        CastMemberModel(
          name: 'Ethan Vance',
          characterName: 'The Navigator',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDz4qi0IcC7Bk-EA9ddlfVquHqvz10EJHyyhQSq5WnlRI3GgFBgqv6QDp1QnlynJWLVmuzKQPi-CcgqpFuz8FsUtJiTwDhuBdvAAVnrzUI-K00XeAEG4oTAMBBv8pWZulyQwfoozuncx5ROmElmRvBhOHZnMoUklbntN5ayRfFczF-s_3aw5SqIMvriYhFulXaiJvRpyEhQgW-AXGYt_RhE03RBcLNW9zjXHidk3uxvvPid7S8EkllMseIor2bXQRZXOnsMzNxF1w',
        ),
        CastMemberModel(
          name: 'Sia Kovic',
          characterName: 'Commander',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDSpap1iSTrHCbVManBoNxqCdXS5MhC3KsPOo5Za1FLwXs0jYlEAetmJ1VDOtTC26aGkPHFJfGcFQlNo3N6FtmYUikVhA4IqVRNbw_G5NwE9LYuo7pQ4sKUnWo6ZDK38XCCJ5ZdUs-JIPYE8J8AQcuUITbIXHB86gdjkpebA05Od3xV-NyZ8SDA3pwR7H2bksgS9YWjbKCxNRYU9vXCoGTA-cu3yITdtiUT1bvZLp_JxMhQXk9gGgfIVr4liSk611tkeSQyzjtDpw',
        ),
        CastMemberModel(
          name: 'Marcus Reed',
          characterName: 'The Oracle',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD825rvek7KVbIaZYI47agnadIRYsc1tYbSUYny9bXxJ4EqSDZ-jygUrWkz5UVF7c_U7U7sbSro_VQ1ZND_YS6pfXnLoYZ2sXmmezVoGCZsvvc5WAtlMGDrKuO0V4qpxSVYEkAhh96musorbUW424Z_UOWy_j50a930ZNBQYl_m_eNqzbhoxLs8l6pMfOBOJCillLYeC5RLMYzjaOb_maXkYF9QczhtgyAxtxpTZDNWfnV8_BxGmsJpyc5HthV0EmLZJ_Hm27uneg',
        ),
        CastMemberModel(
          name: 'Lila Thorne',
          characterName: 'Technician',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDqqbsjO4ltKmvcB0FnttHDpJXT1ndI3HCNT0_R5qZ_X-OGQAYc4ky3TvLSBWRRi-JzZT8J3VSHrP95Y_Pi9i_b-bxODXk9tPKbgWGkqJi87sJ7mVfyVPmo2Z2_mo6VhxOYXlUBgrs0oSxpusHmORek9qojA4G_i7uY4XI50xS41vR7p_hjKcJGKYg9DdfHV5hE34pnojWap0dJa4REvFWk6wwiArjP8jrOCrWhvwz3W4G6TK6zbKvedcI666GtBNydbDHqj3gShQ',
        ),
      ],
      crew: [],
      gallery: [],
      isBookmarked: false,
      showTimes: [
        ShowTimeModel(
          id: 'st_apes_1',
          theatreId: 'pvr_luxe',
          movieId: 'kingdom_planet_apes',
          time: '1:30 PM',
          price: 350.0,
          status: 'Almost Full',
          availableSeats: 4,
        ),
        ShowTimeModel(
          id: 'st_apes_2',
          theatreId: 'pvr_luxe',
          movieId: 'kingdom_planet_apes',
          time: '4:30 PM',
          price: 350.0,
          status: 'Available',
          availableSeats: 52,
        ),
      ],
      category: 'Now Showing',
      nextShowTimeText: '1:30 PM',
      associatedTheatreName: 'PVR LUXE, Level 4',
    ),

    // 2. Carousel Movie 1: The Fall Guy
    const MovieModel(
      id: 'the_fall_guy',
      title: 'The Fall Guy',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASWpec8MSoaJV4bdccO9fDNII4_rhpElhMORn7_Its-kzPlVQKbDM3Xm7qWVGaYtlEZN8L7Etm4_hpObVnWk_Ep5AxStK3Qq-K_wCDLyn0T8JaLtfsGu0EgUd-70tSHUmulp5L4utN9WscWyBdcPb0rPPOEGqUEU2dMFcWeKYPWfC6IQOVYb-T3LafddlPmXo0HPABDixzsRkDPhEfYOikzq8-9HbbTKlweY-6ik4L9sd0iRKWc-txGNegQdoTXUC_kjkZz7Eyow',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBt4zi5IW3Qu4_9vn4BSk5NjpCZCKYvAgCS4xAu4-fpdtxflm7NI6hgmLgi_FM77-ZSrs8RCmwkH7K7tAxgq0YuP-a0KjC86lZEN_ByVsQKbxBs9laaSbHHa5I8owDd9ChUFC67zMw0o3JaAPaRSnPWhOPyiOearlU52NpQJ5Vtt_SRX3Li2kA9NrIXLoXz3upb5s7WZFsW93qs90GIvqHAroyWmY9JRFuslCCEQhQdHKRy8FosbduNFWo9_w8wNJB5g41F-8K7Bg',
      rating: 8.5,
      genre: 'Action/Comedy',
      language: 'English',
      duration: '2h 06m',
      ageRestriction: 'UA',
      synopsis:
          'A battered stuntman, fresh off an almost career-ending accident, has to track down a missing movie star, solve a conspiracy and try to win back the love of his life while still doing his day job.',
      releaseDate: 'Saturday, 22 June',
      cast: [
        CastMemberModel(
          name: 'Ethan Vance',
          characterName: 'The Navigator',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDz4qi0IcC7Bk-EA9ddlfVquHqvz10EJHyyhQSq5WnlRI3GgFBgqv6QDp1QnlynJWLVmuzKQPi-CcgqpFuz8FsUtJiTwDhuBdvAAVnrzUI-K00XeAEG4oTAMBBv8pWZulyQwfoozuncx5ROmElmRvBhOHZnMoUklbntN5ayRfFczF-s_3aw5SqIMvriYhFulXaiJvRpyEhQgW-AXGYt_RhE03RBcLNW9zjXHidk3uxvvPid7S8EkllMseIor2bXQRZXOnsMzNxF1w',
        ),
        CastMemberModel(
          name: 'Sia Kovic',
          characterName: 'Commander',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDSpap1iSTrHCbVManBoNxqCdXS5MhC3KsPOo5Za1FLwXs0jYlEAetmJ1VDOtTC26aGkPHFJfGcFQlNo3N6FtmYUikVhA4IqVRNbw_G5NwE9LYuo7pQ4sKUnWo6ZDK38XCCJ5ZdUs-JIPYE8J8AQcuUITbIXHB86gdjkpebA05Od3xV-NyZ8SDA3pwR7H2bksgS9YWjbKCxNRYU9vXCoGTA-cu3yITdtiUT1bvZLp_JxMhQXk9gGgfIVr4liSk611tkeSQyzjtDpw',
        ),
      ],
      crew: [],
      gallery: [],
      isBookmarked: false,
      showTimes: [
        ShowTimeModel(
          id: 'st_fg_1',
          theatreId: 'pvr_cinemas',
          movieId: 'the_fall_guy',
          time: '2:30 PM',
          price: 250.0,
          status: 'Available',
          availableSeats: 80,
        ),
      ],
      category: 'Now Showing',
      nextShowTimeText: '2:30 PM',
      associatedTheatreName: 'PVR Cinemas, Level 4',
    ),

    // 3. Carousel Movie 2: IF
    const MovieModel(
      id: 'if_movie',
      title: 'IF',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDMF_jtbFGRgeC4iqz4gu3Tw0RFItF5uEpuaaCyLTygkQZxrd7pGL6v2Z4bOy-EWveH5Jgya8TkeZSc1XV_fupcgNaCbbenOLdyupxFnkcRpLMAr4Z5lvpOa9VMKriV1RBvpgzmleX40TNfQlbUJ5B6EZT_NLN5nKlsm3TY4HRTtMTs5iG40RgtNuARvopnogdMIdp25VI34qRRxgUwLqvt1H69LnzZ7FTvnqOxK5i0wlmScxMdKdO0epOC5nwjeQhUjk7c8ITwIA',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBt4zi5IW3Qu4_9vn4BSk5NjpCZCKYvAgCS4xAu4-fpdtxflm7NI6hgmLgi_FM77-ZSrs8RCmwkH7K7tAxgq0YuP-a0KjC86lZEN_ByVsQKbxBs9laaSbHHa5I8owDd9ChUFC67zMw0o3JaAPaRSnPWhOPyiOearlU52NpQJ5Vtt_SRX3Li2kA9NrIXLoXz3upb5s7WZFsW93qs90GIvqHAroyWmY9JRFuslCCEQhQdHKRy8FosbduNFWo9_w8wNJB5g41F-8K7Bg',
      rating: 7.9,
      genre: 'Fantasy/Animation',
      language: 'English',
      duration: '1h 44m',
      ageRestriction: 'U',
      synopsis:
          'A young girl who goes through a difficult experience begins to see everyone\'s imaginary friends who have been left behind as their real-life friends have grown up.',
      releaseDate: 'Saturday, 22 June',
      cast: [
        CastMemberModel(
          name: 'Lila Thorne',
          characterName: 'Technician',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDqqbsjO4ltKmvcB0FnttHDpJXT1ndI3HCNT0_R5qZ_X-OGQAYc4ky3TvLSBWRRi-JzZT8J3VSHrP95Y_Pi9i_b-bxODXk9tPKbgWGkqJi87sJ7mVfyVPmo2Z2_mo6VhxOYXlUBgrs0oSxpusHmORek9qojA4G_i7uY4XI50xS41vR7p_hjKcJGKYg9DdfHV5hE34pnojWap0dJa4REvFWk6wwiArjP8jrOCrWhvwz3W4G6TK6zbKvedcI666GtBNydbDHqj3gShQ',
        ),
      ],
      crew: [],
      gallery: [],
      isBookmarked: false,
      showTimes: [
        ShowTimeModel(
          id: 'st_if_1',
          theatreId: 'pvr_cinemas',
          movieId: 'if_movie',
          time: '11:15 AM',
          price: 220.0,
          status: 'Available',
          availableSeats: 110,
        ),
      ],
      category: 'Coming Soon',
      nextShowTimeText: '11:15 AM',
      associatedTheatreName: 'PVR Cinemas, Level 4',
    ),

    // 4. Carousel Movie 3: Challengers
    const MovieModel(
      id: 'challengers',
      title: 'Challengers',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCOR78tbDbFeDlZYa06DL6hN74XZqdTUYZP0HRMvcSYDaXwFE3kRd9ZNQFo-oJmRy7Dm2gXlgGdDKC6M5MduJVydHoQ61xaPiKIsJkQlAoQ95J-sK5A4viyWXvcIfo7vTs1Yqq9JYXlOp3RlJZUAYzw45p7t7q8sOIOFLbLZLHCs1DTfue_gSPj1QQ6W397GHc6CBquwfDu9YnPeGWgb1Asf6T5JLtUVXNHycwlNs4drnH3_BtGxhYExEqPZ8M12CP2fmKr-1r1qw',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBt4zi5IW3Qu4_9vn4BSk5NjpCZCKYvAgCS4xAu4-fpdtxflm7NI6hgmLgi_FM77-ZSrs8RCmwkH7K7tAxgq0YuP-a0KjC86lZEN_ByVsQKbxBs9laaSbHHa5I8owDd9ChUFC67zMw0o3JaAPaRSnPWhOPyiOearlU52NpQJ5Vtt_SRX3Li2kA9NrIXLoXz3upb5s7WZFsW93qs90GIvqHAroyWmY9JRFuslCCEQhQdHKRy8FosbduNFWo9_w8wNJB5g41F-8K7Bg',
      rating: 9.1,
      genre: 'Drama/Romance',
      language: 'English',
      duration: '2h 11m',
      ageRestriction: 'A',
      synopsis:
          'Tashi, a former tennis prodigy turned coach, has taken her husband, Art, and transformed him into a world-famous grand slam champion. To jolt him out of his recent losing streak, she enters him into a "Challenger" event.',
      releaseDate: 'Saturday, 22 June',
      cast: [
        CastMemberModel(
          name: 'Marcus Reed',
          characterName: 'The Oracle',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD825rvek7KVbIaZYI47agnadIRYsc1tYbSUYny9bXxJ4EqSDZ-jygUrWkz5UVF7c_U7U7sbSro_VQ1ZND_YS6pfXnLoYZ2sXmmezVoGCZsvvc5WAtlMGDrKuO0V4qpxSVYEkAhh96musorbUW424Z_UOWy_j50a930ZNBQYl_m_eNqzbhoxLs8l6pMfOBOJCillLYeC5RLMYzjaOb_maXkYF9QczhtgyAxtxpTZDNWfnV8_BxGmsJpyc5HthV0EmLZJ_Hm27uneg',
        ),
      ],
      crew: [],
      gallery: [],
      isBookmarked: false,
      showTimes: [
        ShowTimeModel(
          id: 'st_ch_1',
          theatreId: 'pvr_cinemas',
          movieId: 'challengers',
          time: '5:45 PM',
          price: 250.0,
          status: 'Available',
          availableSeats: 30,
        ),
      ],
      category: 'Now Showing',
      nextShowTimeText: '5:45 PM',
      associatedTheatreName: 'PVR Cinemas, Level 4',
    ),

    // 5. Vertical List Movie 1: The Strangers
    const MovieModel(
      id: 'the_strangers',
      title: 'The Strangers',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuACUvqKFESKebLKhbc49fEVVYtM51ASvm7d-ui7NyMUTlRPoK1RGr1IRvLMaHTyy-cY99Ru4JPRjg0D68srjjGks_gKc2s9F3WVGyyYTQQvM-Mu5_xmZ8QKcW8i3KTFvE0CFj7rBypFhqjfGcr5YUIy7xlAq6AAzxUyUn4AgxuOcFveeznTaRZfbLDQBM_dC1QHwrfMfi3lEzXfO4hW8ejDuhm_Tv0_2iUuxDRomS-ifmndyobbxZVMppYjotXDW_mAWdE4fe9-Ig',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBt4zi5IW3Qu4_9vn4BSk5NjpCZCKYvAgCS4xAu4-fpdtxflm7NI6hgmLgi_FM77-ZSrs8RCmwkH7K7tAxgq0YuP-a0KjC86lZEN_ByVsQKbxBs9laaSbHHa5I8owDd9ChUFC67zMw0o3JaAPaRSnPWhOPyiOearlU52NpQJ5Vtt_SRX3Li2kA9NrIXLoXz3upb5s7WZFsW93qs90GIvqHAroyWmY9JRFuslCCEQhQdHKRy8FosbduNFWo9_w8wNJB5g41F-8K7Bg',
      rating: 8.2,
      genre: 'Horror',
      language: 'English',
      duration: '1h 45m',
      ageRestriction: 'A',
      synopsis:
          'A young couple drives cross-country for a fresh start; unfortunately, they have no choice but to stop at a secluded Airbnb in Oregon and endure a night of terror against three masked strangers.',
      releaseDate: 'Saturday, 22 June',
      cast: [
        CastMemberModel(
          name: 'Ethan Vance',
          characterName: 'The Navigator',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDz4qi0IcC7Bk-EA9ddlfVquHqvz10EJHyyhQSq5WnlRI3GgFBgqv6QDp1QnlynJWLVmuzKQPi-CcgqpFuz8FsUtJiTwDhuBdvAAVnrzUI-K00XeAEG4oTAMBBv8pWZulyQwfoozuncx5ROmElmRvBhOHZnMoUklbntN5ayRfFczF-s_3aw5SqIMvriYhFulXaiJvRpyEhQgW-AXGYt_RhE03RBcLNW9zjXHidk3uxvvPid7S8EkllMseIor2bXQRZXOnsMzNxF1w',
        ),
      ],
      crew: [],
      gallery: [],
      isBookmarked: false,
      showTimes: [
        ShowTimeModel(
          id: 'st_strangers_1',
          theatreId: 'pvr_luxe',
          movieId: 'the_strangers',
          time: '10:00 AM',
          price: 320.0,
          status: 'Available',
          availableSeats: 45,
        ),
        ShowTimeModel(
          id: 'st_strangers_2',
          theatreId: 'pvr_luxe',
          movieId: 'the_strangers',
          time: '1:30 PM',
          price: 320.0,
          status: 'Available',
          availableSeats: 22,
        ),
        ShowTimeModel(
          id: 'st_strangers_3',
          theatreId: 'pvr_luxe',
          movieId: 'the_strangers',
          time: '4:45 PM',
          price: 320.0,
          status: 'Almost Full',
          availableSeats: 3,
        ),
      ],
      category: 'Now Showing',
      nextShowTimeText: '4:45 PM',
      associatedTheatreName: 'PVR LUXE, Level 4',
    ),

    // 6. Vertical List Movie 2: Furiosa
    const MovieModel(
      id: 'furiosa',
      title: 'Furiosa: A Mad Max Saga',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCbKIolXEJG4zW3pme5cYGEoe7mtB9_5Xnn3LI3qpUM3LtiUjmfJcF320AQhGB9XVLsAuZYxSS08aJfNhyT-QnOg_4yUXKt2uIpi9t5dgUr2yPXCsCqjj035v9L9ippvS21joaika2G-bPHmJAZihG60INCMTQ3-vDYJMsFawKcDuKDGOIJKu-9GpwnCmhRnroHrmfJVCY88s5Xge5G3lL9okZbEcE1bBNkPfiZOT4b3L0IpU-M0DeCi4gQ83285efOaSQeJAfNGA',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBt4zi5IW3Qu4_9vn4BSk5NjpCZCKYvAgCS4xAu4-fpdtxflm7NI6hgmLgi_FM77-ZSrs8RCmwkH7K7tAxgq0YuP-a0KjC86lZEN_ByVsQKbxBs9laaSbHHa5I8owDd9ChUFC67zMw0o3JaAPaRSnPWhOPyiOearlU52NpQJ5Vtt_SRX3Li2kA9NrIXLoXz3upb5s7WZFsW93qs90GIvqHAroyWmY9JRFuslCCEQhQdHKRy8FosbduNFWo9_w8wNJB5g41F-8K7Bg',
      rating: 8.9,
      genre: 'Sci-Fi/Action',
      language: 'English',
      duration: '2h 28m',
      ageRestriction: 'A',
      synopsis:
          'Snatched from the Green Place of Many Mothers, young Furiosa falls into the hands of a great Biker Horde led by the Warlord Dementus. Sweeping through the Wasteland, they come across the Citadel presided over by The Immortan Joe.',
      releaseDate: 'Saturday, 22 June',
      cast: [
        CastMemberModel(
          name: 'Sia Kovic',
          characterName: 'Commander',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDSpap1iSTrHCbVManBoNxqCdXS5MhC3KsPOo5Za1FLwXs0jYlEAetmJ1VDOtTC26aGkPHFJfGcFQlNo3N6FtmYUikVhA4IqVRNbw_G5NwE9LYuo7pQ4sKUnWo6ZDK38XCCJ5ZdUs-JIPYE8J8AQcuUITbIXHB86gdjkpebA05Od3xV-NyZ8SDA3pwR7H2bksgS9YWjbKCxNRYU9vXCoGTA-cu3yITdtiUT1bvZLp_JxMhQXk9gGgfIVr4liSk611tkeSQyzjtDpw',
        ),
      ],
      crew: [],
      gallery: [],
      isBookmarked: false,
      showTimes: [
        ShowTimeModel(
          id: 'st_furiosa_1',
          theatreId: 'pvr_luxe',
          movieId: 'furiosa',
          time: '2:00 PM',
          price: 360.0,
          status: 'Available',
          availableSeats: 50,
        ),
        ShowTimeModel(
          id: 'st_furiosa_2',
          theatreId: 'pvr_luxe',
          movieId: 'furiosa',
          time: '5:30 PM',
          price: 360.0,
          status: 'Available',
          availableSeats: 48,
        ),
        ShowTimeModel(
          id: 'st_furiosa_3',
          theatreId: 'pvr_luxe',
          movieId: 'furiosa',
          time: '9:00 PM',
          price: 360.0,
          status: 'Available',
          availableSeats: 76,
        ),
      ],
      category: 'Now Showing',
      nextShowTimeText: '9:00 PM',
      associatedTheatreName: 'PVR LUXE, Level 4',
    ),
  ];

  @override
  Future<List<MovieEntity>> getMovies() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _movies;
  }

  @override
  Future<List<TheatreEntity>> getTheatres() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _theatres;
  }

  @override
  Future<void> toggleFavoriteMovie(String id) async {
    final idx = _movies.indexWhere((m) => m.id == id);
    if (idx != -1) {
      final current = _movies[idx];
      _movies[idx] = current.copyWith(isBookmarked: !current.isBookmarked);
    }
  }

  @override
  Future<void> bookTicket(String showTimeId) async {
    // Simply print or simulate seat decrement if available
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
