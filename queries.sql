USE LibraryDB;
-- ============================= Create Store procedure ===============================
/*Stored procedure: When a customer returns a book, it performs the following actions:
1. Restocking books (Books) : Increase Quantities for all borrowed books
2. Transactions : Insert late fee transactions for books returned after 7 days
3. Borrow : Update borrow records to mark books as returned (Status = 'Out')
*/ 
-- (Store procedure 1:)
-- It will update a borrow record when a customer returns a book.
-- This is for practical purpose.
DROP PROCEDURE IF EXISTS Retrun_Book;
DELIMITER //
CREATE PROCEDURE Retrun_Book(IN book_id INT,IN customer_id INT)
  BEGIN
	 DECLARE DaysBorrowed INT;
     DECLARE BorrowIdForReturn INT;
  
	 UPDATE Books AS b -- Restocking the book again.
     INNER JOIN Borrow AS br ON br.BookId = b.BookId
	 SET b.Quantities=b.Quantities+1
	 WHERE b.BookId = book_id AND br.Status = 'In';
     
     SELECT BorrowId,DATEDIFF(CURDATE(),BorrowDate) INTO BorrowIdForReturn,DaysBorrowed
     FROM Borrow
     WHERE BookId = book_id AND CustomerId = customer_id AND Status = 'In'
     ORDER BY BorrowDate
     LIMIT 1; -- If customer borrows same book multiple time , it will retrun one book.
          
     IF DaysBorrowed > 7 THEN
		  INSERT INTO Transactions(Amount,BorrowId) VALUES
          ((DaysBorrowed-7)*20,BorrowIdForReturn);
     END IF;
     
     UPDATE Borrow
     SET Status = "Out",
		 ReturnDate = CURDATE()
	 WHERE BorrowId=BorrowIdForReturn AND BorrowId IS NOT NULL;
END //
DELIMITER ;
-- (Store procedure 2):
-- It will update all records from Borrow table,which is just for **TESTING PURPOSE**.
DROP PROCEDURE IF EXISTS Retrun_Book_All;
DELIMITER //
CREATE PROCEDURE Retrun_Book_All()
  BEGIN
	 UPDATE Books -- Restocking the book again.
	 SET Quantities=Quantities+1
	 WHERE BookId IN (SELECT BookId FROM Borrow
						WHERE Status = 'In'); /* Subquey: It will update only all
												 Quantities Field of borrowed book.*/
	
     INSERT INTO Transactions(Amount,BorrowId) 
     SELECT (DATEDIFF(CURDATE(),BorrowDate)-7)*20,BorrowId FROM Borrow 
     WHERE DATEDIFF(CURDATE(),BorrowDate) >7 AND Status = 'In';/*Subquery: It will insert rows for all late fees transaction */

	UPDATE Borrow 
	SET Status = 'Out',
    ReturnDate = CURDATE()
	WHERE Status = 'In';
END //
DELIMITER ;

-- ** Calling Retrun_Book store procedure (SP - 1) for return a book by a customer.
-- =================================START==========================================
SELECT BorrowId,BookId,CustomerId,DATEDIFF(CURDATE(),BorrowDate) AS DaysBorrowed
FROM Borrow WHERE Status='In';

-- Retrun_Book(BookId,CustomerId)
CALL Retrun_Book(1,3); -- Without Late fees
CALL Retrun_Book(3,10); -- With Late fees 

SELECT * FROM Borrow WHERE Status='Out';
SELECT * FROM Transactions; -- For late fee a row has been inserted to Transactions table.

CALL Retrun_Book(2,6);
CALL Retrun_Book(2,8);  
CALL Retrun_Book(3,9);
CALL Retrun_Book(3,12);
CALL Retrun_Book(4,14);
CALL Retrun_Book(4,15);
CALL Retrun_Book(5,18);
CALL Retrun_Book(5,19);
CALL Retrun_Book(6,9);
CALL Retrun_Book(10,14);
CALL Retrun_Book(13,15);
-- ==================================End of Calling SP1===========================================

-- ============================= Delete Query ======================================
/*Deleting all data of "The Children of Noisy Village" book from Borrow table. For this 
first we have to delete data from Transaction table if any late fee was charged for this
book and then we can delete data from Borrow table. Because BorrowId is foreign key in 
Treansactions table.*/ 

SELECT "Table: Borrow" AS 'Table Name',COUNT(br.BorrowId) AS 'No of Records' -- count(b.BookId)
FROM Borrow AS br
INNER JOIN Books AS b ON b.BookId = br.BookId
WHERE b.BookName like '%The Children of Noisy%'
UNION ALL
SELECT "Table: Transactions"  AS 'Table Name',COUNT(t.BorrowId)
FROM Borrow AS br
INNER JOIN Books AS b ON b.BookId = br.BookId
INNER JOIN Transactions t ON t.BorrowId = br.BorrowId
WHERE b.BookName like '%The Children of Noisy%';

