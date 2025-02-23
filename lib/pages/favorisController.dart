import 'package:flutter/material.dart';
import '/Type_donnee/artiste.dart';
import '/Type_donnee/oeuvre.dart';
import '/Type_donnee/musee.dart';


class FavorisController {
 static final List<dynamic> _favoris = [];

  static List<dynamic> getFavorites() {
    return List.from(_favoris);
  }

  static void addToFavorites(dynamic item) {
    if (item is Oeuvre && item.isFavorite && !item.isFavorite) {
      _favoris.add(item); 
    } else if (item is Artistes && item.isFavorite && !item.isFavorite) {
      _favoris.add(item);
    } else if (item is Musee && item.isFavorite && !item.isFavorite) {
      _favoris.add(item);
    }
  }

  
  static void removeFromFavorites(dynamic item) {
    if (item is Oeuvre || item is Artistes || item is Musee) {
      _favoris.remove(item); 
    }
  }
}
