/* ############################################################################################################### */

Sintassi

	SERVERPROPERTY ( propertyname )

/* ############################################################################################################### */	
	
Argomenti

/* --------------------------------------------------------------------------------------------------------------- */

  propertyname

    Espressione contenente il nome della proprietà per la quale devono essere restituite informazioni per il server. I possibili valori di propertyname sono i seguenti.
    Nome proprietà 	Valori restituiti

/* --------------------------------------------------------------------------------------------------------------- */
        
  BuildClrVersion
    	
    Versione di Microsoft .NET Framework Common Language Runtime (CLR) utilizzata durante la generazione dell'istanza di SQL Server 2005.
    Tipo di dati di base: nvarchar(128).

/* --------------------------------------------------------------------------------------------------------------- */
    
  Collation
  
    Nome delle regole di confronto predefinite per il server.
	NULL = Input non valido o errore.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  CollationID

    ID delle regole di confronto SQL Server.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  ComparisonStyle

    Stile di confronto di Windows per le regole di confronto.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  ComputerNamePhysicalNetBIOS

    Nome NetBIOS del computer locale in cui è in esecuzione l'istanza di SQL Server.
    Per un'istanza cluster di SQL Server in un cluster di failover, questo valore cambia in caso di failover dell'istanza di SQL Server su altri nodi del cluster di failover.
    In un'istanza autonoma di SQL Server, questo valore rimane costante e corrisponde al valore della proprietà MachineName.
    Se l'istanza di SQL Server è inclusa in un cluster di failover e si desidera ottenere il nome dell'istanza del cluster di failover, utilizzare la proprietà MachineName.
    ms174396.note(it-it,SQL.90).gifNota:
    NULL = Input non valido o errore.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  Edition
  
    Edizione del prodotto installata per l'istanza di SQL Server. Utilizzare il valore di questa proprietà per determinare le funzionalità e i limiti, come il numero massimo di CPU, supportati dal prodotto installato.
    Restituisce:
    'Desktop Engine' (non disponibile per SQL Server 2005)
    'Developer Edition'
    'Enterprise Edition'
    'Enterprise Evaluation Edition'
    'Personal Edition' (non disponibile per SQL Server 2005)
    'Standard Edition'
    'Express Edition'
    'Express Edition with Advanced Services'
    'Workgroup Edition'
    'Windows Embedded SQL'
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */

  EditionID

    Numero di identificazione che rappresenta l'edizione del prodotto installata per l'istanza di SQL Server. Utilizzare il valore di questa proprietà per determinare le funzionalità e i limiti, come il numero massimo di CPU, supportati dal prodotto installato.
    -1253826760 = Desktop Edition
    -1592396055 = Express Edition
    -1534726760 = Standard Edition
    -1333529388 = Workgroup Edition
    -1804890536 = Enterprise Edition
    -323382091 = Personal Edition
    -2117995310 = Developer Edition
    -610778273 = Enterprise Evaluation Edition
    -1044790755 = Windows Embedded SQL
    -4161255391 = Express Edition with Advanced Services
    Per ulteriori informazioni, vedere Funzionalità supportate dalle edizioni di SQL Server 2005.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  EngineEdition

    Edizione del Motore di database dell'istanza di SQL Server installata nel server.
    1 = Personal o Desktop Engine (non disponibile per SQL Server 2005)
    2 = Standard (valore restituito per le edizioni Standard e Workgroup)
    3 = Enterprise (valore restituito per le edizioni Enterprise, Enterprise Evaluation e Developer)
    4 = Express (valore restituito per le edizioni Express, Express Edition with Advanced Services e Windows Embedded SQL)
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  InstanceName
   	
    Nome dell'istanza a cui è connesso l'utente.
    Restituisce NULL se il nome dell'istanza corrisponde all'istanza predefinita oppure in caso di input non valido o di errore.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  IsClustered
    	
    L'istanza del server è configurata in un cluster di failover.
    1 = Cluster.
    0 = Non cluster.
    NULL = Input non valido o errore.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  IsFullTextInstalled

    Indica se il componente full-text è installato o meno nell'istanza corrente di SQL Server.
    1 = Il componente full-text è installato.
    0 = Il componente full-text non è installato.
    NULL = Input non valido o errore.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */    
    
  IsIntegratedSecurityOnly
    
    Indica se nel server è attivata o meno la modalità di protezione integrata.
    1 = Protezione integrata attivata.
    0 = Protezione integrata non attivata.
    NULL = Input non valido o errore.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */

  IsSingleUser
  
    Indica se nel server è attivata o meno la modalità utente singolo.
    1 = Modalità utente singolo attivata.
    0 = Modalità utente singolo non attivata.
    NULL = Input non valido o errore.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  LCID
    	

    Identificatore delle impostazioni internazionali (LCID) di Windows per le regole di confronto.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  LicenseType
    	
    Modalità dell'istanza corrente di SQL Server.
    PER_SEAT = Modalità Per Postazione
    PER_PROCESSOR = Modalità Per Processore
    DISABLED = Gestione licenze disattivata.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  MachineName
    	
    Nome del computer Windows in cui è in esecuzione l'istanza del server.
    Nel caso di un'istanza cluster, un'istanza di SQL Server eseguita in un server virtuale con Microsoft Cluster Services restituisce il nome del server virtuale.
    NULL = Input non valido o errore.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  NumLicenses
    	
    Numero di licenze client registrate per l'istanza corrente di SQL Server, se è attiva la modalità Per Postazione.
    Numero di processori per i quali è disponibile la licenza per l'istanza corrente di SQL Server, se è attiva la modalità Per Processore.
    Restituisce NULL se nel server non è attiva alcuna delle due modalità precedenti.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  ProcessID
    	
    ID di processo del servizio SQL Server. ProcessID è utile per identificare quale Sqlservr.exe appartiene all'istanza.
    NULL = Input non valido o errore.
    Tipo di dati di base: int

