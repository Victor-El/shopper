import 'package:flutter/material.dart';
import 'package:shopper/blocs/shop_bloc.dart';
import 'package:shopper/models/shop_item_data.dart';

class CartListItem extends StatefulWidget {

  final ShopItemData shopItemData;

  CartListItem({@required this.shopItemData, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CartListItemState();
  }
}

class _CartListItemState extends State<CartListItem> {
  _getTextStyle(FontWeight fw, double fs) {
    return TextStyle(
      fontWeight: fw,
      fontSize: fs,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.red.shade300,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              widget.shopItemData.item,
              style: _getTextStyle(FontWeight.w700, 20),
            ),
          ),
          Expanded(
            child: Text(
              "\$ ${widget.shopItemData.price.toStringAsFixed(2)}",
              style: _getTextStyle(FontWeight.w700, 18),
            ),
          ),
          Expanded(
            child: FlatButton.icon(
              onPressed: () {
                shopBloc.toggleChecked(widget.shopItemData, false);
              },
              icon: Icon(Icons.restore, color: Colors.white,),
              label: Text("Restore", style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}
