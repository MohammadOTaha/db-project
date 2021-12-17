USE PostGradSystem;

------------------- (1) Unregistered User's Features -------------------
-- 1.a:  Register to the website.
EXEC StudentRegister -- GUCian
    'Mark', 'Zuck', '123', 'CS', 1, 'zuck@example.com', 'Harvard St.';
EXEC StudentRegister -- Non-GUCian
    'Bill', 'Gates', '456', 'CS', 0, 'gates@example.com', 'Harvard St.';

EXEC SupervisorRegister
    'SUPER11', '123', 'CS', 'SUPER11@example.com';

------------------- (2) Registered User's Features -------------------
-- 2.a: login using my username and password.
DECLARE @successBit BIT;
EXEC userLogin -- successfull login
    1, '1234', @successBit OUTPUT;
    PRINT @successBit;
EXEC userLogin -- unsuccessfull login
    2, '123', @successBit OUTPUT;
    PRINT @successBit;

-- 2.b: add my mobile number(s).
EXEC addMobile -- GUCian
    1, '1234567890';
EXEC addMobile -- Non-GUCian
    6, '1234567890';

------------------- (4) Supservisor's Features -------------------
-- 4.a: Evaluate a student’s progress report, and give evaluation value 0 to 3
EXEC EvaluateProgressReport 11 ,1,1,3; -- GUCian
EXEC EvaluateProgressReport 11,6,1,3; -- Non- GUCian

-- 4.b:  View all my students’s names and years spent in the thesis.
EXEC ViewSupStudentsYears 13; -- 13 Supervise two students One GUCIAN and other Not Gucian

-- 4.c:  View all my students’s names and years spent in the thesis.
EXEC SupViewProfile 11;
EXEC UpdateSupProfile 14,'Roby','MET';

-- 4.d: View all publications of a student.
EXEC ViewAStudentPublications 4;

-- 4.e: AddDefenseGucian, AddDefenseNonGucian
EXEC AddDefenseGucian 1 ,'2011-05-02','Mozmbik';
EXEC AddDefenseNonGucian 6 , '2022-8-20','Fala70';

-- 4.f: Add examiner(s) for a defense.
EXEC AddExaminer 15, '2010-02-01', 'Roberto', 0, 'CS'

-- 4.g: Cancel a Thesis if the evaluation of the last progress report is zero.
EXEC CancelThesis 5;

-- 4.h: Add a grade for a thesis
EXEC AddGrade 3, 32; 

------------------- (5) Examiner's Features -------------------
-- 5.a: Add grade for a defense.
EXEC AddGradeDefense 1, '2019-05-07', 70.35;

-- 5.b: Add comments for a defense.
EXEC AddCommentsGrade 1, '2019-05-07', 'This is a good defense';

------------------- (6) Registered Student's Features -------------------
-- 6.a: View my profile that contains all my information.
EXEC viewMyProfile 1;

-- 6.b: Edit my profile (change any of my personal information).
EXEC editMyProfile 1, 'Eric', 'Cartman', '123', 'coon@example.com', 'South Park', 'Non GUCian';

-- 6.c: AS a Gucian graduate, add my undergarduate ID.
EXEC addUndergradID 1, 69;

-- 6.d: AS a nonGucian student, view my courses’ grades.
EXEC ViewCoursesGrades 6;

-- 6.e: View all my payments and installments.
---- 6.e.1: View course paymeents.
EXEC ViewCoursePaymentsInstall 6;

---- 6.e.2: View thesis payments.
EXEC ViewThesisPaymentsInstall 1;

---- 6.e.3: View upcoming installments.
EXEC ViewUpcomingInstallments 4;

---- 6.e.4: View missed installments.
EXEC ViewMissedInstallments 1;

-- 6.f: Add and fill my progress report(s).
---- 6.f.1: Add a progress report.
EXEC AddProgressReport 1, '2069-01-01';

---- 6.f.2: Fill a progress report.
EXEC FillProgressReport 1, 1, 200, 'This is a good progress report';

-- 6.i: Link Publication to my thesis
EXEC linkPubThesis 1, 3;

-- 6.h: Add Publication
EXEC addPublication "Facebook Company Interview",'2027-8-20','Host1','Berlin',1;

-- 6.g: View my progress report(s) evaluations.
EXEC ViewEvalProgressReport 6, 1;