-- Create database
CREATE DATABASE SecurityDB;

-- Use the database
USE SecurityDB;

-- Create users table
CREATE TABLE Users (
  UserID INT PRIMARY KEY,
  Username VARCHAR(50) NOT NULL,
  PasswordHash VARCHAR(255) NOT NULL,
  Email VARCHAR(100) NOT NULL
);

-- Create bank accounts table
CREATE TABLE BankAccounts (
  AccountID INT PRIMARY KEY,
  UserID INT,
  AccountNumber VARCHAR(20) NOT NULL,
  AccountType VARCHAR(10) NOT NULL,
  Balance DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create login procedure
DELIMITER //
CREATE PROCEDURE Login(
  IN _username VARCHAR(50),
  IN _password VARCHAR(50)
)
BEGIN
  DECLARE _userID INT;
  SELECT UserID INTO _userID
  FROM Users
  WHERE Username = _username AND PasswordHash = MD5(_password);
  
  IF _userID IS NOT NULL THEN
    SELECT 'Login successful' AS Message;
  ELSE
    SELECT 'Invalid username or password' AS Message;
  END IF;
END//
DELIMITER ;

-- Create stored procedure to add new user
DELIMITER //
CREATE PROCEDURE AddUser(
  IN _username VARCHAR(50),
  IN _password VARCHAR(50),
  IN _email VARCHAR(100)
)
BEGIN
  INSERT INTO Users (Username, PasswordHash, Email)
  VALUES (_username, MD5(_password), _email);
END//
DELIMITER ;

-- Create stored procedure to add new bank account
DELIMITER //
CREATE PROCEDURE AddBankAccount(
  IN _userID INT,
  IN _accountNumber VARCHAR(20),
  IN _accountType VARCHAR(10),
  IN _balance DECIMAL(10, 2)
)
BEGIN
  INSERT INTO BankAccounts (UserID, AccountNumber, AccountType, Balance)
  VALUES (_userID, _accountNumber, _accountType, _balance);
END//
DELIMITER ;