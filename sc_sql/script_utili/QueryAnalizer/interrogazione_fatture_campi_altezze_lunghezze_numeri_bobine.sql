select taggancio,tiprendo,* from u_bol_tt order by taggancio desc
select taggancio,* from u_fat_tt order by taggancio desc
select daggancio,ors_codcli,ors_numddt,ors_datddt,ord_codart,ord_altezz,ord_lunghe,ord_numbob,ord_qtakg,ord_qtamq,ord_qtaml,* from u_fat_dd order by daggancio desc

select taggancio,tiprendo,* from u_bol_tt where ord_numord = '000197' and ord_datord = '2008/03/02'
select daggancio,ord_altezz,ord_lunghe,ord_numbob,ord_qtakg,ord_qtamq,ord_qtaml,* from u_bol_dd where daggancio = '6006001745' and ord_codart = 'AM 58'




