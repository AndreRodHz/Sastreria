-- =============================================
-- Create basic stored procedure template
-- =============================================

CREATE PROCEDURE dbo.ultimo_codigo_pedido
AS
	DECLARE @texto varchar(15),
			@salida varchar(15)

	SET @texto = (SELECT TOP 1 id_pedido FROM pedido
					ORDER BY CONVERT(INT, SUBSTRING(id_pedido, 3, LEN(id_pedido))) DESC)

	SET @salida =
		CASE
			WHEN @texto is not null THEN
				--		Extraigo la P									
				SUBSTRING(@texto, 1, 1) + '-' +CONVERT(varchar(15), ((CONVERT(int, (SUBSTRING(@texto, 3, LEN(@texto)-2)), 0)) + 1), 0)
			ELSE
				@texto
		END
	SELECT @salida
GO

-- =============================================
-- Example to execute the stored procedure
-- =============================================
EXECUTE dbo.ultimo_codigo_pedido
GO

--DROP PROCEDURE dbo.ultimo_codigo_pedido