/*

	PARAMETRI CONTENUTI NELLA CARTELLA "CRITERI OTTIMIZZAZIONE"
	DEL FORM "PRD_TAPPETO"

*/


--- NUMERO RICORRENZE FASCIA MINIMA PER FERMARE IL CALCOLO
delete from para where codice like 'NRF%'
insert into para (codice,descri,LIBERA) values ('NRF01','NUMERO RICORRENZE FASCIA MINIMA','5')
select * from para where codice like 'NRF%'




--- NUMERO MASSIMO COMBINAZIONI DA PROVARE
delete from para where codice like 'NRC%'
insert into para (codice,descri,LIBERA) values ('NRC01','NUMERO MASSIMO COMBINAZIONI DA PROVARE','150')
select * from para where codice like 'NRC%'

