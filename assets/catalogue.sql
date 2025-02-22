CREATE TABLE oeuvres (
  id INTEGER PRIMARY KEY,
  nom TEXT,
  description TEXT,
  prix REAL,
  date INTEGER,
  auteur TEXT
);

CREATE TABLE artistes (
  id INTEGER PRIMARY KEY,
  nom TEXT,
  description TEXT,
  prix REAL
);

CREATE TABLE musées (
  id INTEGER PRIMARY KEY,
  nom TEXT,
  description TEXT,
  prix REAL
);


INSERT INTO oeuvres (nom, description, prix, date, auteur)   
VALUES
('Produit A', 'Description du produit A', 19.99, 2023, 'auteur'),
('Produit B', 'Description du produit B', 29.99, 2023, 'auteur'),
('Produit C', 'Description du produit C', 39.99, 2023, 'auteur');
