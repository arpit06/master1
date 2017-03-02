CREATE TABLE Program (
	ProgramId INTEGER NOT NULL,
	ProgramName	VARCHAR(5),
	CONSTRAINT pk_Program_ProgramId PRIMARY KEY(ProgramId)
);

CREATE TABLE University (
	UniversityId INTEGER NOT NULL,
	UniversityName VARCHAR(50),
	LocCity VARCHAR(20),
	LocState VARCHAR(20),
	LocZipcode CHAR(5),
	CONSTRAINT pk_University_UniversityId PRIMARY KEY(UniversityId)
);

CREATE TABLE Agency (
	AgencyId Integer NOT NULL,
	AgencyName VARCHAR(30),
	CONSTRAINT pk_Agency_AgencyId PRIMARY KEY(AgencyId)
);

CREATE TABLE Yearwise (
	ProgramId INTEGER NOT NULL,
	AgencyId INTEGER NOT NULL,
	UniversityId INTEGER NOT NULL,
	Year CHAR(4) NOT NULL,
	Rank INTEGER 
	CONSTRAINT pk_Yearwise_ProgramId_AgnecyId_UniversityId_Year PRIMARY KEY(ProgramId, AgencyId, UniversityId, Year),
	CONSTRAINT fk_Yearwise_ProgramId FOREIGN KEY (ProgramId)
	REFERENCES Program (ProgramId)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT fk_Yearwise_AgencyId FOREIGN KEY (AgencyId)
	REFERENCES Agency (AgencyId)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT fk_Yearwise_UniversityId FOREIGN KEY (UniversityId)
	REFERENCES University (UniversityId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE School (
	SchoolId INTEGER NOT NULL,
	UniversityId INTEGER,
	SchoolName VARCHAR(50),
	TotalEnrollment INTEGER,
	AcceptanceRates DECIMAL(4,2)
	CONSTRAINT pk_School_SchoolId PRIMARY KEY (SchoolId),
	CONSTRAINT fk_School_UniversityId FOREIGN KEY (UniversityId)
	REFERENCES University (UniversityId)
	ON DELETE CASCADE
	ON UPDATE NO ACTION
);

CREATE TABLE Contact (
	UniversityId INTEGER,
	Email VARCHAR(30),
	Phone VARCHAR(12),
	Fax VARCHAR(12),
	Website VARCHAR(150)
	CONSTRAINT fk_Contact_UniversityId FOREIGN KEY (UniversityId)
	REFERENCES University (UniversityId)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);
