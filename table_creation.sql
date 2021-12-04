-- TODO: Needs revision against our schema,
-- because the relation schema posted is not entirely correct! 

-- Entities:
CREATE TABLE GUCianStudent(
    id              INT PRIMARY KEY IDENTITY,
    firstName       VARCHAR(10),
    lastName        VARCHAR(10),
    email           VARCHAR(255),
    type            VARCHAR(50) DEFAULT 'student',
    faculty         VARCHAR(10),
    address         VARCHAR(50),
    GPA             FLOAT(2),
    underGradID     INT,
)

CREATE TABLE NonGUCianStudent(
    id              INT PRIMARY KEY IDENTITY,
    firstName       VARCHAR(10),
    lastName        VARCHAR(10),
    email           VARCHAR(255),
    type            VARCHAR(50) DEFAULT 'student',
    faculty         VARCHAR(10),
    address         VARCHAR(50),
    GPA             FLOAT(2),
)

CREATE TABLE Supervisor(
    id              INT PRIMARY KEY IDENTITY,
    firstName       VARCHAR(10),
    lastName        VARCHAR(10),
    email           VARCHAR(255),
    faculty         VARCHAR(10),
)

CREATE TABLE Course(
    id              INT PRIMARY KEY IDENTITY,
    fees            INT,
    creditHours     INT,
    code            VARCHAR(10),
)

CREATE TABLE Payment(
    id              INT PRIMARY KEY IDENTITY,
    amount          INT,
    installmentsCnt INT,
    fundPercentage  FLOAT(2),
)

CREATE TABLE Installment(
    date            DATE,
    paymentID       INT,
    amount          INT,
    isPaid          BIT,

    PRIMARY KEY (paymentID, date),
    FOREIGN KEY (paymentID) REFERENCES Payment(id)
)


CREATE TABLE Thesis(
    serialNumber    INT PRIMARY KEY IDENTITY,
    field           VARCHAR(50),
    title           VARCHAR(50),
    startDate       DATE,
    endDate         DATE,
    defenseDate     DATE,
    years           AS DATEDIFF(YEAR, startDate, endDate),
    grade           FLOAT(2),
    payment_id      INT,

    FOREIGN KEY (payment_id) REFERENCES Payment(id)
)

CREATE TABLE Defense(
    thesis_id       INT,
    date            DATE,
    location        VARCHAR(50),
    grade           FLOAT(2),

    PRIMARY KEY (thesis_id, date),
    
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber)
)

CREATE TABLE Publication(
    id              INT PRIMARY KEY IDENTITY,
    title           VARCHAR(50),
    date            DATE,
    place           VARCHAR(50),
    host            VARCHAR(50),
)

CREATE TABLE GUCianProgressReport(
    student_id      INT,
    thesis_id       INT,
    supervisor_id   INT,
    date            DATE,
    evaluation      VARCHAR(50),
    state           INT,

    FOREIGN KEY (student_id) REFERENCES GUCianStudent(id),
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber),
    FOREIGN KEY (supervisor_id) REFERENCES Supervisor(id)
)

CREATE TABLE NonGUCianProgressReport(
    student_id      INT,
    thesis_id       INT,
    supervisor_id   INT,
    date            DATE,
    evaluation      VARCHAR(50),
    state           INT,

    FOREIGN KEY (student_id) REFERENCES NonGUCianStudent(id),
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber),
    FOREIGN KEY (supervisor_id) REFERENCES Supervisor(id)
)

CREATE TABLE Examiner(
    id              INT PRIMARY KEY IDENTITY,
    firstName       VARCHAR(10),
    lastName        VARCHAR(10),
    fieldOfWork     VARCHAR(50),
    isNational      BIT,
)
--------------------- END OF ENTITIES ---------------------

-- Relations:
CREATE TABLE GUCianPhoneNumber(
    GUCianID        INT,
    phoneNumber     VARCHAR(20),

    FOREIGN KEY (GUCianID) REFERENCES GUCianStudent(id)
)

CREATE TABLE NonGUCianPhoneNumber(
    NonGUCianID     INT,
    phoneNumber     VARCHAR(20),

    FOREIGN KEY (NonGUCianID) REFERENCES NonGUCianStudent(id)
)

CREATE TABLE NonGUCianPayCourse(
    NonGUCianID     INT,
    course_id       INT,
    payment_id      INT,

    PRIMARY KEY (NonGUCianID, course_id, payment_id),

    FOREIGN KEY (NonGUCianID) REFERENCES NonGUCianStudent(id),
    FOREIGN KEY (course_id) REFERENCES Course(id),
    FOREIGN KEY (payment_id) REFERENCES Payment(id)
)

CREATE TABLE NonGUCianTakeCourse(
    NonGUCianID     INT,
    course_id       INT,
    grade           FLOAT(2),

    PRIMARY KEY (NonGUCianID, course_id),

    FOREIGN KEY (NonGUCianID) REFERENCES NonGUCianStudent(id),
    FOREIGN KEY (course_id) REFERENCES Course(id)
)

CREATE TABLE NonGUCianRegisterThesis(
    NonGUCianID     INT,
    thesis_id       INT,
    grade           FLOAT(2),

    PRIMARY KEY (NonGUCianID, thesis_id),

    FOREIGN KEY (NonGUCianID) REFERENCES NonGUCianStudent(id),
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber)
)

CREATE TABLE GUCianRegisterThesis(
    GUCianID        INT,
    supervisor_id   INT,
    thesis_id       INT,

    PRIMARY KEY (GUCianID, thesis_id, supervisor_id),

    FOREIGN KEY (GUCianID) REFERENCES GUCianStudent(id),
    FOREIGN KEY (supervisor_id) REFERENCES Supervisor(id),
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber)
)

CREATE TABLE Thesis_Publication(
    thesis_id       INT,
    publication_id  INT,

    PRIMARY KEY (thesis_id, publication_id),

    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber),
    FOREIGN KEY (publication_id) REFERENCES Publication(id)
)

CREATE TABLE ExaminerEvaluateDefense(
    date            DATE,
    thesis_id       INT,
    examiner_id     INT,
    comment         VARCHAR(255),

    PRIMARY KEY (date, thesis_id, examiner_id),

    FOREIGN KEY (date, thesis_id) REFERENCES Defense(date, thesis_id), 
    FOREIGN KEY (examiner_id) REFERENCES Examiner(id)
)


--------------------- END OF RELATIONS ---------------------
