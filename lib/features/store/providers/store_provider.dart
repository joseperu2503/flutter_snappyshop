import 'package:flutter_snappyshop/features/shared/models/loading_status.dart';
import 'package:flutter_snappyshop/features/shared/models/service_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snappyshop/features/store/models/stores_response.dart';
import 'package:flutter_snappyshop/features/store/services/store_service.dart';

final storeProvider = StateNotifierProvider<StoreNotifier, StoreState>((ref) {
  return StoreNotifier(ref);
});

class StoreNotifier extends StateNotifier<StoreState> {
  StoreNotifier(this.ref) : super(StoreState());
  final StateNotifierProviderRef ref;

  initData() {
    state = state.copyWith(
      stores: [],
      storesStatues: LoadingStatus.none,
      page: 1,
      totalPages: 1,
    );
  }

  Future<void> getStores() async {
    if (state.page > state.totalPages ||
        state.storesStatues == LoadingStatus.loading) return;

    state = state.copyWith(
      storesStatues: LoadingStatus.loading,
    );

    try {
      final response = await StoreService.getStores(page: state.page);
      state = state.copyWith(
        stores: [...state.stores, ...response.results],
        page: state.page + 1,
        totalPages: response.info.lastPage,
        storesStatues: LoadingStatus.success,
      );
    } on ServiceException catch (e) {
      state = state.copyWith(
        storesStatues: LoadingStatus.error,
      );
      throw ServiceException(null, e.message);
    }
  }
}

class StoreState {
  final List<Store> stores;
  final LoadingStatus storesStatues;
  final int page;
  final int totalPages;

  StoreState({
    this.stores = const [],
    this.storesStatues = LoadingStatus.none,
    this.page = 1,
    this.totalPages = 1,
  });

  StoreState copyWith({
    List<Store>? stores,
    LoadingStatus? storesStatues,
    int? page,
    int? totalPages,
  }) =>
      StoreState(
        stores: stores ?? this.stores,
        storesStatues: storesStatues ?? this.storesStatues,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
      );
}
