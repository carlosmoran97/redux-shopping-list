class Product{
  String name;
  String price;
  bool done;
}
class ShoppingState{
  final List<Product> products;
  ShoppingState(this.products);

  factory ShoppingState.initialState(){
    return ShoppingState(List.unmodifiable([]));
  }
}