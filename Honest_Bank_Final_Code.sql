create Database Honest_Bank;
use Honest_Bank;
-- done
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    cFirstName VARCHAR(30),
    cLastName VARCHAR(30),
    cCountry VARCHAR(30),
    cCity VARCHAR(30),
    cZipcode VARCHAR(10),
    cStreet VARCHAR(255),
    Email VARCHAR(255),
    csex VARCHAR(10),
    SSN VARCHAR(20) UNIQUE,
    cPosition VARCHAR(255),
    BirthDate DATE,
    CHECK (csex IN ('Male', 'Female'))
);
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY,
    BranchPhone VARCHAR(25),
    BranchCountry VARCHAR(20),
    BranchCity VARCHAR(20),
    BranchName VARCHAR(255),
    ATMAvailability BOOLEAN,
    LanguagesSpoken VARCHAR(255),
    ManagerID INT,
	CHECK (BranchCountry IN ('USA', 'Lebanon', 'UK')),
	CHECK (BranchCity IN ('New York', 'Los Angeles', 'Beirut', 'Byblos', 'London','Chicago',
			'Birmingham','Tripoli','Tyre','Virginia'))
);
-- Employee
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Salary DECIMAL(10, 2), 
    ename VARCHAR(255),
    EmployeeCountry VARCHAR(20),
    EmployeeCity VARCHAR(20),
    EmployeeZipCode VARCHAR(10),
    EmployeeStreet VARCHAR(255),
    EmployeeEmail VARCHAR(255),
    esex VARCHAR(10),
    Age INT CHECK (Age >= 18),
    BranchID INT not null,
	CHECK (Salary >= 0),
	CHECK (esex IN ('Male', 'Female')) 
);
-- Account
CREATE TABLE Account (
    AccountID INT PRIMARY KEY,
    AccountType VARCHAR(20),
    Balance DECIMAL(10, 2),
    DateOpened DATE,
    CustomerID INT not null,
    BranchID INT not null,
    CHECK (AccountType IN ('Savings', 'Checking', 'Investment', 'Credit'))
);

-- Transaction
CREATE TABLE Transaction (
    TransactionID INT PRIMARY KEY,
    PrivateKey INT,
    Description VARCHAR(255),
    Date DATE,
    Amount DECIMAL(10, 2),
    TransactionType VARCHAR(20),
    TargetCryptocurrency VARCHAR(20),
    SourceCryptoCurrency VARCHAR(20),
    BranchID INT not null,
    CardPassword VARCHAR(20),
    CHECK (Amount >= 0)
);

-- CreditCard
CREATE TABLE CreditCard (
    CardNumber VARCHAR(16) PRIMARY KEY,
    ExpDate DATE,
    CreditLimit DECIMAL(10, 2),
    CardPassword VARCHAR(20),
    CustomerID INT NOT NULL,
    CHECK (LENGTH(CardNumber) = 16),
    CHECK (CreditLimit >= 0),
    INDEX idx_CardPassword (CardPassword)  -- Add this line to create an index
);

-- Department
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    Budget DECIMAL(15, 2),
    dname VARCHAR(30),
    depDescription TEXT,
    NumOfEmployees INT,
    ManagerID INT not null,
    CHECK (Budget >= 0), 
    CHECK (NumOfEmployees >= 0) 
);

-- CryptoNews
CREATE TABLE CryptoNews (
    NewsID INT PRIMARY KEY,
    NewsSymbol VARCHAR(10),
    Views INT,
    PublicationDate DATE,
    Content TEXT
);

-- CryptoWallet
CREATE TABLE CryptoWallet (
    PrivateKey INT PRIMARY KEY,
    WalletName VARCHAR(30),
    Balance DECIMAL(10, 2),
    PublicKey VARCHAR(30),
    NetworkExplorerLink VARCHAR(255),
    CustomerID INT not null,
    CHECK (Balance >= 0)
);

-- CryptoCurrency
CREATE TABLE CryptoCurrency (
    CryptoID INT PRIMARY KEY,
    currencyName VARCHAR(30),
    Symbol VARCHAR(10),
    MarketPrice DECIMAL(15, 2),
    WhitePaper TEXT,
    CreationYear INT
);

-- Loan
CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    Amount DECIMAL(10, 2),
    MaxAmount DECIMAL(10, 2),
    DateTaken DATE,
    DueDate DATE,
    InterestRate DECIMAL(8, 2),
    CustomerID INT not null,
    AccountID INT not null,
    CHECK (InterestRate >= 0),
    CHECK (Amount >= 0), 
    CHECK (MaxAmount >= 0), 
    CHECK (DateTaken <= DueDate) 
);

-- StudentLoan
CREATE TABLE StudentLoan (
    LoanID INT PRIMARY KEY,
    UniversityInfo TEXT,
    ExpectedIncome DECIMAL(10, 2),
    ExpectedGradDate DATE,
    CHECK (ExpectedIncome >= 0)
);

-- HomeLoan
CREATE TABLE HomeLoan (
    LoanID INT PRIMARY KEY,
    PropertyType VARCHAR(20),
    PropertyAppraisal DECIMAL(10, 2)
);

-- PersonalLoan
CREATE TABLE PersonalLoan (
    LoanID INT PRIMARY KEY,
    CreditScore INT,
    LoanPurpose VARCHAR(255),
    CHECK (CreditScore >= 0)
);
-- ATM
CREATE TABLE ATM (
    ATMID INT PRIMARY KEY,
    CashBalance DECIMAL(10, 2),
    MaxAmount DECIMAL(10, 2),
    ATMCountry VARCHAR(20),
    ATMCity VARCHAR(20),
    ATMStreet VARCHAR(30),
    ATMPlace VARCHAR(30),
    CHECK (CashBalance >= 0),
    CHECK (MaxAmount >= 0)
);

-- weak entities

-- Dependant
CREATE TABLE Dependant (
    DependantID INT PRIMARY KEY,
    EmpID INT,
    Relationship VARCHAR(255),
    DependantName VARCHAR(255),
    DateOfBirth DATE
);

-- Beneficiary
CREATE TABLE Beneficiary (
    BeneficiaryID INT PRIMARY KEY,
    AccountID INT,
    AccountNum VARCHAR(255),
    FirstName VARCHAR(255),
    LastName VARCHAR(255)
);

-- relationships

-- Links_with
CREATE TABLE Links_with (
    AccountID INT,
    PrivateKey INT,
    DateOpened DATE,
    ConfirmationInfo VARCHAR(255)
);

-- Contains
CREATE TABLE Contains (
    WalletID INT,
    CryptoID INT
);

-- Supervise
CREATE TABLE Supervise (
    SuperviserID INT,
    SuperviseeID INT,
    CHECK (SuperviserID <> SuperviseeID) -- supervisor is not their own supervisee
);
-- Works-in
CREATE TABLE Works_in (
    EmpID INT,
    DepID INT,
    Hours DECIMAL(5, 2)
);
-- Refilled
CREATE TABLE Refilled (
    EmployeeID INT,
    ATMID INT,
    BranchID INT
);

-- Issues
CREATE TABLE Issues (
    DepartmentID INT,
    EmployeeID INT,
    NewsID INT
);

-- Undergoes
CREATE TABLE Undergoes (
    AccountID INT,
    ATMID INT,
    TransactionID INT,
    DestinationAccountID INT,
    TargetCurrency VARCHAR(255),
    SourceCurrency VARCHAR(255)
);

-- multivalued attribute

-- Phone Number
CREATE TABLE PhoneNumber (
    CustomerID INT,
    PhoneNum VARCHAR(25)
);

-- Customer
-- Branch
ALTER TABLE Branch
ADD FOREIGN KEY (ManagerID)
REFERENCES Employee(EmployeeID);

-- Employee
ALTER TABLE Employee
ADD FOREIGN KEY (BranchID)
REFERENCES Branch(BranchID);

-- Account
ALTER TABLE Account
ADD FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerID);
ALTER TABLE Account
ADD FOREIGN KEY (BranchID)
REFERENCES Branch(BranchID);

-- Transaction
ALTER TABLE Transaction
ADD FOREIGN KEY (BranchID)
REFERENCES Branch(BranchID);

Alter TABLE Transaction 
Add Foreign KEY (CardPassword)
References CreditCard(CardPassword);

ALTER TABLE Transaction
ADD FOREIGN KEY (PrivateKey)
REFERENCES CryptoWallet(PrivateKey);

-- CreditCard
ALTER TABLE CreditCard
ADD FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerID);

-- Department
ALTER TABLE Department
ADD FOREIGN KEY (ManagerID)
REFERENCES Employee(EmployeeID);

-- CryptoWallet
ALTER TABLE CryptoWallet
ADD FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerID);

-- Loan
ALTER TABLE Loan
ADD FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerID);
ALTER TABLE Loan
ADD FOREIGN KEY (AccountID)
REFERENCES Account(AccountID);

