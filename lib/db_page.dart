import 'package:flutter/material.dart';
import 'products.dart';
import 'dart:async';
import 'DBHelper.dart';

class DBTestPage extends StatefulWidget {
  final String title;

  DBTestPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }
}

class _DBTestPageState extends State<DBTestPage> {
  Future<List<Product>> products;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String name;
  double price;

  int productId;

  final formKey = new GlobalKey<FormState>();

  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      products = dbHelper.getProducts();
    });
  }

  clearFields() {
    nameController.text = '';
    priceController.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        price = price;
        Product p = Product(productId, name, price);
        dbHelper.update(p);
        setState(() {
          isUpdating = false;
        });
      } else {
        price = price;
        Product p = Product(null, name, price);
        dbHelper.save(p);
      }
      clearFields();
      refreshList();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Producto'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Precio'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => price = double.parse(val),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearFields();
                  },
                  child: Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Product> products) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text('PRODUCTO'),
              ),
              DataColumn(
                label: Text('PRECIO'),
              ),
              DataColumn(
                label: Text('PRECIO \nFINAL'),
              ),
              DataColumn(
                label: Text('BORRAR'),
              )
            ],
            rows: products
                .map(
                  (product) => DataRow(cells: [
                DataCell(
                  Text(product.name),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      productId = product.id;
                    });
                    nameController.text = product.name;
                    priceController.text = (product.price).toString();
                  },
                ),
                DataCell(
                  Text(product.price.toStringAsFixed(2)),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      productId = product.id;
                    });
                    nameController.text = product.name;
                    priceController.text = (product.price).toString();
                  },
                ),
                DataCell(
                  Text((product.price*1.12).toStringAsFixed(2)),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      productId = product.id;
                    });
                    nameController.text = product.name;
                    priceController.text = (product.price).toString();
                  },
                ),
                DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        dbHelper.delete(product.id);
                        refreshList();
                      },
                    )
                ),
              ]),
            ).toList(),
          ),
        ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No hay datos");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Database Storage'),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}