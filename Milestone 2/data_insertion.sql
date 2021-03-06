USE PostGradSystem;

INSERT INTO
    PostGradUser (email, PASSWORD)
VALUES
    -- GUCians
    ('mark@example.com', 'Ay)5Yq'),
    ('tony@example.com', 'Ay)5Yq'),
    ('omar@example.com', 'k~8xJV_E'),
    ('ahmed@example.com', 'LfJy96^s'),
    ('sarah@example.com', 'F{]5x?eL'),
    -- Non-GUCians
    ('amira@example.com', 'W.s1xTF3'),
    ('sally@example.com', 'P6pV/J$f'),
    ('mohammad@example.com', 'm#D<|n6t'),
    ('bassel@example.com', 'pMyb<0zj'),
    ('bahy@exmaple.com', 'Uzaj]7E1'),
    -- Supervisors
    ('Roger.Watson@example.com', 'wb9W_{4D'),
    ('Annie.Dunn@example.com', 'IfrZ27@T'),
    ('Donna.Anderson@example.com', 'Vzx/6W@('),
    ('Lynn.Griffith@example.com', 'Y3&=+yz['),
    ('Meredith.French@example.com', 'zvF1P{M-'),
    -- Examiners
    ('Tyson.Cross@example.com', 'v8O=*K-a'),
    ('Millicent.Schroeder@example.com', 'v8S|/vz.'),
    ('April.Hansen@example.com', 'W4=beW%h'),
    ('Donny.Mcintosh@example.com', 'M(`[5ho9'),
    ('Pamela.Chavez@example.com', 'h%jh}8TV'),
    -- Admins
    ('Richard.Colon@example.com', 'B/IkzY3I'),
    ('Emmitt.Duarte@example.com', 'm3^dbfEH'),
    ('Karina.Martinez@example.com', 'cVm)d6&R'),
    ('Austin.Doyle@example.com', 'Z3SosO#5'),
    ('Vilma.Benton@example.com', 'gAt"57,m');

INSERT INTO
    GUCianStudent (
        id,
        firstName,
        lastName,
        TYPE,
        faculty,
        address,
        GPA,
        underGradID
    )
VALUES
    (
        1,
        'Mark',
        'Zuckerberg',
        1,
        'CS',
        '123 Main St',
        3.5,
        1
    ),
    (
        2,
        'Tony',
        'Stark',
        1,
        'Law',
        '456 Main St',
        3.0,
        2
    ),
    (
        3,
        'Omar',
        'Khan',
        1,
        'Medical',
        '8979 Main St',
        4.0,
        3
    ),
    (
        4,
        'Ahmed',
        'Ali',
        1,
        'Law',
        '132 Main St',
        2.7,
        4
    ),
    (
        5,
        'Sarah',
        'Khan',
        1,
        'Bio',
        '000 Main St',
        1.3,
        5
    );

INSERT INTO
    NonGUCianStudent (
        id,
        firstName,
        lastName,
        TYPE,
        faculty,
        address,
        GPA
    )
VALUES
    (
        6,
        'Amira',
        'Ammar',
        0,
        'CS',
        '6969 Main St',
        1.2
    ),
    (
        7,
        'Sally',
        'Smith',
        0,
        'Law',
        '1234 Main St',
        2.0
    ),
    (
        8,
        'Mohammad',
        'Omar',
        0,
        'Medical',
        '8979 Main St',
        4.0
    ),
    (
        9,
        'Bassel',
        'Waleed',
        0,
        'Law',
        '132 Main St',
        2.7
    ),
    (
        10,
        'Bahy',
        'Oraby',
        0,
        'Bio',
        '000 Main St',
        1.3
    );


INSERT INTO
    Supervisor (id, firstName, lastName, faculty)
VALUES
    (11, 'Roger', 'Watson', 'CS'),
    (12, 'Annie', 'Dunn', 'Law'),
    (13, 'Donna', 'Anderson', 'Medical'),
    (14, 'Lynn', 'Griffith', 'Law'),
    (15, 'Meredith', 'French', 'Bio');

INSERT INTO
    Examiner (id, name, fieldOfWork, isNational)
