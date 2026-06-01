
select * from tbl_menu

--delete from tbl_menu


-- PRIMA DI ESEGUIRE LE QUERY SUL SERVER REMOTO, ASSICURARSI CHE IL SERVER REMOTO E LE CREDENZIALI SIANO MEMORIZZATE NEL SYS.SERVERS TRAMITE I SEGUENTI COMANDI:
--		exec sp_addlinkedserver '<NOME_O_IP_SERVER_REMOTO>'
--		exec sp_addlinkedsrvlogin 'NOME_O_IP_SERVER_REMOTO', 'FALSE', NULL, 'sviluppo', 'sviluppo'


--insert into tbl_menu select * from [SRV-L3A].L3A.[DBO].tbl_menu
