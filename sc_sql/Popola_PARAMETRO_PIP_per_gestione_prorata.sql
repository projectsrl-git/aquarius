/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'PIP%'

insert into para (codice,descri,libera,italiano) values ('PIP2010','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')
insert into para (codice,descri,libera,italiano) values ('PIP2011','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')
insert into para (codice,descri,libera,italiano) values ('PIP2012','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')
insert into para (codice,descri,libera,italiano) values ('PIP2013','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')
insert into para (codice,descri,libera,italiano) values ('PIP2014','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')
insert into para (codice,descri,libera,italiano) values ('PIP2015','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')
insert into para (codice,descri,libera,italiano) values ('PIP2016','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')
insert into para (codice,descri,libera,italiano) values ('PIP2017','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')
insert into para (codice,descri,libera,italiano) values ('PIP2018','PRCENTUALE IVA PRORATA          ','6,5','SE IVA PRORATA HA UNA PERCENTUALE CON DECIMALI IMPOSTARE PER ES: XX,YY')


select * from para where codice like 'PIP%'