-- Beneficiary
ALTER TABLE Beneficiary
ADD FOREIGN KEY (AccountID)
REFERENCES Account(AccountID);

-- Links_with
ALTER TABLE Links_with
ADD FOREIGN KEY (AccountID)
REFERENCES Account(AccountID);
ALTER TABLE Links_with
ADD FOREIGN KEY (PrivateKey)
REFERENCES Cryptowallet(PrivateKey);

-- Contains
ALTER TABLE Contains
ADD FOREIGN KEY (WalletID)
REFERENCES CryptoWallet(PrivateKey);
ALTER TABLE Contains
ADD FOREIGN KEY (CryptoID)
REFERENCES CryptoCurrency(CryptoID);

-- Supervise
ALTER TABLE Supervise
ADD FOREIGN KEY (SuperviserID)
REFERENCES Employee(EmployeeID);
ALTER TABLE Supervise
ADD FOREIGN KEY (SuperviseeID)
REFERENCES Employee(EmployeeID);

-- Works-in
ALTER TABLE Works_in
ADD FOREIGN KEY (EmpID)
REFERENCES Employee(EmployeeID);
ALTER TABLE Works_in
ADD FOREIGN KEY (DepID)
REFERENCES Department(DepartmentID);

-- Refilled
ALTER TABLE Refilled
ADD FOREIGN KEY (EmployeeID)
REFERENCES Employee(EmployeeID);
ALTER TABLE Refilled
ADD FOREIGN KEY (ATMID)
REFERENCES ATM(ATMID);
ALTER TABLE Refilled
ADD FOREIGN KEY (BranchID)
REFERENCES Branch(BranchID);

-- Issues
ALTER TABLE Issues
ADD FOREIGN KEY (DepartmentID)
REFERENCES Department(DepartmentID);
ALTER TABLE Issues
ADD FOREIGN KEY (EmployeeID)
REFERENCES Employee(EmployeeID);
ALTER TABLE Issues
ADD FOREIGN KEY (NewsID)
REFERENCES CryptoNews(NewsID);

-- Undergoes
ALTER TABLE Undergoes
ADD FOREIGN KEY (AccountID)
REFERENCES Account(AccountID);
ALTER TABLE Undergoes
ADD FOREIGN KEY (ATMID)
REFERENCES ATM(ATMID);
ALTER TABLE Undergoes
ADD FOREIGN KEY (TransactionID)
REFERENCES Transaction(TransactionID);
ALTER TABLE Undergoes
ADD FOREIGN KEY (DestinationAccountID)
REFERENCES Account(AccountID);
INSERT INTO Customer (CustomerID, cFirstName, cLastName, cCountry, cCity, cZipcode, cStreet, Email, csex, SSN, cPosition, BirthDate)
VALUES
(1, 'John', 'Johnson', 'USA', 'New York', '10001', '123 Main St', 'john.johnson@email.com', 'Male', '123-85-6789', 'Manager', '1980-05-15'),
(2, 'Jane', 'Smith', 'Canada', 'Toronto', 'M5V 2L7', '456 Maple Ave', 'jane.smith@email.com', 'Female', '988-65-4321', 'Developer', '1985-08-22'),
(3, 'Khaleel', 'Johnson', 'UK', 'London', 'SW1A 1AA', '789 Oak Blvd', 'khaleel.johnson@email.com', 'Male', '345-67-8501', 'Analyst', '1990-02-10'),
(4, 'Emily', 'Davis', 'Australia', 'Sydney', '2000', '101 Pine St', 'emily.davis@email.com', 'Female', '569-89-0123', 'Designer', '1988-11-28'),
(5, 'Abdulrahman', 'Brown', 'Germany', 'Berlin', '10117', '202 Cedar Rd', 'abdulrahman.brown@email.com', 'Male', '789-08-2345', 'Engineer', '1983-04-03'),
(6, 'Sophia', 'Garcia', 'Spain', 'Madrid', '28001', '303 Elm Ln', 'sophia.garcia@email.com', 'Female', '812-34-5678', 'Consultant', '1995-07-19'),
(7, 'Daniel', 'Martinez', 'France', 'Paris', '75001', '404 Birch St', 'daniel.martinez@email.com', 'Male', '23-56-7890', 'Supervisor', '1982-09-14'),
(8, 'Olivia', 'Rodriguez', 'Italy', 'Rome', '00185', '505 Oak Ave', 'olivia.rodriguez@email.com', 'Female', '416-78-9012', 'Manager', '1987-01-26'),
(9, 'William', 'Lopez', 'Brazil', 'Rio de Janeiro', '20040-080', '606 Maple Blvd', 'william.lopez@email.com', 'Male', '678-95-1234', 'Developer', '1992-12-07'),
(10, 'Abdulrahman', 'Rodriguez', 'India', 'Mumbai', '400001', '707 Pine Rd', 'abdulrahman.hernandez@email.com', 'Male', '890-12-3256', 'Analyst', '1986-06-30'),
(11, 'John', 'Smith', 'USA', 'Los Angeles', '90001', '111 Oak St', 'john.smith@email.com', 'Male', '111-22-3344', 'Manager', '1975-09-08'),
(12, 'Kevin', 'Williams', 'Canada', 'Vancouver', 'V6C 1A1', '222 Maple Ave', 'kevin.williams@email.com', 'Male', '444-65-6677', 'Developer', '1988-12-18'),
(13, 'Kevin', 'Williams', 'UK', 'Manchester', 'M1 1AB', '333 Pine Blvd', 'kevin.williams1@email.com', 'Male', '999-88-6777', 'Analyst', '1993-03-22'),
(14, 'Sophie', 'Anderson', 'Australia', 'Melbourne', '3000', '444 Cedar Ln', 'sophie.anderson@email.com', 'Female', '122-45-6689', 'Designer', '1982-07-15'),
(15, 'Liam', 'Brown', 'Germany', 'Hamburg', '20095', '555 Elm St', 'liam.brown@email.com', 'Male', '234-56-7810', 'Engineer', '1989-11-30'),
(16, 'Kevin', 'Williams', 'Spain', 'Barcelona', '08001', '666 Oak Ave', 'zoe.martinez@email.com', 'Male', '769-01-2345', 'Consultant', '1996-04-25'),
(17, 'Alain', 'Garcia', 'France', 'Nice', '06000', '777 Maple Rd', 'mason.garcia@email.com', 'Male', '345-67-8701', 'Supervisor', '1984-01-12'),
(18, 'Alain', 'Rodriguez', 'Italy', 'Milan', '20121', '888 Pine Blvd', 'alain.rodriguez@email.com', 'Male', '567-89-0823', 'Manager', '1980-08-07'),
(19, 'Logan', 'Lopez', 'Brazil', 'Sao Paulo', '01000-000', '999 Cedar Ln', 'logan.lopez@email.com', 'Male', '012-94-5678', 'Developer', '1991-06-19'),
(20, 'Alain', 'Hernandez', 'India', 'Delhi', '110001', '1010 Oak St', 'madison.hernandez@email.com', 'Male', '890-22-3456', 'Analyst', '1987-02-03'),
(21, 'Caleb', 'Taylor', 'USA', 'Chicago', '60601', '111 Maple Ave', 'caleb.taylor@email.com', 'Male', '345-67-8981', 'Manager', '1978-04-14'),
(22, 'Scarlett', 'Brown', 'Canada', 'Montreal', 'H3C 1A1', '222 Pine Blvd', 'scarlett.miller@email.com', 'Female', '567-99-0123', 'Developer', '1989-09-26'),
(23, 'Jackson', 'Harris', 'UK', 'Birmingham', 'B1 1AB', '333 Cedar Ln', 'jackson.harris@email.com', 'Male', '789-01-2345', 'Analyst', '1994-12-08'),
(24, 'Jackson', 'Harris', 'Australia', 'Sydney', '2000', '444 Oak Ave', 'chloe.king@email.com', 'Female', '012-34-5668', 'Designer', '1981-03-17'),
(25, 'Elijah', 'Young', 'Germany', 'Munich', '80331', '555 Maple Rd', 'elijah.young@email.com', 'Male', '134-56-7790', 'Engineer', '1986-07-02'),
(26, 'Grace', 'Fisher', 'Spain', 'Seville', '41001', '666 Cedar Ln', 'grace.fisher@email.com', 'Female', '348-67-8901', 'Consultant', '1992-10-15'),
(27, 'Kevin', 'Ward', 'France', 'Marseille', '13001', '777 Oak Ave', 'lucas.ward@email.com', 'Male', '567-89-0223', 'Supervisor', '1987-01-28'),
(28, 'Aubrey', 'Reed', 'Italy', 'Florence', '50123', '888 Pine Blvd', 'aubrey.reed@email.com', 'Female', '779-01-2345', 'Manager', '1984-06-09'),
(29, 'Kevin', 'Williams', 'Brazil', 'Brasilia', '70000-000', '999 Cedar Ln', 'kevin.williams2@email.com', 'Male', '012-34-5658', 'Developer', '1990-09-22'),
(30, 'Lily', 'Baker', 'India', 'Chennai', '600001', '1010 Maple Rd', 'lily.baker@email.com', 'Female', '234-56-7990', 'Analyst', '1983-12-03');
-- Inserting data into the Branch table
-- done
INSERT INTO Branch (BranchID, BranchPhone, BranchCountry, BranchCity, BranchName, ATMAvailability, LanguagesSpoken, ManagerID)
VALUES
(1, '+1-123-456-7890', 'USA', 'New York', 'Main Street Branch', true, 'English, Spanish', NULL),
(2, '+1-987-654-3210', 'USA', 'Los Angeles', 'Sunset Boulevard Branch', false, 'English, Chinese', null),
(3, '+961-71-234567', 'Lebanon', 'Beirut', 'Downtown Branch', true, 'Arabic, French, English', null),
(4, '+961-76-543210', 'Lebanon', 'Byblos', 'Seaside Branch', false, 'Arabic, English', null),
(5, '+44-20-1234-5678', 'UK', 'London', 'City Centre Branch', true, 'English', null),
(6, '+1-555-123-4567', 'USA', 'Chicago', 'Downtown Chicago Branch', true, 'English, Spanish', null),
(7, '+1-333-987-6543', 'USA', 'Virginia', 'Harrisonbourgh', false, 'English, French', null),
(8, '+44-20-5678-1234', 'UK', 'Birmingham', 'Midlands Branch', true, 'English', null),
(9, '+961-70-987654', 'Lebanon', 'Tripoli', 'Northern Lebanon Branch', false, 'Arabic, English', null),
(10, '+961-79-123456', 'Lebanon', 'Tyre', 'Southern Lebanon Branch', true, 'Arabic, English', null);

