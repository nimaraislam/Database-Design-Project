USE LibraryDB;

-- Data for Countries.
-- ==================================================================
INSERT INTO Countries (CountryName) VALUES
("Sweden"),
("England"),
("Denmark"),
("USA");

-- Data for Regions.
-- ==================================================================
INSERT INTO Regions(RegionName,CountryId) VALUES
("Skåne",1),
("Halland",1),
("Kalmar",1);

-- Data for Cities.
-- ==================================================================
INSERT INTO Cities (CityName,RegionId) VALUES
('Malmö', 1),
('Helsingborg', 1),
('Lund', 1),
('Kristianstad', 1),
('Ystad', 1),
('Trelleborg', 1),
('Ängelholm', 1),
('Eslöv', 1),
('Höganäs', 1),
('Landskrona', 1),
('Halmstad', 2),
('Varberg', 2),
('Kalmar', 3),
('Västervik', 3);

-- Data for Authors.
-- ==================================================================
INSERT INTO Authors (FirstName, LastName) VALUES
('Astrid', 'Lindgren'),   -- Sweden
('Selma', 'Lagerlöf'),    -- Sweden
('J.K.', 'Rowling'),      -- England
('Hans', 'Christian Andersen'), -- Denmark
('Stephen', 'King'),      -- USA
('Fredrik', 'Backman');   -- Sweden

-- Data for AuthorDetails.
-- ==================================================================
INSERT INTO AuthorDetails (AuthorId, Email,DOB,CountryId) VALUES
(1, 'astrid.l@example.com', '1907-11-14', 1),
(2, 'selma.l@example.com', '1858-11-20', 1),
(3, 'jk.rowling@example.co.uk', '1965-07-31', 2),
(4, 'hca@example.dk', '1805-04-02', 3),
(5, 'stephen.k@example.com', '1947-09-21', 4),
(6, 'fredrik.b@example.com', '1981-03-02', 1);

-- Data for Authors.
-- ==================================================================
INSERT INTO Genres (GenreName) VALUES
('Children'),
('Fantasy'),
('Thriller'),
('Fiction'),
('Horror'),
('Romantic'),
('Advanture');

-- Data for Authors.
-- ==================================================================
INSERT INTO Books (BookName, GenreId, Quantities, AuthorId) VALUES
-- Astrid Lindgren (Sweden)
('Pippi Longstocking', 1, 10, 1),
('The Children of Noisy Village', 1, 5, 1),
('Karlsson on the Roof', 1, 7, 1),
-- Selma Lagerlöf (Sweden)
('The Wonderful Adventures of Nils', 2, 8, 2),
('Gösta Berlings Saga', 4, 6, 2),
-- J.K. Rowling (England)
('Harry Potter and the Philosopher''s Stone', 2, 15, 3),
('Harry Potter and the Chamber of Secrets', 2, 14, 3),
-- Hans Christian Andersen (Denmark)
('The Little Mermaid', 1, 12, 4),
('The Emperor''s New Clothes', 1, 9, 4),
-- Stephen King (USA)
('The Shining', 5, 10, 5),
('It', 5, 8, 5),
('Misery', 5, 7, 5),
-- Fredrik Backman (Sweden)
('A Man Called Ove', 4, 11, 6);

-- Data for Librarians.
-- ==================================================================
INSERT INTO Librarians (FirstName,LastName) VALUES
('Anna','Svensson'),
('Björn','Karlsson'),
('Caroline','Lind');

-- Data for LibrarianDetails.
-- ==================================================================
INSERT INTO LibrarianDetails (LibrarianId, PersonNumber, Email, MobileNumber, CityId) VALUES
(1, '197801012345', 'anna.s@example.com', '0701234567', 1),
(2, '198502034567', 'bjorn.k@example.com', '0702345678', 5),
(3, '199012056789', 'caroline.l@example.com', '0703456789', 10);

