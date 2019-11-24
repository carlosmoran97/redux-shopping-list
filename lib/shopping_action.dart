import 'package:example/shopping_state.dart';

class AddProductAction{
  Product product;
  AddProductAction(this.product);
}

class UpdateProductAction{
  int index;
  Product product;
  UpdateProductAction(this.product, this.index);
}

class DeleteProductAction{
  int index;
  DeleteProductAction(this.index);
}