Invia un messaggio di posta elettronica ai destinatari specificati. Il messaggio può includere il set dei risultati di una query, file allegati o entrambi. Quando un messaggio viene inserito correttamente nella coda di Posta elettronica database, sp_send_dbmail restituisce il valore di mailitem_id del messaggio. Questa stored procedure è archiviata nel database msdb.

Icona di collegamento a un argomento Convenzioni della sintassi Transact-SQL
Sintassi

sp_send_dbmail [ [ @profile_name = ] 'profile_name' ]
    [ , [ @recipients = ] 'recipients [ ; ...n ]' ]
    [ , [ @copy_recipients = ] 'copy_recipient [ ; ...n ]' ]
    [ , [ @blind_copy_recipients = ] 'blind_copy_recipient [ ; ...n ]' ]
    [ , [ @subject = ] 'subject' ] 
    [ , [ @body = ] 'body' ] 
    [ , [ @body_format = ] 'body_format' ]
    [ , [ @importance = ] 'importance' ]
    [ , [ @sensitivity = ] 'sensitivity' ]
    [ , [ @file_attachments = ] 'attachment [ ; ...n ]' ]
    [ , [ @query = ] 'query' ]
    [ , [ @execute_query_database = ] 'execute_query_database' ]
    [ , [ @attach_query_result_as_file = ] attach_query_result_as_file ]
    [ , [ @query_attachment_filename = ] query_attachment_filename ]
    [ , [ @query_result_header = ] query_result_header ]
    [ , [ @query_result_width = ] query_result_width ]
    [ , [ @query_result_separator = ] 'query_result_separator' ]
    [ , [ @exclude_query_output = ] exclude_query_output ]
    [ , [ @append_query_error = ] append_query_error ]
    [ , [ @query_no_truncate = ] query_no_truncate ]
    [ , [ @mailitem_id = ] mailitem_id ] [ OUTPUT ]


/* ######################################################################################################### */    
/* ######################################################################################################### */    
/* ######################################################################################################### */    
   
	Argomenti

/* ######################################################################################################### */    
/* ######################################################################################################### */    
/* ######################################################################################################### */    

[ @profile_name = ] 'profile_name'

    Nome del profilo da cui inviare il messaggio. profile_name è di tipo sysname e il valore predefinito è NULL. 
    profile_name deve essere il nome di un profilo esistente di Posta elettronica database. Se non si specifica 
    profile_name, per la stored procedure sp_send_dbmail verrà utilizzato il profilo privato predefinito 
    dell'utente corrente. Se all'utente non è associato un profilo privato predefinito, per sp_send_dbmail verrà 
    utilizzato il profilo pubblico predefinito per il database msdb. Se all'utente non è associato un profilo 
    privato predefinito e non esiste un profilo pubblico predefinito per il database, l'impostazione di 
    @profile_name è obbligatoria.

/* ######################################################################################################### */    
    
[ @recipients = ] 'recipients'

    Elenco delimitato da punti e virgola degli indirizzi di posta elettronica a cui inviare il messaggio. 
    L'elenco dei destinatari è di tipo varchar(max). Sebbene questo parametro sia facoltativo, è necessario 
    specificare almeno uno degli argomenti @recipients, @copy_recipients o @blind_copy_recipients. 
    In caso contrario, sp_send_dbmail restituisce un errore.

/* ######################################################################################################### */    
    
[ @copy_recipients = ] 'copy_recipients'

    Elenco delimitato da punti e virgola degli indirizzi di posta elettronica a cui inviare una copia 
    per conoscenza del messaggio. L'elenco dei destinatari della copia per conoscenza è di tipo varchar(max). 
    Sebbene questo parametro sia facoltativo, è necessario specificare almeno uno degli argomenti 
    @recipients, @copy_recipients o @blind_copy_recipients. In caso contrario, sp_send_dbmail restituisce un errore.

/* ######################################################################################################### */    
    
[ @blind_copy_recipients = ] 'blind_copy_recipients'

    Elenco delimitato da punti e virgola degli indirizzi di posta elettronica a cui inviare una copia per 
    conoscenza nascosta del messaggio. L'elenco dei destinatari della copia per conoscenza nascosta è di 
    tipo varchar(max). Sebbene questo parametro sia facoltativo, è necessario specificare almeno uno degli 
    argomenti @recipients, @copy_recipients o @blind_copy_recipients. 
    In caso contrario, sp_send_dbmail restituisce un errore.

/* ######################################################################################################### */    
    
[ @subject = ] 'subject'

    Oggetto del messaggio di posta elettronica. L'oggetto è di tipo nvarchar(255). 
    Se l'oggetto viene omesso, il valore predefinito è "Messaggio SQL Server".

