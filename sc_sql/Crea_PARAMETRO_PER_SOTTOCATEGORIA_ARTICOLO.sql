/********************************************************************
 PARAMETRO PER SOTTOCATEGORIA ARTICOLO
*********************************************************************
 PERMETTE DI DISCRIMINARE GLI ADESIVI
   - SE SOTTOCATEGORIA E' VUOTA, E' UN SEMPLICE ADESIVO
   - SE SOTTOCATEGORIA E' "RE", E' UN RETICOLANTE
   - SE SOTTOCATEGORIA E' "CT", E' UN CATALIZZATORE
 L'INTRODUZIONE DI QUESTO PARAMETRO E' NECESSARIA IN FASE DI ESTRAPOLAZIONE ARTICOLI ADESIVO
 DALLA DISTINTA BASE QUANDO SELEZIONE GLI ORDINI DA PRODURRE
********************************************************************/

delete from para where codice like 'STC%'

insert into para (codice,descri) values ('STCRE','RETICOLANTE')
insert into para (codice,descri) values ('STCCT','CATALIZZATORE')

select * from para where codice like 'STC%'

