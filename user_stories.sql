
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
        INNER join Thesis T1 on T1.serialNumber = GUCianRegisterThesis.thesis_id
        INNER JOIn GUCianStudent ON GUCianStudent.id = GUCianRegisterThesis.GUCianID
UNION
    Select S2.name, T2.title, NonGUCianStudent.firstName , NonGUCianStudent.lastName
    From NonGUCianRegisterThesis
        INNER JOIN Supervisor S2 On S2.id = NonGUCianRegisterThesis.supervisor_id
        INNER join Thesis T2 on T2.serialNumber = NonGUCianRegisterThesis.thesis_id
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
        INNER JOIN GUCianRegisterThesis ON ExaminerEvaluateDefense.thesis_id = GUCianRegisterThesis.thesis_id
        INNER JOIN Supervisor S ON S.id = GUCianRegisterThesis.supervisor_id
        WHEre ExaminerEvaluateDefense.[date] = @defenseDate
    --Connecting The defenseData with Date given
UNION
    select E.name , S.name
    From ExaminerEvaluateDefense
        INNER JOIN Examiner E ON E.id = ExaminerEvaluateDefense.examiner_id
        INNER JOIN NonGUCianRegisterThesis ON ExaminerEvaluateDefense.thesis_id = NonGUCianRegisterThesis.thesis_id
        INNER JOIN Supervisor S ON S.id = NonGUCianRegisterThesis.supervisor_id
        WHEre ExaminerEvaluateDefense.[date] = @defenseDate





--4)e)--

go
create proc AddDefenseNonGucian
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @DefenseLocation varchar(15)
as
IF @ThesisSerialNo is null or @DefenseDate is null or @DefenseLocation is null
BEGIN
    print 'hello'
END
else 
BEGIN
    declare @id int
    select @id = NonGUCianRegisterThesis.NonGUCianID
    from NonGUCianRegisterThesis
    where NonGUCianRegisterThesis.thesis_id = @ThesisSerialNo
    if @id IN (                 select id
        from NonGUCianStudent
    EXCEPT
        select s.id
        from NonGUCianStudent S, Course C , NonGUCianTakeCourse X
        where S.id = X.NonGUCianID and C.id = X.NonGUCianID and X.grade <= 50)
        insert into Defense
        (thesis_id, date, location)
    values
        (@ThesisSerialNo, @DefenseDate, @DefenseLocation)
END

/*
drop proc AddDefenseNonGucian
exec AddDefenseNonGucian 1, '2022-05-07', 'KOKO';
select *
from Defense;
select * from NonGUCianStudent
Select * from NonGUCianTakeCourse
-- Testing some stuff --
*/




--Hassan Solutions
GO
CREATE PROC AddDefenseGrade
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @grade decimal
AS
UPDATE defense
    grade=@grade
where thesis_id=@ThesisSerialNo and date=@DefenseDate

GO
CREATE PROC AddCommentsGrade
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @comments varchar(300)
AS
INSERT into ExaminerEvaluateDefense
    (thesis_id, date, comment)
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
WHERE GUCianProgressReport.thesis_id=@thesisSerialNo and GUCianProgressReport.progressReportNumber=@progressReportNo )
select g.evaluation
from GUCianProgressReport g
WHERE g.thesis_id=@thesisSerialNo and g.progressReportNumber=@progressReportNo
ELSE
select g.evaluation
from NonGUCianProgressReport g
WHERE g.thesis_id=@thesisSerialNo and g.progressReportNumber=@progressReportNo



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
    (thesis_id, publication_id)
VALUES
    (@thesisSerialNo, @PubID)