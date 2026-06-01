/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'ICP%'

insert into para (codice,descri,libera) values ('ICP00010','Azienda distaccante           :','** TIPO ELAB:1 * COSTO:   2,00**  RICAVO:   5,00** Intercetta cedolini particolari zucchetti')
insert into para (codice,descri,libera) values ('ICP00020','Agenzia di somministrazione   :','** TIPO ELAB:2 * COSTO:   3,00**  RICAVO:   6,00** Intercetta cedolini particolari zucchetti')


select * from para where codice like 'ICP%'
/* select * from para where codice like 'ICP%' and descri = 'Agenzia di somministrazione   :' */