-- Inserting data into the Employee table
-- done
INSERT INTO Employee (EmployeeID, Salary, ename, EmployeeCountry, EmployeeCity, EmployeeZipCode, EmployeeStreet, EmployeeEmail, esex, Age, BranchID)
VALUES
(1, 80000.00, 'Robert Johnson', 'USA', 'New York', '10001', '456 Oak St', 'robert.johnson@email.com', 'Male', 30, 1),
(2, 75000.00, 'Sarah White', 'UK', 'London', 'SW1A 1AA', '789 Pine Ave', 'sarah.white@email.com', 'Female', 28, 5),
(3, 90000.00, 'Chris Smith', 'USA', 'Los Angeles', '90001', '101 Maple Rd', 'chris.smith@email.com', 'Male', 35, 2),
(4, 82000.00, 'Emily Davis', 'Lebanon', 'Beirut', '12345', '303 Cedar Ln', 'emily.davis@email.com', 'Female', 32, 3),
(5, 70000.00, 'Daniel Martinez', 'Lebanon', 'Byblos', '54321', '202 Birch Blvd', 'daniel.martinez@email.com', 'Male', 28, 8),
(6, 85000.00, 'Ava Hernandez', 'USA', 'New York', '10002', '404 Elm St', 'ava.hernandez@email.com', 'Female', 33, 1),
(7, 88000.00, 'Michael Brown', 'USA', 'Los Angeles', '90002', '606 Pine Ave', 'michael.brown@email.com', 'Male', 30, 2),
(8, 95000.00, 'Saad Hamdoun', 'Lebanon', 'Beirut', '54322', '707 Cedar Rd', 'sosoh@email.com', 'Male', 35, 9),
(9, 78000.00, 'William Lopez', 'Lebanon', 'Byblos', '12346', '808 Maple Blvd', 'william.lopez@email.com', 'Male', 31, 4),
(10, 92000.00, 'Sophia Garcia', 'UK', 'London', 'SW1A 1AB', '909 Oak Ln', 'sophia.garcia@email.com', 'Female', 34, 5),
(11, 80000.00, 'Jason Turner', 'USA', 'Chicago', '60601', '111 Oak St', 'jason.turner@email.com', 'Male', 29, 6),
(12, 75000.00, 'Mia Cooper', 'USA', 'Virginia', 'M5V 2L7', '222 Maple Ave', 'mia.cooper@email.com', 'Female', 27, 7),
(13, 90000.00, 'Ryan Walker', 'UK', 'Manchester', 'M1 1AB', '333 Pine Blvd', 'ryan.walker@email.com', 'Male', 36, 8),
(14, 82000.00, 'Emma Robinson', 'Australia', 'Melbourne', '3000', '444 Cedar Ln', 'emma.robinson@email.com', 'Female', 33, 6),
(15, 70000.00, 'James Reed', 'Germany', 'Hamburg', '20095', '555 Elm St', 'james.reed@email.com', 'Male', 29, 10),
(16, 85000.00, 'Sophie Turner', 'Spain', 'Barcelona', '08001', '666 Oak Ave', 'sophie.turner@email.com', 'Female', 34, 2),
(17, 88000.00, 'David Hall', 'France', 'Nice', '06000', '777 Maple Rd', 'david.hall@email.com', 'Male', 31, 2),
(18, 95000.00, 'Chloe Evans', 'Italy', 'Milan', '20121', '888 Pine Blvd', 'chloe.evans@email.com', 'Female', 36, 3),
(19, 78000.00, 'Daniel Parker', 'Brazil', 'Sao Paulo', '01000-000', '999 Cedar Ln', 'daniel.parker@email.com', 'Male', 32, 4),
(20, 92000.00, 'Aria Hughes', 'India', 'Delhi', '110001', '1010 Oak St', 'aria.hughes@email.com', 'Female', 35, 6),
(21, 80000.00, 'Elijah Taylor', 'USA', 'Los Angeles', '90001', '456 Oak St', 'elijah.taylor@email.com', 'Male', 30, 6),
(22, 75000.00, 'Lily Adams', 'UK', 'London', 'SW1A 1AA', '789 Pine Ave', 'lily.adams@email.com', 'Female', 28, 7),
(23, 90000.00, 'Mason Miller', 'USA', 'Chicago', '60601', '101 Maple Rd', 'mason.miller@email.com', 'Male', 35, 6),
(24, 82000.00, 'Zoe Parker', 'Lebanon', 'Beirut', '12345', '303 Cedar Ln', 'zoe.parker@email.com', 'Female', 32, 9),
(25, 70000.00, 'Aiden Scott', 'Lebanon', 'Byblos', '54321', '202 Birch Blvd', 'aiden.scott@email.com', 'Male', 28, 10),
(26, 85000.00, 'Scarlett Young', 'USA', 'New York', '10002', '404 Elm St', 'scarlett.young@email.com', 'Female', 33, 1),
(27, 88000.00, 'Owen Adams', 'USA', 'Los Angeles', '90002', '606 Pine Ave', 'owen.adams@email.com', 'Male', 30, 2),
(28, 95000.00, 'Ava Turner', 'Lebanon', 'Beirut', '54322', '707 Cedar Rd', 'ava.turner@email.com', 'Female', 35, 3),
(29, 78000.00, 'Logan Hall', 'Lebanon', 'Byblos', '12346', '808 Maple Blvd', 'logan.hall@email.com', 'Male', 31, 4),
(30, 92000.00, 'Emma Walker', 'UK', 'London', 'SW1A 1AB', '909 Oak Ln', 'emma.walker@email.com', 'Female', 34, 5);
-- Inserting data into the Account table
-- done
INSERT INTO Account (AccountID, AccountType, Balance, DateOpened, CustomerID, BranchID)
VALUES
(1, 'Savings', 5000.00, '2020-01-15', 1, 1),
(2, 'Checking', 2500.00, '2019-05-20', 2, 2),
(3, 'Investment', 10000.00, '2022-02-10', 3, 3),
(4, 'Credit', -500.00, '2021-08-05', 4, 4),  -- Negative balance for credit
(5, 'Savings', 7500.00, '2023-01-30', 5, 5),
(6, 'Checking', 3000.00, '2020-12-12', 6, 1),
(7, 'Investment', 12000.00, '2021-10-18', 7, 2),
(8, 'Credit', -200.00, '2018-07-25', 8, 3),  -- Negative balance for credit
(9, 'Savings', 6000.00, '2019-11-08', 9, 4),
(10, 'Checking', 4000.00, '2022-05-03', 10, 5),
(11, 'Savings', 5500.00, '2021-02-20', 11, 6),
(12, 'Checking', 3200.00, '2020-08-15', 12, 7),
(13, 'Investment', 15000.00, '2023-03-05', 13, 8),
(14, 'Credit', -700.00, '2022-02-12', 14, 9),  -- Negative balance for credit
(15, 'Savings', 8000.00, '2022-11-28', 15, 10),
(16, 'Checking', 3500.00, '2021-07-01', 16, 1),
(17, 'Investment', 18000.00, '2020-12-10', 17, 2),
(18, 'Credit', -300.00, '2019-05-22', 18, 3),  -- Negative balance for credit
(19, 'Savings', 7000.00, '2020-03-18', 19, 4),
(20, 'Checking', 4500.00, '2023-06-09', 20, 5),
(21, 'Savings', 5800.00, '2022-04-14', 21, 6),
(22, 'Checking', 2800.00, '2021-10-05', 22, 7),
(23, 'Investment', 13000.00, '2020-07-22', 23, 8),
(24, 'Credit', -600.00, '2022-09-15', 24, 9),  -- Negative balance for credit
(25, 'Savings', 8500.00, '2019-12-01', 25, 10),
(26, 'Checking', 3200.00, '2019-06-28', 26, 1),
(27, 'Investment', 16000.00, '2022-01-12', 27, 2),
(28, 'Credit', -250.00, '2018-04-05', 28, 3),  -- Negative balance for credit
(29, 'Savings', 6700.00, '2021-11-08', 29, 4),
(30, 'Checking', 5000.00, '2023-05-03', 30, 5),
(31, 'Savings', 6000.00, '2019-10-15', 1, 6),
(32, 'Checking', 3800.00, '2018-04-10', 2, 7),
(33, 'Investment', 12000.00, '2021-02-28', 3, 8),
(34, 'Credit', -400.00, '2019-09-01', 4, 9),  -- Negative balance for credit
(35, 'Savings', 7200.00, '2020-06-15', 5, 10);

