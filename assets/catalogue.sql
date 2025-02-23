CREATE TABLE IF NOT EXISTS artistes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    photo TEXT,
    date_naissance TEXT,
    date_mort TEXT,
    style_art TEXT
);

CREATE TABLE IF NOT EXISTS musees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    logo TEXT,
    nom TEXT NOT NULL,
    date_creation TEXT,
    localisation TEXT
);

CREATE TABLE IF NOT EXISTS oeuvres (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titre TEXT NOT NULL,
    image TEXT,
    date_creation TEXT,
    auteur_id INTEGER,
    musee_id INTEGER,
    FOREIGN KEY(auteur_id) REFERENCES artistes(id),
    FOREIGN KEY(musee_id) REFERENCES musees(id)
);


INSERT INTO artistes (nom, photo, date_naissance, date_mort, style_art) VALUES
('Pablo Picasso', 'https://example.com/picasso.jpg', '1881-10-25', '1973-04-08', 'Cubisme'),
('Vincent van Gogh', 'https://example.com/vangogh.jpg', '1853-03-30', '1890-07-29', 'Post-impressionnisme'),
('Claude Monet', 'https://example.com/monet.jpg', '1840-11-14', '1926-12-05', 'Impressionnisme'),
('Salvador Dalí', 'https://example.com/dali.jpg', '1904-05-11', '1989-01-23', 'Surréalisme'),
('Leonardo da Vinci', 'https://example.com/davinci.jpg', '1452-04-15', '1519-05-02', 'Renaissance'),
('Henri Matisse', 'https://example.com/matisse.jpg', '1869-12-31', '1954-11-03', 'Fauvisme'),
('Georgia O''Keeffe', 'https://example.com/okeeffe.jpg', '1887-11-15', '1986-03-06', 'Modernisme');


INSERT INTO musees (nom, date_creation, localisation) VALUES
('Le Louvre', '1793-08-10', 'Paris, France'),
('Le Musée d''Orsay', '1986-12-09', 'Paris, France'),
('Le Musée du Prado', '1819-11-19', 'Madrid, Espagne'),
('Le Musée Van Gogh', '1973-06-02', 'Amsterdam, Pays-Bas'),
('Le MoMA', '1929-11-07', 'New York, États-Unis'),
('Le Tate Modern', '2000-05-12', 'Londres, Royaume-Uni'),
('Le Musée d''Art Moderne de la Ville de Paris', '1961-01-01', 'Paris, France');

INSERT INTO oeuvres (titre, image, date_creation, auteur_id, musee_id) VALUES
('Guernica', 'https://example.com/guernica.jpg', '1937-04-26', 1, 1),
('Les Nympheas', 'https://example.com/nympheas.jpg', '1916-01-01', 3, 2),
('La Nuit étoilée', 'https://example.com/nuitetoilee.jpg', '1889-06-01', 2, 4),
('La Persistance de la mémoire', 'https://example.com/persistance.jpg', '1931-04-01', 4, 5),
('La Joconde', 'https://example.com/joconde.jpg', '1503-06-01', 5, 1),
('Le Rouge et le Bleu', 'https://example.com/rougebleu.jpg', '1907-01-01', 6, 6),
('Les Fleurs du désert', 'https://example.com/fleursdesert.jpg', '1936-01-01', 7, 7);
