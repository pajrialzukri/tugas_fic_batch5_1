part of 'edit_product_bloc.dart';

@immutable
abstract class EditProductState {}

class EditProductInitial extends EditProductState {}

class EditProductLoading extends EditProductState {}

class EditProductLoaded extends EditProductState {
  final ProductResponseModel model;
  final int id;

  EditProductLoaded({required this.model, required this.id});
}

class EditProductError extends EditProductState {
  final String message;
  EditProductError({required this.message});
}
