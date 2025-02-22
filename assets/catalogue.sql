CREATE TABLE Oeuvre (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nom TEXT NOT NULL,
  description TEXT NOT NULL,
  prix REAL NOT NULL,         
  date INT NOT NULL,
  auteur TEXT NOT NULL
);


INSERT INTO Oeuvre (nom, description, prix, date, auteur)   
VALUES
('Produit A', 'Description du produit A', 19.99, 2023, 'auteur'),
('Produit B', 'Description du produit B', 29.99, 2023, 'auteur'),
('Produit C', 'Description du produit C', 39.99, 2023, 'auteur');
