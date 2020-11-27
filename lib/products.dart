class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
    };
    return map;
  }

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
  }
}