------------------- (1) Unregistered User's Features -------------------
-- 1.a:  Register to the website.
GO
CREATE PROC StudentRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @faculty VARCHAR(20),
    @Gucian BIT,
    @email VARCHAR(50),
    @address VARCHAR(20)
AS
BEGIN
    INSERT INTO PostGradUser 
        (email, password)
    VALUES
        (@email, @password);

    DECLARE @student_id INT = SCOPE_IDENTITY();

    IF @Gucian = 1
        BEGIN
            INSERT INTO GUCianStudent
                (id, firstName, lastName, type, faculty, address)
            VALUES
                (@student_id, @first_name, @last_name, @Gucian, @faculty, @address);
        END
    ELSE
        BEGIN
            INSERT INTO NonGUCianStudent
                (id, firstName, lastName, type, faculty, address, GPA)
            VALUES
                (@student_id, @first_name, @last_name, @Gucian, @faculty, @address);
        END
END

GO
CREATE PROC SupervisorRegister
    @name VARCHAR(20),
    @password VARCHAR(20),
    @faculty VARCHAR(20),
    @email VARCHAR(20)
AS
BEGIN
    INSERT INTO PostGradUser
        (email, password)
    VALUES
        (@email, @password);

    DECLARE @supervisor_id INT = SCOPE_IDENTITY();

    INSERT INTO Supervisor
        (id, name, faculty)
    VALUES
        (@supervisor_id, @name, @faculty);
END

------------------- (2) Registered User's Features -------------------
-- 2.a: login using my username and password.
GO
CREATE PROC userLogin
    @ID INT,
    @password VARCHAR(20),
    @Success BIT OUTPUT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM PostGradUser 
        WHERE id = @ID AND password = @password
    )
        BEGIN
            SET @Success = 1;
        END
    ELSE
        BEGIN
            SET @Success = 0;
        END
END

/*
we have to test it
declare @success bit
exe userlogin 18,'123',@success output
print @success
*/

-- 2.b: add my mobile number(s).
GO
CREATE PROC addMobile
    @ID INT,
    @mobile_number VARCHAR(20)
AS
BEGIN
    IF EXISTS (
        SELECT * FROM GUCianStudent
        WHERE id = @ID
    )
        BEGIN
            INSERT INTO GUCStudentPhoneNumber
                (GUCianID, phoneNumber)
            VALUES
                (@ID, @mobile_number);
        END
    ELSE
        BEGIN
            INSERT INTO NonGUCianPhoneNumber
                (NonGUCianID, phoneNumber)
            VALUES
                (@ID, @mobile_number);
        END
END


GO
CREATE PROC AdminListUp
AS
select *
from Supervisor
    INNER JOIN PostGradUser ON PostGradUser.id = Supervisor.id;

GO
CREATE PROC AdminViewSupervisorProfile
    @supID INT
AS
select *
from Supervisor
    INNER JOIN PostGradUser on PostGradUser.id = Supervisor.id
Where Supervisor.id = @supID;


GO
CREATE PROC AdminViewAllTheses
AS
select *
from Thesis;

GO
CREATE PROC AdminViewOnGoingTheses
    @ThesisCount SMALLINT Output
AS
select @ThesisCount = Count(*)
from Thesis T


--We need to ask about it
GO
CREATE PROC AdminViewStudentThesisBySupervisor
AS
    Select S1.name as Supervisor, T1.title as Thesis , GUCianStudent.firstName as First_name , GUCianStudent.lastName as Last_name
    From GUCianRegisterThesis
        INNER JOIN Supervisor S1 On S1.id = GUCianRegisterThesis.supervisor_id
        INNER join Thesis T1 on T1.serialNumber = GUCianRegisterThesis.thesisSerialNumber
        INNER JOIn GUCianStudent ON GUCianStudent.id = GUCianRegisterThesis.GUCianID
UNION
    Select S2.name, T2.title, NonGUCianStudent.firstName , NonGUCianStudent.lastName
    From NonGUCianRegisterThesis
        INNER JOIN Supervisor S2 On S2.id = NonGUCianRegisterThesis.supervisor_id
        INNER join Thesis T2 on T2.serialNumber = NonGUCianRegisterThesis.thesisSerialNumber
        INNER JOIn NonGUCianStudent ON NonGUCianStudent.id = NonGUCianRegisterThesis.NonGUCianID




