import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

//  No se puede hacer un constructor asincrono

class _OldProductsProvider{ 
  List<dynamic> products = [];                                              //  Creo una lista de tipo dynamic de nombre opciones, vacia.

  Future <List<dynamic>> cargarDataP() async{ 
    final resp = await rootBundle.loadString('data/oldproducts_list.json');        //  en resp se almacena el resultado de rootBundle
    Map dataMap = json.decode(resp);                                        //  una vez obtenido la resp se hace un decode en json y se almacena en la variable dataMap de tipo Map
    products = dataMap['products']; 
    return products;  
  }
}

final oldProductsProvider = _OldProductsProvider();