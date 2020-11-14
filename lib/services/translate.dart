import 'package:flutter/material.dart';

/// The Translate widget
/// 
/// Used for i18n, based language is English
class Translate extends StatelessWidget {
  /// English - French translations
  static Map<String, String> translations = {
    'Price Comparator': 'Comparateur de prix',
    'Stores': 'Magasins',
    'Add a new store': 'Ajouter un nouveau magasin',
    'Enter store name': 'Taper le nom du magasin',
    'Remove "%1" ?': 'Supprimer "%1" ?',
    'CANCEL': 'ANNULER',
    'SAVE': 'Enregistrer',
    'REMOVE': 'SUPPRIMER',
    'Remove': 'Supprimer',
    'Edit': 'Modifier',
    'Add a new item': 'Ajouter un article',
    'Enter item name': 'Taper le nom de l\'article',
    'Add a new price': 'Ajouter un prix',
    'The minimum price is ': 'Le prix minimum est de ',
    ' in ': ' à ',
    'No data': 'Aucune donnée',
    'Enter your price': 'Taper votre prix',
    'A store with same name already exists.': 'Un magasin avec le même nom a déjà été créé.',
    'An item with same name already exists.': 'Un object avec le même nom a déjà été créé.',
    'Fill this field.': 'Remplisser le champ',
    'Settings': 'Options',
    'Create account': 'Créer un compte',
    'Can': 'Conserve',
    'Freeze': 'Surgelé',
    'Bio': 'Bio',
    'Wrap': 'Avec emballage',
    'Unavailable': 'Non Disponible',
    'Search': 'Recherche'
  };

  @override
  Widget build(BuildContext context) {
    return null;
  }

  /// Translate [string] with some [parameters]
  static String translate(String string, [List<String> parameters]) {
    if (translations.keys.contains(string)) {
      string = translations[string];
      if (parameters != null) {
        for (int i = 1; i <= parameters.length; i++) {
          String replace = parameters[i - 1];
          string = string.replaceAll('%$i', '$replace');
        }
      }
    }

    return string;
  }
}