GO
CREATE PROC AdminListNonGucianCourse
    @courseID Int
AS
Select NG.firstName , NG.lastName, C.code, NonGUCianTakeCourse.grade
FRom NonGUCianTakeCourse
    INNER JOIN NonGUCianStudent NG ON NG.id = NonGUCianTakeCourse.NonGUCianID
    INNER JOIN Course C ON C.id = NonGUCianTakeCourse.course_id

GO
CREATE PROC AdminUpdateExtension
    @ThesisSerial INT
AS
UPDATE Thesis 
SET Thesis.noExtension = Thesis.noExtension+1
Where  Thesis.noExtension = @ThesisSerial


GO
create PROC AdminIssueThesisPayment
    @ThesisSerial INT,
    @amount DECIMAL,
    @noOfInstallments INT,
    @fundPrecentage Decimal ,
    @success bit OUTPUT
AS
Declare @pay_id SMALLINT
if exists ( select *
from Thesis
where Thesis.serialNumber = @ThesisSerial)
BEGIN
    set @success = 1;
    select @pay_id =payment_id
    from Thesis
    where serialNumber=@ThesisSerial
    INSERT into Payment
        (id, amount, installmentsCnt, fundPercentage)
    VALUES
        (@pay_id, @amount, @noOfInstallments, @fundPrecentage)
END
ELSE
BEGIN
    set @success = 0;
END;


GO
CREATE PROC AdminViewStudentProfile
    @sid INT
AS
If EXISTS (Select *
From GUCianStudent
where GUCianStudent.id = @sid)
begin
    select *
    from GUCianStudent INNER JOIN PostGradUser ON PostGradUser.id = GUCianStudent.id
    INNER JOIN GUCStudentPhoneNumber GP ON GP.GUCianID = GUCianStudent.id
    WHERE GUCianStudent.id = @sid
end
else 
begin
    select *
    from NonGUCianStudent INNER JOIN PostGradUser ON PostGradUser.id = NonGUCianStudent.id
     INNER JOIN NonGUCianPhoneNumber GP ON GP.NonGUCianID = NonGUCianStudent.id
    WHERE NonGUCianStudent.id = @sid;
end


--3)j) wait to undrstand
-- GO
--  declare @dateInform DATE 

--   select @dateInform = DATEADD(month, 2, '2017/08/25');
--   print(@dateInform)

GO
CREATE PROC AdminIssueInstallPayment
    @paymentID int,
    @installStartDate DATE
AS
declare @paymentIdFound INT
declare @numberOfInstallments INT
declare @dateAdded DATE
declare @totalPaymentAmount INT
declare @amountOfInstallment INT
select @paymentIdFound = Payment.id
From Payment
Where Payment.id = @paymentID
-- Now I got the ID of the payment
Select @numberOfInstallments = Payment.installmentsCnt
From Payment
where Payment.id = @paymentID
-- getting number of installemnts
select @totalPaymentAmount = Payment.amount
From Payment
where Payment.id = @paymentID
--getting the amount of payment
set @dateAdded = @installStartDate
set @amountOfInstallment = @totalPaymentAmount/@numberOfInstallments
while( @numberOfInstallments >0)
BEGIN
    INSERT INTo Installment
        (date,paymentID,amount,isPaid)
    VALUES
        (@dateAdded, @paymentIdFound, @amountOfInstallment, 1)
set @dateAdded = DATEADD(month, 6, @dateAdded);
set @numberOfInstallments = @numberOfInstallments-1
END
--Doing the insertion


--We have to check it again--
GO
CREATE PROC AdminListAcceptPublication
AS
select P.title
from Thesis_Publication
    INNER JOIN Publication P ON P.id = Thesis_Publication.publication_id
Where P.isAccepted = '1';


GO
CREATE PROC AddCourse
    @coursecode varchar(10),
    @creditHrs INT,
    @fees DECIMAL
AS
INSERT INTO Course
    (code , creditHours , fees)
VALUES
    (@coursecode, @creditHrs , @fees)




GO
CREATE PROC linkCourseStudent
    @courseID INT,
    @studentID INT
