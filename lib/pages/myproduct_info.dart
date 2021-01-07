
import 'package:cerrajeria/pages/product_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyProductInfo extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final GetArguments args = ModalRoute.of(context).settings.arguments;

    


    Widget sell(snapshot,myPrice,profValue){
      if (snapshot.data['Stock'] > 0) {
        return RaisedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context){
                return AlertDialog(
                  title: Center(child: Text('Crear venta')),
                  content: CreateQ(snapshot: snapshot, price: myPrice, prof: profValue),
                );
              }
            );
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
              'Crear venta',
              style: TextStyle(fontSize: 20)
            ),
          ),
        );
      } else {
        return RaisedButton(
          onPressed: null,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.grey)
          ),
          color: Colors.blue,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Sin Stock!',
              style: TextStyle(fontSize: 20)
            ),
          ),
        );
      }
      
    }

    Widget canSub(snapshot){
      if (snapshot.data['Stock'] > 0) {
        return IconButton(
          icon: Icon(Icons.remove_circle_outline,size: 32,color: Colors.red),
          onPressed: (){
            Firestore.instance.collection('myProducts').document(snapshot.data.documentID).updateData({'Stock' : snapshot.data['Stock']-1});
          }
        );
      } else {
        return IconButton(
          icon: Icon(Icons.remove_circle_outline,size: 32,color: Colors.grey),
          onPressed: null
        );
      }
    }

    Widget myStock(snapshot){
      return StreamBuilder(
        stream: Firestore.instance.collection('data').document('configStock').snapshots(),
        builder: (context,snapshottt){
          if (!snapshottt.hasData){
            return Text('Cargando..');
          }
          if (!snapshottt.data['canMod']) {
            return Text('Stock: ' + (snapshot.data['Stock']).toString(),style: TextStyle(fontSize: 25),);
            
          }
          else{
            return Row(
              children: <Widget>[
                Expanded(
                  child: Text('Stock: ' + (snapshot.data['Stock']).toString(),style: TextStyle(fontSize: 25),),
                ),
                
                canSub(snapshot),
                IconButton(
                  icon: Icon(Icons.add_circle_outline,size: 32,color: Colors.green),
                  onPressed: (){
                    Firestore.instance.collection('myProducts').document(snapshot.data.documentID).updateData({'Stock' : snapshot.data['Stock']+1});
                  },
                ),
              ],
            );
          }

        },
      );
      
    }


    Widget infoSectionMP(snapshot){
      return Center( 
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text( snapshot.data['Item'], 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              decoration: TextDecoration.underline,
              decorationColor: Colors.black
            ),
          ),
        )
      );
    }
              
        
      


    Widget myPrice(snapshot){
      return StreamBuilder(
        stream: Firestore.instance.collection('data').document('configProf').snapshots(),
        builder: (context,snapshott){
          if (!snapshott.hasData){
            return Text('Cargando..');
          }
          final aux = (double.parse(snapshot.data['Precio + iva']) * snapshott.data['profValue'])/100;
          final myPrice = (aux + double.parse(snapshot.data['Precio + iva'])).toStringAsFixed(2);
          return Padding(
            padding: const EdgeInsets.only(top:50.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0)
                  )
                ),
                child: Column(
                  children:[
                    Text('Precio del producto:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0),
                      child: Text('\$' + myPrice,style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:15.0,bottom: 10.0),
                      child: sell(snapshot,myPrice,snapshott.data['profValue']),
                    ),
                    Text('\$' + snapshot.data['Precio + iva'] + '(precio con iva) + \$' + aux.toStringAsFixed(2) + '('+ (snapshott.data['profValue']).toString() + '% ganancia)',style: TextStyle(fontSize: 13),),
                  ]
                )
              )
            )
          );
        },
      );
    }

    Widget union(snapshot){
      return Padding(
        padding: const EdgeInsets.only(top:50.0,left: 20,right: 20),
        child: Column(
          children: <Widget>[
            myStock(snapshot),
            myPrice(snapshot),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Informacion de mi producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete,color: Colors.red,),
            onPressed: (){
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context){
                  return AlertDialog(
                    title: Center(child: Text('¿Eliminar el producto?'),),
                    actions: <Widget>[
                      RaisedButton(
                        child: Text('SI'),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)
                        ),
                        color: Colors.red,
                        onPressed: (){
                          Navigator.popUntil(context, ModalRoute.withName('myproducts'));
                          Future.delayed(Duration(seconds: 1), () {
                            Firestore.instance.collection('myProducts').document(args.item.documentID).delete();
                          });
                        }
                      ),
                      RaisedButton(
                        child: Text('NO'),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue)
                        ),
                        color: Colors.blue,
                        onPressed: (){
                          Navigator.of(context).pop();
                        }
                      )
                    ],
                  );
                }
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('myProducts').document(args.item.documentID).snapshots(),
        builder: (context,snapshot){
          if (!snapshot.hasData) {
            return Text('Cargando..');
          }
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(15.0)
              )
            ),
            margin: EdgeInsets.all(10),
            child: ListView(
              children: [
                infoSectionMP(snapshot),
                union(snapshot),
              ],
            ),
          );
        },
      )
    );
  }
  
}

class CreateQ extends StatefulWidget {
  CreateQ({this.snapshot,this.price,this.prof});
  final prof;
  final snapshot;
  final price;
  @override
  _CreateQState createState() => _CreateQState(snapshot: snapshot, price: price, prof: prof);
}

class _CreateQState extends State<CreateQ> {
  _CreateQState({this.snapshot, this.price, this.prof});
  final prof;
  final price;
  final snapshot;
  int cant = 1;
  TextEditingController sellInfo = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child:Text('Cantidad: ' + cant.toString(),style: TextStyle(fontSize: 20),),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: (){
                if (cant > 1) {
                  setState(() {
                    cant--;
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: (){
                if (cant < snapshot.data['Stock']) {
                  setState(() {
                    cant++;
                  });
                }
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top:10.0,bottom: 15.0),
          child: Row(
            children: <Widget>[
              Text('Total: \$' + (double.parse(price)*cant).toStringAsFixed(2),style: TextStyle(fontSize: 20),)
            ],
          ),
        ),
        Flexible(
          child: TextField(
            controller: sellInfo,
            minLines: 4,
            maxLines: 10,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'Informacion sobre la venta',
              filled: true,
              fillColor: Color(0xFFDBEDFF),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)
                ),
                color: Colors.red,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 13)
                  ),
                ),
              ),
              RaisedButton(
                onPressed: (){
                  
                  Firestore.instance.collection('sales').add(
                    {
                      'Codigo': snapshot.data['Codigo'],
                      'Item' : snapshot.data['Item'],
                      'Cantidad': cant,
                      'Precio': snapshot.data['Precio'],
                      'Precio + iva': snapshot.data['Precio + iva'],
                      'Fecha' : DateTime.now(),
                      'Comentario' : sellInfo.text,
                      'Ganancia' : prof,
                    }
                  ).then((done){
                    Firestore.instance.collection('myProducts').document(snapshot.data.documentID).updateData({'Stock' : snapshot.data['Stock']-cant});
                    Navigator.of(context).pop();
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          title: Column(
                            children: <Widget>[
                              Icon(Icons.check_circle,color: Colors.green,size: 30,),
                              Text('Venta creada!'),
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
                    'Vender',
                    style: TextStyle(fontSize: 13)
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
        }
      
      
     
}