-- TODO: Needs revision against our schema,
-- because the relation schema posted is not entirely correct! 


-- Entities:

CREATE TABLE Users(
    id              INT PRIMARY KEY IDENTITY,
    email           VARCHAR(255),
    password       VARCHAR (255)

)

CREATE TABLE Admin(
    id             INT PRIMARY KEY IDENTITY,
    email           VARCHAR(255),
    passwword       VARCHAR (255)
    FOREIGN KEY(id) REFERENCES Users(id)
)

CReate table Student(
     id             INT PRIMARY KEY IDENTITY,
    firstName       VARCHAR(10),
    lastName        VARCHAR(10),
    email           VARCHAR(255),
    password        VARCHAR(255),
    type            VARCHAR(50) DEFAULT 'student',
    faculty         VARCHAR(10),
    address         VARCHAR(50),
    GPA             FLOAT(2),
    FOREIGN KEY (id) REFERENCES Users(id)

    

)


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
    FOREIGN KEY (id) REFERENCES Users(id)
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
     FOREIGN KEY (id) REFERENCES Users(id)
)

CREATE TABLE Supervisor(
    id              INT PRIMARY KEY IDENTITY,
    name       VARCHAR(10),
    email           VARCHAR(255),
    password        VARCHAR (255),
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
    type            VARCHAR(50),
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




CREATE TABLE Publication(
    id              INT PRIMARY KEY IDENTITY,
    title           VARCHAR(50),
    date            DATE,
    place           VARCHAR(50),
    accepted        VARCHAR(20),
    host            VARCHAR(50),
)


CREATE TABLE GUCianProgressReport(
    student_id      INT,
    progressReportNumber INT,
    date            DATE,
    evaluation      VARCHAR(50),
    state           INT,
    thesis_id       INT,
    supervisor_id   INT,
    
    PRIMARY KEY(student_id,progressReportNumber),
    FOREIGN KEY (student_id) REFERENCES GUCianStudent(id),
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber),
    FOREIGN KEY (supervisor_id) REFERENCES Supervisor(id)
)

CREATE TABLE NonGUCianProgressReport(
    student_id      INT,
    progressReportNumber INT,
    date            DATE,
    evaluation      VARCHAR(50),
    state           INT,
    thesis_id       INT,
    supervisor_id   INT,
    
    PRimary KEY(student_id,progressReportNumber),
    FOREIGN KEY (student_id) REFERENCES NonGUCianStudent(id),
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber),
    FOREIGN KEY (supervisor_id) REFERENCES Supervisor(id)
)

CREATE TABLE Examiner(
    id              INT PRIMARY KEY IDENTITY,
    name            VARCHAR(60),
    email           VARCHAR(255),
     password        VARCHAR(50),
    fieldOfWork     VARCHAR(50),
    isNational      BIT,
)
CREATE TABLE Defense(
    thesis_id       INT,
    date            DATE,
    location        VARCHAR(50),
    grade           FLOAT(2),
    PRIMARY KEY (thesis_id, date),
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber)
)
--------------------- END OF ENTITIES ---------------------



-- Relations:
CREATE TABLE GUCStudentPhoneNumber(
    GUCianID        INT,
    phoneNumber     VARCHAR(20),
    PRIMARY KEY (GUCianID , phoneNumber),
    FOREIGN KEY (GUCianID) REFERENCES GUCianStudent(id)
)

CREATE TABLE NonGUCianPhoneNumber(
    NonGUCianID     INT,
    phoneNumber     VARCHAR(20),
    PRIMARY KEY(NonGUCianID , phoneNumber),
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
    NonGUCianID        INT,
    supervisor_id   INT,
    thesis_id       INT,
    thesisNumber    VARCHAR(20),
    PRIMARY KEY (NonGUCianID, thesis_id,supervisor_id,thesisNumber),
    FOREIGN KEY (NonGUCianID) REFERENCES NonGUCianStudent(id),
    FOREIGN KEY (thesis_id) REFERENCES Thesis(serialNumber),
    FOREIGN KEY (supervisor_id) REFERENCES Supervisor(id),
)

CREATE TABLE GUCianRegisterThesis(
    GUCianID        INT,
    supervisor_id   INT,
    thesis_id       INT,
     thesisNumber    VARCHAR(20),
    PRIMARY KEY (GUCianID, thesis_id, supervisor_id,thesisNumber),
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
    FOREIGN KEY (examiner_id) REFERENCES Examiner(id),
    FOREIGN KEY(thesis_id,date) REFERENCES Defense(thesis_id,date)
)





--------------------- END OF RELATIONS ---------------------