-- Inserting data into the Transaction table
-- CHECK IT 
-- Inserting data into the CryptoWallet table
-- done
INSERT INTO CryptoWallet (PrivateKey, WalletName, Balance, PublicKey, NetworkExplorerLink, CustomerID)
VALUES
(101, 'Main Wallet', 5.0, 'pubkey1', 'https://explorer.link/pubkey1', 1),
(102, 'Savings Wallet', 8.2, 'pubkey2', 'https://explorer.link/pubkey2', 2),
(103, 'Trading Wallet', 12.5, 'pubkey3', 'https://explorer.link/pubkey3', 3),
(104, 'Investment Wallet', 3.7, 'pubkey4', 'https://explorer.link/pubkey4', 10),
(105, 'Crypto Ventures', 6.8, 'pubkey5', 'https://explorer.link/pubkey5', 9),
(106, 'Daily Transactions', 9.3, 'pubkey6', 'https://explorer.link/pubkey6', 2),
(107, 'Personal Savings', 2.5, 'pubkey7', 'https://explorer.link/pubkey7', 7),
(108, 'Emergency Fund', 7.1, 'pubkey8', 'https://explorer.link/pubkey8', 2),
(109, 'Retirement Savings', 11.0, 'pubkey9', 'https://explorer.link/pubkey9', 9),
(110, 'Long-Term Investments', 4.5, 'pubkey10', 'https://explorer.link/pubkey10', 10);

INSERT INTO CreditCard (CardNumber, ExpDate, CreditLimit, CardPassword, CustomerID)
VALUES
('1111222233334444', '2023-05-01', 5000.00, '1122', 1),
('2222333344445555', '2024-08-01', 8000.00, '3344', 2),
('3333444455556666', '2023-12-01', 3000.00, '7788', 3),
('4444555566667777', '2024-10-01', 6000.00, '9900', 4),
('5555666677778888', '2023-06-01', 7000.00, '5566', 5),
('6666777788889999', '2024-03-01', 9000.00, '1234', 6),
('7777888899990000', '2023-09-01', 4000.00, '5678', 7),
('8888999900001111', '2024-05-01', 5500.00, '9101', 8),
('9999000011112222', '2023-11-01', 7500.00, '5323', 9),
('1234567812345670', '2024-07-01', 3500.00, '1343', 10),
('2345678923456781', '2023-04-01', 4800.00, '5342', 11),
('3456789034567892', '2024-02-01', 6200.00, '5233', 12),
('4567890145678903', '2023-08-01', 2800.00, '7765', 13),
('5678901256789014', '2024-01-01', 4200.00, '7875', 14),
('6789012367890125', '2023-07-01', 5800.00, '9879', 15),
('7890123478901236', '2024-09-01', 3200.00, '9865', 16),
('8901234589012347', '2023-10-01', 4900.00, '8567', 17);

INSERT INTO Transaction (TransactionID, Description, Date, Amount, TransactionType, TargetCryptocurrency, SourceCryptoCurrency, BranchID, PrivateKey,CardPassword)
VALUES
(1, 'Purchase at Electronics Store', '2023-01-15', 500.00, 'Debit', null, null, 1, null, '1122'),
(2, 'Online Shopping', '2023-02-10', 120.00, 'Credit', null, null, 2, null, '3344' ),
(3, 'Restaurant Dinner', '2023-03-05', 80.00, 'Debit', 'EUR', 'Ethereum', 3, 103, null),
(4, 'Cash Withdrawal', '2023-04-20', 50.00, 'Credit', null, null, 4, null, '7788'),
(5, 'Crypto Transfer', '2023-05-15', 15.00, 'Debit', 'Bitcoin', 'Bitcoin', 5, 105, null),                               
(6, 'Cash Withdrawal', '2023-06-01', 100.00, 'Debit', 'Litecoin', 'USD', 8, 106, null),
(7, 'Crypto Transfer', '2023-07-10', 200.00, 'Credit', 'Bitcoin', 'Ethereum', 2, 107, null),
(8, 'Cash Withdrawal', '2023-08-25', 30.00, 'Debit', 'Bitcoin', 'USD', 3, 108, null),
(9, 'Hotel Stay', '2023-09-18', 150.00, 'Credit', null, null, 4, null, '9900'),
(10, 'Shopping Mall', '2023-10-05', 70.00, 'Debit', null, null, 5, null, '5566'),
(11, 'Currency to CryptoCurrency', '2023-11-15', 5.00, 'Debit', 'USD', 'Litecoin', 8, 101, null),          
(12, 'Currency to CryptoCurrency', '2023-12-10', 40.00, 'Credit', 'EUR', 'Litecoin', 2, 102, null),
(13, 'Bookstore', '2024-01-22', 25.00, 'Debit', null, null, 3, null, '1234'),
(14, 'Cash Withdrawal', '2024-02-28', 80.00, 'Credit', null, null, 4, null, '5566'),
(15, 'Electronics Upgrade', '2024-03-15', 300.00, 'Debit', null, null, 5, null, '5566'),
(16, 'Cash Withdrawal', '2024-04-01', 120.00, 'Credit', null, null, 10, null, '5678'),
(17, 'Currency to CryptoCurrency', '2024-05-10', 50.00, 'Debit', 'USD', 'Bitcoin', 9, 101, null),
(18, 'Concert Tickets', '2024-06-18', 100.00, 'Credit', 'Bitcoin', 'USD', 3, 101, null),
(19, 'Travel Expenses', '2024-07-22', 200.00, 'Debit', 'Bitcoin', 'USD', 4, 101, null),
(20, 'Cash Withdrawal', '2024-08-05', 30.00, 'Credit', null, null, 5, null, '1234'),
(21, 'Purchase at Electronics Store', '2023-01-15', 500.00, 'Debit', null, null, 1, null, '1122'),
(22, 'Online Shopping', '2023-02-10', 120.00, 'Credit', null, null, 2, null, '3344'),
(23, 'Sending Money to Family Abroad', '2023-03-05', 300.00, 'Debit', null, null, 3, null, '5566'),
(24, 'Buying Gifts for Eid Celebration', '2023-04-20', 200.00, 'Credit', null, null, 4, null, '7788'),
(25, 'Family Support Payment', '2023-05-15', 150.00, 'Debit', null, null, 5, null, '9900'),
(26, 'Online Purchase - Clothing', '2023-06-01', 80.00, 'Credit', null, null, 6, null, '1122'),
(27, 'Eid Festivities Expenses', '2023-07-10', 250.00, 'Debit', null, null , 7, null, '3344'),
(28, 'Sending Money for Education', '2023-08-25', 400.00, 'Credit', null, null, 8, null, '5566'),
(29, 'Gifts for Family Occasion', '2023-09-18', 100.00, 'Debit', null, null, 9, null, '7875'),
(30, 'International Charity Donation', '2023-10-05', 50.00, 'Credit', null, null , 10, null, '9900'),
(31, 'Large Deposit', '2023-04-01', '15000.00', 'Deposit', NULL, NULL, '1', NULL, '1122'),
(32, 'Business Payment', '2023-04-02', '12000.00', 'Debit', NULL, NULL, '3', NULL, '3344');


