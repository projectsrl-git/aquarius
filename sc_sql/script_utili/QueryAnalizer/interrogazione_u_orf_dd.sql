select ors_codcli,ord_codart,ord_desart,ord_qtaord,ord_qtaev,ord_qtadev,ord_datcon,* from u_orf_dd order by ord_datcon

select ors_codcli,ord_codart,ord_qtaord,ord_qtaev,ord_qtadev,* from u_ord_dd order by ord_datcon

select * from u_orf_dd where ors_datord = ors_datord and ord_datcon between '2007/01/01' and '2008/12/31' and ors_codcli = ors_codcli and ord_codart = 'MP_01' and ord_codmat = ord_codmat and ord_codcol = ord_codcol and ord_spesso = ord_spesso and ord_altezz = ord_altezz and ord_lunghe = ord_lunghe and (ord_qtaord - ord_qtaev) > 0 order by ord_datcon

