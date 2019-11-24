import 'package:example/shopping_action.dart';
import 'package:example/shopping_state.dart';
import 'package:redux/redux.dart';

ShoppingState shoppingReducer( ShoppingState state, action){
  return ShoppingState(productReducer(state.products, action));
}

Reducer<List<Product>> productReducer = combineReducers([
  TypedReducer<List<Product>, AddProductAction>(addProduct),
  TypedReducer<List<Product>, UpdateProductAction>(updateProduct),
  TypedReducer<List<Product>, DeleteProductAction>(deleteProduct),
]);

List<Product> addProduct(List<Product> products, AddProductAction action){
  return List.from(products)..add(action.product);
}

List<Product> updateProduct(List<Product> products, UpdateProductAction action){
  List productsNew = List.from(products);
  productsNew[action.index] = action.product;
  return productsNew;
}

List<Product> deleteProduct(List<Product> products, DeleteProductAction action){
  List productsNew = List.from(products);
  products.removeAt(action.index);
  return productsNew;
}