-- Inserting data into the Department table for a bank
-- done
INSERT INTO Department (DepartmentID, Budget, dname, depDescription, NumOfEmployees, ManagerID)
VALUES
(1, 800000.00, 'Corporate Banking', 'Provides financial services to businesses.', 5, 2),
(2, 1500000.00, 'Investment Banking', 'Handles investment and financial transactions.', 5, 4),
(3, 900000.00, 'Information Technology', 'Manages the bank\'s information systems.', 5, 1),
(4, 600000.00, 'Customer Support', 'Provides assistance and support to bank customers.', 5, 7),
(5, 450000.00, 'Branch Operations', 'Manages day-to-day operations of bank branches.', 5, 10);



-- Inserting data into the CryptoCurrency table
-- done 
INSERT INTO CryptoCurrency (CryptoID, currencyName, Symbol, MarketPrice, WhitePaper, CreationYear)
VALUES
(101, 'Bitcoin', 'BTC', 60000.1234567890, 'Link to Bitcoin Whitepaper', 2009),
(102, 'Ethereum', 'ETH', 2000.9876543210, 'Link to Ethereum Whitepaper', 2015),
(103, 'Binance Coin', 'BNB', 400.5678901234, 'Link to Binance Coin Whitepaper', 2017),
(104, 'Cardano', 'ADA', 2.3456789012, 'Link to Cardano Whitepaper', 2015),
(105, 'Solana', 'SOL', 150.6789012345, 'Link to Solana Whitepaper', 2020),
(106, 'XRP', 'XRP', 1.2345678901, 'Link to XRP Whitepaper', 2012),
(107, 'Polkadot', 'DOT', 30.0987654321, 'Link to Polkadot Whitepaper', 2020),
(108, 'Dogecoin', 'DOGE', 0.5678901234, 'Link to Dogecoin Whitepaper', 2013),
(109, 'Avalanche', 'AVAX', 80.1234567890, 'Link to Avalanche Whitepaper', 2020),
(110, 'Litecoin', 'LTC', 180.9876543210, 'Link to Litecoin Whitepaper', 2011);

-- Inserting data into the CryptoNews table
-- done
INSERT INTO CryptoNews (NewsID, NewsSymbol, Views, PublicationDate, Content)
VALUES
(1, 'BTC', 5000, '2023-01-15', 'Bitcoin reaches new all-time high.'),
(2, 'ETH', 3500, '2023-02-10', 'Ethereum upgrades its consensus mechanism.'),
(3, 'BNB', 2000, '2023-03-05', 'Binance Coin becomes a major player in DeFi.'),
(4, 'ADA', 8000, '2023-04-20', 'Cardano introduces smart contract capabilities.'),
(5, 'SOL', 4500, '2023-05-15', 'Solana gains popularity for its fast transactions.'),
(6, 'XRP', 6000, '2023-06-01', 'XRP used for cross-border payments on a large scale.'),
(7, 'DOT', 3000, '2023-07-10', 'Polkadot implements parachains for better scalability.'),
(8, 'DOGE', 7000, '2023-08-25', 'Dogecoin community continues to grow.'),
(9, 'AVAX', 2500, '2023-09-18', 'Avalanche introduces new features for developers.'),
(10, 'LTC', 4000, '2023-10-05', 'Litecoin celebrates its 10th anniversary.');

-- Inserting data into the Loan table
-- done
INSERT INTO Loan (LoanID, Amount, MaxAmount, DateTaken, DueDate, InterestRate, CustomerID, AccountID)
VALUES
(1, 5000.00, 10000.00, '2023-01-15', '2024-01-15', 5.5, 1, 31),
(2, 10000.00, 20000.00, '2023-02-10', '2024-02-10', 7.2, 2, 2),
(3, 7500.00, 12000.00, '2023-03-05', '2024-03-05', 6.0, 2, 32),
(4, 12000.00, 25000.00, '2023-04-20', '2024-04-20', 8.3, 4, 4),
(5, 20000.00, 35000.00, '2023-05-15', '2024-05-15', 6.8, 7, 7),
(6, 15000.00, 28000.00, '2023-06-01', '2024-06-01', 7.5, 9, 9),
(7, 18000.00, 30000.00, '2023-07-10', '2024-07-10', 6.2, 4, 34),
(8, 25000.00, 40000.00, '2023-08-25', '2024-08-25', 8.0, 8, 8),
(9, 3000.00, 6000.00, '2023-09-18', '2024-09-18', 5.0, 9, 9),
(10, 22000.00, 45000.00, '2023-10-05', '2024-10-05', 7.9, 10, 10),
-- Adding more tuples
(11, 8000.00, 15000.00, '2023-11-15', '2024-11-15', 6.5, 14, 14),
(12, 12000.00, 20000.00, '2023-12-10', '2024-12-10', 7.8, 12, 12),
(13, 10000.00, 18000.00, '2024-01-05', '2025-01-05', 5.3, 16, 16),
(14, 18000.00, 32000.00, '2024-02-20', '2025-02-20', 8.1, 14, 14),
(15, 25000.00, 40000.00, '2024-03-15', '2025-03-15', 7.0, 15, 15),
(16, 20000.00, 35000.00, '2024-04-01', '2025-04-01', 6.5, 18, 18),
(17, 22000.00, 38000.00, '2024-05-10', '2025-05-10', 7.2, 18, 18),
(18, 28000.00, 45000.00, '2024-06-25', '2025-06-25', 6.8, 18, 18),
(19, 35000.00, 55000.00, '2024-07-18', '2025-07-18', 8.3, 21, 21),
(20, 3000.00, 6000.00, '2024-08-05', '2025-08-05', 5.5, 20, 20),
-- Adding more tuples for a total of 30
(21, 18000.00, 30000.00, '2024-09-20', '2025-09-20', 6.2, 21, 21),
(22, 25000.00, 42000.00, '2024-10-25', '2025-10-25', 7.9, 22, 22),
(23, 30000.00, 55000.00, '2024-11-10', '2025-11-10', 6.0, 23, 23),
(24, 40000.00, 65000.00, '2024-12-05', '2025-12-05', 8.5, 24, 24),
(25, 35000.00, 60000.00, '2025-01-20', '2026-01-20', 7.2, 25, 25),
(26, 28000.00, 50000.00, '2025-02-15', '2026-02-15', 6.8, 26, 26),
(27, 32000.00, 55000.00, '2025-03-01', '2026-03-01', 7.5, 27, 27),
(28, 42000.00, 70000.00, '2025-04-10', '2026-04-10', 8.0, 28, 28),
(29, 6000.00, 12000.00, '2025-05-05', '2026-05-05', 5.2, 29, 29),
(30, 45000.00, 80000.00, '2025-06-20', '2026-06-20', 7.7, 30, 30);
-- Inserting data into the StudentLoan table
-- NOT done (change the LoanID to 101...)
INSERT INTO StudentLoan (LoanID, UniversityInfo, ExpectedIncome, ExpectedGradDate)
VALUES
(1, 'LAU, Computer Science', 60000.00, '2024-05-15'),
(2, 'AUB, Business Administration', 80000.00, '2024-08-10'),
(3, 'University DEF, Engineering', 70000.00, '2024-06-05'),
(4, 'University GHI, Medicine', 90000.00, '2024-09-20'),
(5, 'University JKL, Engineering', 50000.00, '2024-07-15'),
(6, 'LAU, Finance', 75000.00, '2025-08-01'),
(7, 'AUB, Computer Science', 65000.00, '2024-07-10'),
(8, 'LAU, Psychology', 50000.00, '2024-10-25'),
(9, 'University VWX, Sociology', 55000.00, '2024-09-18'),
(10, 'University YZ, History', 70000.00, '2025-10-05');
-- Inserting data into the HomeLoan table
-- done
INSERT INTO HomeLoan (LoanID, PropertyType, PropertyAppraisal)
VALUES
(11, 'Single Family Home', 300000.00),
(12, 'Condo', 200000.00),
(13, 'Townhouse', 250000.00),
(14, 'Apartment', 180000.00),
(15, 'Vacation Home', 400000.00),
(16, 'Duplex', 350000.00),
(17, 'Cottage', 180000.00),
(18, 'Mansion', 800000.00),
(19, 'Rural Property', 220000.00),
(20, 'Urban Loft', 280000.00);


-- Inserting data into the PersonalLoan table
-- done
INSERT INTO PersonalLoan (LoanID, CreditScore, LoanPurpose)
VALUES
(21, 720, 'Home Improvement'),
(22, 680, 'Debt Consolidation'),
(23, 750, 'Travel'),
(24, 700, 'Education'),
(25, 780, 'Medical Expenses'),
(26, 650, 'Wedding'),
(27, 710, 'Car Purchase'),
(28, 740, 'Business Startup'),
(29, 690, 'Emergency'),
(30, 760, 'Vacation');

