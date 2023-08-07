
--DROP FUNCTION dbo.generar_serie_comprobante;

CREATE FUNCTION dbo.generar_serie_comprobante (@input_id_com VARCHAR(15))
RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @salida varchar(20)

	IF @input_id_com like 'CMP-1'
		BEGIN
			IF (SELECT MAX(num_comprobante) FROM recibo where num_comprobante like ('%B%')) is not null
				BEGIN
					SET @salida = dbo.num_comprobante('B')
				END
			ELSE
				BEGIN
					SET @salida = 'B001-00000001'
				END
		END

	ELSE IF @input_id_com like 'CMP-2'
		BEGIN
			IF (SELECT MAX(num_comprobante) FROM recibo where num_comprobante like ('%F%')) is not null
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

