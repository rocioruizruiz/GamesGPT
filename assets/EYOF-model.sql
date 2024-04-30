/*==============================================================*/
/* Table: Customer                                              */
/*==============================================================*/
CREATE TABLE Customer (
   Id                   INT AUTO_INCREMENT,
   FirstName            VARCHAR(40)         NOT NULL,
   LastName             VARCHAR(40)         NOT NULL,
   City                 VARCHAR(40)         NULL,
   Country              VARCHAR(40)         NULL,
   Phone                VARCHAR(20)         NULL,
   PRIMARY KEY (Id)
);

/*==============================================================*/
/* Index: IndexCustomerName                                     */
/*==============================================================*/
CREATE INDEX IndexCustomerName ON Customer (LastName ASC, FirstName ASC);

/*==============================================================*/
/* Table: CustomerOrder                                                 */
/*==============================================================*/
CREATE TABLE CustomerOrder (
   Id                   INT AUTO_INCREMENT,
   OrderDate            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
   OrderNumber          VARCHAR(10)         NULL,
   CustomerId           INT                 NOT NULL,
   TotalAmount          DECIMAL(12,2)       NULL DEFAULT 0,
   PRIMARY KEY (Id),
   CONSTRAINT FK_ORDER_CUSTOMER FOREIGN KEY (CustomerId) REFERENCES Customer (Id)
);

/*==============================================================*/
/* Indexes for CustomerOrder Table                                      */
/*==============================================================*/
CREATE INDEX IndexOrderCustomerId ON CustomerOrder (CustomerId ASC);
CREATE INDEX IndexOrderOrderDate ON CustomerOrder (OrderDate ASC);

/*==============================================================*/
/* Table: Medals                                                */
/*==============================================================*/
CREATE TABLE Medals (
   Id                   INT AUTO_INCREMENT,
   Season               CHAR(1)		    NOT NULL,
   Games                VARCHAR(40)         NOT NULL,
   FirstName            VARCHAR(40)         NULL,
   LastName             VARCHAR(40)         NULL,
   Team                 VARCHAR(40)         NULL,
   Country              VARCHAR(40)         NOT NULL,
   Discipline           VARCHAR(40)         NOT NULL,
   Event		VARCHAR(40)	    NOT NULL,
   Medal		VARCHAR(10)	    NOT NULL,
   Type			VARCHAR(10)	    NULL,
   Score                VARCHAR(20)         NULL,
   Position             INT
   PRIMARY KEY (Id)
);

/*==============================================================*/
/* Index: IndexMedalist.   IndexMedals                          */
/*==============================================================*/
CREATE INDEX IndexMedalist ON Medals (LastName ASC, FirstName ASC);
CREATE INDEX IndexMedals ON Medals (Games ASC, Discipline ASC, Event ASC, Medal ASC);

/*==============================================================*/
/* Table: Customer                                              */
/*==============================================================*/
CREATE TABLE Customer (
   Id                   INT AUTO_INCREMENT,
   FirstName            VARCHAR(40)         NOT NULL,
   LastName             VARCHAR(40)         NOT NULL,
   City                 VARCHAR(40)         NULL,
   Country              VARCHAR(40)         NULL,
   Phone                VARCHAR(20)         NULL,
   PRIMARY KEY (Id)
);

/*==============================================================*/
/* Index: IndexCustomerName                                     */
/*==============================================================*/
CREATE INDEX IndexCustomerName ON Customer (LastName ASC, FirstName ASC);

/*==============================================================*/
/* Table: CustomerOrder                                                 */
/*==============================================================*/
CREATE TABLE CustomerOrder (
   Id                   INT AUTO_INCREMENT,
   OrderDate            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
   OrderNumber          VARCHAR(10)         NULL,
   CustomerId           INT                 NOT NULL,
   TotalAmount          DECIMAL(12,2)       NULL DEFAULT 0,
   PRIMARY KEY (Id),
   CONSTRAINT FK_ORDER_CUSTOMER FOREIGN KEY (CustomerId) REFERENCES Customer (Id)
);

/*==============================================================*/
/* Indexes for CustomerOrder Table                                      */
/*==============================================================*/
CREATE INDEX IndexOrderCustomerId ON CustomerOrder (CustomerId ASC);
CREATE INDEX IndexOrderOrderDate ON CustomerOrder (OrderDate ASC);

