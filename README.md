# Mon Application Flutter - Art_Log

## Description

Ce projet est une application Flutter permettant de gérer un catalogue d'œuvres d'art, d'artistes et de musées. L'utilisateur peut consulter les différentes pages et ajouter des éléments à ses favoris grâce à un bouton "like". Les informations sont récupérées depuis une base de données locale et affichées sur quatre pages :

- **Œuvres** : Liste des œuvres d'art disponibles.
- **Artistes** : Liste des artistes associés aux œuvres.
- **Musées** : Liste des musées où les œuvres sont exposées.
- **Favoris** : Liste des œuvres, artistes et musées ajoutés aux favoris par l'utilisateur.

Le but principal de l'application est d'afficher ces informations et permettre à l'utilisateur de marquer ses préférences (œuvres/artistes/musées) en les ajoutant à la page des favoris via un bouton "like".

## Fonctionnalités

- Liste des **œuvres**, **artistes** et **musées**.
- Possibilité de **liker** un élément (œuvre, artiste ou musée).
- Les éléments **likés** sont ajoutés automatiquement à la page **Favoris**.
- Stockage des éléments favoris dans **SharedPreferences** pour persister la sélection entre les redémarrages de l'application.

## Prérequis

Avant de commencer, assurez-vous d'avoir installé Flutter et d'avoir configuré votre environnement pour le développement Flutter. Pour plus de détails, vous pouvez consulter la documentation officielle de Flutter ici : [Flutter Installation Guide](https://flutter.dev/docs/get-started/install).

### Prérequis pour Flutter :
- Flutter SDK
- Dart SDK
- Xcode (pour iOS, sur Mac) ou Android Studio (pour Android)

## Installation

1. Clonez le repository depuis GitHub :

   ```bash
   git clone https://github.com/SuzanneLeonore/appli_tp1.git
