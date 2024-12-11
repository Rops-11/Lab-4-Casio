CREATE TABLE IF NOT EXISTS Users (
	id UUID DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
	full_name VARCHAR(255) NOT NULL,
	email_address VARCHAR(255) NOT NULL,
	membership_date DATE DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS Books (
	isbn VARCHAR(17) NOT NULL PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	author VARCHAR(255) NOT NULL,
	genre VARCHAR(255) NOT NULL,
	published_year INT NOT NULL,
	quantity_available INT NOT NULL
);

CREATE TABLE IF NOT EXISTS BookLoans (
	user_id UUID NOT NULL,
	book_isbn VARCHAR(17) NOT NULL,
	loan_date DATE DEFAULT now() NOT NULL,
	return_date DATE DEFAULT now() + '7 days'::interval NOT NULL,
	status VARCHAR(255) DEFAULT 'borrowed' NOT NULL,
	CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	CONSTRAINT fk_book FOREIGN KEY (book_isbn) REFERENCES books(isbn) ON DELETE CASCADE
);
