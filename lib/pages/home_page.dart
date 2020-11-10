import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopper/blocs/shop_bloc.dart';
import 'package:shopper/models/shop_item_data.dart';
import 'package:shopper/widgets/shop_list_item.dart';

class HomePage extends StatelessWidget {
  final TextEditingController itemController = TextEditingController(text: "");
  final TextEditingController priceController = TextEditingController(text: "");

  var dismissedItem;

  void _showCreateShopItemDialog(BuildContext context) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    await showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orangeAccent.shade50),
            width: width / 1.2,
            height: height / 1.5,
            child: Center(
              child: ListView(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          maxLines: 1,
                          style: TextStyle(fontFamily: "Nunito", fontSize: 20),
                          controller: itemController,
                          validator: (String s) {
                            if (s == null || s.isEmpty) {
                              return "Enter a valid item";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Item",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            prefixIcon: Icon(Icons.shopping_basket),
                            labelText: "Item",
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        ),
                        TextFormField(
                          style: TextStyle(fontFamily: "Nunito", fontSize: 20),
                          controller: priceController,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          validator: (String s) {
                            if (s == null || s.isEmpty) {
                              return "Enter a valid price";
                            }
                            return null;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(13),
                            WhitelistingTextInputFormatter(RegExp(r'[0-9.]'))
                          ],
                          decoration: InputDecoration(
                            hintText: "Price",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            prefixIcon: Icon(Icons.attach_money),
                            labelText: "Price",
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        shopBloc.add(new ShopItemData(
                            itemController.text.trim(),
                            double.parse(priceController.text.trim()),
                            false));
                        itemController.text = "";
                        priceController.text = "";
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Add to list",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 21,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          elevation: 10,
          insetPadding: EdgeInsets.all(20),
        );
      },
      barrierDismissible: true,
      barrierLabel: "Add Item",
      transitionDuration: Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, "/cart");
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
        title: Text(
          "Shopper",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => this._showCreateShopItemDialog(context),
        tooltip: "Add shopping item",
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: shopBloc.shopStream,
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
                        return Dismissible(
                          key: Key(snapshot.data.elementAt(index).item),
                          confirmDismiss: (direction) async {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 2000),
                              action: SnackBarAction(label: "Undo", onPressed: () {
                                shopBloc.restoreShopItem(dismissedItem, index);
                              }),
                              content: Text(
                                  "Delete ${snapshot.data.elementAt(index).item}?"),
                            ));
                            return true;
                          },
                          onDismissed: (DismissDirection direction) {
                            dismissedItem = snapshot.data.elementAt(index);
                            shopBloc.removeItemFromShopList(
                                snapshot.data.elementAt(index));
                          },
                          child: ShopListItem(
                            shopItemData: snapshot.data.elementAt(index),
                          ),
                        );
                      }
                      return null;
                    });
          },
        ),
      ),
      persistentFooterButtons: <Widget>[
        StreamBuilder<List<ShopItemData>>(
            initialData: shopBloc.shopList,
            stream: shopBloc.shopStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<ShopItemData>> snapshot) {
              var val = snapshot.data
                  .map((e) => e.price)
                  .fold(0, (previousValue, element) => previousValue + element);
              val = val.toStringAsFixed(2);
              return Text(
                "Total: \$ $val",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
        StreamBuilder<List<ShopItemData>>(
            initialData: shopBloc.shopList,
            stream: shopBloc.shopStream,
            builder: (context, AsyncSnapshot<List<ShopItemData>> snapshot) {
              var val = snapshot.data
                  .where((element) => !element.checked)
                  .map((e) => e.price)
                  .fold(0, (previousValue, element) => previousValue + element);
              val = val.toStringAsFixed(2);
              return Text(
                "Balance: \$ $val",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              );
            })
      ],
    );
  }
}
