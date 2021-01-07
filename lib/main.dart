import 'package:cerrajeria/pages/myproduct_info.dart';
import 'package:cerrajeria/pages/myproducts_page.dart';
import 'package:cerrajeria/pages/products_page.dart';
import 'package:cerrajeria/pages/sales_page.dart';
import 'package:cerrajeria/pages/product_info.dart';
import 'package:cerrajeria/pages/sale_info.dart';

import 'package:flutter/material.dart';               //  importo el material@flutter

import 'pages/home_page.dart';                        //  importo home_page donde va a estar mi HomePage()

 
void main() => runApp(MyApp());                       //  toda app dentro de su main.dart tendra su funcion main(), buscara y ejecutara runApp(), este se encarga de mostrar el widget dado. En este caso llamamos a MyApp(se puede usar new MyApp) que es el encargado de armar el widget y devolverlo. 
 
class MyApp extends StatelessWidget {                 //  creamos la clase MyApp, en este caso StatelessWidget
  @override                                           //  Como el StatelessWidget ya posee su propio build, ingresamos @override para armar nuestro build
  Widget build(BuildContext context) {                //  Armamos el build(ingresamos Widget al comienzo para decir que el build devuelve un widget obligadamente). El context contendra el arbol de widgets. 
    return MaterialApp(                               //  Hacemos return de MaterialApp, el cual es un widget que permite la configuracion global de la app.
      title: 'Material App',                          //  Seteamos el titulo a la app, debe devolver un string.
      debugShowCheckedModeBanner: false,              //  Seteamos la señal de debug como deshabilitada, debe devolver un bool.
      initialRoute: '/',                              //  Mi ruta inicial sera '/'
      routes: <String,WidgetBuilder>{                               //  routes espera un mapa que esta constituido por un string y un BuildContext
        '/' : ( BuildContext context) => HomePage(),
        'products' : ( BuildContext context) => ProductsPage(),
        'sales' : ( BuildContext context) => SalesPage(),
        'productInfo' : (context) => ProductInfo(),
        'myproducts' : (BuildContext context) => MyProducts(),
        'myProductInfo' : (context) => MyProductInfo(),
        'saleInfo' : (context) => SaleInfo(),
      },
    );
  }
}