SET SQL_SAFE_UPDATES = 0;
DELETE t     -- 1st delete data from Transaction
FROM Transactions AS t
INNER JOIN Borrow AS br ON br.BorrowId = t.BorrowId
INNER JOIN Books AS b ON b.BookId = br.BookId
WHERE b.BookName like '%The Children of Noisy%';
SET SQL_SAFE_UPDATES = 1;

DELETE br -- Then delete data from Borrow
FROM Borrow AS br
INNER JOIN BOOKS AS b ON b.BookId = br.BookId
WHERE b.BookName like '%The Children of Noisy%';
-- ================================End of Delete Query==============================
-- =============================== View ===========================================
/*This view shows all infromation from Borrow table.*/
CREATE VIEW  vw_BorrowingInformation AS
SELECT b.BookName,
CONCAT(a.FirstName,' ',a.LastName) AS AuthorName,
g.GenreName Genre,
CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,
DATE_FORMAT(br.BorrowDate,"%d-%m-%Y") AS BorrowDate,
CASE
	WHEN br.ReturnDate IS NULL THEN 'Not returned yet.'
    ELSE DATE_FORMAT(br.ReturnDate,"%d-%m-%Y")
END AS ReturnDate,
br.Status AS BorrowingStatus,
CONCAT(l.FirstName,' ',l.LastName) AS LibrarianName
FROM Borrow AS br
INNER JOIN Books AS b ON b.BookId = br.BookId
INNER JOIN Genres AS g ON b.GenreId = b.GenreId
INNER JOIN Authors AS a ON a.AuthorId = b.AuthorId
INNER JOIN Customers AS c ON c.CustomerId = br.CustomerId
INNER JOIN Librarians AS L ON L.LibrarianId = br.LibrarianId
ORDER BY BookName;

-- Calling vw_BorrowingInformation to check which books are borrowed by customer.
SELECT * FROM vw_BorrowingInformation
WHERE BorrowingStatus = 'In';

/*Top borrowed books view helps librarians quickly identify popular titles.*/
CREATE VIEW  vw_TopBorrowedBook AS
SELECT B.BookName,
	   CONCAT(a.FirstName,' ',a.LastName) AS AuthorName,
	   COUNT(BorrowId) AS CountBorrow
FROM Books AS b
INNER JOIN Authors a ON a.AuthorId = b.AuthorId
INNER JOIN Borrow AS br ON b.BookId = br.BookId
WHERE MONTH(br.Borrowdate) =  MONTH(CURDATE())
GROUP BY b.BookId
ORDER BY CountBorrow DESC
LIMIT 3;

-- Congratulate top ranked book's authors from view vw_TopBorrowedBook
SELECT CONCAT('Congratulations ',AuthorName,'! Your book ',"'",BookName, 
				"'",' is ONE OF the most borrowed book in Skåne Library.') AS MESSAGE 
FROM vw_TopBorrowedBook;
-- ==================================End of View===========================================
-- =============================== Function ===========================================
-- Creating a function to get date of birth from person number.
DELIMITER //
CREATE FUNCTION GetBirthdayFromPersonNumber(PersonNumber VARCHAR(12))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	RETURN DATE_FORMAT(LEFT(PersonNumber,8),"%d-%m-%Y");
END//
DELIMITER ;

-- Creating a function to calculate age from person number.
DELIMITER //
CREATE FUNCTION CalculateAge(PersonNumber VARCHAR(12))
RETURNS INT
DETERMINISTIC
BEGIN
 RETURN TIMESTAMPDIFF(
        YEAR,
        STR_TO_DATE(GetBirthdayFromPersonNumber(PersonNumber), '%d-%m-%Y'),
        CURDATE()
    );
END//
DELIMITER ;

-- Creating a function to get address by city id.
DELIMITER //
CREATE FUNCTION GetAddress(city_id INT)
RETURNS VARCHAR(150)
DETERMINISTIC
BEGIN
	DECLARE Address VARCHAR(150);
	SELECT CONCAT(c.CityName,',',r.RegionName,',',cr.CountryName) INTO Address
	FROM Cities AS c
	INNER JOIN Regions r ON r.RegionId = c.RegionId
	INNER JOIN Countries cr ON cr.CountryId = r.CountryId
    WHERE c.CityId = city_id;
	RETURN Address;
END//
DELIMITER ;

