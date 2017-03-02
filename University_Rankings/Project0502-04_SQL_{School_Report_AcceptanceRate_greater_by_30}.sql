Select University.LocState,University.UniversityName,University.LocCity,School.SchoolName,
School.TotalEnrollment, School.AcceptanceRates From University, School
where University.UniversityId = School.UniversityId and School.AcceptanceRates > '30'
order by University.LocState;