AS
IF EXISTS (select *
from NonGUCianTakeCourse
where NonGUCianTakeCourse.NonGUCianID = @studentID)
BEGIN
    INSERT INTO NonGUCianTakeCourse
        (course_id ,NonGUCianID)
    VALUES(@courseID, @studentID)
end


-- UPDATE OR INSERT ?
GO
CREATE PROC AddStudentCourseGrade
    @courseID INT,
    @studentID INT,
    @grade DECIMAL
AS
IF EXISTS (select *
from NonGUCianTakeCourse
where NonGUCianTakeCourse.NonGUCianID = @studentID)
BEGIN
    UPDATE NonGUCianTakeCourse
SET grade = @grade
where NonGUCianTakeCourse.NonGUCianID =@studentID AND NonGUCianTakeCourse.course_id = @courseID;
END



-- Which student so I can choose the supervisor of him
GO
CREATE PROC ViewExamSupDefense
    @defenseDate DATETIME
AS
    select E.name , S.name
    From ExaminerEvaluateDefense
        INNER JOIN Examiner E ON E.id = ExaminerEvaluateDefense.examiner_id
        INNER JOIN GUCianRegisterThesis ON ExaminerEvaluateDefense.thesisSerialNumber = GUCianRegisterThesis.thesisSerialNumber
        INNER JOIN Supervisor S ON S.id = GUCianRegisterThesis.supervisor_id
        WHEre ExaminerEvaluateDefense.[date] = @defenseDate
    --Connecting The defenseData with Date given
UNION
    select E.name , S.name
    From ExaminerEvaluateDefense
        INNER JOIN Examiner E ON E.id = ExaminerEvaluateDefense.examiner_id
        INNER JOIN NonGUCianRegisterThesis ON ExaminerEvaluateDefense.thesisSerialNumber = NonGUCianRegisterThesis.thesisSerialNumber
        INNER JOIN Supervisor S ON S.id = NonGUCianRegisterThesis.supervisor_id
        WHEre ExaminerEvaluateDefense.[date] = @defenseDate


------------------- (4) Supservisor's Features -------------------

-- 4.a: Evaluate a student’s progress report, and give evaluation value 0 to 3
GO
CREATE PROC EvaluateProgressReport
    @supervisorID INT,
    @thesisSerialNo INT,
    @progressReportNo INT,
    @evaluation INT
AS
IF EXISTS (
    SELECT * FROM GUCianProgressReport PR
    WHERE 
        PR.thesisSerialNumber = @thesisSerialNo AND 
        PR.progressReportNumber = @progressReportNo AND
        PR.supervisor_id = @supervisorID
)
BEGIN
    UPDATE GUCianProgressReport
    SET evaluation = @evaluation
    WHERE 
        GUCianProgressReport.thesisSerialNumber = @thesisSerialNo AND 
        GUCianProgressReport.progressReportNumber = @progressReportNo AND
        GUCianProgressReport.supervisor_id = @supervisorID
END
ELSE
BEGIN
    UPDATE NonGUCianProgressReport
    SET evaluation = @evaluation
    WHERE 
        NonGUCianProgressReport.thesisSerialNumber = @thesisSerialNo AND 
        NonGUCianProgressReport.progressReportNumber = @progressReportNo AND
        NonGUCianProgressReport.supervisor_id = @supervisorID
END

-- 4.b: View all my students’s names and years spent in the thesis.
GO
CREATE PROC ViewSupStudentsYears
    @supervisorID INT
AS
BEGIN
    SELECT GUCianStudent.firstName, GUCianStudent.lastName, T1.years
    FROM GUCianRegisterThesis GUCianThesis
    INNER JOIN GUCianStudent GUCianStudent ON GUCianStudent.id = GUCianThesis.GUCianID
    INNER JOIN Thesis T1 ON T1.serialNumber = GUCianThesis.thesisSerialNumber
    WHERE GUCianThesis.supervisor_id = @supervisorID
    UNION
    SELECT NonGUCianStudent.firstName, NonGUCianStudent.lastName, T2.years
    FROM NonGUCianRegisterThesis NonGUCianThesis
    INNER JOIN NonGUCianStudent NonGUCianStudent ON NonGUCianStudent.id = NonGUCianThesis.NonGUCianID
    INNER JOIN Thesis T2 ON T2.serialNumber = NonGUCianThesis.thesisSerialNumber
    WHERE NonGUCianThesis.supervisor_id = @supervisorID
