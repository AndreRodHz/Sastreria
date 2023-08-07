-- =============================================
-- Create basic stored procedure template
-- =============================================

CREATE PROCEDURE dbo.ultimo_codigo_transaccion

AS
	DECLARE @texto varchar(15),
			@salida varchar(15)

	SET @texto = (SELECT TOP 1 id_transac FROM transaccion
					ORDER BY CONVERT(INT, SUBSTRING(id_transac, 3, LEN(id_transac))) DESC)

	SET @salida =
		CASE
			WHEN @texto is not null THEN
				--		Extraigo la T								
				SUBSTRING(@texto, 1, 1) + '-' + CONVERT(varchar(15), ((CONVERT(int, (SUBSTRING(@texto, 3, LEN(@texto)-2)), 0)) + 1), 0)
			ELSE
				@texto
		END
	SELECT @salida
GO

-- =============================================
-- Example to execute the stored procedure
-- =============================================
EXECUTE dbo.ultimo_codigo_transaccion
GO