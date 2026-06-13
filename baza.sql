DROP DATABASE IF EXISTS dbd_prodaja_bundlova;
CREATE DATABASE IF NOT EXISTS dbd_prodaja_bundlova DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE dbd_prodaja_bundlova;

-- 1. Tabela za Korisnike (Kupce / Igrače)
CREATE TABLE IF NOT EXISTS Korisnici (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime_prezime VARCHAR(100) NOT NULL,
    starost INT NOT NULL,
    Platforma VARCHAR(100) -- PC, PlayStation, Xbox, Switch
) ENGINE=InnoDB;

-- 2. Tabela za Kategorije paketa
CREATE TABLE IF NOT EXISTS Kategorije (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv_kategorije VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- 3. Tabela za Bundlove (Pakete) sa akcijskim cenama
CREATE TABLE IF NOT EXISTS Bundlovi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv_bundla VARCHAR(100) NOT NULL,
    kategorija_id INT,
    cena_eur INT NOT NULL, -- Snižena cena po kojoj se prodaje
    FOREIGN KEY (kategorija_id) REFERENCES Kategorije(id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Tabela za Prodaju bundlova
CREATE TABLE IF NOT EXISTS Prodaja_bundlova (
    id INT AUTO_INCREMENT PRIMARY KEY,
    korisnik_id INT NOT NULL,
    bundle_id INT NOT NULL,
    datum_kupovine DATE NOT NULL,
    kolicina INT NOT NULL, -- Broj kupljenih licenci/kodova
    FOREIGN KEY (korisnik_id) REFERENCES Korisnici(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (bundle_id) REFERENCES Bundlovi(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Tabela za Kontakt formu (Za ocenu 9/10)
CREATE TABLE IF NOT EXISTS Kontakt (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    poruka TEXT NOT NULL,
    datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
) ENGINE=InnoDB;


-- ================= INSERT PODATAKA =================

-- Unos Kategorija bundlova
INSERT INTO Kategorije (naziv_kategorije) VALUES 
('Game Editions'),        -- Osnovna igra + neki DLC-jevi
('Licensed Chapters'),    -- Paketi sa filmskim likovima (Halloween, Resident Evil...)
('Original Chapters'),    -- Paketi sa Behavior originalnim likovima
('Cosmetic Bundles'),     -- Paketi sa skinovima/odećom za likove
('Bloodpoint Packs');     -- Paketi valuta i in-game resursa


-- Unos Bundlova (Dead by Daylight paketi po ekstra niskim cenama)
INSERT INTO Bundlovi (naziv_bundla, kategorija_id, cena_eur) VALUES 
('DbD Gold Edition', 1, 25),             -- Sniženo sa 50€
('Ultimate Edition Bundle', 1, 35),      -- Sniženo sa 70€
('Resident Evil Chapter Pack', 2, 8),    -- Sniženo sa 12€
('Silent Hill & Halloween Pack', 2, 10), -- Sniženo sa 15€
('All Killers Original Bundle', 3, 15),  
('All Survivors Original Bundle', 3, 15),
('Attack on Titan Outfit Set', 4, 12),   -- Limitirani skinovi
('Iron Maiden Collection', 4, 9),       
('1.000.000 Bloodpoints Booster', 5, 4), -- Jeftini dodatak
('2.500.000 BP + Iridescent Shards', 5, 7);


-- Unos Korisnika (Igrača i njihove primarne platforme)
INSERT INTO Korisnici (ime_prezime, starost, platforma) VALUES 
('Luka Jovanović', 22, 'PC'),
('Milica Savić', 25, 'PlayStation'),
('Stefan Nikolić', 19, 'PC'),
('Ana Petrović', 30, 'Xbox'),
('Marko Ilić', 28, 'PC'),
('Jovana Đorđević', 21, 'Switch'),
('Nikola Ristić', 35, 'PlayStation'),
('Marija Kostić', 24, 'PC'),
('Aleksandar Popović', 18, 'Xbox'),
('Sara Živković', 27, 'PC'),
('Filip Cvetković', 23, 'PlayStation'),
('Teodora Marković', 29, 'PC'),
('Uroš Stanković', 20, 'Xbox'),
('Katarina Lukić', 32, 'PC'),
('Ognjen Vasić', 26, 'PlayStation'),
('Nevena Jović', 22, 'Switch'),
('Vukašin Mitrović', 31, 'PC'),
('Milena Pavlović', 25, 'Xbox'),
('David Todorović', 19, 'PC'),
('Tijana Krstić', 28, 'PlayStation');


-- Unos prodatih bundlova
INSERT INTO Prodaja_bundlova (korisnik_id, bundle_id, datum_kupovine, kolicina) VALUES 
(1, 1, '2026-06-10', 1), 
(1, 3, '2026-06-10', 1), 
(2, 4, '2026-06-11', 1),  
(2, 7, '2026-06-11', 1),  
(3, 2, '2026-06-11', 1), 
(3, 9, '2026-06-11', 2), -- Kupio dva koda za Bloodpointse
(4, 5, '2026-06-12', 1), 
(4, 6, '2026-06-12', 1),  
(4, 10, '2026-06-12', 1),  
(5, 1, '2026-06-12', 1), 
(5, 8, '2026-06-12', 1),  
(6, 3, '2026-06-13', 1), 
(6, 4, '2026-06-13', 1),  
(7, 2, '2026-06-13', 1),
(7, 10, '2026-06-13', 1),
(8, 1, '2026-06-13', 1),
(8, 7, '2026-06-13', 1),
(9, 3, '2026-06-13', 1),
(10, 5, '2026-06-13', 1),
(10, 9, '2026-06-13', 3),
(11, 4, '2026-06-13', 1),
(12, 1, '2026-06-13', 1),
(13, 2, '2026-06-13', 1),
(13, 8, '2026-06-13', 1),
(14, 3, '2026-06-13', 1),
(15, 6, '2026-06-13', 1),
(16, 4, '2026-06-13', 1),
(16, 9, '2026-06-13', 1),
(17, 2, '2026-06-13', 1),
(18, 1, '2026-06-13', 1),
(19, 3, '2026-06-13', 1),
(20, 5, '2026-06-13', 1);