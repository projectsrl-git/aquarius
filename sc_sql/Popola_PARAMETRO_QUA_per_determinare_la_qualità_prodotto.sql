/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'QUA01'
insert into para (codice,descri,libera) values ('QUA01','Prodotto eccellente','')
delete from para where codice like 'QUA02'
insert into para (codice,descri,libera) values ('QUA02','Prodotto colore scuro','')
delete from para where codice like 'QUA03'
insert into para (codice,descri,libera) values ('QUA03','Prodotto colore chiaro','')
delete from para where codice like 'QUA04'
insert into para (codice,descri,libera) values ('QUA04','Prodotto prodotto da almeno 1 anno','')
delete from para where codice like 'QUA05'
insert into para (codice,descri,libera) values ('QUA05','Prodotto prodotto da almeno 2 anno','')
delete from para where codice like 'QUA06'
insert into para (codice,descri,libera) values ('QUA06','Prodotto prodotto da oltre due anni','')








select codice,descri,libera,italiano,note,desiva,* from para where codice like 'QUA%'
