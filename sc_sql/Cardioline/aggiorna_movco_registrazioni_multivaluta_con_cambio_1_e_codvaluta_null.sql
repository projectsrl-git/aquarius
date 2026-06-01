
SELECT SOTTOCONTO,NUMERO,RIGA,CAUSALE,ECAMBIO,SEGNO,EIMPORTO,CODVALUTA,DATAVALUTA  FROM CARD_MOVCO 
WHERE NUMERO in (
	select NUMERO from 
	(select t1.NUMERO, datareg, count(t1.NUMERO) as quante_valute from (
	SELECT NUMERO,datareg,coalesce(CODVALUTA,'EUR') as codvaluta FROM CARD_MOVCO 
	where substring(datareg ,1,4) ='2013'
	group by NUMERO,datareg,CODVALUTA
	) as t1
	group by t1.NUMERO,datareg
	) as t2 
	where quante_valute >1)
order by numero,riga



update CARD_MOVCO set ecambio=0 , codvaluta=null 
WHERE NUMERO in (
	select NUMERO from 
	(select t1.NUMERO, datareg, count(t1.NUMERO) as quante_valute from (
	SELECT NUMERO,datareg,coalesce(CODVALUTA,'EUR') as codvaluta FROM CARD_MOVCO 
	where substring(datareg ,1,4) ='2013'
	group by NUMERO,datareg,CODVALUTA
	) as t1
	group by t1.NUMERO,datareg
	) as t2 
	where quante_valute >1)
