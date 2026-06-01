select sum(ord_qtamq)from u_fat_dd
where daggancio in (select taggancio
			from u_fat_tt
			where ord_codsoc = '01'
			and ord_datord >= '2008/03/01'
			and ord_caus = '699')




select sum(ord_qtamq) from u_stc_an
where stc_data = '200803'
and stc_unimis = 'MQ'

select ord_qtamq,* from u_stc_an
where stc_data = '200803'
and stc_unimis = 'MQ'
and ord_qtamq < 0

select sum(ord_qtamq) from u_stc_an
where stc_data = '200803'
and stc_unimis = 'MQ'
and ord_qtamq < 0




select ord_qtamq,* from u_stc_an
where stc_data = '200803'
and stc_unimis = 'MQ'
and ord_qtamq > 0

select sum(ord_qtamq) from u_stc_an
where stc_data = '200803'
and stc_unimis = 'MQ'
and ord_qtamq > 0


select sum(STC_qtaVEN) from u_stc_an
where stc_data = '200803'
and stc_unimis = 'MQ'
and ord_qtamq > 0