-- Inserting data into the ATM table
-- done
INSERT INTO ATM (ATMID, CashBalance, MaxAmount, ATMCountry, ATMCity, ATMStreet, ATMPlace)
VALUES
(1, 15000.00, 2000.00, 'USA', 'New York', '123 Main St', 'Near Central Park'),
(2, 20000.00, 2500.00, 'USA', 'Los Angeles', '456 Oak Ave', 'Downtown LA'),
(3, 18000.00, 2500.00, 'Lebanon', 'Beirut', '789 Pine Rd', 'Hamra District'),
(4, 12000.00, 1500.00, 'Lebanon', 'Byblos', '101 Maple Blvd', 'Old Souk Area'),
(5, 25000.00, 3000.00, 'UK', 'London', '202 Cedar Ln', 'Financial District'),
(6, 22000.00, 2800.00, 'USA', 'Chicago', '303 Elm St', 'Downtown Loop'),
(7, 20000.00, 2600.00, 'USA', 'Virginia', '404 Birch Ave', 'Midtown'),
(8, 28000.00, 3500.00, 'Lebanon', 'Tripoli', '505 Oak Rd', 'City Center'),
(9, 16000.00, 2000.00, 'UK', 'Manchester', '606 Pine Blvd', 'Northern Quarter'),
(10, 24000.00, 3000.00, 'USA', 'San Francisco', '707 Cedar Ave', 'Financial District'),
(11, 13000.00, 1800.00, 'USA', 'Los Angeles', '808 Maple St', 'Pioneer Square'),
(12, 18000.00, 2200.00, 'Lebanon', 'Sidon', '909 Oak Ave', 'Downtown Souk'),
(13, 20000.00, 2500.00, 'UK', 'Glasgow', '121 Birch Ln', 'City Center'),
(14, 21000.00, 2500.00, 'USA', 'Miami', '232 Elm Rd', 'South Beach'),
(15, 18000.00, 2500.00, 'USA', 'Atlanta', '343 Pine Blvd', 'Downtown'),
(16, 30000.00, 4000.00, 'USA', 'New York', '444 Oak St', 'Times Square'),
(17, 26000.00, 3200.00, 'USA', 'Los Angeles', '555 Pine Ave', 'Hollywood'),
(18, 22000.00, 2500.00, 'Lebanon', 'Beirut', '666 Cedar Rd', 'Downtown Gemmayze'),
(19, 17000.00, 1800.00, 'Lebanon', 'Byblos', '777 Maple Blvd', 'Byblos Old Port'),
(20, 32000.00, 4500.00, 'UK', 'London', '888 Elm Ln', 'Westminster'),
(21, 28000.00, 3800.00, 'USA', 'Chicago', '999 Birch St', 'Magnificent Mile'),
(22, 24000.00, 3200.00, 'USA', 'Houston', '1010 Oak Ave', 'Downtown Theater District'),
(23, 35000.00, 5000.00, 'Lebanon', 'Byblos', '1111 Pine Blvd', 'Al Mina'),
(24, 29000.00, 4200.00, 'UK', 'Manchester', '1212 Cedar Rd', 'Castlefield'),
(25, 26000.00, 3500.00, 'USA', 'San Francisco', '1313 Maple Blvd', 'Chinatown');

-- Inserting data into the Dependant table
-- done
INSERT INTO Dependant (DependantID, EmpID, Relationship, DependantName, DateOfBirth)
VALUES
(1, 1, 'Spouse', 'Emma Johnson', '1985-03-12'),
(2, 3, 'Child', 'Alex Smith', '2008-09-05'),
(3, 5, 'Spouse', 'Alex Brown', '1990-11-18'),
(4, 7, 'Child', 'Ethan Martinez', '2015-07-22'),
(5, 9, 'Child', 'Isabella Lopez', '2012-04-30'),
(6, 2, 'Spouse', 'Alex White', '1982-06-14'),
(7, 1, 'Uncle', 'Oliver Davis', '2007-12-08'),
(8, 6, 'Child', 'Emma Garcia', '2019-04-25'),
(9, 9, 'Spouse', 'Liam Johnson', '1987-08-29'),
(10, 10, 'Child', 'Aria White', '2011-10-12');

-- Inserting data into the Beneficiary table
INSERT INTO Beneficiary(BeneficiaryID, AccountID, AccountNum, FirstName, LastName)
VALUES
(1, 1, '123456789', 'Alice', 'Johnson'),
(2, 3, '987654321', 'Charlie', 'Smith'),
(3, 5, '567890123', 'Emily', 'Brown'),
(4, 7, '234567890', 'Mia', 'Martinez'),
(5, 9, '678901234', 'Olivia', 'Lopez'),
(6, 2, '345678901', 'Mia', 'White'),
(7, 4, '789012345', 'Harper', 'Davis'),
(8, 6, '012345678', 'Sebastian', 'Johnson'),
(9, 8, '456789012', 'Mia', 'Rodriguez'),
(10, 10, '901234567', 'Jackson', 'Hernandez');

-- Inserting modified data into the Links_with table
-- done
INSERT INTO Links_with (AccountID, PrivateKey, DateOpened, ConfirmationInfo)
VALUES
(1, 101, '2022-01-15', 'Confirmation123'),
(2, 102, '2022-02-20', 'Confirmation234'),
(3, 103, '2022-03-25', 'Confirmation345'),
(10, 104, '2022-04-30', 'Confirmation456'),
(7, 105, '2022-05-15', 'Confirmation567'),
(9, 106, '2022-06-20', 'Confirmation678'),
(8, 107, '2022-07-25', 'Confirmation789'),
(4, 108, '2022-08-30', 'Confirmation890'),
(9, 109, '2022-09-05', 'Confirmation901'),
(6, 110, '2022-10-10', 'Confirmation102');

-- Inserting modified data into the Contains table
-- done
INSERT INTO Contains (WalletID, CryptoID)
VALUES
(101, 101),
(102, 102),
(103, 103),
(104, 104),
(105, 105),
(101, 102),
(107, 101),
(101, 108),
(109, 101),
(110, 101);

-- Inserting data into the Supervise table
-- done
INSERT INTO Supervise (SuperviserID, SuperviseeID)
VALUES
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(3, 9),
(3, 10),
(3, 11),
(4, 12),
(4, 13),
(4, 14),
(5, 15),
(5, 16),
(5, 17),
(6, 18),
(6, 19),
(6, 20),
(7, 21),
(7, 22),
(7, 23),
(8, 24),
(8, 25),
(8, 26),
(9, 27),
(9, 28),
(9, 29),
(10, 30);

-- Inserting data into the Works_in table
-- done
INSERT INTO Works_in (EmpID, DepID, Hours)
VALUES
(1, 1, 40.0),
(2, 2, 35.5),
(3, 3, 38.0),
(4, 4, 42.5),
(5, 5, 37.0),
(6, 1, 41.5),
(7, 2, 36.0),
(8, 3, 39.5),
(9, 4, 40.0),
(10, 5, 35.5),
(11, 1, 38.0),
(12, 2, 42.5),
(13, 3, 37.0),
(14, 4, 41.5),
(15, 5, 36.0),
(16, 1, 39.5),
(17, 2, 40.0),
(18, 3, 35.5),
(19, 4, 38.0),
(20, 5, 42.5),
(21, 1, 37.0),
(22, 2, 41.5),
(23, 3, 36.0),
(24, 4, 39.5),
(25, 5, 40.0),
(26, 1, 35.5),
(27, 2, 38.0),
(28, 3, 42.5),
(29, 4, 37.0),
(30, 5, 41.5);

-- Inserting shuffled data into the Refilled table
-- done
-- Correcting data for refills based on ATM and branch values
INSERT INTO Refilled (EmployeeID, ATMID, BranchID)
VALUES
(24, 8, 9),  
(8, 8, 9),  
(11, 6, 6),  
(10, 5, 5), 
(23, 6, 6), 
(4, 3, 3),  
(6, 1, 1),  
(12, 7, 7),  
(3, 2, 2), 
(16, 2, 2),
(20, 6, 6),  
(21, 6, 6),  
(14, 6, 6), 
(13, 9, 8);  




-- Inserting shuffled data into the Issues table
-- done
INSERT INTO Issues (EmployeeID, DepartmentID, NewsID)
VALUES
(2, 2, 2),
(1, 1, 10),
(2, 2, 2),
(3, 3, 10),
(9, 4, 10),
(2, 2, 7),
(8, 3, 10),
(6, 1, 7),
(4, 4, 9),
(1, 1, 6),
(30, 5, 6),
(22, 2, 1),
(17, 2, 2),
(20, 5, 8),
(7, 2, 1),
(9, 4, 5),
(6, 1, 7);

