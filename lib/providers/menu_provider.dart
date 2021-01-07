import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

//  No se puede hacer un constructor asincrono

class _MenuProvider{                                                        //  Creo la clase privada

  List<dynamic> opciones = [];                                              //  Creo una lista de tipo dynamic de nombre opciones, vacia.
  List<dynamic> aux = [];
  Future <List<dynamic>> cargarData() async{                                //  un async me devuelve un Future, en este caso una List de tipo dynamic
    final resp = await rootBundle.loadString('data/menu_opts.json');        //  en resp se almacena el resultado de rootBundle
    Map dataMap = json.decode(resp);                                        //  una vez obtenido la resp se hace un decode en json y se almacena en la variable dataMap de tipo Map
    opciones = dataMap['sections'];           
    return opciones;                                                        //  retorno mi List dynamic
  }
}

final menuProvider = new _MenuProvider();                                   //  creo una instancia de _MenuProvider en menuProvider