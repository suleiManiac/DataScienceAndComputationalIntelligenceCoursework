CREATE TABLE Author (
AuthorID VARCHAR2(4) PRIMARY KEY,
Name  VARCHAR2(20) NOT NULL
);

CREATE TABLE Category (
CategoryID VARCHAR2(4) PRIMARY KEY,
Type VARCHAR2(20) NOT NULL 
);

CREATE TABLE Publication (
PubID VARCHAR2(4) PRIMARY KEY,
AuthorID VARCHAR2(4) REFERENCES Author,
Title VARCHAR2(50) NOT NULL,
CatID VARCHAR2(4) REFERENCES Category,
PublishedYear INT NOT NULL,
Availabilty VARCHAR2(3) NOT NULL
);

CREATE TABLE DBUser (
UserID VARCHAR2(4) PRIMARY KEY,
Name VARCHAR2(20) NOT NULL,
Email VARCHAR2(25) NOT NULL,
Password VARCHAR2(20) NOT NULL
);

CREATE TABLE Request (
UserID VARCHAR2(4) REFERENCES DBUser,
PublicationID VARCHAR2(4) REFERENCES Publication,
RequestDate DATE NOT NULL,
PRIMARY KEY (UserID, PublicationID, RequestDate)
);

INSERT INTO Author VALUES('A011', 'Dingle R');
INSERT INTO Author VALUES('A012', 'Ransom A');
INSERT INTO Author VALUES('A013', 'Wardale R');
INSERT INTO Author VALUES('A014', 'Alexander T');
INSERT INTO Author VALUES('A015', 'Spurrier S');

INSERT INTO Category VALUES('C911', 'Short stories');
INSERT INTO Category VALUES('C912', 'Journal articles');
INSERT INTO Category VALUES('C913', 'Biography');
INSERT INTO Category VALUES('C914', 'Illustrations');

INSERT INTO Publication VALUES('P001', 'A011', 'The Blue Treacle', 'C911', 1911, 'No');
INSERT INTO Publication VALUES('P002', 'A012', 'In Aleppo Once', 'C911', 2001, 'Yes');
INSERT INTO Publication VALUES('P003', 'A012', 'Illustrating Arthur Ransome', 'C914', 1973, 'Yes');
INSERT INTO Publication VALUES('P004', 'A012', 'Ransome the Artist', 'C914', 1994, 'Yes');
INSERT INTO Publication VALUES('P005', 'A014', 'Bohemia in London', 'C912', 2008, 'No');
INSERT INTO Publication VALUES('P006', 'A011', 'The Best of Childhood', 'C911', 2002, 'Yes');
INSERT INTO Publication VALUES('P007', 'A015', 'Distilled Enthusiasms', 'C912', 201, 'Yes');

INSERT INTO DBUser VALUES ('U111', 'Kenderine J', 'KenderineJ@hotmail.com', 'Kenj2');
INSERT INTO DBUser VALUES ('U241', 'Wang F', 'WangF@hotmail.com', 'Wanf05');
INSERT INTO DBUser VALUES ('U55', 'Flavel K', 'FlavelK@hotmail.com', 'Flak77');
INSERT INTO DBUser VALUES ('U016', 'Zidane Z', 'ZidaneZ@hotmail.com', 'Zidz13');
INSERT INTO DBUser VALUES ('U121', 'Keita R', 'KeitaR@hotmail.com', 'Keir22');

INSERT INTO Request VALUES ('U016', 'P001', '05-Oct-17');
INSERT INTO Request VALUES ('U241', 'P001', '28-Sep-17');
INSERT INTO Request VALUES ('U55', 'P002', '08-Sep-17');
INSERT INTO Request VALUES ('U016', 'P004', '06-Oct-17');
INSERT INTO Request VALUES ('U121', 'P002', '23-Sep-17');

SELECT Name, Email FROM DBUser WHERE UserID IN
    (SELECT UserID FROM Request WHERE Request.PublicationID IN 
        (SELECT PubID from Publication WHERE Publication.CatID IN 
            (SELECT CategoryID FROM Category WHERE Type='Illustrations')));


SELECT PubId, Title, PublicationID, RequestDate FROM Publication, Request 
WHERE PubID= PublicationId AND RequestDate BETWEEN '01-Sep-17' AND '30-Sep-2017' 
ORDER BY RequestDate DESC;


SELECT Name FROM DBUser WHERE UserID IN 
(SELECT UserID FROM Request 
HAVING COUNT(UserID) > 1
GROUP BY UserID);

SELECT Publication.CatID, COUNT(Publication.PubID)
FROM Request INNER JOIN Publication
ON Publication.PubID = Request.PublicationID
GROUP BY Publication.CatID;


CREATE TABLE FlightInfo (
Year INTEGER NOT NULL,
Month INTEGER NOT NULL,
DayOfMonth INTEGER NOT NULL,
WeekDay INTEGER NOT NULL,
DepartureTime DATE NOT NULL,
ActDepartureTime DATE NOT NULL,
ArrivalTime DATE NOT NULL,
Carrier VARCHAR2(5),
FlightNo VARCHAR(6) PRIMARY KEY,
DepartureDelay INTEGER NOT NULL,
ArrivalDelay INTEGER NOT NULL,
Cancellation VARCHAR2(3) DEFAULT 'No' NOT NULL,
WeatherDelay INTEGER NOT NULL
);

INSERT INTO FlightInfo VALUES(1999, 5, 21, 3, '0015', '0014', '0115 ', '001', 'BA123','1','0','No','0'); 
INSERT INTO FlightInfo VALUES('2001', '7', '01', '2', '1200', '1200', '1600', '013', 'EA456', '0', '5', 'No', '0') ;
INSERT INTO FlightInfo VALUES('2015', '12', '25', '7', '1312', '1300', '1700', '045', 'GA123', '12', '0', 'No', '0'); 
INSERT INTO FlightInfo VALUES('2000', '3', '4', '3', '1400', '1400', '1500', '007', 'NA125', '0', '5', 'No', '0') ;
INSERT INTO FlightInfo VALUES('2003', '10', '17', '6', '1800', '1800', '2000', '007', 'NA321', '0', '0', 'No', '0'); 
INSERT INTO FlightInfo VALUES('2005', '6',  '6', '7', '0400', '0400', '0430', '001', 'BA126', '0', '5', 'No', '0' );
INSERT INTO FlightInfo VALUES('2009', '2', '14', '5', '0015', '0000', '0100 ', '013', 'EA876', '15', '15', 'No', '0'); 

SELECT Carrier, COUNT(FlightNo) FROM FlightInfo 
WHERE DepartureDelay > 0 OR ArrivalDelay > 0
GROUP BY Carrier;
INSERT INTO FlightInfo 
VALUES(1999, 5, 21, 3, TO_DATE('00:15', 'HH24:MI'),
TO_DATE('00:14', 'HH24:MI'), TO_DATE('01:15', 'HH24:MI'), '001', 'BA123',1,0,'No',0); 