-- Inserting shuffled data into the Undergoes table
-- not done
INSERT INTO Undergoes (AccountID, TransactionID, DestinationAccountID, TargetCurrency, SourceCurrency)
VALUES
(1, 1, null, 'EUR', 'EUR'),
(2, 2, null, 'USD', 'JPY'),
(3, 4, 13, 'USD', 'USD'),
(4, 9, null, 'LBP', 'USD'),
(5, 10, null, 'GBP', 'USD'),
(6, 13, null, 'EUR', 'USD'),
(5, 14, 5, 'USD', 'EUR'),
(5, 15, null, 'LBP', 'LBP'),
(7, 16, 11, 'LBP', 'USD'),
(6, 20, 9, 'EUR', 'LBP'),
(1, 21, null, 'USD', 'JPY'),
(2, 22, null, 'USD', 'USD'),
(5, 23, 17, 'USD', 'USD'),
(3, 24, null, 'EUR', 'USD'),
(4, 25, 4, 'USD', 'USD'),
(1, 26, null, 'EUR', 'EUR'),
(2, 27, 18, 'USD', 'USD'),
(7, 28, 14, 'USD', 'LBP'),
(14, 29, null, 'USD', 'EUR'),
(4, 30, 16, 'EUR', 'USD'),
(1, 31, NULL, 'USD', 'USD'),
(4, 32, NULL, 'JPY', 'USD');  

-- Inserting data into the PhoneNumber table
INSERT INTO PhoneNumber (CustomerID, PhoneNum)
VALUES
(1, '+1-123-456-7890'),
(2, '+1-987-654-3210'),
(3, '+961-71-234567'),
(4, '+961-76-543210'),
(5, '+44-20-1234-5678'),
(6, '+1-234-567-8901'),
(7, '+961-81-987654'),
(8, '+44-20-9876-5432'),
(9, '+1-345-678-9012'),
(10, '+61-2-9876-5432'),
(11, '+44-20-8765-4321'),
(12, '+961-70-987654'),
(13, '+1-555-123-4567'),
(14, '+44-20-3456-7890'),
(15, '+961-81-987654'),
(16, '+1-123-987-6543'),
(17, '+961-70-987654'),
(18, '+44-20-8765-4321'),
(19, '+61-2-9876-5432'),
(20, '+1-555-123-4567'),
(21, '+44-20-3456-7890'),
(22, '+961-71-234567'),
(23, '+961-76-543210'),
(24, '+44-20-1234-5678'),
(25, '+1-234-567-8901'),
(26, '+961-81-987654'),
(27, '+44-20-9876-5432'),
(28, '+1-345-678-9012'),
(29, '+61-2-9876-5432'),
(30, '+1-123-987-6543'),
(1, '+961-76-123456'),
(2, '+1-555-987-6543'),
(3, '+44-20-8765-1234'),
(4, '+61-2-3456-7890'),
(5, '+961-70-987123'),
(6, '+1-555-987-3210'),
(7, '+44-20-8765-4321'),
(8, '+961-71-987654'),
(8, '+961-71-917654'),
(8, '+961-71-917614'),
(9, '+61-2-9876-9876'),
(1, '+961-71-123455');

-- Basic Queries
-- Task 1:
-- Select employees that work in IT who live in the US and make over 90 thousand a year, 
-- or work in Customer support but make less than 80 thousand a year
-- Display their name, salary, sex, and age
SELECT  
	ename, 
    salary, 
    esex, 
    age
FROM employee e
JOIN works_in w
	ON w.empid = e.employeeid
JOIN department d
	ON d.departmentID = w.depID
WHERE dname = 'Information Technology' AND salary > 90000
UNION 
SELECT  
	ename, 
    salary, 
    esex, 
    age
FROM employee e
JOIN works_in w
	ON w.empid = e.employeeid
JOIN department d
	ON d.departmentID = w.depID
WHERE dname = 'Customer Support' AND salary < 80000;

-- Task 2:
-- Showcase which branches have the highest average transactions for each country
-- display the branch id, name, country, and average transactions ordered descending by the 
-- average transactions and country name. Round the average to 2 decimal places
SELECT
	b.BranchID,
    BranchName,
    BranchCountry,
    ROUND(AVG(amount), 2) AS average_transactions
FROM Branch b
NATURAL JOIN transaction
GROUP BY b.BranchID, BranchName, BranchCountry
ORDER BY BranchCountry, ROUND(AVG(amount), 2) DESC;

-- Task 3:
-- Display the average balance and average loan per account type
-- Show the Account type, average balance, and average loan.
-- Round the averages to 2 decimal places
SELECT
    AccountType,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(AVG(Amount), 2) AS average_loan_amount
FROM Account a
JOIN Loan USING(AccountID)
GROUP BY  AccountType;

-- Task 4:
-- For each customer whose first name starts with a J or an A
-- , display the amount of money in their cryptowallets as well as the
-- crypto currencies in them
-- Display the customer's full name, balance, and currency name

SELECT
	concat(CFirstName,' ', CLastName) AS full_name,
    balance,
    currencyName
FROM customer c
JOIN CryptoWallet cw
	ON c.CustomerID = cw.CustomerID
JOIN contains con
	ON con.WalletID = cw.PrivateKey
JOIN CryptoCurrency cc
	ON cc.CryptoID = con.CryptoID
WHERE CFirstName LIKE 'J%' OR CFirstName LIKE 'A%';

-- Task 5:
-- Display the average number of views per month 

SELECT
    EXTRACT(MONTH FROM publicationDate) As month,
	AVG(views) as average_views
FROM CryptoNews cn
GROUP BY EXTRACT(MONTH FROM publicationDate);

-- Task 6:
-- display the total number of transactions per account.
-- The final output should contain the accountID, customer's full name,
-- and the total number of transactions


SELECT 
	a.AccountID,
    CONCAT(CFirstName, ' ', CLastName) AS full_name,
    COALESCE(SUM(t.TransactionID), 0) AS total_number_of_transactions
FROM Customer c
JOIN Account a
	ON a.CustomerID = c.CustomerID
JOIN Undergoes u
	ON u.AccountID = a.AccountID
LEFT JOIN transaction t
	ON t.TransactionID = u.TransactionID
GROUP BY a.AccountID, CONCAT(CFirstName, ' ', CLastName);

-- Task 7:
-- For each employee that has at least one child that is over 10, showcase his/her
-- name, salary, department, sex, and age

SELECT
	ename,
    salary,
    dname,
    esex,
    age
FROM employee e
JOIN works_in wi
	ON wi.empID = e.EmployeeID
JOIN Department d
	ON d.DepartmentID = wi.DepID
WHERE EmployeeID IN (SELECT EmpID FROM dependant
					WHERE TIMESTAMPDIFF(YEAR, dateOFBirth, current_date()) > 10 and relationship = 'Child');

-- Task 8:
-- Select the top 5 countries in terms of average loan amounts
-- Order the results from highest to lowest

SELECT
    cCountry As Country,
	AVG(amount) AS average_loan_amount
FROM customer c
JOIN loan l
	ON l.CustomerID = c.CustomerID
GROUP BY cCountry
ORDER BY AVG(amount) DESC
LIMIT 5;

-- Task 9:
-- Find out where most customers' phone numbers are registered
-- display the count of customers while grouping by the telephone country code
-- Order the results by the count of customers from highest to lowest

SELECT
	LEFT(PhoneNum,LOCATE('-', PhoneNum) - 1) AS country_code,
    COUNT(CustomerID) as Number_of_customers
FROM Phonenumber
GROUP BY LEFT(PhoneNum,LOCATE('-', PhoneNum) - 1)
ORDER BY COUNT(CustomerID) DESC;

-- Task 10:
-- What is the total amount of cash available in ATMs across different countries
-- Showcase only countries that have more or equal to the average of the total amount of money
-- Across countries 

SELECT
	ATMCity,
	ROUND(SUM(cashbalance)) As Total_cash_available
FROM ATM
GROUP BY ATMCity
HAVING ROUND(SUM(CashBalance)) > 
	(SELECT 
		AVG((Total_cash_available)) 
	FROM (
		SELECT
			ATMCity,
			ROUND(SUM(cashbalance)) As Total_cash_available
		FROM ATM
		GROUP BY ATMCity) 
	AS subquery) ;

-- Task 11: 
-- Show the total number of students per major who have taken a loan
-- The result should contain the number of students aggregated by the major
SELECT
	SUBSTRING(UniversityInfo, LOCATE(',', UniversityInfo) +2) AS major,
    COUNT(DISTINCT c.customerID) AS number_of_students
FROM StudentLoan sl
JOIN Loan l
	ON sl.LoanID = l.LoanID
JOIN customer c
	ON c.CustomerID = l.CustomerID
GROUP BY SUBSTRING(UniversityInfo, LOCATE(',', UniversityInfo) +2) 
ORDER BY number_of_students DESC;

-- Task 12:
-- What is the number of transactions per country

SELECT 
	COUNT(transactionID) AS number_of_transactions,
    BranchCountry
FROM Branch b
LEFT JOIN transaction t
	ON b.BranchID = t.BranchID
