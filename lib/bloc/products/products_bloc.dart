import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:flutter_ecatalog/data/datasources/product_datasource.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource dataSource;

  ProductsBloc(
    this.dataSource,
  ) : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      if (state is ProductsLoading) return;
      final currentStae = state;
      List<ProductResponseModel> oldList = [];
      if (currentStae is ProductsLoaded) {
        oldList = event.offset == 0 ? [] : currentStae.data;
      }
      emit(ProductsLoading(data: oldList));
      final result = await dataSource.getAllProduct(event.offset, event.limit);
      List<ProductResponseModel> newList = [];
      newList = oldList;

      result.fold(
          (error) => emit(ProductsError(message: error)),
          (result) => {
                newList.addAll(result),
                emit(ProductsLoaded(data: newList)),
              });
    });
  }
}
