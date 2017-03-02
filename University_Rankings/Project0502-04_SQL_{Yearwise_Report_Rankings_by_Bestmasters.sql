select Agency.AgencyName,Program.ProgramName, University.UniversityName,Yearwise.year, Yearwise.rank
from Yearwise, Program, University, Agency
where (Yearwise.UniversityId = University.UniversityId and
Yearwise.AgencyId = Agency.AgencyId and
Yearwise.ProgramId = Program.ProgramId and Agency.AgencyName = 'BestMasters.com');
