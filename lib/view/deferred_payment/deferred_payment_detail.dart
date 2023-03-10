import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/deferred_payment/deferred_payment_db_helper.dart';
import '../../model/deferred_payment/deferred_payments.dart';
import 'deferred_payment_detail_edit.dart';

// catsテーブルの中の1件のデータに対する操作を行うクラス
class DeferredPaymentDetail extends StatefulWidget {
  final int id;

  const DeferredPaymentDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<DeferredPaymentDetail> createState() => _DeferredPaymentDetailState();
}

class _DeferredPaymentDetailState extends State<DeferredPaymentDetail> {
  late DeferredPayments deferred_payments;
  bool isLoading = false;
  static const int textExpandedFlex = 2; // 見出しのexpaded flexの比率
  static const int dataExpandedFlex = 4; // 項目のexpanede flexの比率


// Stateのサブクラスを作成し、initStateをオーバーライドすると、wedgit作成時に処理を動かすことができる。
// ここでは、渡されたidをキーとしてcatsテーブルからデータを取得する
  @override
  void initState() {
    super.initState();
    deferred_paymentData();
    // print('deferred_payments');
  }

// initStateで動かす処理
// catsテーブルから指定されたidのデータを1件取得する
  Future deferred_paymentData() async {
    setState(() => isLoading = true);
    deferred_payments = await DeferredPaymentDbHelper.deferred_paymentinstance.deferred_paymentData(widget.id);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('後払い詳細'),
          actions: [
            IconButton(
              onPressed: () async {                          // 鉛筆のアイコンが押されたときの処理を設定
                await Navigator.of(context).push(            // ページ遷移をNavigatorで設定
                  MaterialPageRoute(
                    builder: (context) => DeferredPaymentDetailEdit(    // 詳細更新画面を表示する
                      deferred_payments: deferred_payments,
                    ),
                  ),
                );
                deferred_paymentData();                                  // 更新後のデータを読み込む
              },
              icon: const Icon(Icons.edit),                 // 鉛筆マークのアイコンを表示
            ),
            IconButton(
              onPressed: () async {                         // ゴミ箱のアイコンが押されたときの処理を設定
                await DeferredPaymentDbHelper.deferred_paymentinstance.deferred_paymentdelete(widget.id);  // 指定されたidのデータを削除する
                Navigator.of(context).pop();                // 削除後に前の画面に戻る
              },
              icon: const Icon(Icons.delete),               // ゴミ箱マークのアイコンを表示
            )
          ],
        ),
        body: isLoading                                     //「読み込み中」だったら「グルグル」が表示される
            ? const Center(
          child: CircularProgressIndicator(),         // これが「グルグル」の処理
        )
            : Column(
          children :[
            Column(                                             // 縦並びで項目を表示
              crossAxisAlignment: CrossAxisAlignment.stretch,   // 子要素の高さを合わせる
              children: [
                Row(children: [
                  const Expanded(                               // 見出しの設定
                    flex: textExpandedFlex,
                    child: Text('日付',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(                           // catsテーブルのnameの表示を設定
                      padding: const EdgeInsets.all(5.0),
                      child: Text(DateFormat("yyyy年MM月dd日").format(deferred_payments.deferred_payment_datetime),style: const TextStyle(fontSize: 20),),
                    ),
                  ),
                ],),
                Row(children: [
                  const Expanded(
                    flex: textExpandedFlex,
                    child: Text('支払名',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                      flex: dataExpandedFlex,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(deferred_payments.deferred_payment_name,style: const TextStyle(fontSize: 20),),
                      )
                  ),
                ],),
                Row(children: [
                  const Expanded(     // 「メモ」の見出し行の設定
                      flex: textExpandedFlex,
                      child: Text('金額',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      )
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(                                      // catsテーブルのmemoの表示を設定
                      padding: const EdgeInsets.all(5.0),
                      child: Text(deferred_payments.deferred_payment_amount_including_tax.toString(),style: const TextStyle(fontSize: 20),),
                    ),
                  ),
                ],),
                Row(children: [
                  const Expanded(           // 「誕生日」の見出し行の設定
                    flex: textExpandedFlex,
                    child: Text('カテゴリー',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(                                      // catsテーブルのbirthdayの表示を設定
                      padding: const EdgeInsets.all(5.0),
                      child: Text(deferred_payments.deferred_payment_category_code,style: const TextStyle(fontSize: 20),),
                    ),
                  )
                ],),
                Row(children: [
                  const Expanded(     // 「メモ」の見出し行の設定
                      flex: textExpandedFlex,
                      child: Text('ジャンル',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      )
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(                                      // catsテーブルのmemoの表示を設定
                      padding: const EdgeInsets.all(5.0),
                      child: Text(deferred_payments.deferred_payment_genre_code,style: const TextStyle(fontSize: 20),),
                    ),
                  ),
                ],),
                Row(children: [
                  const Expanded(     // 「メモ」の見出し行の設定
                      flex: textExpandedFlex,
                      child: Text('支払い方法',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      )
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(                                      // catsテーブルのmemoの表示を設定
                      padding: const EdgeInsets.all(5.0),
                      child: Text(deferred_payments.payment_method_id,style: const TextStyle(fontSize: 20),),
                    ),
                  ),
                ],),
                Row(children: [
                  const Expanded(     // 「メモ」の見出し行の設定
                      flex: textExpandedFlex,
                      child: Text('メモ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      )
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(                                      // catsテーブルのmemoの表示を設定
                      padding: const EdgeInsets.all(5.0),
                      child: Text(deferred_payments.deferred_payment_memo,style: const TextStyle(fontSize: 20),),
                    ),
                  ),
                ],),
              ],
            ),
          ],
        )
    );
  }
}