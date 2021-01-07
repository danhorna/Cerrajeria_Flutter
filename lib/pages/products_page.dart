import 'package:cerrajeria/pages/product_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cerrajeria/providers/products_provider.dart';

class ProductsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: Contenido(),
      
    );
  }
}

class Contenido extends StatefulWidget {
  ContenidoState createState() => ContenidoState();
}

class ContenidoState extends State<Contenido> {
  String word;
  String botonValue = 'Normal';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        searchW(),
        Flexible(child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ProductsList(palabra: word, orden: botonValue)),
        )
      ],
    );
  }


  Widget searchW(){
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
            Flexible(
              child: searchWidget()
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0,right: 0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: filterWidget(),
              )
            ),
        ],
      )
    );
  }

  Widget filterWidget(){
    return DropdownButton<String>(
      value: botonValue,
      icon: Icon(Icons.filter_list),
      iconSize: 24,
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String newValue){
        setState(() {
          botonValue = newValue;
        });
      },
      items: <String>['Normal','Mayor','Menor'].map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
      .toList()
    );
  }


  Widget searchWidget(){
    return TextField(
      autofocus: false,
      onChanged: (value){
        setState(() {
          word = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Buscar",
        hintText: "Buscar",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)))
      ),
    );
  }

}



class ProductsList extends StatelessWidget {
  ProductsList({this.palabra, this.orden});
  final String orden;
  final String palabra;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productsProvider.cargarDataP(palabra, orden),
      initialData: [],
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
        return CreateList(data : snapshot.data);
      },
    );
  }
}

class CreateList extends StatelessWidget {
  CreateList({this.data});
  final List<dynamic> data;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('data').document('configProf').snapshots(),
      builder: (context,snapshot){
        return completeList(context, snapshot);
      },
    );
  }

  ListView completeList(BuildContext context,snapshot){
    final List<Widget> finalList = [];
    for (var item in data) {
      final aux2 = (double.parse(item['Precio + iva']) * snapshot.data['profValue'])/100;
      final myPriceaux = (aux2 + double.parse(item['Precio + iva'])).toStringAsFixed(2);
      final aux = ListTile(
        title: Text(item['Item']),
        trailing: Text('\$' + myPriceaux),
        onTap: (){
          Navigator.pushNamed(context, 'productInfo',arguments: GetArguments(item));
        }
      );
      finalList..add(aux)
               ..add(Divider());
    }
    return ListView(
      children: finalList
    );
  }


}
