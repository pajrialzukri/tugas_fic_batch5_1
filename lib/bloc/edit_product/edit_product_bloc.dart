import 'package:bloc/bloc.dart';
import 'package:flutter_ecatalog/data/datasources/product_datasource.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';
import 'package:meta/meta.dart';

part 'edit_product_event.dart';
part 'edit_product_state.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  final ProductDataSource dataSource;
  EditProductBloc(this.dataSource) : super(EditProductInitial()) {
    on<DoEditProductEvent>((event, emit) async {
      emit(EditProductLoading());
      final result = await dataSource.updateProduct(event.model, event.id);

      result.fold((error) => emit(EditProductError(message: error)),
          (data) => emit(EditProductLoaded(model: data, id: event.id)));
    });
  }
}