/* ######################################################################################################### */    
    
[ @body = ] 'body'

    Corpo del messaggio di posta elettronica. Il corpo del messaggio è di tipo nvarchar(max) e il valore 
    predefinito è NULL.

/* ######################################################################################################### */    
    
[ @body_format = ] 'body_format'

    Formato del corpo del messaggio. Questo parametro è di tipo varchar(20) e il valore predefinito è NULL. 
    Se specificato, le intestazioni del messaggio in uscita vengono impostate in modo da indicare che per 
    il corpo del messaggio è impostato il formato specificato. Il parametro può includere uno dei valori seguenti:

        * TEXT
        * HTML

    Il valore predefinito è TEXT.

/* ######################################################################################################### */    
    
[ @importance = ] 'importance'

    Priorità del messaggio. Questo parametro è di tipo varchar(6). 
    Il parametro può includere uno dei valori seguenti:

        * Low
        * Normal
        * High

    Il valore predefinito è Normal.

/* ######################################################################################################### */    
    
[ @sensitivity = ] 'sensitivity'

    Riservatezza del messaggio. Questo parametro è di tipo varchar(12). 
    Il parametro può includere uno dei valori seguenti:

        * Normal
        * Personal
        * Private
        * Confidential

    Il valore predefinito è Normal.

/* ######################################################################################################### */    
    
