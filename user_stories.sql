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
if @GucianBit =1 
  INSERT INTO GUCianStudent
    (firstName,lastName,faculty,type,address)
VALUES
    (@first_name, @last_name, @faculty, @GucianBit, @address)
  else 
   INSERT INTO NonGUCianStudent
    (firstName,lastName,faculty,type,address)
VALUES
    (@first_name, @last_name, @faculty, @GucianBit, @address)

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
INSERT INTO Supervisor
    (name,faculty)
VALUES
    (@name, @faculty)



-- Leaving Success Bit --
GO
CREATE PROC userLogin
    @ID int,
    @paswword varchar(20)
AS

select *
from PostGradUser
where @iD = PostGradUser.id AND @paswword = PostGradUser.password;

-- Leave addMobile Now--



GO
CREATE PROC AdminListUp
AS
select *
from Supervisor;

GO
CREATE PROC AdminViewSupervisorProfile
    @supID INT
AS
select *
from Supervisor
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



GO
CREATE PROC AdminViewStudentThesisBySupervisor
AS
    Select S1.name, T1.title, GUCianStudent.firstName , GUCianStudent.lastName
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


-- 3)h) wait to understand

GO
CREATE PROC AdminIssueThesisPayment
    @ThesisSerial INT,
    @amount DECIMAL,
    @noOfInstallments INT,
    @fundPrecentage Decimal
AS
Declare @getIdOfThesis SMALLINT


--3)i) wait to understand



























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
if @GucianBit =1 
  INSERT INTO GUCianStudent
    (firstName,lastName,faculty,type,address)
VALUES
    (@first_name, @last_name, @faculty, @GucianBit, @address)
  else 
   INSERT INTO NonGUCianStudent
    (firstName,lastName,faculty,type,address)
VALUES
    (@first_name, @last_name, @faculty, @GucianBit, @address)

GO

CREATE PROC SupervisorRegister
    @name varchar(20),
    @password varchar(20),
    @faculty varchar(20),
    @email varchar(50)
AS
INSERT INTO PostGradUser
    (email,password)
values(@email, @password)
Insert INTO Supervisor
    (name,faculty)
values(@name , @faculty)






-- Leaving Success Bit --
GO
CREATE PROC userLogin
    @ID int,
    @paswword varchar(20)
AS

select *
from PostGradUser
where @iD = PostGradUser.id AND @paswword = PostGradUser.password;

-- Leave addMobile Now--



GO
CREATE PROC AdminListUp
AS
select *
from Supervisor;

GO
CREATE PROC AdminViewSupervisorProfile
    @supID INT
AS
select *
from Supervisor
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



GO
CREATE PROC AdminViewStudentThesisBySupervisor
AS
    Select S1.name, T1.title, GUCianStudent.firstName , GUCianStudent.lastName
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


-- 3)h) wait to understand

GO
CREATE PROC AdminIssueThesisPayment
    @ThesisSerial INT,
    @amount DECIMAL,
    @noOfInstallments INT,
    @fundPrecentage Decimal
AS
Declare @getIdOfThesis SMALLINT




GO
CREATE PROC AdminViewStudentProfile
@sid INT
AS
If EXISTS (Select * From GUCianStudent where GUCianStudent.id = @sid)
begin
select * from GUCianStudent;
end
else 
begin
select * from NonGUCianStudent;
end



--3)j) wait to undrstand




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
INSERT INTO NonGUCianTakeCourse
    (course_id ,NonGUCianID)
VALUES(@courseID, @studentID)


-- UPDATE OR INSERT ?
GO 
CREATE PROC AddStudentCourseGrade
@courseID INT,
@studentID INT,
@grade DECIMAL
AS
UPDATE NonGUCianTakeCourse
SET grade = @grade
where NonGUCianTakeCourse.NonGUCianID =@studentID AND NonGUCianTakeCourse.course_id = @courseID;



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
UNION
select E.name , S.name
From ExaminerEvaluateDefense
INNER JOIN Examiner E ON E.id = ExaminerEvaluateDefense.examiner_id
INNER JOIN NonGUCianRegisterThesis ON ExaminerEvaluateDefense.thesis_id = NonGUCianRegisterThesis.thesis_id
INNER JOIN Supervisor S ON S.id = NonGUCianRegisterThesis.supervisor_id




















































