class ProductModel {
  String title;
  String description;
  String id;

  ProductModel({this.title = "", this.description = "", this.id = ""});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(title : json['title'],
      description : json['description'],
      id : json['id']);

}