import 'dart:convert';

import 'package:data_app/domain/http_connector.dart';
import 'package:data_app/domain/product/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final productHttpRepository = Provider<ProductHttpRepository>((ref) {
  return ProductHttpRepository(ref);
});

class ProductHttpRepository {
  Ref _ref;
  ProductHttpRepository(this._ref);

  Future<Product> findById(int id) async {
    Response response =
        await _ref.read(httpConnector).get("/api/product/${id}");
    Product product = Product.fromJson(jsonDecode(response.body));
    return product;
  }

  // 역할 : 통신과 파싱
  Future<List<Product>> findAll() async {
    Response response = await _ref.read(httpConnector).get("/api/product");
    print("${response}");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];
      List<Product> productList = body.map((e) => Product.fromJson(e)).toList();
      return productList;
    } else {
      return [];
    }
  }

  // name, price
  Future<Product> insert(Product productReqDto) async {
    // body
    String body = jsonEncode(productReqDto.toJson());
    Response response =
        await _ref.read(httpConnector).post("/api/product", body);
    Product product = Product.fromJson(jsonDecode(response.body)["data"]);
    return product;
  }

  Future<Product> updateById(int id, Product productReqDto) async {
    // body
    String body = jsonEncode(productReqDto.toJson());
    print("repository id : ${id}");
    print("repository body : ${body}");
    Response response =
        await _ref.read(httpConnector).put("/api/product/${id}", body);
    Product product = Product.fromJson(jsonDecode(response.body)["data"]);
    return product;
  }

  Future<int> deleteById(int id) async {
    Response response =
        await _ref.read(httpConnector).delete("/api/product/${id}");
    return jsonDecode(response.body)["code"];
  }
}
