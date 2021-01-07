import 'package:cerrajeria/pages/product_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SalesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: SalesList()
    );
  }

  
}

class SalesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('sales').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (!snapshot.hasData) {
          return Text('Cargando...');
        }
        snapshot.data.documents.sort((a, b) {
          return b["Fecha"].compareTo(a["Fecha"]);
        });
        return ListView.separated(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            DateTime now = snapshot.data.documents[index]['Fecha'].toDate();
            String formattedDate = DateFormat('dd/MM/yyyy – kk:mm').format(now);
            return ListTile(
              title: Text(snapshot.data.documents[index]['Item']),
              subtitle: Text('$formattedDate'),
              onTap: (){
                Navigator.pushNamed(context, 'saleInfo',arguments: GetArguments(snapshot.data.documents[index]));
              },
            );
          },
          separatorBuilder: (context,index){
            return Divider();
          },
        );
      }
    );
  }
}


