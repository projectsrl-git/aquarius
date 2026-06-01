
select 	lis_codart,
	substring(lis_codart,
                  len(rtrim(lis_codart))-3,
                  len(rtrim(lis_codart))
        ) as DA_ELIM,
	substring(lis_codart,
                  1,
                  len(rtrim(lis_codart))-4
        ) as DA_TENERE,
	len(rtrim(lis_codart)) as lung,
* from u_lif_tt
where isnumeric(substring(lis_codart,
                          len(rtrim(lis_codart))-3,
                          len(rtrim(lis_codart))
                         )
               ) = 1 
and lis_codart != 'VERN49631'
and lis_codart not like 'M%'
order by lis_codcli



/*

update u_lif_tt
set lis_codart = substring(lis_codart,
                  1,
                  len(rtrim(lis_codart))-4
        )
where isnumeric(substring(lis_codart,
                          len(rtrim(lis_codart))-3,
                          len(rtrim(lis_codart))
                         )
               ) = 1 
and lis_codart != 'VERN49631'
and lis_codart not like 'M%'


*/