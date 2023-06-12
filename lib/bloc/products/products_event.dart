part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class GetProductsEvent extends ProductsEvent {
  final int offset;
  final int limit;
  GetProductsEvent({required this.offset, required this.limit});
}
