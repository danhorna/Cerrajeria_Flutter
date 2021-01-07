import 'package:flutter/material.dart';
import 'package:cerrajeria/pages/product_info.dart';
import 'package:intl/intl.dart';


class SaleInfo extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final GetArguments args = ModalRoute.of(context).settings.arguments;
    final aux = (double.parse(args.item['Precio + iva']) * args.item['Ganancia'])/100;
    final myPrice = (aux + double.parse(args.item['Precio + iva'])).toStringAsFixed(2);
    DateTime now = args.item['Fecha'].toDate();
    String formattedDate = DateFormat('dd/MM/yyyy – kk:mm').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion de la venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
              child: RichText(
                text: TextSpan(
                  text: 'Vendiste: ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: args.item['Item'],style: TextStyle(fontWeight: FontWeight.normal),
                    )
                  ]
                ),
              ),
            ),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'Cantidad: ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: args.item['Cantidad'].toString(),style: TextStyle(fontWeight: FontWeight.normal),
                  )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'Precio por unidad: ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '\$' + myPrice,style: TextStyle(fontWeight: FontWeight.normal),
                    )
                  ]
                ),
              ),
            ),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'Cobraste: ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '\$' + (double.parse(myPrice) * args.item['Cantidad']).toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.normal),
                  )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'Fecha: ',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: formattedDate,style: TextStyle(fontWeight: FontWeight.normal),
                    )
                  ]
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}