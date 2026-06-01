
-- PARAMETRO PER TRASFERTE

delete from para where codice like 'TRX%'

insert into para (codice,descri) values ('TRX001','Nessuna disponibilità')
insert into para (codice,descri) values ('TRX002','Italia - Brevi')
insert into para (codice,descri) values ('TRX003','Italia')
insert into para (codice,descri) values ('TRX004','Estero - Brevi')
insert into para (codice,descri) values ('TRX005','Estero')
insert into para (codice,descri) values ('TRX006','Italia/Estero - Brevi')
insert into para (codice,descri) values ('TRX007','Italia/Estero')

select * from para where codice like 'TRX%'