/*==============================================================*/
/* Table: Supplier                                              */
/*==============================================================*/
CREATE TABLE Supplier (
   Id                   INT AUTO_INCREMENT,
   CompanyName          VARCHAR(40)         NOT NULL,
   ContactName          VARCHAR(50)         NULL,
   ContactTitle         VARCHAR(40)         NULL,
   City                 VARCHAR(40)         NULL,
   Country              VARCHAR(40)         NULL,
   Phone                VARCHAR(30)         NULL,
   Fax                  VARCHAR(30)         NULL,
   PRIMARY KEY (Id)
);

/*==============================================================*/
/* Indexes for Supplier Table                                   */
/*==============================================================*/
CREATE INDEX IndexSupplierName ON Supplier (CompanyName ASC);
CREATE INDEX IndexSupplierCountry ON Supplier (Country ASC);

/*==============================================================*/
/* Table: Product                                               */
/*==============================================================*/
CREATE TABLE Product (
   Id                   INT AUTO_INCREMENT,
   ProductName          VARCHAR(50)         NOT NULL,
   SupplierId           INT                 NOT NULL,
   UnitPrice            DECIMAL(12,2)       NULL DEFAULT 0,
   Package              VARCHAR(30)         NULL,
   IsDiscontinued       BOOLEAN             NOT NULL DEFAULT 0,
   PRIMARY KEY (Id),
   CONSTRAINT FK_PRODUCT_SUPPLIER FOREIGN KEY (SupplierId) REFERENCES Supplier (Id)
);

/*==============================================================*/
/* Indexes for Product Table                                    */
/*==============================================================*/
CREATE INDEX IndexProductSupplierId ON Product (SupplierId ASC);
CREATE INDEX IndexProductName ON Product (ProductName ASC);
/*==============================================================*/
/* Table: OrderItem                                             */
/*==============================================================*/

CREATE TABLE OrderItem (
   Id                   INT AUTO_INCREMENT,
   OrderId              INT                 NOT NULL,
   ProductId            INT                 NOT NULL,
   UnitPrice            DECIMAL(12,2)       NOT NULL DEFAULT 0,
   Quantity             INT                 NOT NULL DEFAULT 1,
   PRIMARY KEY (Id),
   CONSTRAINT FK_ORDERITEM_ORDER FOREIGN KEY (OrderId) REFERENCES CustomerOrder (Id),
   CONSTRAINT FK_ORDERITEM_PRODUCT FOREIGN KEY (ProductId) REFERENCES Product (Id)
);

/*==============================================================*/
/* Indexes for OrderItem Table                                  */
/*==============================================================*/
CREATE INDEX IndexOrderItemOrderId ON OrderItem (OrderId ASC);
CREATE INDEX IndexOrderItemProductId ON OrderItem (ProductId ASC);

/*==============================================================*/
/* Table: GamesMedals                                        */
/*==============================================================*/
CREATE TABLE GamesMedals (
   Id             INT AUTO_INCREMENT,
   Code				VARCHAR(8)	NOT NULL,
   Games          VARCHAR(5)	NOT NULL,
   Season         VARCHAR(5)  NOT NULL,
   Year          	VARCHAR(10) NOT NULL,
   Championship	VARCHAR(60)	NULL,
   DC				   VARCHAR(3)	NOT NULL,
   Ordered	 		INT,
   ODF_code			VARCHAR(34)	NOT NULL,
   Discipline		VARCHAR(40)	NOT NULL,
   Gender			VARCHAR(8)	NOT NULL,
   Event			   VARCHAR(60)	NULL,
   Position			INT,
   Medal			   VARCHAR(6)	NOT NULL,
   Count			   BOOLEAN		NOT NULL,
   EvType			VARCHAR(15)	NOT NULL,
   Name				VARCHAR(60)	NULL,
   FirstName      VARCHAR(60)	NULL,
   LastName       VARCHAR(60)	NULL,
   AthGender		CHAR(1)		NULL,
   Team				VARCHAR(60)	NULL,
   NOC				VARCHAR(3)	NOT NULL,
   Country			VARCHAR(60)	NOT NULL,
   Type				VARCHAR(10)	NULL,
   Score			   VARCHAR(25)	NULL,
   PRIMARY KEY (Id)
);
 
 CREATE INDEX IndexMedals ON GamesMedals (Year ASC, Season DESC, Games DESC, DC ASC, Ordered ASC, Position ASC, Count DESC);