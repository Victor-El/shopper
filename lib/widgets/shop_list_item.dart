import 'package:flutter/material.dart';
import 'package:shopper/blocs/shop_bloc.dart';
import 'package:shopper/models/shop_item_data.dart';

class ShopListItem extends StatefulWidget {
  final ShopItemData shopItemData;

  ShopListItem({@required this.shopItemData, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShopListItemState();
  }
}

class _ShopListItemState extends State<ShopListItem> {

  _getTextStyle(FontWeight fw, double fs, bool lineThrough) {
    return TextStyle(
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
      fontWeight: fw,
      fontSize: fs,
    );
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
              style: _getTextStyle(FontWeight.w700, 20, widget.shopItemData.checked),
            ),
          ),
          Expanded(
            child: Text(
              "\$ ${widget.shopItemData.price.toStringAsFixed(2)}",
              style: _getTextStyle(FontWeight.w700, 18, widget.shopItemData.checked),
            ),
          ),
          Checkbox(
            value: widget.shopItemData.checked,
            onChanged: (state) {
              shopBloc.toggleChecked(widget.shopItemData, state);
            },
          ),
        ],
      ),
    );
  }
}
