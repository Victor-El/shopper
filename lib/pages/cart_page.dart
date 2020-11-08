import 'package:flutter/material.dart';
import 'package:shopper/blocs/shop_bloc.dart';
import 'package:shopper/models/shop_item_data.dart';
import 'package:shopper/widgets/cart_list_item.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: true,
        title: Text("My Cart"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          initialData: shopBloc.cartList,
        stream: shopBloc.cartStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ShopItemData>> snapshot) {
          return snapshot.data == null || snapshot.data.length <= 0
              ? Center(
            child: Text(
              "No item in the list",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          )
              : ListView.builder(
            itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (!snapshot.hasError && snapshot.data != null) {
                  return CartListItem(
                      shopItemData: snapshot.data.elementAt(index));
                }
                return null;
              });
        },
      ),
      ),
    );
  }

  @override
  void didUpdateWidget(CartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }
}
