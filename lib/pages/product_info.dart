import 'package:cerrajeria/providers/oldproducts_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ProductInfo extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final GetArguments args = ModalRoute.of(context).settings.arguments;

    Widget sideButton(item, context){
      final text = Text('Agregar',style: TextStyle(fontSize: 16));
      return StreamBuilder(
        stream: Firestore.instance.collection('myProducts').where('Codigo',isEqualTo: item['Codigo']).snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData) {
            return Text('Cargando..');
          }
          if (snapshot.data.documents.length != 0)
            return RaisedButton(
              child: text,
              onPressed: null,
            );
          else
            return RaisedButton(
              onPressed: (){
                item['Stock'] = 0;
                item['Favorito'] = 0;
                Firestore.instance.collection('myProducts').add(item);
              },
              child: text,
            );
        },
      );
    }

    Widget infoSection = Container(
      margin: EdgeInsets.all(32),
      child: Column( 
        children: [
          Row(
            children: [
                  Expanded(
                    child: Text(args.item['Item'], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                  ),
                  sideButton(args.item, context)
            ],
          ),
        ]
      )
    );


    Widget priceSection(item){
      return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text('Precio sin iva',style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Text('\$' + item['Precio']),
            )
          ],
        ),
        Column(
          children: <Widget>[
            Text('Precio con iva',style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Text('\$' + item['Precio + iva']),
            )
          ],
        ),
      ],
    );
    }


    Widget oldPriceSection(){
      Firestore.instance.collection('myProducts').where('Codigo',isEqualTo: 'ACY-0067').getDocuments().then((asd){
        if (asd.documents.length != 0) 
          Firestore.instance.collection('myProducts').document(asd.documents[0].documentID).updateData({'Precio' : '500'});
      });
      return FutureBuilder(
        future: oldProductsProvider.cargarDataP(),
        initialData: [],
        builder: (context,AsyncSnapshot<List<dynamic>> snapshot){
          dynamic old = { 'Codigo' : 'Sin datos', 'Precio' : 'Sin datos', 'Precio + iva' : 'Sin datos'};
          for (var item in snapshot.data) {
            if (item['Codigo'] == args.item['Codigo']) {
              old = item;
            }
          }
          return priceSection(old);
        }
      );
    } 

    Widget myPrice(){
      return StreamBuilder(
        stream: Firestore.instance.collection('data').document('configProf').snapshots(),
        builder: (context,snapshot){
          if (!snapshot.hasData) {
            return Text('Cargando..');
          }
          final aux = (double.parse(args.item['Precio + iva']) * snapshot.data['profValue'])/100;
          final myPriceaux = (aux + double.parse(args.item['Precio + iva'])).toStringAsFixed(2);
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: Text('\$' + myPriceaux,style: TextStyle(fontSize: 25),),
              ),
              Text('\$' + args.item['Precio + iva'] + '(precio con iva) + \$' + aux.toStringAsFixed(2) + '('+ (snapshot.data['profValue']).toString() + '% ganancia)',style: TextStyle(fontSize: 13),),

            ],
          );
        },
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion del producto'),
      ),
      body: Column(
        children: [
          infoSection,
          Padding(
            padding: const EdgeInsets.only(bottom:30.0),
            child: Center(child: Text('Precio actual',style: TextStyle(fontSize: 20),)),
          ),
          priceSection(args.item),
          Padding(
            padding: const EdgeInsets.only(bottom:30.0,top: 30.0),
            child: Center(child: Text('Precio viejo',style: TextStyle(fontSize: 20),)),
          ),
          oldPriceSection(),
          Padding(
            padding: const EdgeInsets.only(top:40.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 3.0, color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0)
                )
              ),
              child: Column(
                children: <Widget>[
                  Text('Precio a la venta',style: TextStyle(fontSize: 30),),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: myPrice(),
                  ),
                ],
              ),
            ),
          )
          

        ]
        
      )
    );
  }
}
class GetArguments {
  final dynamic item;
  GetArguments(this.item);
}