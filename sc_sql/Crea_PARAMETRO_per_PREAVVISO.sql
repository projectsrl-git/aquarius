
-- PARAMETRO PER PREAVVISO

delete from para where codice like 'PRV%'

insert into para (codice,descri) values ('PRV001','1 settimana')
insert into para (codice,descri) values ('PRV002','2 settimane')
insert into para (codice,descri) values ('PRV003','3 settimane')
insert into para (codice,descri) values ('PRV004','1 mese')
insert into para (codice,descri) values ('PRV005','2 mesi')
insert into para (codice,descri) values ('PRV006','3 mesi')
insert into para (codice,descri) values ('PRV007','4 mesi')
insert into para (codice,descri) values ('PRV008','5 mesi')
insert into para (codice,descri) values ('PRV009','6 mesi')
insert into para (codice,descri) values ('PRV010','7 mesi')
insert into para (codice,descri) values ('PRV011','8 mesi')
insert into para (codice,descri) values ('PRV012','9 mesi')
insert into para (codice,descri) values ('PRV012','10 mesi')
insert into para (codice,descri) values ('PRV012','11 mesi')
insert into para (codice,descri) values ('PRV012','1 anno')
insert into para (codice,descri) values ('PRV012','Più di 1 anno')

select * from para where codice like 'PRV%'
