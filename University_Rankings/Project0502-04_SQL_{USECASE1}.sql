select U.UniversityName, P.ProgramName, A.AgencyName, Y.Rank, Y.Year
from University U, Yearwise Y, Agency A, Program P
where U.UniversityName like '%Maryland'
and U.UniversityId = Y.UniversityId and P.ProgramId = Y.ProgramId and A.AgencyId = Y.AgencyId;