END

-- 4.c: View my profile and update my personal information.
GO
CREATE PROC SupViewProfile
    @supervisorID INT
AS
BEGIN
    SELECT * FROM Supervisor
    WHERE Supervisor.id = @supervisorID
END

GO
CREATE PROC UpdateSupProfile
    @supervisorID INT,
    @name VARCHAR(20),
    @faculty VARCHAR(20)
AS
BEGIN
    UPDATE Supervisor
    SET name = @name, faculty = @faculty
    WHERE Supervisor.id = @supervisorID
END

-- 4.d: View all publications of a student.
GO
CREATE PROC ViewAStudentPublications
    @studentID INT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM GUCianStudent
        WHERE GUCianStudent.id = @studentID
    )
    BEGIN
        SELECT P.title
        FROM GUCianStudent GUCianStudent
        INNER JOIN GUCianRegisterThesis GUCianRegisterThesis ON GUCianRegisterThesis.GUCianID = GUCianStudent.id
        INNER JOIN Thesis_Publication T_P ON T_P.thesisSerialNumber = GUCianRegisterThesis.thesisSerialNumber
        INNER JOIN Publication P ON P.id = T_P.publication_id
        WHERE GUCianStudent.id = @studentID
    END
    ELSE
    BEGIN
        SELECT P.title
        FROM NonGUCianStudent NonGUCianStudent
        INNER JOIN NonGUCianRegisterThesis NonGUCianRegisterThesis ON NonGUCianRegisterThesis.NonGUCianID = NonGUCianStudent.id
        INNER JOIN Thesis_Publication T_P ON T_P.thesisSerialNumber = NonGUCianRegisterThesis.thesisSerialNumber
        INNER JOIN Publication P ON P.id = T_P.publication_id
        WHERE NonGUCianStudent.id = @studentID
    END
END

-- 4.e: Add defense for a thesis, for nonGucian students all courses’ grades should be greater than 50 percent.
-- TODO: not sure about not having grade
GO
CREATE PROC AddDefenseGucian
    @thesisSerialNo INT,
    @defenseDate DATETIME,
    @defenseLocation VARCHAR(15) -- TODO: Shall we change the length to 15 in table_creations too? 
AS
BEGIN
    INSERT INTO Defense (thesisSerialNumber, date, location)
    VALUES (@thesisSerialNo, @defenseDate, @defenseLocation)

    UPDATE Thesis
    SET defenseDate = @defenseDate
    WHERE Thesis.serialNumber = @thesisSerialNo
END

GO
CREATE PROC AddDefenseNonGucian
    @thesisSerialNo INT,
    @defenseDate DATETIME,
    @defenseLocation VARCHAR(15) -- TODO: Shall we change the length to 15 in table_creations too?
AS
BEGIN
    -- get NonGUCianID
    DECLARE @NonGUCianID INT
    SELECT @NonGUCianID = NonGUCianID
    FROM NonGUCianRegisterThesis T
    WHERE T.thesisSerialNumber = @thesisSerialNo

    -- check if all student's grades are greater than 50 percent
    IF NOT EXISTS (
        SELECT * FROM NonGUCianTakeCourse C
        WHERE C.NonGUCianID = @NonGUCianID AND C.grade <= 50
    )
    BEGIN
        INSERT INTO Defense (thesisSerialNumber, date, location)
        VALUES (@thesisSerialNo, @defenseDate, @defenseLocation)

        UPDATE Thesis
        SET defenseDate = @defenseDate
        WHERE Thesis.serialNumber = @thesisSerialNo
    END
END

-- 4.f: Add examiner(s) for a defense.
GO
CREATE PROC AddExaminer
    @thesisSerialNo INT,
    @DefenseDate DATETIME,
    @ExaminerName VARCHAR(20),
    @National BIT,
    @fieldOfWork VARCHAR(20)
