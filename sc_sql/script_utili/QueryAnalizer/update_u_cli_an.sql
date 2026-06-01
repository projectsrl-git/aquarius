SELECT for_clicee, for_ba2abi, for_ba2cab , for_ba2cc , * FROM U_FOR_AN WHERE for_ba2cab <> ''
SELECT for_clicee, for_ba2abi, for_ba2cab , for_ba2cc , * FROM U_FOR_AN WHERE for_ba2cc  <> ''
SELECT for_clicee, for_ba2abi, for_ba2cab , for_ba2cc , * FROM U_FOR_AN WHERE for_clicee <> ''


SELECT CLI_VALUTA,* FROM U_CLI_AN WHERE CLI_VALUTA = ''

UPDATE U_CLI_AN SET CLI_VALUTA = 'EUR' where CLI_VALUTA = ''


SELECT FOR_VALUTA,* FROM U_FOR_AN WHERE FOR_VALUTA = ''

UPDATE U_FOR_AN SET FOR_VALUTA = 'EUR' where FOR_VALUTA = ''
