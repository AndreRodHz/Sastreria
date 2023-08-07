
--DROP FUNCTION dbo.generar_serie_comprobante;

CREATE FUNCTION dbo.generar_serie_comprobante (@input_id_com VARCHAR(15))
RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @salida VARCHAR(20)

	IF @input_id_com LIKE 'CMP-1'
		BEGIN
			IF (SELECT MAX(num_comprobante) FROM recibo WHERE num_comprobante LIKE ('%B%')) IS NOT NULL
				BEGIN
					SET @salida = dbo.num_comprobante('B')
				END
			ELSE
				BEGIN
					SET @salida = 'B001-00000001'
				END
		END

	ELSE IF @input_id_com LIKE 'CMP-2'
		BEGIN
			IF (SELECT MAX(num_comprobante) FROM recibo WHERE num_comprobante LIKE ('%F%')) IS NOT NULL
				BEGIN
					SET @salida = dbo.num_comprobante('F')
				END
			ELSE
				BEGIN
					SET @salida = 'F001-00000001'
				END
		END
RETURN @salida;
END;
-- =======================================================================================================================================
-- SELECT para obtener la matriz de cara al usuario
-- =======================================================================================================================================

--SELECT dbo.generar_serie_comprobante('CMP-1')	--B001-00000001
--SELECT dbo.generar_serie_comprobante('CMP-2')	--F001-00000001

-- =======================================================================================================================================
-- SELECT para obtener la matriz de cara al usuario
-- ============