[ [ @file_attachments = ] 'file_attachments'

    Elenco delimitato da punti e virgola dei nomi di file da allegare al messaggio di posta elettronica. 
    I file nell'elenco devono essere specificati come percorsi assoluti. 
    L'elenco degli allegati è di tipo nvarchar(max). Per impostazione predefinita, Posta elettronica database 
    limita le dimensioni degli allegati a 1 MB per file. Per ulteriori informazioni, vedere Configurazione 
    guidata posta elettronica database.

/* ######################################################################################################### */    
    
[ @query = ] 'query'

    Query da eseguire. I risultati della query possono essere allegati come file o inclusi nel corpo del 
    messaggio di posta elettronica. La query è di tipo nvarchar(max) e può contenere qualsiasi istruzione 
    Transact-SQL valida. Si noti che la query viene eseguita in una sessione separata, pertanto le variabili 
    locali nello script che chiama sp_send_dbmail non saranno disponibili per la query.

/* ######################################################################################################### */    
    
[ @execute_query_database = ] 'execute_query_database'

    Contesto del database in cui la stored procedure esegue la query. 
    Questo parametro è di tipo sysname e il valore predefinito è il database corrente. 
    Questo parametro è applicabile solo se si specifica @query.

/* ######################################################################################################### */    
    
[ @attach_query_result_as_file = ] attach_query_result_as_file

    Specifica se il set di risultati della query deve essere restituito come file allegato. 
    attach_query_result_as_file è di tipo bit e il valore predefinito è 0.

    Con il valore 0, 
    	i risultati della query vengono inclusi nel corpo del messaggio di posta elettronica, 
    	dopo il contenuto del parametro @body. 
    Con il valore 1, 
    	i risultati vengono restituiti come allegato. 
    	Questo parametro è applicabile solo se si specifica @query.

/* ######################################################################################################### */    
    
[ @query_attachment_filename = ] query_attachment_filename

    Specifica il nome di file da utilizzare per il set dei risultati dell'allegato query. 
    Il parametro query_attachment_filename è di tipo nvarchar(255) e il valore predefinito è NULL. 
    Quando attach_query_result è 0, questo parametro viene ignorato. 
    Quando attach_query_result è 1 e questo parametro è NULL, Posta elettronica database crea un nome file arbitrario.

/* ######################################################################################################### */    
    
[ @query_result_header = ] query_result_header

    Specifica se includere le intestazioni di colonna nei risultati della query. 
    Il valore di query_result_header è di tipo bit. Quando il valore è 1, i risultati della query contengono 
    le intestazioni di colonna. 
    Quando il valore è 0, i risultati della query non includono le intestazioni di colonna. 
    Il valore predefinito del parametro è 1. 
    Questo parametro è applicabile solo se si specifica @query.

/* ######################################################################################################### */    
    
[ @query_result_width = ] query_result_width

    Larghezza della riga, in caratteri, per la formattazione dei risultati della query. query_result_width è 
    di tipo int e il valore predefinito è 256. Il valore specificato deve essere compreso tra 10 e 32767. 
    Questo parametro è applicabile solo se è stato specificato @query.

/* ######################################################################################################### */    
    
[ @query_result_separator = ] 'query_result_separator'

    Carattere utilizzato per separare le colonne nell'output della query. Il separatore è di tipo char(1). 
    Il valore predefinito è ' ' (spazio).

/* ######################################################################################################### */    
    
[ @exclude_query_output = ] exclude_query_output

    Specifica se restituire l'output dell'esecuzione della query nel messaggio di posta elettronica. 
    exclude_query_output è di tipo bit e il valore predefinito è 0. 
    Quando questo parametro è 0 e si esegue la stored procedure sp_send_dbmail, il messaggio restituito come 
    	risultato dell'esecuzione della query viene stampato nella console. 
    Quando questo parametro è 1 e si esegue la stored procedure sp_send_dbmail, nella console non viene 
    	stampato alcun messaggio di esecuzione della query.

/* ######################################################################################################### */    
    
[ @append_query_error = ] append_query_error

    Specifica se inviare il messaggio di posta elettronica quando la query specificata nell'argomento @query 
    restituisce un errore. append_query_error è di tipo bit e il valore predefinito è 0. 
    Quando questo parametro è 1, Posta elettronica database invia il messaggio di posta elettronica e include 
    il messaggio di errore della query nel corpo del messaggio di posta elettronica. Quando questo parametro è 0, 
    Posta elettronica database non invia il messaggio di posta elettronica e sp_send_dbmail termina con il codice 
    restituito 1, che indica esito negativo.

/* ######################################################################################################### */    
    
[ @query_no_truncate = ] query_no_truncate

    Specifica se la query deve essere eseguita con l'opzione che consente di evitare il troncamento dei tipi 
    di dati a lunghezza variabile di grandi dimensioni (varchar(max), nvarchar(max), varbinary(max), xml, text, 
    ntext, image e tipi di dati definiti dall'utente). Quando il parametro è impostato, i risultati della query 
    non includono le intestazioni di colonna. Il valore di query_no_truncate è di tipo bit. 
    Quando il valore è 0 o viene omesso, la lunghezza delle colonne della query viene troncata a 256 caratteri. 
    Quando il valore è 1, le colonne della query non vengono troncate. 
    Il valore predefinito del parametro è 0.
    ms190307.note(it-it,SQL.100).gifNota:
    Se utilizzata con grandi quantità di dati, l'opzione @query_no_truncate utilizza risorse aggiuntive e può 
    causare un rallentamento delle prestazioni del server.

/* ######################################################################################################### */    
    
[ @mailitem_id = ] mailitem_id [ OUTPUT ]

    Il parametro facoltativo di output restituisce il valore di mailitem_id del messaggio. 
    mailitem_id è di tipo int.

/* ######################################################################################################### */    
    
Set di risultati

In caso di esito positivo, viene restituito il messaggio "Posta elettronica accodata".
Osservazioni

Prima dell'utilizzo, è necessario abilitare Posta elettronica database mediante la Configurazione guidata posta elettronica database o sp_configure.

sysmail_stop_sp interrompe Posta elettronica database interrompendo gli oggetti di Service Broker utilizzati dal programma esterno. sp_send_dbmail continua ad accettare messaggi anche dopo l'interruzione di Posta elettronica database mediante sysmail_stop_sp. Per avviare Posta elettronica database, utilizzare sysmail_start_sp.

Se @profile viene omesso, sp_send_dbmail utilizza un profilo predefinito. Se l'utente che invia il messaggio di posta elettronica dispone di un profilo privato predefinito, Posta elettronica database utilizzerà tale profilo. Se all'utente non è associato un profilo privato predefinito, per sp_send_dbmail verrà utilizzato il profilo pubblico predefinito. Se non è disponibile un profilo privato predefinito per l'utente oppure un profilo pubblico predefinito, sp_send_dbmail restituisce un errore.

sp_send_dbmail non supporta messaggi di posta elettronica senza contenuto. Per inviare un messaggio di posta elettronica, è necessario specificare almeno uno dei parametri @body, @query, @file_attachments o @subject. In caso contrario, sp_send_dbmail restituisce un errore.

Per controllare l'accesso ai file, Posta elettronica database utilizza il contesto di protezione di Microsoft Windows dell'utente corrente. Pertanto, gli utenti autenticati tramite l'autenticazione di SQL Server non possono allegare file con @file_attachments. Windows non consente a SQL Server di passare credenziali da un computer remoto a un altro computer remoto. Per questo motivo, Posta elettronica database potrebbe non essere in grado di allegare file da una condivisione di rete nei casi in cui il comando viene eseguito da un computer diverso dal computer in cui è in esecuzione SQL Server.

Se si specificano entrambi i parametri @query e @file_attachments e non è possibile trovare il file, la query viene comunque eseguita ma il messaggio di posta elettronica non viene inviato.

Se si specifica una query, il set dei risultati viene formattato come testo incorporato. I dati binari nel risultato vengono inviati in formato esadecimale.

I parametri @recipients, @copy_recipients e @blind_copy_recipients sono elenchi delimitati da punti e virgola di indirizzi di posta elettronica. È necessario specificare almeno uno di questi parametri. In caso contrario, sp_send_dbmail restituisce un errore.

In caso di esecuzione di sp_send_dbmail senza un contesto di transazione, Posta elettronica database avvia una transazione implicita e ne esegue il commit. In caso di esecuzione di sp_send_dbmail in una transazione esistente, il commit o il rollback di qualsiasi modifica viene gestito dall'utente. Posta elettronica database non avvia una transazione interna.
Autorizzazioni

Le autorizzazioni di esecuzione per sp_send_dbmail vengono assegnate per impostazione predefinita a tutti i membri del ruolo del database DatabaseMailUser nel database msdb. Tuttavia, se l'utente che invia il messaggio non dispone delle autorizzazioni per l'utilizzo del profilo per la richiesta, sp_send_dbmail restituisce un errore e non invia il messaggio.
Valori restituiti

In caso di esito positivo viene restituito il codice 0. Qualsiasi altro valore indica esito negativo. Il codice di errore per l'istruzione non riuscita viene archiviato nella variabile @@ERRROR.
Esempi
A. Invio di un messaggio di posta elettronica

In questo esempio viene inviato un messaggio di posta elettronica all'utente Dan Wilson con l'indirizzo di posta elettronica danw@Adventure-Works.com. L'oggetto del messaggio è Automated Success Message. Il corpo del messaggio contiene la frase 'The stored procedure finished successfully'.

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'AdventureWorks Administrator',
    @recipients = 'danw@Adventure-Works.com',
    @body = 'The stored procedure finished successfully.',
    @subject = 'Automated Success Message' ;

B. Invio di un messaggio di posta elettronica con i risultati di una query

In questo esempio viene inviato un messaggio di posta elettronica all'utente Dan Wilson con l'indirizzo di posta elettronica danw@Adventure-Works.com. L'oggetto del messaggio è Work Order Count e il messaggio esegue una query che visualizza il numero degli ordini di lavoro con una data di scadenza DueDate minore di due giorni dopo il 30 aprile 2004. I risultati vengono allegati come file di testo.

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'AdventureWorks Administrator',
    @recipients = 'danw@Adventure-Works.com',
    @query = 'SELECT COUNT(*) FROM AdventureWorks.Production.WorkOrder
                  WHERE DueDate > ''2004-04-30''
                  AND  DATEDIFF(dd, ''2004-04-30'', DueDate) < 2' ,
    @subject = 'Work Order Count',
    @attach_query_result_as_file = 1 ;

C. Invio di un messaggio di posta elettronica HTML

In questo esempio viene inviato un messaggio di posta elettronica all'utente Dan Wilson con l'indirizzo di posta elettronica danw@Adventure-Works.com. L'oggetto del messaggio è Work Order List e il messaggio contiene un documento HTML che visualizza gli ordini di lavoro con una data di scadenza DueDate minore di due giorni dopo il 30 aprile 2004. Il messaggio viene inviato in formato HTML.

DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>Work Order Report</H1>' +
    N'<table border="1">' +
    N'<tr><th>Work Order ID</th><th>Product ID</th>' +
    N'<th>Name</th><th>Order Qty</th><th>Due Date</th>' +
    N'<th>Expected Revenue</th></tr>' +
    CAST ( ( SELECT td = wo.WorkOrderID,       '',
                    td = p.ProductID, '',
                    td = p.Name, '',
                    td = wo.OrderQty, '',
                    td = wo.DueDate, '',
                    td = (p.ListPrice - p.StandardCost) * wo.OrderQty
              FROM AdventureWorks.Production.WorkOrder as wo
              JOIN AdventureWorks.Production.Product AS p
              ON wo.ProductID = p.ProductID
              WHERE DueDate > '2004-04-30'
                AND DATEDIFF(dd, '2004-04-30', DueDate) < 2 
              ORDER BY DueDate ASC,
                       (p.ListPrice - p.StandardCost) * wo.OrderQty DESC
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;

EXEC msdb.dbo.sp_send_dbmail @recipients='danw@Adventure-Works.com',
    @subject = 'Work Order List',
    @body = @tableHTML,
    @body_format = 'HTML' ;

Vedere anche
Riferimento
Stored procedure di Posta elettronica database e SQL Mail (Transact-SQL)
sp_addrolemember (Transact-SQL)
Altre risorse
Posta elettronica database
Profili di Posta elettronica database
Configurazione guidata posta elettronica database

Guida e informazioni
Assistenza su SQL Server 2008 