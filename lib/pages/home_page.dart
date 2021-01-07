import 'dart:convert';

import 'package:cerrajeria/providers/menu_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {

  Widget modStock(){
    return StreamBuilder(
      stream: Firestore.instance.collection('data').document('configStock').snapshots(),
      builder: (context,snapshot){
        
        if (!snapshot.hasData){
          return Text('Cargando..');
        }
        return Padding(
          padding: const EdgeInsets.only(top:20.0,bottom: 18.0),
          child: Row(
            children: <Widget>[
              Text('Cambio de stock: '),
              Switch(
                value: snapshot.data['canMod'],
                onChanged: (value){
                  Firestore.instance.collection('data').document('configStock').updateData({"canMod" : value});
                }
              )
            ],
          ),
        );
      },
    );
    
  }

  Future updatePrices() async{
    final resp = await rootBundle.loadString('data/products_list.json');
    Map dataMap = json.decode(resp);
    List<dynamic> products = dataMap['products'];
    for (var item in products) {
      await Firestore.instance.collection('myProducts').where('Codigo',isEqualTo: item['Codigo']).getDocuments().then((it) async{
        if (it.documents.length != 0) {
          await Firestore.instance.collection('myProducts').document(it.documents[0].documentID).updateData({'Precio' : item['Precio'],'Precio + iva' : item['Precio + iva']});
          
        }
      });
    }
  }


  Widget configS(){
    return StreamBuilder(
      stream: Firestore.instance.collection('data').document('configProf').snapshots(),
      builder: (context,snapshot){
        if (!snapshot.hasData){
          return Text('Cargando..');
        }
        TextEditingController gananciaDato = TextEditingController();
        gananciaDato.text = snapshot.data['profValue'].toString();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Ganancia: ',style: TextStyle(fontSize: 18),),
                Flexible(
                  child:Container(
                    width: 30,
                    child: TextField(
                      inputFormatters: [LengthLimitingTextInputFormatter(2)],
                      keyboardType: TextInputType.number,
                      controller: gananciaDato,
                      decoration: InputDecoration(
                        hintText: snapshot.data['profValue'].toString()
                      ),
                    ),
                  )
                ),
                Text('%')
              ],
            ),
            modStock(),
            // Padding(
            //   padding: const EdgeInsets.only(bottom:20.0),
            //   child: RaisedButton(
            //     onPressed: (){
            //       updatePrices();
            //     },
            //     child: Text('Actualizar mis precios'),
            //   ),
            // ),
            RaisedButton(
                  onPressed: (){
                    Firestore.instance.collection('data').document('configProf').updateData({'profValue' : int.parse(gananciaDato.text)})
                    .then((done){
                      Navigator.of(context).pop();
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            title: Column(
                              children: <Widget>[
                                Icon(Icons.check_circle,color: Colors.green,size: 30,),
                                Text('Datos actualizados!'),
                              ],
                            ),
                          );
                        }
                      );
                    });
                  },
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)
                  ),
                  color: Colors.blue,
                  child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(fontSize: 16)
                  ),
                ),
                )
              ,
            
          ],
        );
      },
    );
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(                                                    //  retorna el widget scaffold 
      appBar: AppBar(                                //  le asignamos un color de fondo al appBar
        title: Text('Menú'),                                            //  le asignamos un titulo al appBar con el el widget Text
        centerTitle: true,                                              //  le asigno la propiedad center al appBar con un bool
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context){
                  return AlertDialog(
                    title: Center(child: Text('Configuracion'),),
                    content: configS()
                  );
                }
              );
            },
          )
        ],
      ),
      body: _lista(),
    );
  }

  Widget _lista(){                                                      //  Creo mi _lista de tipo List de widgets
    
    return FutureBuilder(                                             
      future: menuProvider.cargarData(),                                //  el future: tiene que estar enlazado a nuestro future de menu_provider.dart
      initialData: [],                                                  //  indica el valor inicial que tendra por defecto hasta que se resuelva el future, no es obligatorio.
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){        //  recibe una funcion como argumento el context y un AsynSnapshot de tipo List dynamic(en este caso)
        return ListView(                                                //  el builder debe retornar un widget, dicho widget sera armado por el ListView con los datos de nuestro future
          children: _listaItems(snapshot.data, context),                //  indicamos que el ListView tendra un children que es de tipo List de widgets. Le envamos a _listaItems la data del snapshot. Enviamos el context para ser usado por el push.
        );
      },  
    );
    
  }


  List<Widget> _listaItems(List<dynamic> data, BuildContext context){   //  Indicamos que _listaItems recibe data de tipo List dynamic

    final List<Widget> opciones = [];                                   //  creamos un final de tipos List de widgets de nombre opciones, vacia.

    data.forEach((opt){                                                 //  hago un forEach de cada dato en data
      final widgetTemp = ListTile(                                      //  creo un widgetTemp de tipo ListTile
        title: Text(opt['text']),
        trailing: Icon(Icons.keyboard_arrow_right),                     //  le agrego una flecha a la derecha al ListTile
        onTap: (){                                                      //  indica el codigo a ejecutar al hacer tap en el ListTile
          
          Navigator.pushNamed(context, opt['route']);                   //  llamamos a un pushnamed, la ruta indicada debe estar definida en las rutas del MaterialApp
        },                            
      );

      opciones..add(widgetTemp)                                         //  agrego mi widgetTemp en opciones
              ..add(Divider());                                         //  agrego tambien un Divider
    });
    return opciones;                                                    //  devuelvo opciones de tipo List de widgets

  }





}

