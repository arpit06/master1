select count(y.UniversityId) as 'Number of Universities', u.LocState as 'State'
from Yearwise y, University u
where y.UniversityId = u.UniversityId
group by 'State';