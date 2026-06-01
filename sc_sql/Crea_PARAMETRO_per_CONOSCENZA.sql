
-- PARAMETRO PER CONOSCIENZA CORSO CONTATTO

delete from para where codice like 'CNS%'

insert into para (codice,descri) values ('CNS001','Conoscenza diretta')
insert into para (codice,descri) values ('CNS002','Pubblicità giornale')
insert into para (codice,descri) values ('CNS003','Pubblicità internet')
insert into para (codice,descri) values ('CNS004','Passaparola')
insert into para (codice,descri) values ('CNS005','Volantini')

select * from para where codice like 'CNS%'
