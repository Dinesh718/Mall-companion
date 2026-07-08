import '../../domain/entities/restaurant_entities.dart';
import '../models/restaurant_models.dart';

abstract class RestaurantLocalDataSource {
  Future<List<RestaurantEntity>> getRestaurants();
  Future<void> toggleFavoriteRestaurant(String id);
  Future<void> reserveTable(String id, String timeSlot, int guestCount);
}

class RestaurantLocalDataSourceImpl implements RestaurantLocalDataSource {
  static final List<RestaurantEntity> _restaurants = [
    const RestaurantModel(
      id: 'lessence_moderne',
      name: "L'Essence Moderne",
      cuisine: 'Contemporary French',
      floorText: 'Level 3, North Wing',
      rating: 4.9,
      priceRange: r'$$$$',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAc1M-gwuWQbCS94uV5Stk7Xl28vzFD8bUlU2-rCjoEPA-S_CXJsPIeBK04Z4UYJkbxm9F01eAzaVFeFY5zy3jCUU6dL1vHs_3KVpZLF4u14txRGp4JfDsJeaEbnZ1Eq9mY9itegQcX34fcyWItnzmneQsE5CuRFnf1yqe9P5qSlz9AzzC1dVVHXCKnuZEbZHbEDaxJF-i1-7NUncBZovUkEi-OLJLs3IFgG07-YXB2k_eSpdT7Oso4kUrNfKNMR_iqU_bjSU_NMQ',
      description: 'Experience the pinnacle of fine dining at L\'Essence Moderne. Our kitchen blends traditional French techniques with innovative local ingredients to create a symphony of flavors that delight the senses.',
      phone: '+1 (555) 890-2100',
      website: 'www.lessencemoderne.com',
      isOpen: true,
      waitTimeText: '15 min',
      walkTimeText: 'Walk: 3 mins from here',
      interestedCount: 345,
      isFavorite: false,
      galleryUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC6iBpsWnzVodd2MU2HkSB-67GuHCr54FBqf429eK2yo6Of2DTahusppgYWbi9j7vrpls-ltE9xnHc-y7uki70EixCbr-aGwvFAcorTuQVSQrCR-be4rRXnO6NzCrzJRDX0fBOg9Gu4h7K70ALzMJtmMcMmbPzYCqruFFfAOVJ9HpBQAqTLlkU7dF2BoPHAPDJ3MDQItFuULZ7rcEZ7ooqSOfGRskPqkMkAJo_Xt82P1EphOrVnfChZRoTsBaCWI7YA5IG_pg7-bQ',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBCYIM1ppxCS4vwadNNtP8fwK4mq4ih5zETwKxg-bDb-slNKpJN8ob0Mu4FbOLcLwB34o83GCaZ4cSFdtsl-BYyrDBRs-X_NsRb6VjAN7E6fLTgJml65815XqUS9KYvkeoLGzQ2vedXUJQbjV-JvDKAIJIRAOVuK9CF45CzVxs5Uks4OEm95GTkqWMAPHT0qYiWL0y5iqQIPC0Z208W0i2t2GZxreUQiVG5jill18NbD6T2ZDzVJsLwu7BR6OKjXLnfwY7vqCLYiA',
      ],
      reviews: [
        RestaurantReviewModel(
          userName: 'Charlotte Bennett',
          userAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=100&q=80',
          rating: 5.0,
          reviewText: 'Sensational wagyu steak and perfect ambient lighting. Service is top tier.',
          dateText: 'Yesterday',
        ),
        RestaurantReviewModel(
          userName: 'Julian Vance',
          userAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80',
          rating: 4.8,
          reviewText: 'Amazing scallops and desserts. Very high-end feel.',
          dateText: '3 days ago',
        ),
      ],
      menu: [
        MenuItemModel(
          category: 'Appetizer',
          name: 'Atlantic Scallops',
          price: 28.0,
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuASC4sKTo78VdXZrlpBhZwPvcDQaYkldnBTqoSdFOsUfR-URagXdkKIHPytPNGKZiDShF1hbw8HqT95yun2grMwfp-NRczkqUtF2wWcUliHn45VvWTm54etk7BxHhAqoMOgnsPM58iFSlWcsL6oFsn-719f-lwo8tq39AGOgswSuA67FamcxPjeregZLHzA75SDp69bHt9G76tHl-1IxXSE_7f9Gg4twP86odMbn9k1akl5k_H4j5a4DXHLd3kfwm292ZhEKDzP7A',
        ),
        MenuItemModel(
          category: 'Main Course',
          name: 'Wagyu A5 Fillet',
          price: 115.0,
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB14AI7s8298S9XyTz-UvY7Sq6pB7ouWkSf5iwSfJv659O59wCKjKupUIfxLk-Sa7c3TJ_xg_1Dxi1u_SEwPZzP5Rn36kIHln_Ec9TXedpbLrEOf7FHxYgmf3QJXbbRXWtB5UewXuEg-fSwj3F3xXJAhwH3EpFdyeZelUcMDWVFz3JQ_tJYElGPT27KlLKzJjBoDKEGN0tB-Da4HjqOHcqJaazChYzrmBVItmwQ_FEmcXLNGY6K2fwQru_f92Yp_NQLsf7MPfCxIQ',
        ),
        MenuItemModel(
          category: 'Dessert',
          name: 'Sphère de Chocolat',
          price: 22.0,
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCBromvHmK9QEfn2IYD6lBCPQ7bxCNg619dRooe_w1-Y5ee0p7UR95mRzkxSF0DD5s6Pi4CQCgct9-t50yyUxqZqpFYJd4wzDvrUJyTy0vjGTgOno9VJK_CKBMEU9hZ75GqPMHvj4pPdgIRx7VY2gCjGSFwGnmeum3L2IyxSUKoaCt_cTcSqQWNHSV9ezJ2We8xWQMQpDkWmoWWa6AeiK3XKtZDclNtvBdUYPAbCS6VtKPs_7FbPRyfg9HV-q9AxVro3XINFgN5mw',
        ),
      ],
      slots: [
        TableSlotModel(timeSlot: '19:00 PM', tableSize: 2, status: 'Available'),
        TableSlotModel(timeSlot: '19:30 PM', tableSize: 4, status: 'Reserved'),
        TableSlotModel(timeSlot: '20:00 PM', tableSize: 2, status: 'Available'),
        TableSlotModel(timeSlot: '20:30 PM', tableSize: 4, status: 'Available'),
      ],
      offers: [
        RestaurantOfferModel(
          title: 'Complimentary Dessert',
          discountPercentage: 0,
          promoCode: 'LUMIEREDESSERT',
        ),
        RestaurantOfferModel(
          title: '15% Off Total Bill',
          discountPercentage: 15,
          promoCode: 'MODERNE15',
        ),
      ],
    ),
    const RestaurantModel(
      id: 'lumiere_brasserie',
      name: 'Lumière Brasserie',
      cuisine: 'French Fine Dining',
      floorText: 'Floor 3, South wing',
      rating: 4.8,
      priceRange: r'$$$',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC6iBpsWnzVodd2MU2HkSB-67GuHCr54FBqf429eK2yo6Of2DTahusppgYWbi9j7vrpls-ltE9xnHc-y7uki70EixCbr-aGwvFAcorTuQVSQrCR-be4rRXnO6NzCrzJRDX0fBOg9Gu4h7K70ALzMJtmMcMmbPzYCqruFFfAOVJ9HpBQAqTLlkU7dF2BoPHAPDJ3MDQItFuULZ7rcEZ7ooqSOfGRskPqkMkAJo_Xt82P1EphOrVnfChZRoTsBaCWI7YA5IG_pg7-bQ',
      description: 'Lumière Brasserie brings classical Parisian dining into a modern space. Savor freshly shucked oysters, perfectly crusted steak frites, and premium vintage selections.',
      phone: '+1 (555) 789-3210',
      website: 'www.lumierebrasserie.com',
      isOpen: true,
      waitTimeText: '12 min',
      walkTimeText: 'Walk: 4 mins from here',
      interestedCount: 298,
      isFavorite: false,
      galleryUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC6iBpsWnzVodd2MU2HkSB-67GuHCr54FBqf429eK2yo6Of2DTahusppgYWbi9j7vrpls-ltE9xnHc-y7uki70EixCbr-aGwvFAcorTuQVSQrCR-be4rRXnO6NzCrzJRDX0fBOg9Gu4h7K70ALzMJtmMcMmbPzYCqruFFfAOVJ9HpBQAqTLlkU7dF2BoPHAPDJ3MDQItFuULZ7rcEZ7ooqSOfGRskPqkMkAJo_Xt82P1EphOrVnfChZRoTsBaCWI7YA5IG_pg7-bQ',
      ],
      reviews: [
        RestaurantReviewModel(
          userName: 'George Harrison',
          userAvatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80',
          rating: 4.7,
          reviewText: 'Great atmosphere, excellent steak frites.',
          dateText: '4 days ago',
        ),
      ],
      menu: [
        MenuItemModel(
          category: 'Main Course',
          name: 'Steak Frites',
          price: 42.0,
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB14AI7s8298S9XyTz-UvY7Sq6pB7ouWkSf5iwSfJv659O59wCKjKupUIfxLk-Sa7c3TJ_xg_1Dxi1u_SEwPZzP5Rn36kIHln_Ec9TXedpbLrEOf7FHxYgmf3QJXbbRXWtB5UewXuEg-fSwj3F3xXJAhwH3EpFdyeZelUcMDWVFz3JQ_tJYElGPT27KlLKzJjBoDKEGN0tB-Da4HjqOHcqJaazChYzrmBVItmwQ_FEmcXLNGY6K2fwQru_f92Yp_NQLsf7MPfCxIQ',
        ),
      ],
      slots: [
        TableSlotModel(timeSlot: '18:00 PM', tableSize: 2, status: 'Available'),
        TableSlotModel(timeSlot: '18:30 PM', tableSize: 2, status: 'Available'),
      ],
      offers: [],
    ),
    const RestaurantModel(
      id: 'sushi_zen',
      name: 'Sushi Zen',
      cuisine: 'Japanese',
      floorText: '1st Floor, Central Court',
      rating: 4.6,
      priceRange: r'$$$',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBYihnfu5WSEmAqU2UpcMVM_fKxWqw2f05ZcXatuzcIAgYVBfopIWqQz_QrDmhersspAuituDWQ4QD8eVvTDBPtFzIpfkxuSmfHWJohM2duSxMcDnzg83yz4xyhNggoBox3BRwpvmgG_Ti0bGPa5wwzpGq1FfZtxAx0fCzgE8mdABhI4osU7I_Rgz26ZOJxVORsgmwqaSpdugE6f4YdTdwkdGOCFruRPnQX7rT4gLSoNKonFTYa9oCBkS-70J84ofLNScZaTV7z1g',
      description: 'Experience authentic Edomae sushi handcrafted by master chefs. We fly fresh fish daily from Toyosu market to deliver the ultimate omakase journey.',
      phone: '+1 (555) 456-7890',
      website: 'www.sushizenmall.com',
      isOpen: true,
      waitTimeText: '8 min',
      walkTimeText: 'Walk: 2 mins from here',
      interestedCount: 195,
      isFavorite: false,
      galleryUrls: [],
      reviews: [],
      menu: [],
      slots: [],
      offers: [],
    ),
    const RestaurantModel(
      id: 'burger_craft',
      name: 'Burger Craft',
      cuisine: 'Fast Food',
      floorText: 'Ground Floor, North Court',
      rating: 4.5,
      priceRange: r'$$',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD9cWdEMsdg9xyCIEyMEVIz3xyK4u--N2nu20frREl3MeVHvZUTjq64aq1UxA-6TX56yGCgUy7Jj_40XIsQlhG7I68HzhPOwXKVuW5n_R4nzlRC6G_7S7zOiYBWik7Wghxj8D3G9ofSIID2Zh5Y3qKdZ8O230GLdLt8H3Ex7_JBCFoPfd8SgsU74vGNvYbiGhl53WeXCLyVrlYg29Lv1jZLNPIu9EwZ4_5TtWOrGd48lT4SODqiNhpUKzT5hGDIIlrcoppmc2h4cg',
      description: 'Gourmet smashed beef patties, house-made brioche buns, and hand-cut truffle fries. Simple ingredients elevated to absolute perfection.',
      phone: '+1 (555) 345-6789',
      website: 'www.burgercraft.com',
      isOpen: true,
      waitTimeText: '20 min',
      walkTimeText: 'Walk: 5 mins from here',
      interestedCount: 154,
      isFavorite: false,
      galleryUrls: [],
      reviews: [],
      menu: [],
      slots: [],
      offers: [],
    ),
    const RestaurantModel(
      id: 'cafe_bistro',
      name: 'Cafe Bistro',
      cuisine: 'Cafe',
      floorText: 'Ground Floor, South Wing',
      rating: 4.4,
      priceRange: r'$',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB4hxkz6PR4EADIVev0ohhgL2rxyir5R-KlgXwg8ZKQIHKZ9zlqBxyxfV2rzRvjoOQrM_BHX5hphCvKZ1He2590SzOnt0woqBWO4nbRHXbZOpq9zjbrJc61SUcVzeOR69EYc9JE3SSn2iNY0YZE-w19EMwQiYl9MFYrfE0dNrjIdzhD67FS1efL52KyzZcdoX1DjqsOLXWrule0ztQXs_IgOPyt4OMZnh16MKILGOXa0XDVyAd6sAyh39m1a15SbGAlAjLzqQENpw',
      description: 'Your neighborhood cozy retreat inside Lumina. Freshly roasted single-origin coffees, organic teas, and custom French pastries baked in-house daily.',
      phone: '+1 (555) 234-5678',
      website: 'www.cafebistrolumina.com',
      isOpen: true,
      waitTimeText: 'Open',
      walkTimeText: 'Walk: 1 min away',
      interestedCount: 420,
      isFavorite: false,
      galleryUrls: [],
      reviews: [],
      menu: [],
      slots: [],
      offers: [],
    ),
  ];

  @override
  Future<List<RestaurantEntity>> getRestaurants() async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return _restaurants;
  }

  @override
  Future<void> toggleFavoriteRestaurant(String id) async {
    final idx = _restaurants.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _restaurants[idx];
      _restaurants[idx] = current.copyWith(
        isFavorite: !current.isFavorite,
        interestedCount: current.isFavorite ? current.interestedCount - 1 : current.interestedCount + 1,
      );
    }
  }

  @override
  Future<void> reserveTable(String id, String timeSlot, int guestCount) async {
    final idx = _restaurants.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _restaurants[idx];
      final slotIndex = current.slots.indexWhere((s) => s.timeSlot == timeSlot);
      if (slotIndex != -1) {
        final updatedSlots = List<TableSlotEntity>.from(current.slots);
        updatedSlots[slotIndex] = updatedSlots[slotIndex].copyWith(status: 'Reserved');
        _restaurants[idx] = current.copyWith(slots: updatedSlots);
      }
    }
  }
}
