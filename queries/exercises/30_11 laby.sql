use library

select m.lastname, m.firstname, count (*), m.member_no
from member as m
       join adult a on m.member_no = a.member_no
       join juvenile j on j.adult_member_no = m.member_no
where state = 'AZ'
group by m.member_no, m.lastname, m.firstname
having count (*) > 2


