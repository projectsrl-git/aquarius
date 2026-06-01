-- per permettere al form di spalmatura di estrarre delle righe di programma
-- di produzione da selezionare

-- In spalmatura faccio un filtro e mi prendo solo quei programmi 
-- che hanno lo stato a : 002, 003, 004
--		SPP002	PRONTO PER SPALMATURA
--		SPP003	IN SPALMATURA
--		SPP004	SPALMATURA SOSPESA



update u_prd_d1 set pr1_staprg = '003'
