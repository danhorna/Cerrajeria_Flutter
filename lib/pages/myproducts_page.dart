
import 'package:cerrajeria/pages/product_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProducts extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis productos'),),
      body: ContenidoMP(),
    );
  }
}

class ContenidoMP extends StatefulWidget {
  _ContenidoMPState createState() => _ContenidoMPState();
}

class _ContenidoMPState extends State<ContenidoMP> {
  TextEditingController editingController = TextEditingController();
  String word;
  String botonValue = 'Favoritos';
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
          child: MyProductsList(palabra: word, orden: botonValue)),
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
      items: <String>['Favoritos','Mayor','Menor'].map<DropdownMenuItem<String>>((String value){
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
      controller: editingController,
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




class MyProductsList extends StatelessWidget {
  MyProductsList({this.palabra, this.orden});
  final String orden;
  final String palabra;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('myProducts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
        if (!snapshot.hasData){
          return Text('Cargando..');
        }
        List<Widget> sendList = [];
        if ((palabra != null) & (palabra != "")) {
          List<dynamic> finalList = [];
          for (var item in snapshot.data.documents) {
            final aux = item['Item'].toLowerCase();
            if (aux.contains(palabra)) {
              finalList.add(item);
            }
          }
          finalList.sort((a,b) => b['Favorito'] - (a['Favorito']));
          if (orden == 'Menor') 
              finalList.sort((a,b) => a['Stock'].compareTo(b['Stock']));
          else{
            if (orden == 'Mayor')
              finalList.sort((a,b) => b['Stock'].compareTo(a['Stock']));
          }
          for (var item in finalList) {
            var aux2;
            if (item['Favorito'] == 1) {
              aux2 = IconButton(
                icon: Icon(Icons.favorite),
                color: Colors.red,
                onPressed: (){
                  Firestore.instance.collection('myProducts').document(item.documentID).updateData({'Favorito': 0});
                },
              );
            }
            else{
              aux2 = IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: (){
                  Firestore.instance.collection('myProducts').document(item.documentID).updateData({'Favorito': 1});
                },
              );
            }
            final aux = ListTile(
              title: Text(item['Item'],style: TextStyle(fontSize: 14.7),),
              subtitle: Text('Stock: ' + item['Stock'].toString()),
              trailing: aux2,
              onTap: (){
                Navigator.pushNamed(context, 'myProductInfo',arguments: GetArguments(item));
              },
            );
            sendList..add(aux)
                    ..add(Divider());
          }
          return ListView(
            children: sendList,
          );
        }
        else{
          snapshot.data.documents.sort((a,b) => b['Favorito'] - (a['Favorito']));
          if (orden == 'Menor') 
            snapshot.data.documents.sort((a,b) => a['Stock'].compareTo(b['Stock']));
          else{
            if (orden == 'Mayor')
              snapshot.data.documents.sort((a,b) => b['Stock'].compareTo(a['Stock']));
          }
          for (var item in snapshot.data.documents) {
            var aux2;
            if (item['Favorito'] == 1) {
              aux2 = IconButton(
                icon: Icon(Icons.favorite),
                color: Colors.red,
                onPressed: (){
                  Firestore.instance.collection('myProducts').document(item.documentID).updateData({'Favorito': 0});
                },
              );
            }
            else{
              aux2 = IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: (){
                  Firestore.instance.collection('myProducts').document(item.documentID).updateData({'Favorito': 1});
                },
              );
            }
            final aux = ListTile(
              title: Text(item['Item'],style: TextStyle(fontSize: 14.7),),
              subtitle: Text('Stock: ' + item['Stock'].toString()),
              trailing: aux2,
              onTap: (){
                Navigator.pushNamed(context, 'myProductInfo',arguments: GetArguments(item));
              },
            );
            sendList..add(aux)
                    ..add(Divider());
          }
          return ListView(
            children: sendList,
          );
        }
      },
    );
  }
}