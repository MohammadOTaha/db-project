INSERT INTO PostGradUser (
    email, password
)
VALUES
('mark@example.com', '1234'),
('tony@example.com', '1234'),
('omar@example.com', '1234'),
('ahmed@example.com', '1234'),
('sarah@example.com', '12340'),
('amira@example.com', '1234'),
('sally@example.com', '1234'),
('mohammad@example.com', '1234'),
('bassel@example.com', '1234'),
('sup1@example.com', '12340'),
('sup2@example.com', '12340'),
('sup3@example.com', '12340'),
('sup4@example.com', '12340'),
('sup5@example.com', '12340'),

-- TODO: inserting into Admin?


SET IDENTITY_INSERT GUCianStudent ON;
INSERT INTO GUCianStudent(
    id, firstName, lastName, type, faculty, address, GPA, underGradID
)
VALUES
(1, 'Mark', 'Zuckerberg', 1, 'CS', '123 Main St', 3.5, 1),
(2, 'Tony', 'Stark', 1, 'Law', '456 Main St', 3.0, 2),
(3, 'Omar', 'Khan', 1, 'Medical', '8979 Main St', 4.0, 3),
(4, 'Ahmed', 'Ali', 1, 'Law', '132 Main St', 2.7, 4),
(5, 'Sarah', 'Khan', 1, 'Bio', '000 Main St', 1.3, 5);
SET IDENTITY_INSERT GUCianStudent OFF;

SET IDENTITY_INSERT NonGUCianStudent ON;
INSERT INTO NonGUCianStudent(
    id, firstName, lastName, type, faculty, address, GPA
)
VALUES
(6, 'Amira', 'Ammar', 0, 'CS', '6969 Main St', 1.2),
(7, 'Sally', 'Smith', 0, 'Law', '1234 Main St', 2.0),
(8, 'Mohammad', 'Omar', 0, 'Medical', '8979 Main St', 4.0),
(9, 'Bassel', 'Waleed', 0, 'Law', '132 Main St', 2.7),
(10, 'Bahy', 'Oraby', 0, 'Bio', '000 Main St', 1.3);
SET IDENTITY_INSERT NonGUCianStudent OFF;

SET IDENTITY_INSERT Supervisor ON;
INSERT INTO Supervisor(
    id, name, faculty
)
VALUES
(11, 'Sup1', 'CS'),
(12, 'Sup2', 'Law'),
(13, 'Sup3', 'Medical'),
(14, 'Sup4', 'Law'),
(15, 'Sup5', 'Bio');
SET IDENTITY_INSERT Supervisor OFF;

INSERT INTO Course(
    fees, creditHours, code
)
VALUES
(69420, 4, 'MATH501'),
(911, 6, 'CSEN301'),
(1000, 2, 'CHEM101'),
(5000, 4, 'MATH402'),
(1000, 2, 'ELCT401');

INSERT INTO Payment(
    amount, installmentsCnt, fundPercentage
)
VALUES
(69420, 4, 0.5),
(911, 6, 0.25),
(1000, 2, 0.15),
(5000, 4, 0.10),
(1000, 2, 0.40);

INSERT INTO Thesis(
    type, field, title, startDate, endDate, defenseDate, grade, payment_id, noExtension 
)
VALUES
('type1', 'Computer Science', 'Thesis on Algorithms', '2019-01-01', '2019-02-01', '2019-02-01', 60.4, 1, 0),
('type2', 'Physics', 'Thesis on Speed', '2019-01-01', '2019-02-01', '2019-02-01', 80, 2, 1),
('type3', 'Chemistry', 'Thesis on Chemicals', '2019-01-01', '2019-02-01', '2019-02-01', 75, 3, 2),
('type4', 'Computer Science', 'Thesis on Complexity', '2019-01-01', '2019-02-01', '2019-02-01', 25, 4, 0),
('type5', 'Bio-informatics', 'Thesis on Germs', '2019-01-01', '2019-02-01', '2019-02-01', 90, 5, 3);


INSERT INTO Publication (
    title, date, place, isAccepted, host
)
VALUES
('The first paper', '2015-01-01', 'New York', 1, 'host1'),
('The second paper', '2019-02-01', 'Cairo', 0, 'host2'),
('The third paper', '2018-03-01', 'Paris', 1, 'host3'),
('The fourth paper', '2017-04-01', 'London', 0, 'host4'),
('The fifth paper', '2016-05-01', 'Tokyo', 1, 'host5');
