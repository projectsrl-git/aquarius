update COMUNI set COMUNE = REPLACE(COMUNE,'a''','à') WHERE COMUNE LIKE '%a''%'

go

 

update COMUNI set COMUNE = REPLACE(COMUNE,'e''','è') WHERE COMUNE LIKE '%e''%'

go

 

update COMUNI set COMUNE = REPLACE(COMUNE,'i''','ì') WHERE COMUNE LIKE '%i''%'

go

 

update COMUNI set COMUNE = REPLACE(COMUNE,'o''','ò') WHERE COMUNE LIKE '%o''%'

go

 

update COMUNI set COMUNE = REPLACE(COMUNE,'u''','ù') WHERE COMUNE LIKE '%u''%'

go

 

update COMUNI set COMUNE = REPLACE(COMUNE,'''','`') WHERE COMUNE LIKE '%''%'

go

 

select * from COMUNI order by comune

