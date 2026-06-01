
-- PARAMETRO PER CONOSCIENZA CORSO CONTATTO

delete from para where codice like 'ARC%'

insert into para (codice,descri) values ('ARC001','Area 1')
insert into para (codice,descri) values ('ARC002','Area 2')
insert into para (codice,descri) values ('ARC003','Area 3')
insert into para (codice,descri) values ('ARC004','Area 4')
insert into para (codice,descri) values ('ARC005','Area 5')

select * from para where codice like 'ARC%'
