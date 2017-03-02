select Yearwise.year, Yearwise.rank, Program.ProgramName, Agency.AgencyName,
University.UniversityName, University.LocState from Yearwise, Program, Agency, University
where (Yearwise.UniversityId = University.UniversityId and
Yearwise.AgencyId = Agency.AgencyId and
Yearwise.ProgramId = Program.ProgramId) order by University.LocState;
