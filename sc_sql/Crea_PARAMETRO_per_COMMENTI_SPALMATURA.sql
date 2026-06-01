
-- PARAMETRO PER COMMENTI IN SPALMATURA

delete from para where codice like 'CSP%'

insert into para (codice,descri) values ('CSPSTR','STROPICCIATO')
insert into para (codice,descri) values ('CSPGKO','GRAMMATURA KO')
insert into para (codice,descri) values ('CSPMNC','NON CONFORME')
insert into para (codice,descri) values ('CSPLB+','LUNGHEZZA +')
insert into para (codice,descri) values ('CSPLB-','LUNGHEZZA -')
insert into para (codice,descri) values ('CSPSAD','ADESIVO SCARSO')
insert into para (codice,descri) values ('CSPHH-','ALTEZZA -')

select * from para where codice like 'CSP%'

