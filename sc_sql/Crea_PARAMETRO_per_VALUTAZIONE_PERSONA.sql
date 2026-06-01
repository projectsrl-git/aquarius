-- PARAMETRO PER VALUTAZIONE PERSONA

delete from para where codice like 'VLP%'

insert into para (codice,descri) values ('VLP001','Negativa')
insert into para (codice,descri) values ('VLP002','Media')
insert into para (codice,descri) values ('VLP003','Positiva')

select * from para where codice like 'VLP%'