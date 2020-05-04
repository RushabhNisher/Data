-- MySQL Workbench Forward Engineering
DROP SCHEMA IF EXISTS mydb;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Domain`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Domain` (
  `Domain_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Domain_Name` VARCHAR(20) NOT NULL,
  `No_Of_SubDomain` INT(3) NULL,
  UNIQUE INDEX `idDomain_UNIQUE` (`Domain_ID` ASC) ,
  PRIMARY KEY (`Domain_ID`),
  UNIQUE INDEX `Domain Name_UNIQUE` (`Domain_Name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Subdomain`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Subdomain` (
  `Subdomain_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Domain_ID` INT(10) NOT NULL,
  `SubDomain_Name` VARCHAR(25) NULL,
  `No_Of_Companies` INT(3) NULL,
  PRIMARY KEY (`Subdomain_ID`, `Domain_ID`),
  INDEX `fk_Subdomain_Domain_idx` (`Domain_ID` ASC) ,
  CONSTRAINT `fk_Subdomain_Domain`
    FOREIGN KEY (`Domain_ID`)
    REFERENCES `mydb`.`Domain` (`Domain_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Admin` (
  `Admin_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Admin_Name` VARCHAR(20) NULL,
  `Admin_Email_ID` VARCHAR(45) NULL,
  `Admin_Contact_Number` VARCHAR(20) NULL,
  PRIMARY KEY (`Admin_ID`),
  UNIQUE INDEX `idowner_UNIQUE` (`Admin_ID` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Company` (
  `Company_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Admin_ID` INT(10) NOT NULL,
  `Company_Name` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(100) NULL,
  `Contact_Number` VARCHAR(20) NULL,
  `Email_ID` VARCHAR(45) NULL,
  `No_Of_Department` INT(10) NULL,
  `No_Of_Employees` INT(6) NULL,
  PRIMARY KEY (`Company_ID`),
  UNIQUE INDEX `idCompany_UNIQUE` (`Company_ID` ASC) ,
  INDEX `fk_Company_Admin1_idx` (`Admin_ID` ASC) ,
  CONSTRAINT `fk_Company_Admin1`
    FOREIGN KEY (`Admin_ID`)
    REFERENCES `mydb`.`Admin` (`Admin_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `mydb`.`Company_has_Subdomain`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Company_has_Subdomain` (
  `Company_idCompany` INT(10) NOT NULL,
  `Subdomain_idSubdomain` INT(10) NOT NULL,
  `Subdomain_Domain_idDomain` INT(10) NOT NULL,
  PRIMARY KEY (`Company_idCompany`, `Subdomain_idSubdomain`, `Subdomain_Domain_idDomain`),
  INDEX `fk_Company_has_Subdomain_Subdomain1_idx` (`Subdomain_idSubdomain` ASC, `Subdomain_Domain_idDomain` ASC) ,
  INDEX `fk_Company_has_Subdomain_Company1_idx` (`Company_idCompany` ASC) ,
  CONSTRAINT `fk_Company_has_Subdomain_Company1`
    FOREIGN KEY (`Company_idCompany`)
    REFERENCES `mydb`.`Company` (`Company_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Company_has_Subdomain_Subdomain1`
    FOREIGN KEY (`Subdomain_idSubdomain` , `Subdomain_Domain_idDomain`)
    REFERENCES `mydb`.`Subdomain` (`Subdomain_ID` , `Domain_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Department_Catalog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Department_Catalog` (
  `Department_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Company_id` INT(10) NOT NULL DEFAULT 1,
  `Department_Name` VARCHAR(30) NULL,
  `Department_Head` VARCHAR(20) NULL,
  `No_Of_Employees` INT(5) NULL,
  PRIMARY KEY (`Department_ID`),
  UNIQUE INDEX `idDepartment_Catalog_UNIQUE` (`Department_ID` ASC) ,
  INDEX `fk_Department_Catalog_Company1_idx` (`Company_id` ASC) ,
  CONSTRAINT `fk_Department_Catalog_Company1`
    FOREIGN KEY (`Company_id`)
    REFERENCES `mydb`.`Company` (`Company_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Finance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Finance` (
  `Transaction_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Department_Catalog_idDepartment_Catalog` INT(10) NOT NULL DEFAULT 4,
  `Transaction_Type` VARCHAR(95) NULL,
  `Transaction_Ref` VARCHAR(45) NOT NULL,
  `Transaction_Amount` INT(10) NULL,
  `Transaction_Date` DATE NULL,
  PRIMARY KEY (`Transaction_ID`),
  UNIQUE INDEX `idDepartment_Finance_UNIQUE` (`Transaction_ID` ASC) ,
  INDEX `fk_Department_Finance_Department_Catalog1_idx` (`Department_Catalog_idDepartment_Catalog` ASC) ,
  CONSTRAINT `fk_Department_Finance_Department_Catalog1`
    FOREIGN KEY (`Department_Catalog_idDepartment_Catalog`)
    REFERENCES `mydb`.`Department_Catalog` (`Department_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Hiring`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Hiring` (
  `Hiring_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Department_Catalog_idDepartment_Catalog` INT(10) NOT NULL DEFAULT 5,
  `Joining_Date` DATE NULL,
  `End_Date` DATE NULL,
  `Salary` INT(6) NULL,
  PRIMARY KEY (`Hiring_ID`),
  UNIQUE INDEX `idDepartment_Hiring_UNIQUE` (`Hiring_ID` ASC) ,
  INDEX `fk_Department_Hiring_Department_Catalog1_idx` (`Department_Catalog_idDepartment_Catalog` ASC) ,
  CONSTRAINT `fk_Department_Hiring_Department_Catalog1`
    FOREIGN KEY (`Department_Catalog_idDepartment_Catalog`)
    REFERENCES `mydb`.`Department_Catalog` (`Department_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Employee` (
  `Employee_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Department_Hiring_idDepartment_Hiring` INT(10) NOT NULL,
  `Employee_Name` VARCHAR(45) NULL,
  `Department_ID` INT(10) NOT NULL,
  `Employee_Email` VARCHAR(45) NULL,
  `Employee_Address` VARCHAR(100) NULL,
  `Employee_Phone_Number` VARCHAR(20) NULL,
  `Role` VARCHAR(10) NULL,
  PRIMARY KEY (`Employee_ID`),
  UNIQUE INDEX `idEmployee_UNIQUE` (`Employee_ID` ASC) ,
  INDEX `fk_Employee_Department_Hiring1_idx` (`Department_Hiring_idDepartment_Hiring` ASC) ,
  INDEX `fk_Employee_Employee2_idx` (`Employee_Name` ASC) ,
  CONSTRAINT `fk_Employee_Department_Hiring1`
    FOREIGN KEY (`Department_Hiring_idDepartment_Hiring`)
    REFERENCES `mydb`.`Hiring` (`Hiring_ID`),
    FOREIGN KEY (Department_ID) REFERENCES mydb.Department_Catalog (Department_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Product_Service_Catalog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Product_Service_Catalog` (
  `Product_Service_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Company_ID` INT(10) NOT NULL,
  `PS_Name` VARCHAR(45) NULL,
  `PS_Type` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Product_Service_ID`),
  UNIQUE INDEX `idProduct_Service_UNIQUE` (`Product_Service_ID` ASC) ,
  INDEX `fk_Product_Service_Catalog_Company1_idx` (`Company_ID` ASC) ,
  CONSTRAINT `fk_Product_Service_Catalog_Company1`
    FOREIGN KEY (`Company_ID`)
    REFERENCES `mydb`.`Company` (`Company_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Product` (
  `Product_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Product_Service_Catalog_idProduct_Service_Catalog` INT(10) NULL,
  `Product_Name` VARCHAR(45) NULL,
  `Product_Price` INT(10) NULL,
  `Product_Qty` INT(10) NULL,
  `Product_Details` VARCHAR(100) NULL,
  PRIMARY KEY (`Product_ID`),
  UNIQUE INDEX `idProduct_UNIQUE` (`Product_ID` ASC) ,
  INDEX `fk_Product_Product_Service_Catalog1_idx` (`Product_Service_Catalog_idProduct_Service_Catalog` ASC) ,
  CONSTRAINT `fk_Product_Product_Service_Catalog1`
    FOREIGN KEY (`Product_Service_Catalog_idProduct_Service_Catalog`)
    REFERENCES `mydb`.`Product_Service_Catalog` (`Product_Service_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Project`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Project` (
  `Project_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Product_idProduct` INT(10) NOT NULL,
  `Project_Name` VARCHAR(45) NULL,
  `No_Of_Employees` INT(3) NULL,
  `Budget` INT(10) NULL,
  `Start_Date` DATE NULL,
  `End_Date` DATE NULL,
  PRIMARY KEY (`Project_ID`, `Product_idProduct`),
  UNIQUE INDEX `idProject_UNIQUE` (`Project_ID` ASC) ,
  INDEX `fk_Project_Product1_idx` (`Product_idProduct` ASC) ,
  CONSTRAINT `fk_Project_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `mydb`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Service` (
  `Service_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Product_Service_Catalog_idProduct_Service_Catalog` INT(10) NULL,
  `Service_Name` VARCHAR(45) NULL,
  `Service_Charge` INT(5) NULL,
  PRIMARY KEY (`Service_ID`),
  UNIQUE INDEX `idService_UNIQUE` (`Service_ID` ASC) ,
  INDEX `fk_Service_Product_Service_Catalog1_idx` (`Product_Service_Catalog_idProduct_Service_Catalog` ASC) ,
  CONSTRAINT `fk_Service_Product_Service_Catalog1`
    FOREIGN KEY (`Product_Service_Catalog_idProduct_Service_Catalog`)
    REFERENCES `mydb`.`Product_Service_Catalog` (`Product_Service_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Employee_has_Project`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Employee_has_Project` (
  `Employee_idEmployee` INT(10) NOT NULL,
  `Project_idProject` INT(10) NOT NULL,
  `Project_Product_idProduct` INT(10) NOT NULL,
  PRIMARY KEY (`Employee_idEmployee`, `Project_idProject`, `Project_Product_idProduct`),
  INDEX `fk_Employee_has_Project_Project1_idx` (`Project_idProject` ASC, `Project_Product_idProduct` ASC) ,
  INDEX `fk_Employee_has_Project_Employee1_idx` (`Employee_idEmployee` ASC) ,
  CONSTRAINT `fk_Employee_has_Project_Employee1`
    FOREIGN KEY (`Employee_idEmployee`)
    REFERENCES `mydb`.`Employee` (`Employee_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_has_Project_Project1`
    FOREIGN KEY (`Project_idProject` , `Project_Product_idProduct`)
    REFERENCES `mydb`.`Project` (`Project_ID` , `Product_idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Service_has_Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Service_has_Employee` (
  `Service_ID` INT(10) NOT NULL,
  `Employee_ID` INT(10) NOT NULL,
  PRIMARY KEY (`Service_ID`, `Employee_ID`),
  INDEX `fk_Service_has_Employee_Employee1_idx` (`Employee_ID` ASC) ,
  INDEX `fk_Service_has_Employee_Service1_idx` (`Service_ID` ASC) ,
  CONSTRAINT `fk_Service_has_Employee_Service1`
    FOREIGN KEY (`Service_ID`)
    REFERENCES `mydb`.`Service` (`Service_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Service_has_Employee_Employee1`
    FOREIGN KEY (`Employee_ID`)
    REFERENCES `mydb`.`Employee` (`Employee_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Supplier` (
  `Supplier_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Supplier_Name` VARCHAR(190) NULL,
  `Supplier_Address` VARCHAR(100) NULL,
  `Supplier_Email_ID` VARCHAR(45) NULL,
  `Supplier_Phone_Number` VARCHAR(20) NULL,
  PRIMARY KEY (`Supplier_ID`),
  UNIQUE INDEX `idSupplier_UNIQUE` (`Supplier_ID` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Client` (
  `Client_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Client_Name` VARCHAR(195) NULL,
  `Client_Address` VARCHAR(100) NULL,
  `Client_Email_ID` VARCHAR(45) NULL,
  `Client_Phone_Number` VARCHAR(20) NULL,
  PRIMARY KEY (`Client_ID`),
  UNIQUE INDEX `idClient_UNIQUE` (`Client_ID` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Order` (
  `Order_ID` INT(10) NOT NULL AUTO_INCREMENT,
  `Supplier_ID` INT(10) DEFAULT NULL,
  `Client_ID` INT(10) DEFAULT NULL,
  `Order_Type` VARCHAR(3) NULL,
  `Order_Name` VARCHAR(45) NULL,
  `Order_Value` INT(7) NULL,
  `Order_Status` VARCHAR(10) NULL,
  `Department_Finance_Transaction_ID` INT(10) NOT NULL,
  PRIMARY KEY (`Order_ID`),
  INDEX `fk_Order_Supplier1_idx` (`Supplier_ID` ASC) ,
  INDEX `fk_Order_Client1_idx` (`Client_ID` ASC) ,
  INDEX `fk_Order_Department_Finance1_idx` (`Department_Finance_Transaction_ID` ASC) ,
  CONSTRAINT `fk_Order_Supplier1`
    FOREIGN KEY (`Supplier_ID`)
    REFERENCES `mydb`.`Supplier` (`Supplier_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Client1`
    FOREIGN KEY (`Client_ID`)
    REFERENCES `mydb`.`Client` (`Client_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_Department_Finance1`
    FOREIGN KEY (`Department_Finance_Transaction_ID`)
    REFERENCES `mydb`.`Finance` (`Transaction_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Product_has_Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Product_has_Order` (
  `Product_ID` INT(10) NOT NULL,
  `Order_ID` INT(10) NOT NULL,
  PRIMARY KEY (`Product_ID`, `Order_ID`),
  INDEX `fk_Product_has_Order_Order1_idx` (`Order_ID` ASC) ,
  INDEX `fk_Product_has_Order_Product1_idx` (`Product_ID` ASC) ,
  CONSTRAINT `fk_Product_has_Order_Product1`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_has_Order_Order1`
    FOREIGN KEY (`Order_ID`)
    REFERENCES `mydb`.`Order` (`Order_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

 -- ------------------------------------------------------------------------------------------------------------------------------
-- Procedures
-- --------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Cellphone 
DELIMITER //
CREATE PROCEDURE Cellphone()
  
BEGIN
  CREATE TABLE Research_And_Development(
	Development_ID INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 1,
	Project_ID INT(10) NOT NULL ,
    Start_Date DATE ,
    Details TEXT ,
    Expected_Duration_Months INT(3),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID),
	FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
  );
  CREATE TABLE Production(
	Product_ID INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 2,
    Project_ID INT(10) ,
	Product_Name VARCHAR(70) ,
    Product_Category VARCHAR(70),
    Quantity INT(10),
    Department_head VARCHAR(70),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID),
    FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
  );
  CREATE TABLE Warehouse(
	Store_ID INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 3,
	Location VARCHAR(70) ,
    Storage_Capacity VARCHAR(50) default '3000 sq.m.',
    Remaining_Capacity VARCHAR(50) default '0 sq.m.',
    Product_ID INT(10),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8;
END; 

//

-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS FourWheeler 
DELIMITER //
CREATE PROCEDURE FourWheeler()
  
BEGIN
  CREATE TABLE Quality(
	Test_ID INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 1,
	Test_Name VARCHAR(5) NOT NULL,
    Test_Location VARCHAR(30) ,
    Department_Head VARCHAR(30) ,
    Test_Date DATE,
    Next_Test_Date DATE,
    Product_ID INT(10),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
  );
  CREATE TABLE Production(
	Product_ID INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 2,
	Product_Name VARCHAR(30) ,
    Product_Category VARCHAR(30),
    Number_of_Parts INT(10),
    Quantity INT(10),
    Department_head VARCHAR(30),
    Project_ID INT(10) ,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID),
    FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
  );
  CREATE TABLE Maintenance(
	Ticket INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 3,
    Ticket_Details TEXT,
	Action_Date DATE ,
    Future_Action_Date DATE ,
    Requirements TEXT,
    Department_Head VARCHAR(30),
    Product_ID INT(10),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8;
END; 

//


-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS Mens 
DELIMITER //
CREATE PROCEDURE Mens()
  
BEGIN
  CREATE TABLE Design(
	Design_ID INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 1,
	Design_Name VARCHAR(20) NULL,
    Start_Date date ,
    No_Of_Team_Members INT(4),
    Department_Head VARCHAR(30),
    Project_ID INT(10) ,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID),
    FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
  );
  CREATE TABLE Production(
	Product_ID INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 2,
	Product_Name VARCHAR(30) ,
    Product_Category VARCHAR(30),
    Quantity INT(10),
    Department_head VARCHAR(30),
    Project_ID INT(10) ,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID),
    FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
    
  );
  CREATE TABLE Marketing(
	Source_ID INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Department_Catalog_idDepartment_Catalog INT(10) NOT NULL DEFAULT 3,
	Source_Name VARCHAR(20),
    Source_Category VARCHAR(20),
    Air_Date DATE ,
    Sales_Target INT(10),
    Department_Head VARCHAR(30),
    Product_ID INT(10),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    FOREIGN KEY (Department_Catalog_idDepartment_Catalog) REFERENCES mydb.Department_Catalog (Department_ID)
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8;
END; 

//


CALL Cellphone();
-- CALL FourWheeler();
-- CALL Mens();
 -- ------------------------------------------------------------------------------------------------------------------------------
-- DML
-- --------------------------------------------------------------------------------------------------------------------------------

-- Domain;
INSERT INTO Domain (Domain_ID, Domain_Name, No_Of_SubDomain)
VALUES 
(1, 'Technology Sector',1),
(2, 'Automobile Sector',1),
(3, 'Fashion Sector',1);

-- SubDomain;
INSERT INTO Subdomain (Subdomain_ID, Domain_ID, SubDomain_Name, No_Of_Companies)
VALUES 
(1, 1, 'Cellphone', 3),
(2, 2, 'Cars', 3),
(3, 3, 'Mens Apparel', 3);

-- Admin;
INSERT INTO Admin (Admin_ID, Admin_Name, Admin_Email_ID, Admin_Contact_Number)
VALUES 
(1,'John Smith','johns@onthefly.com','965-431-7394'),
(2,'Jane Welch','janew@onthefly.com','397-545-0767'),
(3,'Robert Frost','robertf@onthefly.com','321-405-2494'),
(4,'Rana Beard','ranab@onthefly.com','658-212-8073'),
(5,'Natalie Coffey','nataliec@onthefly.com','630-813-3351'),
(6,'Talon Neal','talonn@onthefly.com','203-322-4776'),
(7,'Meghan Mcclain','meghanm@onthefly.com','230-730-9852'),
(8,'Hamilton Gould','hamiltong@onthefly.com','605-919-9725'),
(9,'Wallace Willis','wallacew@onthefly.com','820-526-9346'),
(10,'Conan Frazier','conanf@onthefly.com','660-617-6904');

-- Company;
INSERT INTO Company (Company_ID, Admin_ID, Company_Name, Address, Contact_Number, Email_ID, No_Of_Department, No_Of_Employees)
VALUES 
(1,1,'Apple','24 Ruskin Terrace','573-931-7359','customersupport@apple.com',5,408910),
(2,2,'Tesla','65 Forest Court','422-790-3263','customersupport@tesla.com',5,556900),
(3,3,'Calvin Klein','9695 Bluestem Avenue','543-555-5474','customersupport@ck.com',5,346876),
(4,4,'Motorola','76 Ridge Oak Crossing','542-774-6351','customersupport@motorola.com',5,356000),
(5,5,'Lexus','621 Gina Avenue','344-102-1435','customersupport@lexus.com',5,125630),
(6,6,'Kenneth Cole','1 Veith Parkway','331-679-7715','customersupport@kencole.com',5,456789),
(7,7,'Samsung','4 Kingsford Parkway','922-196-0597','customersupport@samsung.com',5,987123),
(8,8,'Chevrolet','54 East Street','817-722-5871','customersupport@chevrolet.com',5,587308),
(9,9,'Brooke Brothers','70 South Street','121-188-3909','customersupport@bbrothers.com',5,7530),
(10,10,'One Plus','72 Schiller Avenue','549-783-5218','customersupport@oneplus.com',5,39620);

-- Company_has_Subdomain;
INSERT INTO Company_has_Subdomain (Company_idCompany, Subdomain_idsubdomain, Subdomain_Domain_idDomain)
VALUES 
(1,1,1),
(2,2,2),
(3,3,3),
(4,1,1),
(5,2,2),
(6,3,3),
(7,1,1),
(8,2,2),
(9,3,3),
(10,1,1);

-- Department Catalog;
INSERT INTO Department_Catalog (Department_ID, Company_ID, Department_Name,Department_Head, No_Of_Employees)
VALUES 
(1, 1, 'Research_And_Development','Tawsha Mattia', 200),
(2, 1, 'Production','Dalt MacIlory', 100),
(3, 1, 'Warehouse','Burr Goodsall', 100),
(4, 1, 'Finance','Michele Skidmore', 20),
(5, 1, 'Hiring','Kiah Koschek', 30);


-- Client
INSERT INTO mydb.Client (Client_ID, Client_Name, Client_Address, Client_Email_ID, Client_Phone_Number) VALUES 
(1, 'Freshpet, Inc.', '7330 Raven Place', 'vbicker0@istockphoto.com', '519-582-6829'),
(2, 'Western Asset Municipal High Income Fund, Inc.', '395 Ramsey Way', 'abinch1@multiply.com', '564-906-8600'),
(3, 'PowerShares DWA Basic Materials Momentum Portfolio', '3632 Forest Run Way', 'zchristophers2@livejournal.com', '531-646-5331'),
(4, 'United States Cellular Corporation', '42 Mallory Pass', 'dbonnin3@reverbnation.com', '199-221-6647'),
(5, 'Washington Prime Group Inc.', '6 3rd Place', 'mdechastelain4@businesswire.com', '778-887-4144'),
(6, 'General Electric Capital Corporation', '3017 Roth Court', 'fcheavin5@cornell.edu', '395-411-6131'),
(7, 'Tempur Sealy International, Inc.', '30819 Cottonwood Avenue', 'eswetland6@dailymail.co.uk', '360-153-5638'),
(8, 'Akari Therapeutics Plc', '25 Hoard Way', 'rireland7@360.cn', '775-698-4915'),
(9, 'Innovative Solutions and Support, Inc.', '6 Independence Plaza', 'bomohun8@intel.com', '446-259-2140'),
(10, 'Penns Woods Bancorp, Inc.', '84 John Wall Crossing', 'bosgerby9@hc360.com', '531-145-6752');

-- Supplier
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Supplier_Address, Supplier_Email_ID, Supplier_Phone_Number) VALUES
(1, 'Till Capital Ltd.', '309 Golden Leaf Parkway', 'pfarralla@purevolume.com', '550-877-1960'),
(2, 'DAQO New Energy Corp.', '01738 Old Shore Junction', 'mthreadgouldb@scientificamerican.com', '282-658-8810'),
(3, 'CytRx Corporation', '15 Tomscot Center', 'wmcmeekinc@theglobeandmail.com', '282-827-4555'),
(4, 'First Foundation Inc.', '62 Tony Parkway', 'amckelvied@nature.com', '239-887-9548'),
(5, 'Eagle Bancorp Montana, Inc.', '0764 Nevada Drive', 'alibermoree@purevolume.com', '799-290-1169'),
(6, 'EPR Properties', '53211 Mariners Cove Place', 'jworkmanf@tumblr.com', '209-186-2914'),
(7, 'Condor Hospitality Trust, Inc.', '19 Pawling Plaza', 'groccog@flickr.com', '296-595-5143'),
(8, 'SandRidge Mississippian Trust I', '38839 Transport Place', 'irosebladeh@thetimes.co.uk', '948-254-1611'),
(9, 'Global X NASDAQ China Technology ETF', '3928 Old Gate Park', 'fsecretani@illinois.edu', '749-853-4364'),
(10, 'V.F. Corporation', '52399 Sherman Plaza', 'zcaseleyj@redcross.org', '321-953-2332');


-- Product Service Catalog;
INSERT INTO Product_Service_Catalog(Product_Service_ID , Company_ID, PS_Name , PS_Type)
VALUES
(1, 1, 'iphone X', 'P'),
(2, 1, 'iphone XS', 'P'),
(3, 1, 'iphone XR', 'P'),
(4, 1, 'ipad Air', 'P'),
(5, 1, 'iphone Pro', 'P'),
(6, 1, 'Laptop Repair' , 'S'),
(7, 1, 'Mobile Repair' , 'S'),
(8, 1, 'Customer Service' , 'S'),
(9, 1, 'Quality Assurance', 'S');

-- Product;
INSERT INTO Product (Product_ID, Product_Service_Catalog_idProduct_Service_Catalog , Product_Name, Product_Price, Product_Qty, Product_Details)
VALUES
(1, 1, 'iphone X', 999, 10,'Smartphone'),
(2, 2, 'iphone XS', 1050, 10,'Smartphone'),
(3, 3, 'iphone XR', 1123, 10,'Smartphone'),
(4, 4, 'ipad Air', 789, 10,'Tablet'),
(5, 5, 'ipad Pro', 850, 10,'Tablet');

-- Service;
INSERT INTO Service (Service_ID,Product_Service_Catalog_idProduct_Service_Catalog, Service_Name,Service_Charge)
VALUES
(1, 6, 'Laptop Repair', 150),
(2, 7, 'Mobile Repair', 100),
(3, 8, 'Customer Service', 50),
(4, 9, 'Quality Assurance', 120);

-- Project;
INSERT INTO Project (Project_ID, Product_idProduct, Project_Name, No_Of_Employees, Budget, Start_Date, End_Date)
VALUES
(1, 1, 'IP-X', 6, 50000000, '2015-05-17', '2018-05-15'),
(2, 2, 'IP-XS', 6, 46000000, '2016-06-28', '2019-09-12'),
(3, 3, 'IP-XR', 6, 76700000, '2016-02-02', '2019-04-25'),
(4, 4, 'IP-Air', 6, 24598000, '2014-01-03', '2017-08-08'),
(5, 5, 'IP-Pro', 6, 23695000, '2014-01-03', '2017-08-08');


-- Finance
INSERT INTO Finance (Transaction_ID, Department_Catalog_idDepartment_Catalog, Transaction_Type, Transaction_Ref, Transaction_Amount, Transaction_Date)
VALUES
(1, 4, 'Accounts Payable','SL_1','85370','2017-09-12'),
(2, 4, 'Accounts Receivable', 'CL_1','873464','2018-06-26'),
(3, 4, 'Accounts Receivable', 'CL_2','4500','2018-07-01'),
(4, 4, 'Accounts Receivable', 'SL_6','877664','2018-06-26'),
(5, 4, 'Accounts Payable', 'SL_2','985464','2015-03-21'),
(6, 4, 'Accounts Receivable','CL_7','97380','2016-10-01'),
(7, 4, 'Accounts Payable','SL_9','58070','2018-06-12'),
(8, 4, 'Accounts Payable','SL_8','82350','2019-01-10'),
(9, 4, 'Accounts Receivable','CL_9','46989','2018-11-26'),
(10, 4, 'Accounts Receivable','CL_5','17633','2018-12-12');
 

-- Hiring:                         
INSERT INTO Hiring (Hiring_ID, Department_Catalog_idDepartment_Catalog, Joining_Date, End_Date, Salary)
VALUES
(1, 5, '2018-05-11', null, 62926),
(2, 5, '2018-04-21', null, 95871),
(3, 5, '2018-04-10', null, 68696),
(4, 5, '2018-05-09', null, 74542),
(5, 5, '2018-05-11', null, 66617),
(6, 5, '2018-04-24', null, 51350),
(7, 5, '2018-04-12', null, 59039),
(8, 5, '2018-05-18', null, 94588),
(9, 5, '2018-05-18', null, 94588),
(10, 5, '2018-05-17', null, 98979),
(11, 5, '2018-04-22', null, 66619),
(12, 5, '2018-05-20', null, 47163),
(13, 5, '2018-04-08', null, 99552),
(14, 5, '2018-04-28', null, 59619),
(15, 5, '2018-04-15', null, 60042),
(16, 5, '2018-04-16', null, 98653),
(17, 5, '2018-04-21', null, 70294),
(18, 5, '2018-05-30', null, 92955),
(19, 5, '2018-05-01', null, 46213),
(20, 5, '2018-04-14', null, 65654),
(21, 5, '2018-05-14', null, 70240),
(22, 5, '2018-05-20', null, 52759),
(23, 5, '2018-04-09', null, 59331),
(24, 5, '2018-05-27', null, 77959),
(25, 5, '2018-04-15', null, 91163),
(26, 5, '2018-05-23', null, 95234),
(27, 5, '2018-05-17', null, 49295),
(28, 5, '2018-04-13', null, 45606),
(29, 5, '2018-05-17', null, 98979),
(30, 5, '2018-04-22', null, 66619),
(31, 5, '2018-05-03', '2018-10-12', 79532),
(32, 5, '2018-05-03', '2018-09-20', 99511),
(33, 5, '2018-05-03', '2018-11-30', 73894),
(34, 5, '2018-05/03', '2018-11-03', 66488);

-- Employee 
INSERT INTO Employee (Employee_ID, Department_Hiring_idDepartment_Hiring, Employee_Name, Department_ID, Employee_Email, Employee_Address, Employee_Phone_Number, Role)
VALUES
(1, 1, 'Rodolphe Cadreman', 1,'rcadreman0@spotify.com','25 Anthes Plaza','896-176-0362','P'),
(2, 2, 'Vera Ashlin', 2,'vashlin1@furl.net','5357 Nancy Place','923-357-0342','P'),
(3, 3, 'Jorey Capenor', 3,'jcapenor2@webeden.co.uk','5548 Delladonna Place','656-448-2381','S'),
(4, 4, 'Mindy MacKibbon', 4,'mmackibbon3@cisco.com','5 Fairview Plaza','539-579-1156','S'),
(5, 5, 'Malina Bremeyer', 5,'mbremeyer4@multiply.com','7 Sugar Park','966-686-9111','P'),
(6, 6, 'Nixie Slemmonds', 2,'nslemmonds5@usnews.com','5049 Aberg Avenue','634-358-3558','P'),
(7, 7, 'Denis Keveren', 1,'dkeveren6@chronoengine.com','73 Cordelia Lane','	290-967-7170','S'),
(8, 8, 'Clayborn Tooze', 3,'ctooze7@g.co','43956 Carey Park','827-651-6445','P'),
(9, 9, 'Malchy Maidstone', 4,'mmaidstone8@mit.edu','2492 Miller Street','842-676-8625','S'),
(10, 10, 'Kasper Wetton', 3 ,'kwetton9@wordpress.org','69 Waxwing Point','306-493-6147','P'),
(11, 11, 'Clementine Duerden', 5,'cduerdena@cloudflare.com','5172 Namekagon Way','816-584-4922','S'),
(12, 12, 'Cinda Ficken', 2,'cfickenb@arizona.edu','931 Hintze Pass','623-215-1372','P'),
(13, 13, 'Nahum McGoogan', 1,'nmcgooganc@usatoday.com','328 Lien Street','855-987-9103','S'),
(14, 14, 'Anica Pendry', 3,'apendrya@usatoday.com','4551 Clarendon Trail','328-406-9286','P'),
(15, 15, 'Olympie Janman',2,'ojanmanb@wikimedia.org','99597 Mcguire Court','717-448-8091','S'),
(16, 16, 'Ichabod Pressdee', 1, 'ipressdee0@e-recht24.de', '47211 Delladonna Court', '610-548-9653','S'),
(17, 17, 'Marris Dommett', 2, 'mdommett1@tripod.com', '6584 Delladonna Hill', '338-605-8433','P'),
(18, 18, 'Eunice Antrum', 3, 'eantrum2@marketwatch.com', '9 Chinook Pass', '849-989-0410','P'),
(19, 19, 'Madelaine Gooderick', 4, 'mgooderick3@wisc.edu', '45390 Veith Center', '222-105-1355','S'),
(20, 20, 'Filmer Spread', 5, 'fspread4@webmd.com', '010 Towne Avenue', '838-390-4018','P'),
(21, 21, 'Charlean Abbison', 1, 'cabbison5@amazon.co.jp', '4493 American Center', '642-121-2347','P'),
(22, 22, 'Sanson Ekkel', 4, 'sekkel6@newsvine.com', '5709 Carioca Street', '895-124-8797','S'),
(23, 23, 'Abagail O''Dogherty', 3, 'aodogherty7@adobe.com', '445 Knutson Point', '305-559-4320','S'),
(24, 24, 'Kissee Hubbock', 5, 'khubbock8@scientificamerican.com', '3 Carey Alley', '198-562-3131','S'),
(25, 25, 'Ardelia Jersch', 2, 'ajersch9@issuu.com', '5467 Lukken Court', '605-640-9963','S'),
(26, 26, 'Jonah Davidovicz', 3, 'jdavidovicza@seattletimes.com', '62 Hintze Point', '266-925-2347','S'),
(27, 27, 'Gretel Ambrosoli', 1, 'gambrosolib@g.co', '6015 Crest Line Alley', '358-100-0641','P'),
(28, 28, 'Nonna Belamy', 4, 'nbelamyc@livejournal.com', '55 Anniversary Lane', '597-882-0281','P'),
(29, 29, 'Danette Middup', 4, 'dmiddupd@pagesperso-orange.fr', '563 Morrow Plaza', '890-657-0656','S'),
(30, 30, 'Rufus Grabiec',3, 'rgrabiece@yahoo.com', '86226 Ludington Junction', '325-470-5841','P');
-- Service_has_Employee;
INSERT INTO Service_has_Employee (Service_ID, Employee_ID)
VALUES
(1, 22),
(2, 23),
(3, 24),
(4, 24);

-- Employee_Has_Project;
INSERT INTO Employee_Has_Project (Employee_idEmployee, Project_idProject, Project_Product_idProduct)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 2),
(4, 4, 3),
(5, 5, 5);

-- SELECT * FROM mydb.CLIENT;
-- Order;
INSERT INTO mydb.Order (Order_ID, Supplier_ID, Client_ID, Order_Type, Order_Name, Order_Value, Order_Status, Department_Finance_Transaction_ID)
VALUES
(1, 1, NULL,'IN','Charger', 200, 'Delivered',1),
(2, NUll, 1,'OUT','iphone X', 999, 'On Way',2),
(3, NUll, 2,'OUT','iphone XR', 1199, 'On Way',3),
(4, 6, NULL,'IN','I-Pad', 999, 'On Way',4),
(5, 2, NULL,'IN','ipad Pro', 850, 'Delivered',5),
(6, NULL, 7,'OUT','Iphone XR', 97380, 'Delivered',6),
(7, 9, NULL,'IN','Iphone XR', 58070, 'Placed',7),
(8, 8, NULL,'IN','Iphone XR', 82350, 'Placed',8),
(9, NULL, 9,'OUT','Iphone XR', 46989, 'Placed',9),
(10, NULL, 5,'OUT','Iphone XR', 17633, 'Placed',10);

-- Product_has_Order;
INSERT INTO Product_has_Order (Product_ID,Order_ID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


-- Research_And_Development
INSERT INTO Research_And_Development (Development_ID, Department_Catalog_idDepartment_Catalog, Project_ID, Start_Date, Details, Expected_Duration_Months)
VALUES
(1, 1, 1, '2017-01-24', 'mauris ullamcorper purus sit amet nulla quisque', 15),
(2, 1, 2, '2018-06-02', 'rnare consequat lectus in est risus auctor', 7),
(3, 1, 3, '2016-10-29', 'diam erat fermentum justo nec condimentum', 5);


-- Production
INSERT INTO Production (Product_ID, Department_Catalog_idDepartment_Catalog, Project_ID, Product_Name, Product_Category, Quantity, Department_head)
VALUES
(1, 2, 1, 'iphone X', 'Smartphone', 10000, 'Rodolphe Cadreman'),
(2, 2, 2, 'iphone XS', 'Smartphone', 43350, 'Nixie Slemmonds'),
(3, 2, 3, 'iphone XR', 'Smartphone', 23460, 'Nonna Belamy'),
(4, 2, 4, 'ipad Air', 'Tablet', 66530, 'Clementine Duerden'),
(5, 2, 5, 'ipad Pro', 'Tablet', 44120, 'Charlean Abbison');


-- Warehouse
INSERT INTO WAREHOUSE (Store_ID, Department_Catalog_idDepartment_Catalog, Location, Storage_Capacity, Remaining_Capacity, Product_ID)
VALUES
(1, 3, '18 8th Plaza', '3000 sq.m.', '0 sq.m.', 1),
(2, 3, '75161 Graedel Way', '3200 sq.m.', '250 sq.m.', 2),
(3, 3, '21 Hermina Trail', '3400 sq.m.', '500 sq.m.', 3),
(4, 3, '8 Eagan Pass', '3600 sq.m.', '750 sq.m.', 4),
(5, 3, '44720 Novick Plaza', '3199 sq.m.', '199 sq.m.', 5);


 -- ------------------------------------------------------------------------------------------------------------------------------
-- Queries
-- --------------------------------------------------------------------------------------------------------------------------------

-- Query to see the Product Details

SELECT Prod.Product_Name, Proj.Project_Name, Prod.Product_Price, Prod.Product_Qty, Prod.Product_Details, Proj.Budget FROM Project AS Proj
INNER JOIN Product AS Prod
ON Proj.Product_idProduct = Prod.Product_ID;

-- Query to show products in Warehouse

SELECT warehouse.Store_ID, product.Product_ID, product.Product_Name, product.product_Price, product.Product_Qty, warehouse.Location, warehouse.Storage_Capacity, warehouse.Remaining_Capacity
From product
inner join warehouse
on warehouse.Product_ID = product.Product_ID
order by Store_ID;

/*
SELECT Hiring.Salary, Employee_has_Project.Project_idProject, Project.Project_Name, Project.Budget FROM Hiring
INNER JOIN Employee
ON Hiring.Hiring_ID = Employee.Department_Hiring_idDepartment_Hiring
INNER JOIN Employee_has_Project
ON Employee.Employee_ID = Employee_has_Project.Employee_idEmployee
INNER JOIN Project
ON Employee_has_Project.Project_idProject = Project.Project_ID;
GROUP BY Project.Project_ID
Having (SUM(Hiring.Salary/ Project.Budget)*100 ) < 0.002;
*/

 -- ------------------------------------------------------------------------------------------------------------------------------
-- Views
-- --------------------------------------------------------------------------------------------------------------------------------

-- Employees working on Projects
CREATE VIEW Employee_Working_Product
AS
SELECT Emp.Employee_Name, Emp.Employee_Email, Proj.Project_Name, Prod.Product_Name, Prod.Product_Details FROM Employee AS Emp
INNER JOIN Employee_has_Project AS EmpProj
ON Emp.Employee_ID = EmpProj.Employee_idEmployee
INNER JOIN Project as Proj
ON EmpProj.Project_idProject = Proj.Project_ID
INNER JOIN Product as Prod
ON Prod.Product_ID = Proj.Product_idProduct;


-- To check orders placed by clients;
create view order_client
as 
SELECT c.Client_ID, c.Client_Name, o.Order_ID, .o.Order_Name, Order_Status from Client c
inner join mydb.Order o
on c.Client_ID = o.Client_ID
order by Client_ID;


-- To check orders placed by suppliers;
create view order_supplier
as 
SELECT s.Supplier_ID, s.Supplier_Name, o.Order_ID, o.Order_Name, Order_Status from Supplier s
inner join mydb.Order o
on s.Supplier_ID = o.Supplier_ID
order by Supplier_ID;


-- Major Supplier by largest Amount Payable;
create view Biggest_Supplier
as
select supplier.Supplier_ID, supplier.Supplier_Name, order.Order_Value
from (mydb.order join supplier on
order.Supplier_ID = Supplier.Supplier_ID)
order by Order_Value DESC
LIMIT 1;



-- Major Customer by largest Amount Receivable;
create view Biggest_Customer
as
select client.Client_ID, Client.Client_Name, order.Order_Value
from (mydb.order join Client on
order.Client_ID = CLient.Client_ID)
order by Order_Value DESC
LIMIT 1;



SELECT * FROM Employee_Working_Product;
SELECT * FROM order_client;
SELECT * FROM order_supplier;
SELECT * FROM Biggest_Supplier;
SELECT * FROM Biggest_Customer;
 -- ------------------------------------------------------------------------------------------------------------------------------
-- Triggers
-- --------------------------------------------------------------------------------------------------------------------------------
-- Trigger to update Product after update on Product Service Catalog
DELIMITER $$
CREATE TRIGGER `mydb`.`Product_Service_Catalog_AFTER_INSERT` 
AFTER INSERT 
ON `Product_Service_Catalog` 
FOR EACH ROW
BEGIN

IF NEW.PS_Type='P' THEN
INSERT INTO Product (`Product_ID`, `Product_Service_Catalog_idProduct_Service_Catalog` , `Product_Name`, `Product_Price`, `Product_Qty`, `Product_Details`)
VALUES (null, NEW.Product_Service_ID, NEW.PS_Name, null, null, null);

ELSE
INSERT INTO Service (`Service_ID`, `Product_Service_Catalog_idProduct_Service_Catalog` , `Service_Name`, `Service_Charge`)
VALUES (null, NEW.Product_Service_ID, NEW.PS_Name, null);

END IF;
END;
$$

INSERT INTO Product_Service_Catalog (Company_ID, PS_Name, PS_Type)
VALUES (1, 'Apple-Watch', 'P');

INSERT INTO Product_Service_Catalog (Company_ID, PS_Name, PS_Type)
VALUES (1, 'Apple-Watch_Repair', 'S');

-- ALTER TABLE Product_Service_Catalog AUTO_INCREMENT = 10;
-- ALTER TABLE Product AUTO_INCREMENT = 5;
-- DROP TRIGGER Product_Service_Catalog_AFTER_INSERT;
-- DELETE FROM Product_Service_Catalog WHERE Product_Service_ID=10;
-- DELETE FROM Product WHERE Product_ID=6;

SELECT * FROM Product;
SELECT * FROM Product_Service_Catalog;
SELECT * FROM Service;
-- Trigger to update Employee after update on Hiring

DELIMITER $$
CREATE TRIGGER `mydb`.`Employee_AFTER_INSERT` 
AFTER INSERT 
ON `Hiring` 
FOR EACH ROW
BEGIN
INSERT INTO Employee (Employee_ID, Department_Hiring_idDepartment_Hiring, Employee_Name, Department_ID, Employee_Email, Employee_Address, Employee_Phone_Number, Role)
VALUES (null, NEW.Hiring_ID, null, 5, null, null, null, null);
END;
$$

INSERT INTO Hiring (Department_Catalog_idDepartment_Catalog, Joining_Date, End_Date, Salary)
VALUES (5, '2018-05-21', null, 67214);
-- ALTER TABLE Hiring AUTO_INCREMENT = 34;
-- DROP TRIGGER Employee_AFTER_INSERT;
-- DELETE FROM Employee WHERE Employee_ID=31;
-- DELETE FROM Hiring WHERE Hiring_ID=36;
SELECT * FROM Employee;
SELECT * FROM Hiring;


-- ----------------------------------------------------------------------------------------
-- Grant 
-- ----------------------------------------------------------------------------------------
-- Admin User
create user if not exists Admin identified by 'password';
grant all
on mydb.* 
to Admin;
show grants for Admin;

-- Owner User
create user if not exists Owners identified by 'password';
grant SELECT
on mydb.* 
to Owners;
show grants for Owners;

-- Employee User
create user if not exists Employee identified by 'password';
grant SELECT(Employee_Name, Employee_Email, Employee_Phone_Number, Role)
on mydb.Employee 
to Employee;

grant SELECT(Product_Name, Product_Details)
on mydb.Product
to Employee;

grant SELECT(Project_Name, Start_Date, End_Date)
on mydb.Project
to Employee;

grant SELECT(Supplier_ID, Client_ID, Order_Type, Order_Name, Order_Status)
on mydb.Order
to Employee;

show grants for Employee;