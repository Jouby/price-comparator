import 'package:flutter/material.dart';

class Translate extends StatelessWidget {
  static Map<String, String> translations = {
    'Price Comparator': 'Comparateur de prix',
    'Stores': 'Magasins',
    'Add a new store': 'Ajouter un nouveau magasin',
    'Enter store name': 'Taper le nom du magasin',
    'Remove "%1" ?': 'Supprimer "%1" ?',
    'CANCEL': 'ANNULER',
    'REMOVE': 'SUPPRIMER',
    'Add a new item': 'Ajouter un article',
    'Enter item name': 'Taper le nom de l\'article',
    'Add a new price': 'Ajouter un prix',
    'The minimum price is %1€ in %2': 'Le prix minimum est de %1€ à %2',
    'No data': 'Aucune donnée',
    'Enter your price': 'Taper votre prix',
  };
  @override
  Widget build(BuildContext context) {
    return null;
  }

  static String translate(String string, [List<String> data]) {
    if (translations.keys.contains(string)) {
      string = translations[string];
      if (data != null) {
        for (var i = 1; i <= data.length; i++) {
          var replace = data[i - 1];
          string = string.replaceAll('%$i', '$replace');
        }
      }
    }
    return string;
  }
}