AS
BEGIN
    INSERT INTO Examiner(name, isNational, fieldOfWork)
    VALUES (@ExaminerName, @National, @fieldOfWork)
    
    DECLARE @ExaminerID INT = SCOPE_IDENTITY()
    INSERT INTO ExaminerEvaluateDefense(thesisSerialNumber, examiner_id, date)
    VALUES (@thesisSerialNo, @ExaminerID, @DefenseDate)
END

-- 4.g: Cancel a Thesis if the evaluation of the last progress report is zero.
GO
CREATE PROC CancelThesis
    @thesisSerialNo INT
AS
BEGIN
    IF ( 
        EXISTS (
            SELECT * FROM GUCianProgressReport PR
            WHERE PR.thesisSerialNumber = @thesisSerialNo
        ) AND (
            SELECT TOP 1 evaluation FROM GUCianProgressReport PR
            WHERE PR.thesisSerialNumber = @thesisSerialNo
            ORDER BY PR.date DESC
        ) = 0
    )
    BEGIN
        DELETE FROM Thesis
        WHERE Thesis.serialNumber = @thesisSerialNo
    END
    ELSE IF (
        EXISTS (
            SELECT * FROM NonGUCianProgressReport PR
            WHERE PR.thesisSerialNumber = @thesisSerialNo
        ) AND (
            SELECT TOP 1 evaluation FROM NonGUCianProgressReport PR
            WHERE PR.thesisSerialNumber = @thesisSerialNo
            ORDER BY PR.date DESC
        ) = 0
    )
    BEGIN
        DELETE FROM Thesis
        WHERE Thesis.serialNumber = @thesisSerialNo
    END
END

-- 4.h: Add a grade for a thesis.
-- TODO: grade missing in question statement!
GO
CREATE PROC AddGrade
    @thesisSerialNo INT,
    @grade DECIMAL
AS
BEGIN
    UPDATE Thesis
    SET grade = @grade
    WHERE Thesis.serialNumber = @thesisSerialNo
END


------------------- (5) Examiner's Features -------------------

-- 5.a: Add grade for a defense.
GO
CREATE PROC AddGradeDefense
    @ThesisSerialNo INT,
    @DefenseDate DATETIME,
    @grade DECIMAL
AS
BEGIN
    UPDATE Defense
    SET grade = @grade
    WHERE Defense.thesisSerialNumber = @ThesisSerialNo AND Defense.date = @DefenseDate
END

-- 5.b: Add comments for a defense.
GO
CREATE PROC AddCommentsGrade
    @ThesisSerialNo INT ,
    @DefenseDate Datetime ,
    @comments VARCHAR(300)
AS
INSERT INTO ExaminerEvaluateDefense
    (thesisSerialNumber, date, comment)
VALUES
    (@ThesisSerialNo, @DefenseDate, @comments)

------------------- (6) Registered Student's Features -------------------

-- 6.a: View my profile that contains all my information.
GO
CREATE PROC viewMyProfile
    @studentId INT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM GUCianStudent
        WHERE GUCianStudent.id = @studentId
    )
        BEGIN
            SELECT * FROM GUCianStudent
            WHERE GUCianStudent.id = @studentId
        END
    ELSE
        BEGIN
            SELECT * FROM NonGUCianStudent
            WHERE NonGUCianStudent.id = @studentId
        END
END

-- 6.b: Edit my profile (change any of my personal information).
GO
CREATE PROC editMyProfile
    @studentId INT,
    @firstName VARCHAR(10),
    @lastName VARCHAR(10),
    @password VARCHAR(10),
    @email VARCHAR(10),
    @address VARCHAR(10),
    @type VARCHAR(10)
AS
BEGIN
    UPDATE PostGradUser
    SET email = @email, password = @password
    WHERE PostGradUser.id = @studentId

    IF EXISTS (
        SELECT * FROM GUCianStudent
        WHERE GUCianStudent.id = @studentId
    )
        BEGIN
            UPDATE GUCianStudent
            SET firstName = @firstName, lastName = @lastName, address = @address
            WHERE GUCianStudent.id = @studentId
        END
    ELSE
        BEGIN
            UPDATE NonGUCianStudent
            SET firstName = @firstName, lastName = @lastName, address = @address
            WHERE NonGUCianStudent.id = @studentId
        END
END

-- 6.c: As a Gucian graduate, add my undergarduate ID.
GO
CREATE PROC addUndergradID
    @studentID INT,
    @undergradID VARCHAR(10)