-- Data for Customers.
-- ==================================================================
INSERT INTO Customers (FirstName, LastName) VALUES
('Emma','Svensson'),
('Liam','Karlsson'),
('Olivia','Andersson'),
('Noah','Johansson'),
('Ava','Nilsson'),
('William','Larsson'),
('Sophia','Eriksson'),
('James','Olsson'),
('Isabella','Persson'),
('Benjamin','Gustafsson'),
('Mia','Pettersson'),
('Lucas','Jonsson'),
('Charlotte','Berg'),
('Henry','Lindberg'),
('Amelia','Håkansson'),
('Alexander','Hansson'),
('Evelyn','Bergström'),
('Daniel','Axelsson'),
('Harper','Nyström'),
('Sebastian','Lund'),
('Ella','Holm'),
('Oskar','Mattsson'),
('Scarlett','Sjöberg'),
('Ethan','Lind'),
('Aria','Engström');

-- Data for CustomerDetails.
-- ==================================================================
INSERT INTO CustomerDetails (CustomerId, PersonNumber, Email, MobileNumber, CityId) VALUES
(1, '198001012345', 'emma.svensson@gmail.com', '0701000001', 1),
(2, '198102034567', 'liam.karlsson@gmail.com', '0701000002', 2),
(3, '199003056789', 'olivia.andersson@example.com', '0701000003', 3),
(4, '199104078901', 'noah.johansson@example.com', '0701000004', 4),
(5, '198205091234', 'ava.nilsson@example.com', '0701000005', 5),
(6, '199306011234', 'william.larsson@yahoo.com', '0701000006', 6),
(7, '198407022345', 'sophia.eriksson@example.com', '0701000007', 7),
(8, '199508033456', 'james.olsson@abc.com', '0701000008', 8),
(9, '198609044567', 'isabella.persson@example.com', '0701000009', 9),
(10, '199710055678', 'benjamin.gustafsson@abc.com', '0701000010', 10),
(11, '198811066789', 'mia.pettersson@example.com', '0701000011', 1),
(12, '199912077890', 'lucas.jonsson@example.com', '0701000012', 2),
(13, '198902088901', 'charlotte.berg@example.com', '0701000013', 3),
(14, '199003099012', 'henry.lindberg@gmail.com', '0701000014', 4),
(15, '198104010123', 'amelia.hakansson@example.com', '0701000015', 5),
(16, '199205021234', 'alexander.hansson@gmail.com', '0701000016', 6),
(17, '198306032345', 'evelyn.bergstrom@gmail.com', '0701000017', 7),
(18, '199407043456', 'daniel.axelsson@example.com', '0701000018', 8),
(19, '198508054567', 'harper.nystrom@example.com', '0701000019', 9),
(20, '199609065678', 'sebastian.lund@yahoo.com', '0701000020', 10),
(21, '198710076789', 'ella.holm@example.com', '0701000021', 1),
(22, '199811087890', 'oskar.mattsson@example.com', '0701000022', 2),
(23, '198912098901', 'scarlett.sjoberg@outlook.com', '0701000023', 3),
(24, '199012109012', 'ethan.lind@example.com', '0701000024', 4),
(25, '198109110123', 'aria.engstrom@outlook.com', '0701000025', 5);

