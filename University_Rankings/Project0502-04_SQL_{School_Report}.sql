Select University.UniversityName, University.LocCity, University.LocState, School.SchoolName,
School.TotalEnrollment, School.AcceptanceRates From University, School
where University.UniversityId = School.UniversityId; 