VALUES
    (16, 'Tyson Cross', 'CS', 1),
    (17, 'Millicent Schroeder', 'Law', 0),
    (18, 'April Hansen', 'Medical', 1),
    (19, 'Donny Mcintosh', 'Law', 0),
    (20, 'Pamela Chavez', 'Bio', 1);

INSERT INTO Admin (id)
VALUES
    (21),
    (22),
    (23),
    (24),
    (25);

INSERT INTO
    Course (fees, creditHours, code)
VALUES
    (69420, 4, 'MATH501'),
    (911, 6, 'CSEN301'),
    (1000, 2, 'CHEM101'),
    (5000, 4, 'MATH402'),
    (1000, 2, 'ELCT401');

INSERT INTO
    Payment (
        amount,
        installmentsCnt,
        fundPercentage
    )
VALUES
    (10000, 4, 0.5),
    (1000, 1, 0.25),
    (5000, 2, 0.15),
    (200000, 2, 0.10),
    (5000, 1, 0.40);


INSERT INTO 
    Installment (
        date,
        paymentID,
        amount,
        isPaid
    )
VALUES
    ('2011-01-05', 1, 2500, 1),
    ('2011-02-05', 1, 2500, 1),
    ('2011-03-05', 1, 2500, 0),
    ('2011-04-05', 1, 2500, 0),
    ('2019-06-07', 2, 1000, 1),
    ('2019-07-07', 3, 2500, 1),
    ('2019-08-07', 3, 2500, 0),
    ('2020-10-10', 4, 100000, 1),
    ('2020-11-10', 4, 100000, 1),
    ('2020-12-10', 5, 5000, 0);


INSERT INTO
    Thesis (
        TYPE,
        field,
        title,
        startDate,
        endDate,
        defenseDate,
        grade,
        payment_id,
        noExtension
    )
VALUES
    (
        'PhD',
        'Computer Science',
        'Thesis on Algorithms',
        '2019-01-01',
        '2019-02-01',
        '2019-05-07',
        60.4,
        1,
        0
    ),
    (
        'Masters',
        'Physics',
        'Thesis on Speed',
        '2018-01-01',
        '2019-02-15',
        '2009-02-01',
        80,
        2,
        1
    ),
    (
        'PhD',
        'Chemistry',
        'Thesis on Chemicals',
        '2020-11-01',
        '2021-02-01',
        '2012-12-05',
        75,
        3,
        2
    ),
    (
        'Master',
        'Computer Science',
        'Thesis on Complexity',
        '2009-10-12',
        '2019-02-01',
        '2019-12-11',
        25,
        4,
        0
    ),
    (
        'PhD',
        'Bio-informatics',
        'Thesis on Germs',
        '2019-01-01',
        '2019-02-01',
        '2018-02-10',
        90,
        5,
        3
    ),
    (
        'PhD',
        'Computer Science',
        'Thesis on Algorithms',
        '2019-01-01',
        '2019-02-01',
        '2019-02-01',
        60.4,
        1,
        0
    ),
    (
        'Masters',
        'Physics',
        'Thesis on Speed',
        '2018-01-01',
        '2019-02-15',
        '2019-02-01',
        80,
        2,
        1
    ),
    (
        'PhD',
        'Chemistry',
        'Thesis on Chemicals',
        '2020-11-01',
        '2021-02-01',
        '2021-02-01',
        75,
        3,
        2
    ),
    (
        'Master',
        'Computer Science',
        'Thesis on Complexity',
        '2009-10-12',
        '2019-02-01',
        '2021-05-07',
        25,
        4,
        0
    ),
    (
        'PhD',
        'Bio-informatics',
        'Thesis on Germs',
        '2019-01-01',
        '2019-02-01',
        '2019-02-01',
        90,
        5,
        3
    ),
    (
        'PhD',
        'Computer Science',
        'Thesis on Algorithms',
        '2019-01-01',
        '2019-02-01',
        '2019-12-12',
        60.4,
        1,
        0
    ),
    (
        'Masters',
        'Physics',
        'Thesis on Speed',
        '2018-01-01',
        '2019-02-15',
        '2001-02-01',
        80,
        2,
        1
    ),
    (
        'PhD',
        'Chemistry',
        'Thesis on Chemicals',
        '2020-11-01',
        '2021-02-01',
        '2025-02-01',
        75,
        3,
        2
    ),
    (
        'Master',
        'Computer Science',
        'Thesis on Complexity',
        '2009-10-12',
        '2019-02-01',
        '2001-05-07',
        25,
        4,
        0
    ),
    (
        'PhD',
        'Bio-informatics',
        'Thesis on Germs',
        '2019-01-01',
        '2019-02-01',
        '2010-02-01',
        90,
        5,
        3
    ),
    (
        'PhD',
        'Computer Science',
        'Thesis on Algorithms',
        '2019-01-01',
        '2019-02-01',
        '2019-12-11',
        60.4,
        1,
        0
    ),
    (
        'Masters',
        'Physics',
        'Thesis on Speed',
        '2018-01-01',
        '2019-02-15',
        '2019-02-01',
        80,
        2,
        1
    ),
    (
        'PhD',
        'Chemistry',
        'Thesis on Chemicals',
        '2020-11-01',
        '2021-02-01',
        '2021-02-01',
        75,
        3,
        2
    ),
    (
        'Master',
        'Computer Science',
        'Thesis on Complexity',
        '2009-10-12',
        '2019-02-01',
        '2021-05-07',
        25,
        4,
        0
    );

