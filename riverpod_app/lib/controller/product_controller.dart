import 'package:data_app/domain/product/product_http_repository.dart';
import 'package:data_app/main.dart';
import 'package:data_app/views/components/my_alert_dialog.dart';
import 'package:data_app/views/product/list/product_list_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product/product.dart';

final productController = Provider<ProductController>((ref) {
  return ProductController(ref);
});

/**
 * 컨트롤러 : 비지니스 로직 담당
 */
class ProductController {
  final context = navigatorKey.currentContext!;
  final Ref _ref;
  ProductController(this._ref);

  // 컨트롤러에서 파싱작업을 하지마라
  // Repository에서 파싱된 것을 갖고 비즈니스 로직을 짜야하는 곳
  Future<void> findAll() async {
    List<Product> productList =
        await _ref.read(productHttpRepository).findAll();
    // 데이터를 ViewModel에 넣고 끝낸다. 왜냐하면 View가 ViewModel을 watch하고 있기 때문에
    _ref.read(productListViewModel.notifier).refresh(productList);
  }

  void insert(Product productReqDto) async {
    Product productRespDto =
        await _ref.read(productHttpRepository).insert(productReqDto);
    _ref.read(productListViewModel.notifier).addProduct(productRespDto);
  }

  void deleteById(int id) async {
    int code = await _ref.read(productHttpRepository).deleteById(id);
    if (code == 1) {
      _ref.read(productListViewModel.notifier).removeProduct(id);
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => MyAlertDialog(msg: "삭제실패"),
      );
    }
  }

  void updateById(int id, Product productReqDto) async {
    Product productRespDto =
        await _ref.read(productHttpRepository).updateById(id, productReqDto);
    _ref.read(productListViewModel.notifier).updateProduct(productRespDto);
  }
}
