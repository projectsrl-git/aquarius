
--********************************************************************
-- INSERIMENTO PARAMETRO "Tipologia gruppo termico"
--********************************************************************

delete from para where codice like 'MCA%'

insert into para (codice,descri,libera,codpgo,italiano) values ('MCA001','GRUPPO TERMICO SINGOLO','','','')
insert into para (codice,descri,libera,codpgo,italiano) values ('MCA002','GRUPPO TERMICO MODULARE','','','')
insert into para (codice,descri,libera,codpgo,italiano) values ('MCA003','TUBO/NASTRO RADIANTE','','','')
insert into para (codice,descri,libera,codpgo,italiano) values ('MCA004','GENERATORE D''ARIA CALDA','','','')

select * from para where codice like 'MCA%'

--UPDATE IMPIANTI_TE SET ID_MARCATU = ''