INSERT INTO
    Publication (title, date, place, isAccepted, host)
VALUES
    ('The first paper', '2015-01-01', 'New York', 1, 'host1'),
    ('The second paper', '2019-02-01', 'Cairo', 0, 'host2'),
    ('The third paper', '2018-03-01', 'Paris', 1, 'host3'),
    ('The fourth paper', '2017-04-01','London', 0, 'host4'),
    ('The fifth paper', '2016-05-01', 'Tokyo', 1, 'host5'),
    ('The sixth paper', '2015-06-01', 'New York', 0, 'host6'),
    ('The seventh paper', '2014-07-01', 'Cairo', 1, 'host7'),
    ('The eighth paper', '2013-08-01', 'Paris', 0, 'host8'),
    ('The ninth paper', '2012-09-01', 'London', 1, 'host9'),
    ('The tenth paper', '2011-10-01', 'Tokyo', 0, 'host10'),
    ('The eleventh paper', '2010-11-01', 'New York', 1, 'host11'),
    ('The twelfth paper', '2009-12-01', 'Cairo', 0, 'host12'),
    ('The thirteenth paper', '2008-01-01', 'Paris', 1, 'host13'),
    ('The fourteenth paper', '2007-02-01', 'London', 0, 'host14'),
    ('The fifteenth paper', '2006-03-01', 'Tokyo', 1, 'host15'),
    ('The sixteenth paper', '2005-04-01', 'New York', 0, 'host16'),
    ('The seventeenth paper', '2004-05-01', 'Cairo', 1, 'host17'),
    ('The eighteenth paper', '2003-06-01', 'Paris', 0, 'host18'),
    ('The nineteenth paper', '2002-07-01', 'London', 1, 'host19');


INSERT INTO
    GUCianProgressReport (
        student_id,
        date,
        evaluation,
        state,
        thesisSerialNumber,
        supervisor_id
    )
VALUES
    (1, '2019-05-07', 60, 2, 1, 11),
    (2, '2009-02-01', 75, 1, 2, 12),
    (3, '2012-12-05', 90, 5, 3, 13),
    (4, '2019-12-11', 10, 6, 4, 14),
    (5, '2018-02-10', 0, 1, 5, 15);

INSERT INTO
    NonGUCianProgressReport (
        student_id,
        date,
        evaluation,
        state,
        thesisSerialNumber,
        supervisor_id
    )
VALUES
    (6, '2020-05-07', 15, 4, 6, 11),
    (7, '2001-07-02', 25, 3, 7, 12),
    (8, '2019-10-05', 35, 5, 8, 13),
    (9, '2019-12-01', 50, 6, 9, 14),
    (10, '2015-02-11', 70, 1, 10, 15);

INSERT INTO
    Defense (thesisSerialNumber, date, location, grade)
