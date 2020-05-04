CREATE Database Test;
USE Test;

DROP PROCEDURE IF EXISTS Cellphone 
DELIMITER //
CREATE PROCEDURE Cellphone()
  
BEGIN
  CREATE TABLE Research_And_Development(
	Development_ID varchar(5) NOT NULL PRIMARY KEY,
	Project_ID varchar(5) NOT NULL ,
    Start_Date datetime ,
    Details text ,
    Expected_Duration_Months int(3),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
  );
  CREATE TABLE Production(
	Product_ID varchar(5) NOT NULL PRIMARY KEY,
    Project_ID varchar(5) ,
	Product_Name varchar(30) ,
    Product_Category varchar(30),
    Quantity int(10),
    Department_head varchar(30),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
  );
  CREATE TABLE Warehouse(
	Store_ID varchar(5) NOT NULL PRIMARY KEY,
	Location varchar(30) ,
    Storage_Capacity varchar(30) default '3000 sq.m.',
    Remaining_Capacity varchar(30),
    Product_ID varchar(5),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8;
END; 

//
-- DELIMITER;


CALL Cellphone();

DROP DATABASE Test;
---------------------------------------------------------------------------- 
DROP PROCEDURE IF EXISTS FourWheeler 
DELIMITER //
CREATE PROCEDURE FourWheeler()
  
BEGIN
  CREATE TABLE Quality(
	Test_ID varchar(5) NOT NULL PRIMARY KEY,
	Test_Name varchar(5) NOT NULL,
    Test_Location varchar(30) ,
    Department_Head varchar(30) ,
    Test_Date datetime,
    Next_Test_Date datetime,
    Product_ID varchar(5),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
  );
  CREATE TABLE Production(
	Product_ID varchar(5) NOT NULL PRIMARY KEY, 
	Product_Name varchar(30) ,
    Product_Category varchar(30),
    Number_of_Parts int(10),
    Quantity int(10),
    Department_head varchar(30),
    Project_ID varchar(5) ,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
  );
  CREATE TABLE Maintenance(
	Ticket varchar(5) NOT NULL PRIMARY KEY,
    Ticket_Details text,
	Action_Date datetime ,
    Future_Action_Date datetime ,
    Requirements text,
    Department_Head varchar(30),
    Product_ID varchar(5),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8;
END; 

//


CALL FourWheeler();

-----------------------------------------------------------------------
DROP PROCEDURE IF EXISTS Mens 
DELIMITER //
CREATE PROCEDURE Mens()
  
BEGIN
  CREATE TABLE Design(
	Design_ID varchar(5) NOT NULL PRIMARY KEY,
	Design_Name varchar(5) NULL,
    Start_Date datetime ,
    No_Of_Team_Members int(4),
    Department_Head varchar(30),
    Project_ID varchar(5) ,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
  );
  CREATE TABLE Production(
	Product_ID varchar(5) NOT NULL PRIMARY KEY,
	Product_Name varchar(30) ,
    Product_Category varchar(30),
    Quantity int(10),
    Department_head varchar(30),
    Project_ID varchar(5) ,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
    
  );
  CREATE TABLE Marketing(
	Source_ID varchar(5) NOT NULL PRIMARY KEY,
	Source_Name varchar(20),
    Source_Category varchar(20),
    Air_Date datetime ,
    Sales_Target int(10),
    Department_Head varchar(30),
    Product_ID varchar(5),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8;
END; 

//


CALL Mens();
