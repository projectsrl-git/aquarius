/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'FSD700'
delete from para where codice like 'FSD800'

insert into para (codice,descri,libera) values ('FSD700','PERCORSO AQUARIUS CONTENENTE SCRIPT SQL SINGOLI DA UNIFICARE','C:\PROGETTI\posta\da')
insert into para (codice,descri,libera) values ('FSD800','PERCORSO AGGIORNAMENTI SW CONTENENTE IL MEGA SCRIPT CREATO','C:\AGGIORNAMENTI_SW_AQUARIUS')


select * from para where codice like 'FSD%'