VALUES
    (1, '2019-05-07', 'Cairo', 0),
    (2, '2009-02-01', 'New York', 60),
    (3, '2012-12-05', 'Paris', 80),
    (4, '2019-12-11', 'London', 10),
    (5, '2018-02-10', 'Tokyo', 95),
    (6, '2019-02-01', 'Munich', 100),
    (7, '2019-02-01', 'Madrid', 50),
    (8, '2021-02-01', 'Chicago', 75),
    (9, '2021-05-07', 'London', 25),
    (10, '2019-02-01', 'Tokyo', 90),
    (11, '2019-12-12', 'Cairo', 0),
    (12, '2001-02-01', 'New York', 60),
    (13, '2025-02-01', 'Paris', 80),
    (14, '2001-05-07', 'London', 10),
    (15, '2010-02-01', 'Tokyo', 95),
    (16, '2019-12-11', 'Munich', 100),
    (17, '2019-02-01', 'Madrid', 50),
    (18, '2021-02-01', 'Chicago', 75),
    (19, '2021-05-07', 'London', 25);
--------------------- END OF ENTITIES ---------------------
-- Relations:
INSERT INTO
    GUCStudentPhoneNumber (GUCianID, phoneNumber)
VALUES
    (1, '0123456345'),
    (2, '0123456145'),
    (3, '0123426345'),
    (4, '0123556345'),
    (5, '0223436345');

INSERT INTO
    NonGUCianPhoneNumber (NonGUCianID, phoneNumber)
VALUES
    (6, '0123456345'),
    (7, '0123456145'),
    (8, '0123426345'),
    (9, '0123556345'),
    (10, '0223436345');

INSERT INTO
    NonGUCianPayCourse (NonGUCianID, course_id, payment_id)
VALUES
    (6, 1, 1),
    (7, 2, 2),
    (8, 3, 3),
    (9, 4, 4),
    (10, 5, 5);

INSERT INTO
    NonGUCianTakeCourse (NonGUCianID, course_id, grade)
VALUES
    (6, 1, 55),
    (7, 2, 45),
    (8, 3, 0),
    (9, 4, 70),
    (10, 5, 90);

INSERT INTO
    NonGUCianRegisterThesis (
        NonGUCianID,
        supervisor_id,
        thesisSerialNumber
    )
VALUES
    (6, 11, 1),
    (7, 12, 2),
    (8, 13, 3),
    (9, 14, 4),
    (10, 15, 5);
   
INSERT INTO
    GUCianRegisterThesis (
        GUCianID, 
        supervisor_id, 
        thesisSerialNumber
    )
VALUES
    (1, 11, 1),
    (2, 12, 2),
    (3, 13, 3),
    (4, 14, 4),
    (5, 15, 5);

INSERT INTO
    Thesis_Publication (thesisSerialNumber, publication_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10),
    (11, 11),
    (12, 12),
    (13, 13),
    (14, 14),
    (15, 15),
    (16, 16),
    (17, 17),
    (18, 18),
    (19, 19);

INSERT INTO
    ExaminerEvaluateDefense (
        date,
        thesisSerialNumber,
        examiner_id,
        comment
    )
VALUES
    ('2019-05-07', 1, 16, 'examiner1 comment1'),
    ('2009-02-01', 2, 17, 'examiner2 comment1'),
    ('2012-12-05', 3, 18, 'examiner3 comment1'),
    ('2019-12-11', 4, 19, 'examiner4 comment1'),
    ('2018-02-10', 5, 20, 'examiner5 comment1'),
    ('2019-02-01', 6, 16, 'examiner1 comment2'),
    ('2019-02-01', 7, 17, 'examiner2 comment2'),
    ('2021-02-01', 8, 18, 'examiner3 comment2'),
    ('2021-05-07', 9, 19, 'examiner4 comment2'),
    ('2019-02-01', 10, 20, 'examiner5 comment2'),
    ('2019-12-12', 11, 16, 'examiner1 comment3'),
    ('2001-02-01', 12, 17, 'examiner2 comment3'),
    ('2025-02-01', 13, 18, 'examiner3 comment3'),
    ('2001-05-07', 14, 19, 'examiner4 comment3'),
    ('2010-02-01', 15, 20, 'examiner5 comment3'),
    ('2019-12-11', 16, 16, 'examiner1 comment4'),
    ('2019-02-01', 17, 17, 'examiner2 comment4'),
    ('2021-02-01', 18, 18, 'examiner3 comment4'),
    ('2021-05-07', 19, 19, 'examiner4 comment4');