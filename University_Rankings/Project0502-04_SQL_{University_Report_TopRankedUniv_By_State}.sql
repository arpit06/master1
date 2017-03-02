Select University.LocState, count(distinct University.UniversityId) as TopStates from University, Yearwise 
where Yearwise.Rank < '7'
group by University.LocState having count(distinct University.UniversityId) > 4;
