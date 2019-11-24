import 'package:example/shopping_action.dart';
import 'package:example/shopping_reducers.dart';
import 'package:example/shopping_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Store<ShoppingState> store = Store<ShoppingState>(
      shoppingReducer,
      initialState: ShoppingState.initialState(),

  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List products = ["Producto 1", "Producto 2"];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return StoreConnector(
      converter: (Store<ShoppingState> store) => ViewModel.create(store),
      builder: (BuildContext context, model){
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Shopping list"),
          ),
          body: ListView(
              padding: EdgeInsets.all(10),
              children: model.products.map<Widget>((producto){
                return ListTile(
                  title: Text(producto.name),
                  subtitle: Text(producto.price),
                  trailing: Checkbox(
                    value: false,
                    onChanged: (value){},
                  ),
                );
              }).toList()
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showModal(context, model);
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }

  void showModal(BuildContext context, ViewModel model){

    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Add an Item"),
          content: Container(
            height: 300,
            child: ListView(
              children: <Widget>[
                Text("Name"),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.title,
                    ),
                  ),
                ),
                Text("Price"),
                TextField(
                  controller: priceController,
                ),
              ],
            ),
          ),

          actions: <Widget>[
            RaisedButton(
              onPressed: (){
                Product p = Product();
                p.name = nameController.value.text;
                p.price = priceController.value.text;

                model.addProduct(p);
              },
              child: Text(
                  "Add",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            RaisedButton(
              onPressed: (){},
              child: Text(
                  "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}

class ViewModel{
  List products;
  Function addProduct;
  Function deleteProduct;
  Function updateProduct;

  ViewModel(this.products, this.addProduct, this.deleteProduct, this.updateProduct);

  factory ViewModel.create(Store<ShoppingState> store){

    void _addProduct(Product product){
      store.dispatch(AddProductAction(product));
    }

    void _deleteProduct(int index){
      store.dispatch(DeleteProductAction(index));
    }

    void _updateProduct(Product product, int index){
      store.dispatch(UpdateProductAction(product, index));
    }

    return ViewModel(
      store.state.products,
      _addProduct,
      _deleteProduct,
      _updateProduct
    );
  }
}
