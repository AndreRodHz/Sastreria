USE SastreriaV1
-- =======================================================================================================================================
----CREACION DEL IDENTIFICADOR **TRANSACCION**
-- =======================================================================================================================================
DECLARE @temp_tabla_ta TABLE (ta_code VARCHAR(15))
DECLARE @transac_code VARCHAR(15)

INSERT INTO @temp_tabla_ta (ta_code)
EXEC dbo.ultimo_codigo_transaccion;

SELECT @transac_code = ta_code FROM @temp_tabla_ta

INSERT INTO transaccion VALUES
	(@transac_code, 'Alquiler', CURRENT_TIMESTAMP)
-- =======================================================================================================================================
----INSERCION DE DATOS PARA LA TABLA **ALQUILER** - GENERACION DEL ALQUILER
-- =======================================================================================================================================
DECLARE @temp_tabla_a TABLE(a_code VARCHAR(15))
DECLARE	@alqui_code VARCHAR(15)

INSERT INTO @temp_tabla_a (a_code)
EXEC dbo.ultimo_codigo_alquiler;

SELECT @alqui_code = a_code FROM @temp_tabla_a

INSERT INTO alquiler VALUES
	(@alqui_code, (SELECT TOP 1 id_transac FROM transaccion ORDER BY fecha_t DESC),
	'CLI-2', 'EMP-2', CURRENT_TIMESTAMP, 0, 0, 0)
-- =======================================================================================================================================
----INSERCION EN LA DE LOS PRODCTOS DE ALQUILER **DETALLE ALQUILER**
-- ======================================================================================================================================= 
INSERT INTO detalle_alquiler VALUES
	(@alqui_code, 'PRO-1', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-1'), 2),
	(@alqui_code, 'PRO-2', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-2'), 1)
-- =======================================================================================================================================
----ACTUALIZACION DE LA TABLA **ALQUILER** CON PRECIOS DEL DETALLE ALQUILER
-- ======================================================================================================================================= 
UPDATE alquiler
	SET precio_base_a =
	(
		SELECT SUM(precio_u * cantidad_alquiler)
		FROM detalle_alquiler
		WHERE detalle_alquiler.id_alquiler = alquiler.id_alquiler
	)
WHERE alquiler.id_alquiler = @alqui_code;

UPDATE alquiler
	SET impuesto_a = (SELECT precio_base_a FROM alquiler WHERE id_alquiler = @alqui_code) * 0.18,
		total_a = (SELECT precio_base_a FROM alquiler WHERE id_alquiler = @alqui_code) +
				  (SELECT precio_base_a FROM alquiler WHERE id_alquiler = @alqui_code) * 0.18
	WHERE alquiler.id_alquiler = @alqui_code;
-- =======================================================================================================================================
----INSERCION EN LA TABLA **RECIBO**
-- =======================================================================================================================================
DECLARE @temp_tabla_ra TABLE(ra_code VARCHAR(15))
DECLARE @recibo_code VARCHAR(15)

INSERT INTO @temp_tabla_ra (ra_code)
EXEC dbo.ultimo_codigo_recibo;

SELECT @recibo_code = ra_code FROM @temp_tabla_ra

DECLARE @id_compro VARCHAR(15)
SET @id_compro = 'CMP-2'

INSERT INTO RECIBO VALUES
	(@recibo_code, (SELECT TOP 1 id_transac FROM transaccion ORDER BY fecha_t DESC),@id_compro,
	(SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
	(SELECT precio_base_a FROM alquiler WHERE id_alquiler = (SELECT TOP 1 id_alquiler FROM alquiler ORDER BY fecha_a DESC)),
	(SELECT impuesto_a FROM alquiler WHERE id_alquiler = (SELECT TOP 1 id_alquiler FROM alquiler ORDER BY fecha_a DESC)),
	(SELECT total_a FROM alquiler WHERE id_alquiler = (SELECT TOP 1 id_alquiler FROM alquiler ORDER BY fecha_a DESC)), 'Pagado')
-- =======================================================================================================================================
-- SELECT para obtener la matriz de cara al usuario
-- =======================================================================================================================================
SELECT alquiler.id_alquiler AS 'ID Alquiler', id_recibo AS 'ID Recibo', alquiler.id_transac AS 'ID Transaccion',
	   id_empleado AS 'ID Empleado', alquiler.id_cliente AS 'ID Cliente', num_doc_c AS 'N° Documento Cliente',
	   nombre_c AS 'Cliente', nombre_com AS 'Comprobante',  num_comprobante AS 'N° Comprobante',fecha_a AS 'Fecha',
	   precio_base_a AS 'Precio BASe', impuesto_a AS 'Impuesto', total_a AS 'Total'
FROM alquiler
INNER JOIN cliente ON alquiler.id_cliente = cliente.id_cliente
INNER JOIN recibo ON alquiler.id_transac = recibo.id_transac
INNER JOIN comprobante ON recibo.id_comprobante = comprobante.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(alquiler.id_alquiler, 3, LEN(alquiler.id_alquiler))) DESC
-- =======================================================================================================================================
-- =======================================================================================================================================
SELECT * FROM transaccion ORDER BY fecha_t DESC
SELECT * FROM alquiler ORDER BY fecha_a DESC
SELECT * FROM detalle_alquiler WHERE id_alquiler = @alqui_code
SELECT * FROM recibo ORDER BY fecha_recibo DESC