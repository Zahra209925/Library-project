-- Luodaan tietokanta
CREATE DATABASE Library;

-- Valitaan tietokanta
USE kirjasto;

-- Taulu: kirjat (Books)
CREATE TABLE Books (
   id INT IDENTITY(1,1) PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   author VARCHAR(255) NOT NULL,
   year INT NOT NULL CHECK (year > 0),
   genre VARCHAR (100) NOT NULL
);

--Taulu: Jäsenet (Members)
CREATE TABLE Members (
	id INT IDENTITY PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE, -- Lisätty UNIQUE, jotta sähköpostit eivät voi toistua
	join_date DATE NOT NULL
);

-- Taulu: Lainat (Loans)
CREATE TABLE Loans (
   id INT IDENTITY PRIMARY KEY,
   book_id INT NOT NULL,
   member_id INT NOT NULL,
   loan_date DATE NOT NULL,
   return_date DATE DEFAULT NULL,
   FOREIGN KEY (book_id) REFERENCES Books(id) ON DELETE CASCADE,
   FOREIGN KEY (member_id) REFERENCES Members(id) ON DELETE CASCADE
);

-- Taulu: Kirjaston henkilökunta (Library Staff)
CREATE TABLE LibraryStaff (
   id INT IDENTITY PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   role VARCHAR(100) NOT NULL,
   email VARCHAR(255) NOT NULL UNIQUE, -- Lisätty UNIQUE, jotta sähköpostit eivät voi toistua
   hire_date DATE NOT NULL
);
	-- Taulu: Varaukset (Reservations)
CREATE TABLE Reservations (
   id INT IDENTITY PRIMARY KEY,
   book_id INT NOT NULL,
   member_id INT NOT NULL,
   reservation_date DATE NOT NULL,
   UNIQUE (book_id, member_id), --Esetään saman kirjan ja jäsenen yhdistelmän toistuminen
   FOREIGN KEY (book_id) REFERENCES Books(id) ON DELETE CASCADE,
   FOREIGN KEY (member_id) REFERENCES Members(id) ON DELETE CASCADE
);
-- Esimerkkitietojen lisääminen (Adding sample data)

-- Lisätään kirjoja (Books)
INSERT INTO Books (title, author, year, genre)
VALUES
    ('Harry Potter ja viisasten kivi', 'J.K. Rowling', 1997, 'Fantasia'),
    ('Taru sormusten herrasta', 'J.R.R. Tolkien', 1954, 'Fantasia'),
    ('1984', 'George Orwell', 1949, 'Dystopia'),
    ('Anna Karenina', 'Leo Tolstoi', 1878, 'Klassikko'),
    ('Jää', 'Ulla-Lena Lundberg', 2012, 'Draama');

-- Lisätään jäseniä (Members)
INSERT INTO Members (name, email, join_date)
VALUES
    ('Pekka Peloton', 'pekka@example.com', '2024-01-10'),
    ('Maija Mallikas', 'maija@example.com', '2024-02-05'),
    ('Ville Virtanen', 'ville@example.com', '2024-03-01');

-- Lisätään henkilökunnan tietoja (Library Staff) 
	 INSERT INTO LibraryStaff (name, role, email, hire_date) 
	 VALUES 
	    ('Anna Kallio', 'Manager', 'anna@example.com', '2020-03-01'),
	    ('Kalle Nieminen', 'Librarian', 'kalle@example.com', '2022-06-15'); 

-- Rekisteröidään lainaus (Loans) 
	  INSERT INTO Loans (book_id, member_id, loan_date) 
	  VALUES 
	   (1, 3, '2024-02-15'),
      (2, 1, '2024-03-01'),
      (4, 2, '2024-03-10');

-- Lisätään varaus (Reservations) 
	 INSERT INTO Reservations (book_id, member_id, reservation_date) 
	 VALUES 
	   (1, 2, '2024-02-20'),
      (3, 3, '2024-02-25');

-- Päätetään lainaus (Return loan)
    UPDATE Loans
      SET return_date = '2024-02-15'
      WHERE id = 1;

-- Näytetään kaikki kirjat (List all books)
      SELECT * FROM Books;

-- Näytetään kaikki jäsenet (List all members)
       SELECT * FROM Members;

-- Näytetään kaikki henkilökunta (List all staff)
	    SELECT * FROM LibraryStaff; 


-- Näytetään lainat ja niiden tiedot (List all loans with details)
    SELECT
       Loans.id AS LoanID,
       Books.title AS BookTitle,
       Members.name AS MemberName,
       Loans.loan_date AS Loan_Date,
       Loans.return_date AS Return_date
    FROM Loans
    JOIN Books ON Loans.book_id = Books.id
    JOIN Members ON Loans.member_id = Members.id;

 -- Näytetään suosituimmat kirjat (List most popular books)
    SELECT Books.title, 
       COUNT(Loans.id) AS LoanCount 
    FROM Books 
    JOIN Loans ON Books.id = Loans.book_id 
    GROUP BY Books.id, Books.title -- Lisätty Books.title GROUP BY -lauseesee
    ORDER BY LoanCount DESC;

-- Näytetään kaikki varaukset (List all reservations)
    SELECT
      Reservations.id AS ReservationID,
      Books.title AS BookTitle,
      Members.name AS MemberName, 
      Reservations.reservation_date AS ReservationDate 
    FROM Reservations 
    JOIN Books ON Reservations.book_id = Books.id 
    JOIN Members ON Reservations.member_id = Members.id;