/* --------------------------------------------------------------------------------------------------------------- */
    
  ProductVersion

    Versione dell'istanza di SQL Server nel formato 'major.minor.build'.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  ProductLevel
    	
    Livello della versione dell'istanza di SQL Server.
    Restituisce uno dei valori seguenti:
    'RTM' = Versione originale
    'SPn' = Versione Service Pack
    'Bn', = Versione beta
    Tipo di dati di base: nvarchar(128).

/* --------------------------------------------------------------------------------------------------------------- */
    
  ResourceLastUpdateDateTime

    Restituisce la data e l'ora dell'ultimo aggiornamento del database Resource.
    Tipo di dati di base: datetime.

/* --------------------------------------------------------------------------------------------------------------- */
    
  ResourceVersion
    	
    Restituisce la versione del database Resource.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  ServerName
    	
    Informazioni relative sia al server Windows che all'istanza associate all'istanza specificata di SQL Server.
    NULL = Input non valido o errore.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  SqlCharSet
    	
    ID del set di caratteri SQL dall'ID delle regole di confronto.
    Tipo di dati di base: tinyint

/* --------------------------------------------------------------------------------------------------------------- */
    
  SqlCharSetName

    Nome del set di caratteri SQL dalle regole di confronto.
    Tipo di dati di base: nvarchar(128)

/* --------------------------------------------------------------------------------------------------------------- */
    
  SqlSortOrder

    ID del tipo di ordinamento SQL dalle regole di confronto.
    Tipo di dati di base: tinyint.

/* --------------------------------------------------------------------------------------------------------------- */
    
  SqlSortOrderName
  
    Nome del tipo di ordinamento SQL dalle regole di confronto.
    Tipo di dati di base: nvarchar(128).

/* ############################################################################################################### */
    

/* ############################################################################################################### */

Tipi restituiti

	sql_variant

/* ############################################################################################################### */
	
	

/* ############################################################################################################### */	

Osservazioni

La proprietà ServerName della funzione SERVERPROPERTY e la funzione @@SERVERNAME restituiscono informazioni simili. La proprietà ServerName restituisce il nome del server Windows e il nome dell'istanza, che nel loro insieme compongono il nome univoco dell'istanza del server. La funzione @@SERVERNAME restituisce il nome del server locale corrente.

La proprietà ServerName e la funzione @@SERVERNAME restituiscono le stesse informazioni se il nome di server impostato come predefinito al momento dell'installazione non è stato modificato. Per configurare il nome del server locale eseguire l'istruzione seguente:

EXEC sp_dropserver 'current_server_name';
GO
EXEC sp_addserver 'new_server_name', 'local';
GO

Se il nome del server locale è stato modificato rispetto al nome del server impostato come predefinito al momento dell'installazione, la funzione @@SERVERNAME restituisce il nuovo nome.
Esempi

Nell'esempio seguente viene utilizzata la funzione SERVERPROPERTY in un'istruzione SELECT per restituire informazioni sul server corrente. Ciò risulta utile quando in un server Windows sono installate più istanze di SQL Server e il client deve aprire un'altra connessione alla stessa istanza utilizzata dalla connessione corrente.

SELECT CONVERT(char(20), SERVERPROPERTY('servername'));
GO