AS
BEGIN
    UPDATE GUCianStudent
    SET undergradID = @undergradID
    WHERE GUCianStudent.id = @studentID
END

-- 6.d: As a nonGucian student, view my courses’ grades.
GO
CREATE PROC ViewCoursesGrades
    @studentID INT
AS
BEGIN
    SELECT C.course_id, C.grade FROM NonGUCianTakeCourse C
    WHERE C.NonGUCianID = @studentID
END

-- 6.e: View all my payments and installments.
---- 6.e.1: View course paymeents.
GO
CREATE PROC ViewCoursePaymentsInstall
    @studentID INT
AS
BEGIN
    SELECT CP.course_id, I.*
    FROM NonGUCianPayCourse CP
    INNER JOIN Installment I ON I.paymentID = CP.payment_id
    WHERE CP.NonGUCianID = @studentID
END

---- 6.e.2: View thesis payments.
GO
CREATE PROC ViewThesisPaymentsInstall
    @studentID INT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM GUCianStudent
        WHERE GUCianStudent.id = @studentID
    )
        BEGIN
            SELECT GUCianThesis.thesisSerialNumber, I.*
            FROM GUCianRegisterThesis GUCianThesis
            INNER JOIN Thesis T ON T.serialNumber = GUCianThesis.thesisSerialNumber
            INNER JOIN Installment I ON I.paymentID = T.payment_id
            WHERE GUCianThesis.GUCianID = @studentID
        END
    ELSE
        BEGIN
            SELECT NonGUCianThesis.thesisSerialNumber, I.*
            FROM NonGUCianRegisterThesis NonGUCianThesis
            INNER JOIN Thesis T ON T.serialNumber = NonGUCianThesis.thesisSerialNumber
            INNER JOIN Installment I ON I.paymentID = T.payment_id
            WHERE NonGUCianThesis.NonGUCianID = @studentID
        END
END

---- 6.e.3: View upcoming installments.
GO
CREATE PROC ViewUpcomingInstallments
    @studentID INT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM GUCianStudent
        WHERE GUCianStudent.id = @studentID
    )
        BEGIN
            SELECT I.*
            FROM GUCianRegisterThesis GUCianThesis
            INNER JOIN Thesis T ON T.serialNumber = GUCianThesis.thesisSerialNumber
            INNER JOIN Installment I ON I.paymentID = T.payment_id
            WHERE GUCianThesis.GUCianID = @studentID AND I.date > GETDATE()
        END
    ELSE
        BEGIN
            SELECT I.*
            FROM NonGUCianRegisterThesis NonGUCianThesis
            INNER JOIN Thesis T ON T.serialNumber = NonGUCianThesis.thesisSerialNumber
            INNER JOIN Installment I ON I.paymentID = T.payment_id
            WHERE NonGUCianThesis.NonGUCianID = @studentID AND I.date > GETDATE()

            UNION

            SELECT I.*
            FROM NonGUCianPayCourse CP
            INNER JOIN Installment I ON I.paymentID = CP.payment_id
            WHERE CP.NonGUCianID = @studentID AND I.date > GETDATE()
        END
END

---- 6.e.4: View missed installments.
GO
CREATE PROC ViewMissedInstallments
    @studentID INT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM GUCianStudent
        WHERE GUCianStudent.id = @studentID
    )
        BEGIN
            SELECT I.*
            FROM GUCianRegisterThesis GUCianThesis
            INNER JOIN Thesis T ON T.serialNumber = GUCianThesis.thesisSerialNumber
            INNER JOIN Installment I ON I.paymentID = T.payment_id
            WHERE GUCianThesis.GUCianID = @studentID AND I.date < GETDATE() AND I.isPaid = 0
        END
    ELSE
        BEGIN
            SELECT I.*
            FROM NonGUCianRegisterThesis NonGUCianThesis
            INNER JOIN Thesis T ON T.serialNumber = NonGUCianThesis.thesisSerialNumber
            INNER JOIN Installment I ON I.paymentID = T.payment_id
            WHERE NonGUCianThesis.NonGUCianID = @studentID AND I.date < GETDATE() AND I.isPaid = 0

            UNION

            SELECT I.*
            FROM NonGUCianPayCourse CP
            INNER JOIN Installment I ON I.paymentID = CP.payment_id
            WHERE CP.NonGUCianID = @studentID AND I.date < GETDATE() AND I.isPaid = 0
        END
