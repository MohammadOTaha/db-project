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
INSERT INTO PostGradUser (email,password)
VALUES (@email,@password)
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
INSERT INTO PostGradUser (email,password) 
VALUES (@email,@password)
INSERT INTO Supervisor(name,faculty)
VALUES (@name,@faculty)


GO
CREATE PROC userLogin
@ID int,
@paswword varchar(20)
AS
select * from PostGradUser 
where @iD = PostGradUser.id AND @paswword = PostGradUser.password;

-- Leave addMobile Now--


GO CREATE PROC AdminListUp
AS
select * from Supervisor;

GO CREATE PROC AdminViewSupervisorProfile
@supID INT
AS 
select * from Supervisor
Where Supervisor.id = @supID;


GO CREATE PROC AdminViewAllTheses
AS
select * from Thesis;

GO CREATE PROC AdminViewOnGoingTheses
AS
select T.noExtension
from Thesis T