-- Creating a function to get country name by country id.
DELIMITER //
CREATE FUNCTION GetCountryName(country_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
	DECLARE CountryName VARCHAR(50);
	SELECT cr.CountryName INTO CountryName
	FROM Countries AS cr
    WHERE c.CountryId = country_id;
	RETURN Address;
END//
DELIMITER ;

-- Query for get all librarians informations with functions
SELECT  CONCAT(l.FirstName,' ',l.LastName) AS LibrarianName,
PersonNumber,
GetBirthdayFromPersonNumber(ld.PersonNumber) AS DOB, -- Calling function to get all librarians DOB
ld.Email,
GetAddress(ld.CityId)AS Address  -- Calling function to get all librarians addresses
FROM Librarians AS l
INNER JOIN LibrarianDetails ld ON ld.LibrarianId = l.LibrarianId;
-- ================================End of Function=================================

-- =============================== Select Queries ===========================================
SELECT * FROM Countries ORDER BY CountryId;
SELECT * FROM Regions ORDER BY RegionId;
SELECT * FROM Cities ORDER BY CityId;
SELECT * FROM Authors;
SELECT * FROM AuthorDetails;
SELECT * FROM Genres;
SELECT * FROM Books;
SELECT * FROM Librarians;
SELECT * FROM LibrarianDetails;
SELECT * FROM Customers;
SELECT * FROM CustomerDetails;
SELECT * FROM Borrow;
SELECT * FROM Transactions;
-- ---------------------------------------------------------------------------------
/* Retrieve books that have not been borrowed yet, displaying the 
book name and borrow count.*/
SELECT B.BookName,COUNT(BorrowId) AS BorrowCount
FROM Books AS b
LEFT JOIN Borrow AS br ON b.BookId = br.BookId
GROUP BY b.BookId
HAVING BorrowCount = 0;

-- Show books with author names and genres, 5 at a time, starting after the first 5.
SELECT B.BookName,
	   CONCAT(a.FirstName,' ',a.LastName) AS AuthorName,
       g.GenreName
FROM Books AS b
INNER JOIN Authors A ON a.AuthorId = b.AuthorId
INNER JOIN Genres g ON g.GenreId = b.GenreId
ORDER BY BookName
LIMIT 5 OFFSET 5;

-- Sum of late fees amount for each customer for current month .
SELECT CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,
	   SUM(Amount) LateFees
FROM TRANSACTIONS AS t
INNER JOIN Borrow AS br ON br.BorrowId = t.BorrowId
INNER JOIN Customers AS c ON c.CustomerId =  br.CustomerId
WHERE MONTH(br.Borrowdate) =  MONTH(CURDATE())
GROUP BY br.CustomerId
UNION ALL
SELECT 'Total Amount :',SUM(Amount) LateFees
FROM TRANSACTIONS AS t
INNER JOIN Borrow AS br ON br.BorrowId = t.BorrowId
WHERE MONTH(br.Borrowdate) =  MONTH(CURDATE());

-- Find authors from Nordic Countries

SELECT  CONCAT(a.FirstName,' ',a.LastName) AS AuthorName, 
		ad.Email,DATE_FORMAT(ad.DOB,'%d-%m-%Y') AS DOB
FROM Authors A
INNER JOIN AuthorDetails ad ON ad.AuthorId = a.AuthorId
WHERE ad.CountryId IN (SELECT CountryId FROM Countries 
						WHERE CountryName IN('Sweden','Denmark',
												'Finland','Iceland','Norway'))
ORDER BY AuthorName;
                                                
-- Send birthday wishes to all customers who have born this month.
SELECT cd.Email,cd.MobileNumber,
CONCAT('Dear ',c.FirstName,' ',c.LastName,',',
		'wishing you a very happy ', CalculateAge(cd.PersonNumber),'th birthday.',
        'Greetings from Skåne Library') AS 'Message'
FROM Customers c
INNER JOIN CustomerDetails cd ON c.CustomerId = cd.CustomerId
WHERE SUBSTR(cd.PersonNumber,5,2)  =  MONTH(CURDATE());

-- Find which kind of books Amelia Håkansson likes to read.

SELECT CONCAT(c.FirstName,' ',c.LastName) Customer,cd.PersonNumber,GenreName
FROM Genres g
INNER JOIN Books AS b ON b.GenreId = g.GenreId
INNER JOIN Borrow AS br ON br.BookId = b.BookId 
INNER JOIN Customers AS c ON c.CustomerId = br.CustomerId
INNER JOIN CustomerDetails AS cd ON cd.CustomerId = c.CustomerId
WHERE c.FirstName LIKE '%Amelia%' AND c.LastName LIKE '%Håkansson%';

-- Find the top 3 customers who have borrowed the most books in the current year, 
-- and show

WITH CountBorrowedBooksByCustomer AS(
		SELECT br.CustomerId,COUNT(br.BorrowId) AS TotalBookBorrowed
			 --  COUNT(br.BorrowId) AS TotalBookBorrowed
        FROM Borrow AS br
        WHERE YEAR(br.BorrowDate) = YEAR(CURDATE())
        GROUP BY br.CustomerId
)
SELECT CONCAT(c.FirstName,' ',c.LastName) Customer,cb.TotalBookBorrowed
FROM Customers AS c
INNER JOIN CountBorrowedBooksByCustomer cb ON cb.CustomerId = c.CustomerId
ORDER BY TotalBookBorrowed DESC
LIMIT 3;
-- ==================================End of Select Query===========================================



-- ** Calling Retrun_Book_All store procedure for return all book which are borrowed.
-- This is wrong for in real. It's just for testing.
-- =================================START==========================================
-- [counting rows that should be inteserted to the Transactions table.]
SELECT COUNT(BorrowId) 
FROM Borrow 
WHERE DATEDIFF(CURDATE(),BorrowDate) >7 AND Status = 'Out';

SET SQL_SAFE_UPDATES = 0;
CALL Retrun_Book_All(); 
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM Transactions;
-- ==================================END===========================================