END

-- 6.f: Add and fill my progress report(s).
---- 6.f.1: Add a progress report.
-- TODO: missing progressReportNumber?
GO
CREATE PROC AddProgressReport
    @thesisSerialNo INT,
    @progressReportDate DATE
AS
BEGIN 
    IF EXISTS (
        SELECT * FROM GUCianRegisterThesis GT
        WHERE GT.thesisSerialNumber = @thesisSerialNo
    )
        BEGIN
            DECLARE @GUCianStudentID INT
            SET @GUCianStudentID = (
                SELECT GUCianID
                FROM GUCianRegisterThesis
                WHERE thesisSerialNumber = @thesisSerialNo
            )

            INSERT INTO GUCianProgressReport
                (date, thesisSerialNumber)
            VALUES
                (@progressReportDate, @thesisSerialNo)
        END
    ELSE
        BEGIN
            DECLARE @NonGUCianStudentID INT
            SET @NonGUCianStudentID = (
                SELECT NonGUCianID
                FROM NonGUCianRegisterThesis
                WHERE thesisSerialNumber = @thesisSerialNo
            )

            INSERT INTO NonGUCianProgressReport
                (date, thesisSerialNumber)
            VALUES
                (@progressReportDate, @thesisSerialNo)
        END
END

---- 6.f.2: Fill a progress report.
-- TODO: where's the description in schema?
GO
CREATE PROC FillProgressReport
    @thesisSerialNo INT, 
    @progressReportNo INT, 
    @state INT, 
    @description VARCHAR(200)
AS
BEGIN
    IF EXISTS (
        SELECT * FROM GUCianRegisterThesis GT
        WHERE GT.thesisSerialNumber = @thesisSerialNo
    )
        BEGIN
            DECLARE @GUCianStudentID INT
            SET @GUCianStudentID = (
                SELECT GUCianID
                FROM GUCianRegisterThesis
                WHERE thesisSerialNumber = @thesisSerialNo
            )

            UPDATE GUCianProgressReport
            SET state = @state, description = @description
            WHERE progressReportNumber = @progressReportNo AND student_id = @GUCianStudentID
        END
    ELSE
        BEGIN
            DECLARE @NonGUCianStudentID INT
            SET @NonGUCianStudentID = (
                SELECT NonGUCianID
                FROM NonGUCianRegisterThesis
                WHERE thesisSerialNumber = @thesisSerialNo
            )

            UPDATE NonGUCianProgressReport
            SET state = @state, description = @description
            WHERE progressReportNumber = @progressReportNo AND student_id = @NonGUCianStudentID
        END
END

-- 6.g: View my progress report(s) evaluations.
GO
CREATE PROC ViewEvalProgressReport
    @thesisSerialNo INT,
    @progressReportNo INT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM GUCianProgressReport
        WHERE thesisSerialNumber = @thesisSerialNo AND progressReportNumber = @progressReportNo
    )
        BEGIN
            SELECT evaluation FROM GUCianProgressReport
            WHERE thesisSerialNumber = @thesisSerialNo AND progressReportNumber = @progressReportNo
        END
    ELSE
        BEGIN
            SELECT evaluation FROM NonGUCianProgressReport
            WHERE thesisSerialNumber = @thesisSerialNo AND progressReportNumber = @progressReportNo
        END
END

-- 6.h: Add Publication.
GO
CREATE PROC addPublication
    @title VARCHAR(50),
    @pubDate DATETIME,
    @host VARCHAR(50),
    @place VARCHAR(50),
    @accepted BIT
AS
BEGIN
    INSERT INTO Publication
        (title, date, host, place, isAccepted)
    VALUES
        (@title, @pubDate, @host, @place, @accepted)
END

-- 6.i: Link publication to my thesis.
GO
create PROC linkPubThesis
    @PubID INT,
    @thesisSerialNo INT
AS
BEGIN
    INSERT INTO Thesis_Publication
        (thesisSerialNumber, publicationID)
    VALUES
        (@thesisSerialNo, @PubID)
END
