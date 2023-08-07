-- =============================================
-- Create basic stored procedure template
-- =============================================

CREATE PROCEDURE dbo.ultimo_codigo_venta

AS
	DECLARE @texto VARCHAR(15),
			@salida VARCHAR(15)

	SET @texto = (SELECT TOP 1 id_venta FROM venta
					ORDER BY CONVERT(INT, SUBSTRING(id_venta, 3, LEN(id_venta))) DESC)

	SET @salida =
		CASE
			WHEN @texto IS NOT NULL THEN
				--		Extraigo la V									
				SUBSTRING(@texto, 1, 1) + '-' +CONVERT(VARCHAR(15), ((CONVERT(INT, (SUBSTRING(@texto, 3, LEN(@texto)-2)), 0)) + 1), 0)
			ELSE
				@texto
		END
	SELECT @salida
GO

-- =============================================
-- Example to execute the stored procedure
-- =============================================
EXECUTE dbo.ultimo_codigo_venta
GO