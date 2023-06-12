part of 'edit_product_bloc.dart';

@immutable
abstract class EditProductEvent {}

class DoEditProductEvent extends EditProductEvent {
  final ProductRequestModel model;
  final int id;
  DoEditProductEvent({required this.model, required this.id});
}
