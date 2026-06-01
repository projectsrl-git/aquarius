
CREATE FUNCTION dbo.RimuoviChrNonNumerici (@InputString VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @KeepValues AS INT
    -- PATINDEX cerca il primo carattere che NON è nell'intervallo 0-9
    SET @KeepValues = PATINDEX('%[^0-9]%', @InputString)
    
    WHILE @KeepValues > 0
    BEGIN
        -- Sostituisce il carattere trovato con una stringa vuota
        SET @InputString = STUFF(@InputString, @KeepValues, 1, '')
        -- Cerca il prossimo carattere non numerico
        SET @KeepValues = PATINDEX('%[^0-9]%', @InputString)
    END
    
    RETURN @InputString
END
GO