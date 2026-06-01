-- PARAMETRO PER RISULTATO COLLOQUIO

delete from para where codice like 'RCQ%'

insert into para (codice,descri) values ('RCQ001','Adeguato')
insert into para (codice,descri) values ('RCQ002','Non Adeguato')
insert into para (codice,descri) values ('RCQ003','Necessario uteriore approfondimento')
insert into para (codice,descri) values ('RCQ004','Non risponde al telefono/mail')
insert into para (codice,descri) values ('RCQ005','Non interessato')
insert into para (codice,descri) values ('RCQ006','Fissato colloquio in Sede')

select * from para where codice like 'RCQ%'