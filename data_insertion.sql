-- NOT THE FINAL VERSION

INSERT INTO
    PostGradUser (email, password)
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
    ('bahy@exmaple.com', '1234'),
    ('sup1@example.com', '12340'),
    ('sup2@example.com', '12340'),
    ('sup3@example.com', '12340'),
    ('sup4@example.com', '12340'),
    ('sup5@example.com', '12340'),
    ('examiner1@example.com', '1234'),
    ('examiner2@example.com', '1234'),
    ('examiner3@example.com', '1234'),
    ('examiner4@example.com', '1234'),
    ('examiner5@example.com', '1234');

-- TODO: inserting into Admin?
SET
    IDENTITY_INSERT GUCianStudent ON;

INSERT INTO
    GUCianStudent (
        id,
        firstName,
        lastName,
        type,
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

SET
    IDENTITY_INSERT GUCianStudent OFF;

SET
    IDENTITY_INSERT NonGUCianStudent ON;

INSERT INTO
    NonGUCianStudent (
        id,
        firstName,
        lastName,
        type,
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

SET
    IDENTITY_INSERT NonGUCianStudent OFF;

SET
    IDENTITY_INSERT Supervisor ON;

INSERT INTO
    Supervisor (id, name, faculty)
VALUES
    (11, 'Sup1', 'CS'),
    (12, 'Sup2', 'Law'),
    (13, 'Sup3', 'Medical'),
    (14, 'Sup4', 'Law'),
    (15, 'Sup5', 'Bio');

SET
    IDENTITY_INSERT Supervisor OFF;

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
    (69420, 4, 0.5),
    (911, 6, 0.25),
    (1000, 2, 0.15),
    (5000, 4, 0.10),
    (1000, 2, 0.40);

INSERT INTO
    Thesis (
        type,
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
        'type1',
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
        'type2',
        'Physics',
        'Thesis on Speed',
        '2019-01-01',
        '2019-02-01',
        '2019-02-01',
        80,
        2,
        1
    ),
    (
        'type3',
        'Chemistry',
        'Thesis on Chemicals',
        '2019-01-01',
        '2019-02-01',
        '2019-02-01',
        75,
        3,
        2
    ),
    (
        'type4',
        'Computer Science',
        'Thesis on Complexity',
        '2019-01-01',
        '2019-02-01',
        '2019-02-01',
        25,
        4,
        0
    ),
    (
        'type5',
        'Bio-informatics',
        'Thesis on Germs',
        '2019-01-01',
        '2019-02-01',
        '2019-02-01',
        90,
        5,
        3
    );

INSERT INTO
    Publication (title, date, place, isAccepted, host)
VALUES
    (
        'The first paper',
        '2015-01-01',
        'New York',
        1,
        'host1'
    ),
    (
        'The second paper',
        '2019-02-01',
        'Cairo',
        0,
        'host2'
    ),
    (
        'The third paper',
        '2018-03-01',
        'Paris',
        1,
        'host3'
    ),
    (
        'The fourth paper',
        '2017-04-01',
        'London',
        0,
        'host4'
    ),
    (
        'The fifth paper',
        '2016-05-01',
        'Tokyo',
        1,
        'host5'
    );

insert into
    GUCianProgressReport (
        student_id,
        progressReportNumber,
        date,
        evaluation,
        state,
        thesis_id,
        supervisor_id
    )
VALUES
    (1, 1, '2019-05-07', 'great', 2, 1, 11),
    (2, 2, '2009-02-01', 'good', 1, 2, 12),
    (3, 3, '2012-12-05', 'bad', 5, 3, 13),
    (4, 4, '2019-12-11', 'good', 6, 4, 14),
    (5, 5, '2018-02-10', 'great', 1, 5, 15);

insert into
    NonGUCianProgressReport (
        student_id,
        progressReportNumber,
        date,
        evaluation,
        state,
        thesis_id,
        supervisor_id
    )
VALUES
    (6, 6, '2020-05-07', 'great', 4, 6, 11),
    (7, 7, '2001-07-02', 'bad', 3, 7, 12),
    (8, 8, '2019-10-05', 'good', 5, 8, 13),
    (9, 9, '2019-12-01', 'good', 6, 9, 14),
    (10, 10, '2015-02-11', 'great', 1, 10, 15);

set
    identity_insert Examiner ON;

insert into
    Examiner (id, name, fieldOfWork, isNational)
VALUES
    (11, 'examiner1', 'CS', 1),
    (12, 'examiner2', 'Law', 0),
    (13, 'examiner3', 'Medical', 1),
    (14, 'examiner4', 'Law', 0),
    (15, 'examiner5', 'Bio', 1);

SET
    IDENTITY_INSERT Examiner OFF;

insert into
    Defense (thesis_id, date, location, grade)
values
    (1, '2019-05-07', 'Cairo', 60.4),
    (2, '2009-02-01', 'New York', 80),
    (3, '2012-12-05', 'Paris', 75),
    (4, '2019-12-11', 'London', 25),
    (5, '2018-02-10', 'Tokyo', 90);

--------------------- END OF ENTITIES ---------------------

-- Relations:
insert into 
    GUCStudentPhoneNumber (GUCianID, phoneNumber)
values
    (1, '0123456345'),
    (2, '0123456145'),
    (3, '0123426345'),
    (4, '0123556345'),
    (5, '0223436345');

INSERT into 
    NonGUCianPhoneNumber (NonGUCianID, phoneNumber)
values
    (6, '0123456345'),
    (7, '0123456145'),
    (8, '0123426345'),
    (9, '0123556345'),
    (10, '0223436345');

INSERT into 
    NonGUCianPayCourse (NonGUCianID, course_id, payment_id)
values
    (6, 1, 1),
    (7, 2, 2),
    (8, 3, 3),
    (9, 4, 4),
    (10, 5, 5);

insert into 
    NonGUCianTakeCourse (NonGUCianID, course_id, grade)
values
    (6, 1, 3.5),
    (7, 2, 3.1),
    (8, 3, 3.2),
    (9, 4, 3.3),
    (10, 5, 3.4);

insert into 
    NonGUCianRegisterThesis (NonGUCianID, supervisor_id, thesis_id, thesisNumber)
values
    (6, 11, 1, 1),
    (7, 12, 2, 2),
    (8, 13, 3, 3),
    (9, 14, 4, 4),
    (10, 15, 5, 5);

insert into 
    GUCianRegisterThesis (GUCianID, supervisor_id, thesis_id, thesisNumber)
values
    (1, 11, 1, 1),
    (2, 12, 2, 2),
    (3, 13, 3, 3),
    (4, 14, 4, 4),
    (5, 15, 5, 5);

INSERT into 
    Thesis_Publication (thesis_id, publication_id)
values
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);
    