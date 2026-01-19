DROP DATABASE IF EXISTS LibraryDB;
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Table for Countries (List of countries).
-- ==================================================================
CREATE TABLE Countries(
	CountryId INT PRIMARY KEY AUTO_INCREMENT,
    CountryName VARCHAR(40) UNIQUE NOT NULL
);
-- Table for Regions. (A list of regions within a country.)
-- ==================================================================
CREATE TABLE Regions(
	RegionId INT PRIMARY KEY AUTO_INCREMENT,
    RegionName VARCHAR(30) NOT NULL,
    CountryId INT NOT NULL,
    FOREIGN KEY(CountryId) REFERENCES Countries(CountryId) 
);
-- Table for Cities.(A list of cities within a region.)
-- ==================================================================
CREATE TABLE Cities(
	CityId INT PRIMARY KEY AUTO_INCREMENT,
    CityName VARCHAR(30) NOT NULL,
    RegionId INT NOT NULL,
    FOREIGN KEY(RegionId) REFERENCES Regions(RegionId)
);

-- Table for Authors.(List of Authors.)
-- ==================================================================
CREATE TABLE Authors(
	AuthorId INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);
-- Table for AuthorDetails.(Author's details information within AuthorId.)
-- ==================================================================
CREATE TABLE AuthorDetails(
	AuthorId INT NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    DOB DATE NOT NULL,
    CountryId INT NOT NULL,
    PRIMARY KEY (AuthorId,Email),
    FOREIGN KEY (AuthorId) REFERENCES Authors(AuthorId) ON DELETE CASCADE,
    FOREIGN KEY(CountryId) REFERENCES Countries(CountryId)
);

-- Table for Genres.(List of genres for books.)
-- ==================================================================
CREATE TABLE Genres(
	GenreId INT PRIMARY KEY AUTO_INCREMENT,
    GenreName VARCHAR(50) NOT NULL
);
DESC Genres;
ALTER TABLE Genres 
ADD CONSTRAINT UQ_Genres_GenreName UNIQUE (GenreName);
DESC Genres;

-- Table for Books.
-- ==================================================================
CREATE TABLE Books(
	BookId INT PRIMARY KEY AUTO_INCREMENT,
    BookName VARCHAR(200) NOT NULL,
    GenreId INT NOT NULL,
    Quantities INT,
    AuthorId INT NOT NULL,
    FOREIGN KEY (AuthorId) REFERENCES Authors(AuthorId) ON DELETE CASCADE,
    FOREIGN KEY (GenreId) REFERENCES Genres(GenreId)
);
 /*Book will be always search by it's name. So using BookName
 as an index,it will help to query run faster.*/
CREATE INDEX idx_bookName ON Books(BookName);

-- Table for Librarians.
-- ==================================================================
CREATE TABLE Librarians(
	LibrarianId INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL
);
DESC Librarians;
ALTER TABLE Librarians
RENAME COLUMN Name TO FirstName;

ALTER TABLE Librarians
ADD LastName VARCHAR(50) NOT NULL;

-- Table for LibrarianDetails.
-- ==================================================================
CREATE TABLE LibrarianDetails(
	LibrarianId INT NOT NULL, 
    PersonNumber VARCHAR(12) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
	MobileNumber VARCHAR(15) UNIQUE NOT NULL,
    CityId INT NULL,
    PRIMARY KEY (LibrarianId,PersonNumber),
    FOREIGN KEY(LibrarianId) REFERENCES Librarians(LibrarianId),
    FOREIGN KEY (CityId) REFERENCES Cities(CityId)
);

-- Table for Customers.
-- ==================================================================
CREATE TABLE Customers(
	CustomerId INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);
-- Table for CustomerDetails.
-- ==================================================================
CREATE TABLE CustomerDetails(
	CustomerId INT NOT NULL,
    PersonNumber VARCHAR(12) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
	MobileNumber VARCHAR(15) UNIQUE NOT NULL,
    CityId INT NULL,
    PRIMARY KEY (CustomerId,PersonNumber),
    FOREIGN KEY(CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (CityId) REFERENCES Cities(CityId)
);

-- Table for Borrow.
-- ==================================================================
CREATE TABLE Borrow(
	BorrowId INT PRIMARY KEY AUTO_INCREMENT,
    BorrowDate DATE NOT NULL,
    Status VARCHAR(3) NOT NULL,
    ReturnDate DATE ,
    BookId INT NOT NULL,
    LibrarianId INT NULL, 
    CustomerId INT NOT NULL,  
    FOREIGN KEY (BookId) REFERENCES Books(BookId),
	FOREIGN KEY (LibrarianId) REFERENCES Librarians(LibrarianId),
	FOREIGN KEY(CustomerId) REFERENCES Customers(CustomerId)
);
-- Table for Transaction.
-- ==================================================================
CREATE TABLE Transactions(
	TransactionId INT PRIMARY KEY AUTO_INCREMENT,
    Amount DECIMAL(10,2) NOT NULL,
    BorrowId INT NOT NULL,
    FOREIGN KEY(BorrowId) REFERENCES Borrow(BorrowId)
);

--                               Trigger
-- ==================================================================
/*If a customer borrow a book then book stock should be decreased from 
  Books table (Quantity field)*/
  
DELIMITER $$
CREATE TRIGGER MaintainBookQuantity
BEFORE INSERT ON Borrow
FOR EACH ROW 
BEGIN 
	DECLARE Available INT;
    SELECT Quantities INTO Available FROM Books WHERE BookId = NEW.BookId ;
    IF Available<=0 THEN -- Condition for checking book is available in stock or not.
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book is not available. No copies left.';
	END IF;
    UPDATE Books -- Update Quantities in Books table if book is available
		SET Quantities=Quantities-1
		WHERE BookId = NEW.BookId;
END$$
DELIMITER ;