GROUP BY BranchCountry;

-- Task 13:
-- For customers who have accounts in UK branches, display their total balance.
-- The result should include the id, full name, balance and should be ordered in alphabetical order
SELECT 
	c.CustomerID,
    CONCAT(cFirstName, ' ', CLastName) AS full_name,
    balance
FROM customer c
JOIN account a
	ON c.CustomerID = a.CustomerID
JOIN Branch b
	ON b.BranchID = a.BranchID
WHERE BranchCountry = 'UK'
ORDER BY full_name;


-- Task 14:
-- For each employee, display their supervisor
-- The result should showcase both the name of the employee and the supervisor as well as the IDs
WITH CTE AS (
SELECT ename, SuperviserID, EmployeeID FROM supervise s
RIGHT JOIN employee e
	ON e.Employeeid = s.superviseeId)
SELECT t1.ename AS employee,
	   COALESCE(t2.ename) AS superviserID,
       t1.employeeID,
       t2.employeeID AS superviserID
FROM CTE t1
LEFT JOIN CTE t2
ON t2.EmployeeID = t1.SuperviserID;

-- Task 15:
-- For every loan that is not personal, display what the amount will be in a year for 
-- every interest rate in the table
-- The interest 
WITH CTE AS (
	(SELECT 
	LoanID
	FROM Loan)
	EXCEPT
	(
	SELECT 
		LoanID
	FROM PersonalLoan))
SELECT 
	l1.amount, 
    l2.interestrate, 
    l1.amount*(1+l2.interestRate/100) AS amount_a_year_from_now 
FROM loan l1
JOIN CTE
	ON CTE.LoanID = l1.LoanID
cross join loan l2
ORDER BY amount DESC;


-- Task 16:
-- Do the same task as the previous one, only this time for Personal Loans only
WITH CTE AS (
	(SELECT 
	LoanID
	FROM Loan)
	INTERSECT
	(
	SELECT 
		LoanID
	FROM personalLoan))
SELECT 
	l1.amount, 
    l2.interestrate, 
    l1.amount*(1+l2.interestRate/100) AS amount_a_year_from_now 
FROM loan l1
JOIN CTE
	ON CTE.LoanID = l1.LoanID
cross join loan l2
ORDER BY amount DESC

-- Advanced Queries
-- Query 1
SELECT DISTINCT C.CustomerID, C.cFirstName, C.cLastName
FROM Customer C
WHERE C.CustomerID IN (
    SELECT CustomerID
    FROM Account A
    JOIN Undergoes u
		ON u.AccountID = A.AccountID
	JOIN Transaction T
		ON T.TransactionID = u.TransactionID
    WHERE T.Amount > 10000
);

-- Query 2
SELECT * 
FROM Employee E
WHERE Salary > 
	(SELECT 
		AVG(Salary) 
	FROM Employee WHERE BranchID = E.BranchID);
    
-- Query 3
SELECT COUNT(*) AS number_of_customers
FROM Customer
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Account
    GROUP BY CustomerID
    HAVING COUNT(AccountID) >= 2);

-- Query 4
SELECT E.EmployeeID, E.ename
FROM Employee E
WHERE E.BranchID IN (
    SELECT A.BranchID
    FROM CryptoWallet CW
    JOIN Customer C 
		ON CW.CustomerID = C.CustomerID
	JOIN Account A
		ON a.CustomerID = C.CustomerID
    WHERE CW.Balance > 10000
    AND a.CustomerID IN 
		(SELECT cw.CustomerID
		FROM CryptoCurrency cc
		JOIN contains c
			ON cc.CryptoID = c.CryptoID
		JOIN CryptoWallet CW
			ON CW.PrivateKey = c.WalletID
		JOIN customer cr
			ON cr.CustomerID = CW.CustomerID
		GROUP BY cw.customerID
		HAVING COUNT(DISTINCT WalletID) >= 2)
);

-- Query 5
SELECT CustomerID FROM Customer C
WHERE NOT EXISTS (
    (SELECT BranchID FROM Branch)
    EXCEPT
    (SELECT BranchID 
    FROM Account WHERE CustomerID = C.CustomerID)
);

-- Query 6
SELECT BranchID, AVG(Balance) AS AverageBalance
FROM (SELECT BranchID, Balance FROM Account) AS BranchBalances
GROUP BY BranchID;

-- Query 7
SELECT 
    B.BranchID, 
    B.BranchName, 
    (SELECT COUNT(*) FROM Employee WHERE BranchID = B.BranchID) AS EmployeeCount,
    (SELECT AVG(Salary) FROM Employee WHERE BranchID = B.BranchID) AS AverageSalary
FROM 
    Branch B;

-- Query 8
UPDATE CreditCard cc
JOIN Customer c ON c.CustomerID = cc.CustomerID
JOIN CryptoWallet CW ON CW.CustomerID = c.CustomerID
SET cc.CreditLimit = CASE 
    WHEN CW.Balance < 5000 THEN 10000
    WHEN CW.Balance BETWEEN 5000 AND 10000 THEN 15000
    ELSE 20000
END;

-- Query 9
SELECT EmployeeID, ename, dname
FROM Employee
LEFT OUTER JOIN Department 
	ON Employee.BranchID = Department.DepartmentID;

-- Query 10
CREATE ASSERTION MaxEmployeeLimit
CHECK (
    NOT EXISTS (
        SELECT BranchID
        FROM Employee
        GROUP BY BranchID
        HAVING COUNT(EmployeeID) > 100
    )
);

-- Query 11
CREATE VIEW CustomerLoanDetails AS
SELECT 
	c.CustomerID, 
    cFirstName, 
    cLastName, 
    SUM(Amount) AS TotalLoanAmount
FROM Customer c
JOIN Loan l
	ON c.CustomerID = l.CustomerID
GROUP BY CustomerID;

-- Query 12
DELIMITER $$

CREATE FUNCTION CalculateTotalBalance(customer_id INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN 
    DECLARE total_balance DECIMAL(10, 2) DEFAULT 0;
    SELECT SUM(Balance) INTO total_balance 
    FROM Account 
    WHERE CustomerID = customer_id;
    RETURN total_balance;
END$$

DELIMITER ;
SELECT CalculateTotalBalance(1);
SELECT CustomerID, CalculateTotalBalance(CustomerID) AS TotalBalance
FROM Customer;



-- Query 13
DELIMITER $$

CREATE FUNCTION CheckLoanEligibility(customer_id INT) 
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN 
    DECLARE eligibility VARCHAR(100);
    DECLARE total_balance DECIMAL(10, 2);
    DECLARE account_opening_date DATE;
    DECLARE years_with_bank INT;

    -- Calculate total balance
    SET total_balance = CalculateTotalBalance(customer_id);

    -- Find the earliest account opening date
    SELECT MIN(DateOpened) INTO account_opening_date 
    FROM Account 
    WHERE CustomerID = customer_id;

    -- Calculate the number of years with the bank
    SET years_with_bank = TIMESTAMPDIFF(YEAR, account_opening_date, CURDATE());

    -- Determine eligibility based on balance and years with bank
    IF total_balance >= 5000 AND years_with_bank >= 2 THEN
        SET eligibility = 'Eligible for loan';
    ELSE 
        SET eligibility = 'Not eligible for loan';
    END IF;

    RETURN eligibility;
END$$

DELIMITER ;
SELECT CheckLoanEligibility(1);

-- Query 14
DELIMITER $$

CREATE PROCEDURE UpdateCustomerAddress(
    IN cust_id INT, 
    IN new_country VARCHAR(30), 
    IN new_city VARCHAR(30), 
    IN new_zipcode VARCHAR(10), 
    IN new_street VARCHAR(255)
)
BEGIN
    UPDATE Customer
    SET cCountry = new_country, 
        cCity = new_city, 
        cZipcode = new_zipcode, 
        cStreet = new_street
    WHERE CustomerID = cust_id;
END$$

DELIMITER ;
CALL UpdateCustomerAddress(1, 'Lebanon', 'Saida', '00000', 'Zaroub Al Njasa');


-- Query 15
DELIMITER $$

CREATE PROCEDURE CreateNewAccount(
    IN account_type VARCHAR(20), 
    IN initial_balance DECIMAL(10, 2), 
    IN customer_id INT, 
    IN branch_id INT
)
BEGIN
    DECLARE new_account_id INT;

    -- Generate new AccountID
    SELECT IFNULL(MAX(AccountID), 0) + 1 INTO new_account_id FROM Account;

    -- Create new account
    INSERT INTO Account(AccountID, AccountType, Balance, DateOpened, CustomerID, BranchID)
    VALUES (new_account_id, account_type, initial_balance, CURDATE(), customer_id, branch_id);
END$$

DELIMITER ;
CALL CreateNewAccount('Savings', 1000.00, 1, 1);


