SELECT * FROM U_ORF_TT WHERE ORD_ANNO = '2010'
AND ORD_VALORE >= 25000

SELECT DISTINCT ORD_CODCLI FROM U_ORF_TT WHERE ORD_ANNO = '2010'
AND ORD_VALORE >= 25000

SELECT * from u_bfo_dd where ord_legame


select * from u_orf_tt 
where taggancio in (
	select distinct daggancio from (
		SELECT sum(ord_valore) as totale,
			   daggancio
		FROM U_BFO_DD 
		WHERE ORD_LEGASY in (
			SELECT ord_codsys FROM U_ORF_dd 
			WHERE daggancio in (
					SELECT taggancio FROM U_ORF_TT WHERE ORD_ANNO = '2010'
					AND ORD_VALORE >= 25000
			)
			and ord_codart != ''
			group by ord_codsys
		) 
		group by daggancio
	) as t1 
) order by ord_codcli


SELECT * FROM U_BFO_TT 
WHERE ORD_DATORD = '2011/12/16'
WHERE ORD_LEGASY = '_2XA0PGMDV' 
AND ORD_LEGAME = '6000001210'






SELECT * FROM U_IVF_CL WHERE IVF_ANNO = '2010' 
AND IVF_CODCLI IN 
( SELECT DISTINCT ORD_CODCLI 
  FROM U_ORF_TT WHERE ORD_ANNO = '2010'
  AND ORD_VALORE >= 25000 
)
order by ivf_mese,ivf_numfat,ivf_imponi



select ord_codcli,ord_ragsoc,ord_numord,ord_datord,ord_riferi,ord_valore,ord_valimp 
from u_bfo_tt 
where taggancio in (
	select distinct daggancio from (
		SELECT sum(ord_valore) as totale,
			   daggancio
		FROM U_BFO_DD 
		WHERE ORD_LEGASY in (
			SELECT ord_codsys FROM U_ORF_dd 
			WHERE daggancio in (
					SELECT taggancio FROM U_ORF_TT WHERE ORD_ANNO = '2010'
					AND ORD_VALORE >= 25000
				)
			and ord_codart != ''
			group by ord_codsys
		) 
		group by daggancio
	) as t1 
) 
and ord_valimp < 25000
order by ord_codcli,ord_numord,ord_valimp


SELECT ORD_CGE,* FROM U_FAT_TT

select * from u_ivf_cl WHERE IVF_DL78 = 1
select * from U_IVF_CL where IVF_CODCLI = '2010000000334' and IVF_ANNO = '2010' order by IVF_NUMFAT