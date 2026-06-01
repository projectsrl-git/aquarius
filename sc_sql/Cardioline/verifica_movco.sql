
--0018238

select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and numero ='0017657' order by numero,riga
select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and numero ='0005783' order by numero,riga
select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and numero ='0008433' order by numero,riga
select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and numero ='0008699' order by numero,riga
select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and numero ='0008699' order by numero,riga



select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and numero ='0017851' order by numero,riga

select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and datareg ='20130103' and datadocum = '20130102' and sottoconto = '20010002' and eimporto = 1357.02  order by numero,riga
select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and datareg ='20130103' and datadocum = '20120711' and sottoconto = '100100316' and eimporto = 340.62  order by numero,riga
select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and datareg ='20130108' and datadocum = '20121221' and sottoconto = '100290041' and eimporto = 35.00  order by numero,riga

select datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and datareg ='20130101' and datadocum = '20130101' and sottoconto = '99010001' and eimporto = 3402.23  order by numero,riga

SELECT * FROM card_movco
			WHERE datareg = '20130109' and datadocum = '        ' and sottoconto = '12030001' and eimporto = '44187.60' 



SELECT NUMERO,DATAREG,EIMPORTO,SOTTOCONTO,* FROM card_movco
			WHERE datareg = '20130131'  and sottoconto = '06010005' and eimporto = '631002.64' 


select SOLOANA_SN,datareg,c_f,sottoconto,numdocum,datadocum,causale,segno,codvaluta,cambio,datacambio,eimporto,descragg,* from card_movco where eseregistr = '2013' and SOLOANA_SN = 'N'

select datareg,numero,c_f,sottoconto,numdocum,datadocum,causale,segno,eimporto,descragg from card_movco where eseregistr = '2013'


--ragruppa per anno registrazione/numero e verifica quadratura prima nota per tutto l'anno
SELECT 
	datareg,
	numero,
	SUM(DARE)-SUM(AVERE) AS SALDO
FROM (
SELECT 
	datareg,
	numero,
	CASE WHEN  segno = 'D' THEN eimporto ELSE 0 END AS DARE,
	CASE WHEN  segno = 'A' THEN eimporto ELSE 0 END AS AVERE
FROM card_movco
WHERE SUBSTRING(datareg,1,4) = '2013') AS T1
GROUP BY datareg, numero
order by datareg,numero

--ragruppa per anno registrazione/numero e verifica quadratura prima nota per singolo mese
SELECT 
	datareg,
	numero,
	SUM(DARE)-SUM(AVERE) AS SALDO
FROM (
SELECT 
	datareg,
	numero,
	CASE WHEN  segno = 'D' THEN eimporto ELSE 0 END AS DARE,
	CASE WHEN  segno = 'A' THEN eimporto ELSE 0 END AS AVERE
FROM card_movco
WHERE SUBSTRING(datareg,1,6) = '201301') AS T1
GROUP BY datareg, numero
order by datareg,numero


--ottiene totale dare/avere per periodo dal mese al mese
SELECT 
	sum(case when SEGNO='D' then EIMPORTO else 0 end) as DARE,
	sum(case when SEGNO='A' then EIMPORTO else 0 end) as AVERE,
	sum(case when SEGNO='D' then EIMPORTO else -1*EIMPORTO end) as SALDO
FROM card_movco
WHERE SUBSTRING(datareg,1,6) >= '201301' and SUBSTRING(datareg,1,6) <= '201306'

--ottiene totale dare/avere del mese
SELECT 
	sum(case when SEGNO='D' then EIMPORTO else 0 end) as DARE,
	sum(case when SEGNO='A' then EIMPORTO else 0 end) as AVERE,
	sum(case when SEGNO='D' then EIMPORTO else -1*EIMPORTO end) as SALDO
FROM card_movco
WHERE SUBSTRING(datareg,1,6) = '201301'  

--ottiene totale dare/avere della registrazine
SELECT 
	sum(case when SEGNO='D' then EIMPORTO else 0 end) as DARE,
	sum(case when SEGNO='A' then EIMPORTO else 0 end) as AVERE,
	sum(case when SEGNO='D' then EIMPORTO else -1*EIMPORTO end) as SALDO
FROM card_movco
WHERE SUBSTRING(datareg,1,4) = '2013' and numero = '0017655'  


select codvaluta,cambio,datacambio,eimporto,* from card_movco where eseregistr = '2013' and codvaluta <> 'EUR'