-- Data for Borrow.
-- ==================================================================
INSERT INTO Borrow
(BorrowDate, Status, ReturnDate, BookId, LibrarianId, CustomerId)
VALUES
-- Book 1 (10 copies) → total 5
(CURDATE(), 'In', NULL, 1, 1, 1),
(DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'In', NULL, 1, 2, 6),
(DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'In', NULL, 1, 2, 2),
(DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'In', NULL, 1, 3, 3),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 1, 1, 4),
(DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'In', NULL, 1, 2, 5),
(DATE_SUB(CURDATE(), INTERVAL 9 DAY), 'In', NULL, 1, 3, 20),
(DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'In', NULL, 1, 2, 21),
(DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'In', NULL, 1, 2, 1),
-- Book 2 (5 copies) → total 3
(CURDATE(), 'In', NULL, 2, 1, 6),
(DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'In', NULL, 2, 2, 7),
(DATE_SUB(CURDATE(), INTERVAL 12 DAY), 'In', NULL, 2, 3, 8),
-- Book 3 (7 copies) → total 4
(DATE_SUB(CURDATE(), INTERVAL 7 DAY), 'In', NULL, 3, 3, 9),
(DATE_SUB(CURDATE(), INTERVAL 9 DAY), 'In', NULL, 3, 1, 10),
(DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'In', NULL, 3, 2, 11),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 3, 3, 12),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 3, 3, 16),
-- Book 4 (8 copies) → total 4
(DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'In', NULL, 4, 1, 13),
(DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'In', NULL, 4, 2, 14),
(DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'In', NULL, 4, 3, 15),
(DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'In', NULL, 4, 1, 16),
-- Book 5 (6 copies) → total 3
(CURDATE(), 'In', NULL, 5, 2, 17),
(DATE_SUB(CURDATE(), INTERVAL 15 DAY), 'In', NULL, 5, 3, 18),
(DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'In', NULL, 5, 1, 19),
-- Book 6 (15 copies) → total 6
(CURDATE(), 'In', NULL, 6, 1, 20),
(DATE_SUB(CURDATE(), INTERVAL 7 DAY), 'In', NULL, 6, 2, 21),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 6, 3, 22),
(DATE_SUB(CURDATE(), INTERVAL 9 DAY), 'In', NULL, 6, 1, 23),
(CURDATE(), 'In', NULL, 6, 2, 24),
(DATE_SUB(CURDATE(), INTERVAL 11 DAY), 'In', NULL, 6, 3, 25),
(DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'In', NULL, 6, 3, 8),
-- Book 7 (14 copies) → total 4
(CURDATE(), 'In', NULL, 7, 1, 1),
(DATE_SUB(CURDATE(), INTERVAL 11 DAY), 'In', NULL, 7, 2, 2),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 7, 3, 3),
(DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'In', NULL, 7, 1, 4),
-- Book 8 (12 copies) → total 4
(CURDATE(), 'In', NULL, 8, 3, 5),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 8, 1, 6),
(DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'In', NULL, 8, 2, 7),
(DATE_SUB(CURDATE(), INTERVAL 13 DAY), 'In', NULL, 8, 3, 8),
-- Book 9 (9 copies) → total 4
(CURDATE(), 'In', NULL, 9, 2, 9),
(DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'In', NULL, 9, 3, 10),
(DATE_SUB(CURDATE(), INTERVAL 8 DAY), 'In', NULL, 9, 1, 11),
(DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'In', NULL, 9, 2, 12),
(DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'In', NULL, 9, 2, 16),
-- Book 10 (10 copies) → total 4
(DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'In', NULL, 10, 1, 13),
(DATE_SUB(CURDATE(), INTERVAL 13 DAY), 'In', NULL, 10, 2, 14),
(DATE_SUB(CURDATE(), INTERVAL 7 DAY), 'In', NULL, 10, 3, 15),
(DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'In', NULL, 10, 1, 16),
-- Book 11 (8 copies) → total 4
(CURDATE(), 'In', NULL, 11, 3, 17),
(DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'In', NULL, 11, 1, 18),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 11, 2, 19),
(DATE_SUB(CURDATE(), INTERVAL 11 DAY), 'In', NULL, 11, 3, 20),
(DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'In', NULL, 11, 3, 16),
-- Book 13 (11 copies) → total 4
(DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'In', NULL, 13, 2, 25),
(DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'In', NULL, 13, 3, 1),
(DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'In', NULL, 13, 1, 2),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 13, 1, 3),
(DATE_SUB(CURDATE(), INTERVAL 16 DAY), 'In', NULL, 13, 2, 15),
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'In', NULL, 13, 1, 16);



