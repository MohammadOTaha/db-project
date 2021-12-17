------------------- (1) Unregistered User's Features -------------------
-- 1.a:  Register to the website.
EXEC StudentRegister -- GUCian
    'Mark', 'Zuck', '123', 'CS', 1, 'zuck@example.com', 'Harvard St.';
EXEC StudentRegister -- Non-GUCian
    'Bill', 'Gates', '456', 'CS', 0, 'gates@example.com', 'Harvard St.';

EXEC SupervisorRegister
    'SUPER11', '123', 'CS', 'SUPER11@example.com'

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

EXEC EvaluateProgressReport 11,6,1,3 -- Non- GUCian

EXEC ViewSupStudentsYears 13 -- 13 Supervise two students One GUCIAN and other Not Gucian

EXEC SupViewProfile 11

EXEC UpdateSupProfile 14,'Roby','MET';

--Another test case needed
EXEC ViewAStudentPublications 4





