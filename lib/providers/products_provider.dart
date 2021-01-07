import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

//  No se puede hacer un constructor asincrono

class _ProductsProvider{                                                        //  Creo la clase privada
  List<dynamic> products = [];                                              //  Creo una lista de tipo dynamic de nombre opciones, vacia.

  Future <List<dynamic>> cargarDataP(palabra, String orden) async{                                //  un async me devuelve un Future, en este caso una List de tipo dynamic
    final resp = await rootBundle.loadString('data/products_list.json');        //  en resp se almacena el resultado de rootBundle
    Map dataMap = json.decode(resp);                                        //  una vez obtenido la resp se hace un decode en json y se almacena en la variable dataMap de tipo Map
    products = dataMap['products'];                                         //  a nuestra List dynamic de nombre opciones le asignamos "sections" de nuestro Map anterior
    if ((palabra != null) & (palabra != "")) {
      List<dynamic> finalList = [];
      for (var item in products) {
        final aux = item['Item'].toLowerCase();
        if (aux.contains(palabra)) {
          finalList.add(item);
        }
      }
      if (orden == 'Menor') 
          finalList.sort((a,b) => double.parse(a['Precio']).compareTo(double.parse(b['Precio'])));
      else{
        if (orden == 'Mayor')
          finalList.sort((a,b) => double.parse(b['Precio']).compareTo(double.parse(a['Precio'])));
      }
      return finalList;
      
    }
    else{
      if (orden == 'Menor') 
          products.sort((a,b) => double.parse(a['Precio']).compareTo(double.parse(b['Precio'])));
      else{
        if (orden == 'Mayor')
          products.sort((a,b) => double.parse(b['Precio']).compareTo(double.parse(a['Precio'])));
      }
      return products;
    }
    
  }
}

final productsProvider = new _ProductsProvider();                                   //  creo una instancia de _MenuProvider en menuProvider