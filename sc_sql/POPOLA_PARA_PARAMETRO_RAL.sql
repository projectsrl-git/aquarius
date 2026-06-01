
--*****************************************************
-- INSERIMENTO PARAMETRO RAGRUPPAMENTI IMPIANTI/LISTINI
--*****************************************************

delete from para where codice like 'RAL%'

insert into para (codice,descri,libera,note,italiano,inglese,PAR_COSTCAD1,PAR_RICCAD1,PAR_COSOLTRA,PAR_RICOLTRA) values ('RAL-1','Bruciatori gas/gasolio','','SANT ANDREA, RIELLO, BALTUR, HOVAL, JOANNES, THERMO, FBR, ISOTHERMO, ITALWNSON, LAMBORGHINI, ECOFLAM, QUENOD,SEVESO,UNIGAS, RHOSS, CIBUMIGAS, FULGENS','ISO1-2 OE8, OE9-11-12 OE9-2G, TN 4-8-10, KB 3-4-6-8-11, KB 4-6-8G, PG 24 AP 45, EURO 6 IO','BRUCATORI GAS/GASOLIO',34.88,98.83,30000,85000)
insert into para (codice,descri,libera,note,italiano,inglese,PAR_COSTCAD1,PAR_RICCAD1,PAR_COSOLTRA,PAR_RICOLTRA) values ('RAL-2','Bruciatori gas/gasolio','','SANT ANDREA, RIELLO, BALTUR, HOVAL, JOANNES, THERMO, FBR, ISOTHERMO, ITALWNSON, LAMBORGHINI, ECOFLAM, QUENOD,SEVESO,UNIGAS, RHOSS, CIBUMIGAS, FULGENS','OE9 1-23-4, OE9 21-22, OE9 3-4 G, KB15-22-22/2-25, KB15-22-22/2G, TN 15-18, FM 8-15, ISO 3 EURO 10, KB25MOG KB25/2G, TN 15-18G','BRUCATORI GAS/GASOLIO',100.00,232.55,86000,200000)
insert into para (codice,descri,libera,note,italiano,inglese,PAR_COSTCAD1,PAR_RICCAD1,PAR_COSOLTRA,PAR_RICOLTRA) values ('RAL-26','Caldaie murali/terra','','Arte del clima','Contratto TOP senza solare','CALDAIE MURALI/TERRA DI TUTTE LE MARCHE',0,34.8,0,34.8)
insert into para (codice,descri,libera,note,italiano,inglese,PAR_COSTCAD1,PAR_RICCAD1,PAR_COSOLTRA,PAR_RICOLTRA) values ('RAL700','Impianto obsoleto','OBSOLETO','','','',0,0,0,0)

select * from para where codice like 'RAL%'

