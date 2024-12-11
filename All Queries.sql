-- FOR DEMO - Deletes all content from tables.
-- TRUNCATE users, books, bookloans;

-------------------------------------------------------------------------------------------------------------

-- BOOKS
INSERT INTO books (isbn, title, author, genre, published_year, quantity_available)
VALUES
	('9780439708194', 'Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 'Fantasy', 1997, 10),
	('9780345538978', 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 5),
	('9780451524935', '1984', 'George Orwell', 'Dystopian Fiction', 1949, 8),
	('9780061120084', 'The Lord of the Rings', 'J.R.R. Tolkien', 'Fantasy', 1954, 12),
	('9780393045172', 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 7);
-- This creates all the data for books.

-------------------------------------------------------------------------------------------------------------

-- OLD USERS
INSERT INTO users (id, full_name, email_address, membership_date)
VALUES
    ('066b1b8f-3055-497e-85bf-d4990efb29ab', 'John Doe', 'johndoe@example.com', '2023-11-22'),
    ('1af309f4-df78-4f28-9075-a8970fa5a6ce', 'Jane Smith', 'janesmith@example.com', '2024-01-15'),
    ('cef408a3-714d-4ff5-ac33-5d4213c7d54d', 'Michael Johnson', 'michaeljohnson@example.com', '2023-08-09');
-- This creates old users, where we didn't use the defaults.
-- NOTES: I placed in the UUIDs so that there is a constant uuid for demos which will make
-- the codes below run as well with close to none complications.

-------------------------------------------------------------------------------------------------------------

-- NEW USERS
INSERT INTO users (full_name, email_address)
VALUES 
	('Emily Brown', 'emilybrown@example.com'),
	('David Lee', 'davidlee@example.com');
-- This creates the users that are new and has only been a member today.

-------------------------------------------------------------------------------------------------------------

-- NEW BOOK LOAN
START TRANSACTION;

INSERT INTO BookLoans (user_id, book_isbn)
             -- Use an existing user_id
SELECT '066b1b8f-3055-497e-85bf-d4990efb29ab', b.isbn 
FROM Books b
WHERE b.title = 'To Kill a Mockingbird'
  AND b.quantity_available > 0
LIMIT 1;

UPDATE Books
SET quantity_available = quantity_available - 1
WHERE isbn = (SELECT b.isbn
              FROM Books b
              WHERE b.title = 'To Kill a Mockingbird'
                AND b.quantity_available > 0
              LIMIT 1);
			  
COMMIT;
-- This creates book loan by a user based on user_id of a book based on the title.

-------------------------------------------------------------------------------------------------------------

-- RETURN BOOK LOAN
START TRANSACTION;

UPDATE BookLoans
SET status = 'returned'
WHERE user_id = '066b1b8f-3055-497e-85bf-d4990efb29ab' -- Use an existing user_id
	AND book_isbn = '9780345538978'
	AND status = 'borrowed';

UPDATE Books
SET quantity_available = quantity_available + 1
WHERE isbn = '9780345538978';
			  
COMMIT;
-- This returns the book loaned above. This sets the status of the book loan to 'returned' and added
-- back 1 book on its quantity-available.

-------------------------------------------------------------------------------------------------------------

-- OVERDUE BOOK LOAN
START TRANSACTION;

INSERT INTO BookLoans (user_id, book_isbn, loan_date, return_date, status)
			 -- Use an existing user_id
SELECT '1af309f4-df78-4f28-9075-a8970fa5a6ce', b.isbn, '2024-12-2', '2024-12-10', 'overdue'
FROM Books b
WHERE b.title = 'To Kill a Mockingbird'
  AND b.quantity_available > 0
LIMIT 1;

UPDATE Books
SET quantity_available = quantity_available - 1
WHERE isbn = (SELECT b.isbn
              FROM Books b
              WHERE b.title = 'To Kill a Mockingbird'
                AND b.quantity_available > 0
              LIMIT 1);

COMMIT;
-- This creates a book loan record that is overdued for testing purposes.

-------------------------------------------------------------------------------------------------------------

-- OVERDUE BOOK LOAN
START TRANSACTION;

INSERT INTO BookLoans (user_id, book_isbn, loan_date, return_date, status)
			 -- Use an existing user_id
SELECT '1af309f4-df78-4f28-9075-a8970fa5a6ce', b.isbn, '2024-12-2', '2024-12-10', 'overdue'
FROM Books b
WHERE b.title = 'To Kill a Mockingbird'
  AND b.quantity_available > 0
LIMIT 1;

UPDATE Books
SET quantity_available = quantity_available - 1
WHERE isbn = (SELECT b.isbn
              FROM Books b
              WHERE b.title = 'To Kill a Mockingbird'
                AND b.quantity_available > 0
              LIMIT 1);

COMMIT;
-- This creates another book loan record that is overdued for testing purposes.

-------------------------------------------------------------------------------------------------------------

-- TO RETRIEVE OVERDUE LOANS 
START TRANSACTION;

UPDATE Books b
SET quantity_available = quantity_available + (
    SELECT COUNT(*)
    FROM BookLoans bl
    WHERE bl.book_isbn = b.isbn
      AND bl.status = 'overdue'
)
WHERE b.isbn IN (
    SELECT bl.book_isbn
    FROM BookLoans bl
    WHERE bl.status = 'overdue'
);

UPDATE BookLoans
SET status = 'returned'
WHERE status = 'overdue';

COMMIT;
-- Here I started by updating the quantity_available by adding the count of books loaned that
-- are overdue by selecting all of them and using the count function to get how many there
-- are and adding it to the current quantity_available.

-------------------------------------------------------------------------------------------------------------

-- VIEW ALL RECORDS FOR EVERY TABLE
SELECT * FROM users;
SELECT * FROM books;
SELECT * FROM bookloans;

-------------------------------------------------------------------------------------------------------------

-- VIEW ALL THE RECORDS THAT A PERSON BORROWED NO MATTER THE STATUS,
-- FOR STATUS SPECIFICACY JUST ADD "AND bl.status = 'borrowed', 'returned', or 'overdue'"
AFTER the bl.user_id
SELECT b.*
FROM BookLoans bl
JOIN Books b ON bl.book_isbn = b.isbn
WHERE bl.user_id = '066b1b8f-3055-497e-85bf-d4990efb29ab';

-------------------------------------------------------------------------------------------------------------

-- VIEW ALL THE RECORDS WHERE THE STATUS IS 'overdue'
SELECT * 
FROM BookLoans bl
WHERE bl.status = 'overdue';


