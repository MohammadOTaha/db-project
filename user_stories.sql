GO
CREATE PROC StudentRegister
    @first_name varchar(20),
    @last_name varchar(20),
    @password varchar(20),
    @faculty varchar(20),
    @GucianBit BIT,
    @email varchar(50),
    @address varchar(20)
AS
INSERT INTO PostGradUser
    (email,password)
VALUES
    (@email, @password)
declare @id int = SCOPE_IDENTITY();

if @GucianBit =1 
  INSERT INTO GUCianStudent
    (id,firstName,lastName,faculty,type,address)
VALUES
    (@id, @first_name, @last_name, @faculty, @GucianBit, @address)
  else 
   INSERT INTO NonGUCianStudent
    (id,firstName,lastName,faculty,type,address)
VALUES
    (@id, @first_name, @last_name, @faculty, @GucianBit, @address)

GO
CREATE PROC SupervisorRegister
    @name varchar(20),
    @password varchar(20),
    @faculty varchar(20),
    @email varchar(20)
AS
INSERT INTO PostGradUser
    (email,password)
VALUES
    (@email, @password)
declare @id int  = scope_iDentity();

INSERT INTO Supervisor
    (id,name,faculty)
VALUES
    (@id, @name, @faculty)



--We have to ask for it--
GO
CREATE PROC userLogin
    @ID int,
    @paswword varchar(20),
    @Success bit OUTPUT
AS
if exists(select *
from PostGradUser
where PostGradUser.id = @id)
BEGIN
    set @Success = 1

end 
else 
BEGIN
    set @Success = 0;
END
/*
we have to test it
declare @success bit
exe userlogin 18,'123',@success output
print @success
*/



GO
CREATE PROC addMobile
    @ID int,
    @mobile_number varchar(20)
AS
IF EXISTS (select *
from GUCStudentPhoneNumber
where GUCStudentPhoneNumber.GUCianID = @ID )
BEGIN
    insert into GUCStudentPhoneNumber
        (GUCianID , phoneNumber)
    VALUES
        (@id, @mobile_number);
END
ELSE
BEGIN
    insert into NonGUCianPhoneNumber
        (NonGUCianID,phoneNumber)
    VALUES(@id, @mobile_number);
end;



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
    WHERE GUCianStudent.id = @sid
end
else 
begin
    select *
    from NonGUCianStudent INNER JOIN PostGradUser ON PostGradUser.id = NonGUCianStudent.id
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

--Hassan Solutions
GO
CREATE PROC AddDefenseGrade
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @grade decimal
AS
UPDATE defense
    grade=@grade
where thesisSerialNumber=@ThesisSerialNo and date=@DefenseDate

GO
CREATE PROC AddCommentsGrade
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @comments varchar(300)
AS
INSERT into ExaminerEvaluateDefense
    (thesisSerialNumber, date, comment)
VALUES
    (@ThesisSerialNo, @DefenseDate, @comments)

GO
CREATE PROC viewMyProfile
    @studentId int
AS
select *
from GUCianStudent, NonGUCianStudent
where @studentId=NonGUCianStudent.id OR @studentId=GUCianStudent;


GO
CREATE PROC editMyProfile
    @studentID int,
    @firstName varchar(10),
    @lastName varchar(10),
    @password varchar(10),
    @email varchar(10),
    @address varchar(10),
    @type varchar(10)
AS
IF EXISTS ( Select *
from GUCianStudent
WHERE GUCianStudent.ID = @studentID)
UPDATE GUCianStudent
set firstName = @firstName, lastName=@lastName, password=@password, email=@email, address=@address, type=@type
where id=@studentID
ELSE
UPDATE GUCianStudent
set firstName = @firstName, lastName=@lastName, password=@password, email=@email, address=@address, type=@type
where id=@studentID


GO
CREATE PROC addUndergradID
    @studentID int,
    @undergradID varchar(10)
AS
UPDATE GUCIANSTUDENT
set underGradID=@undergradID


GO
CREATE PROC ViewCoursesGrades
    @studentID int
AS
SELECT NonGUCianTakeCourse.grade
from NonGUCianTakeCourse
where @studentID=NonGUCianTakeCourse.NonGUCianID;


GO
CREATE PROC ViewCoursePaymentsInstall
    @studentID int
AS
select Payment.*, Installment.*
from Payment p, Installment i
    inner JOIN NonGUCianPayCourse ng on ng.payment_id=payment.payment_id
    INNER JOIN NonGUCianPayCourse ng on ng.payment_id=installment.payment_id
WHERE @studentID =ng.id


--Waiting to solve E)2,3,4

--Waiting to solve F

GO
CREATE PROC ViewEvalProgressReport
    @thesisSerialNo int,
    @progressReportNo int
AS
IF EXISTS ( Select *
from GUCianProgressReport
WHERE GUCianProgressReport.thesisSerialNumber=@thesisSerialNo and GUCianProgressReport.progressReportNumber=@progressReportNo )
select g.evaluation
from GUCianProgressReport g
WHERE g.thesisSerialNumber=@thesisSerialNo and g.progressReportNumber=@progressReportNo
ELSE
select g.evaluation
from NonGUCianProgressReport g
WHERE g.thesisSerialNumber=@thesisSerialNo and g.progressReportNumber=@progressReportNo



GO
CREATE PROC addPublication
    @title varchar(50),
    @pubDate datetime,
    @host varchar(50),
    @place varchar(50),
    @accepted bit
AS
insert into Publication
    (title, date, host, place, isAccepted)
VALUES
    (@title, @pubDate, @host, @place, @accepted)

GO
create PROC linkPubThesis
    @PubID int,
    @thesisSerialNo int
AS
insert into Thesis_Publication
    (thesisSerialNumber, publication_id)
VALUES
    (@thesisSerialNo, @PubID)