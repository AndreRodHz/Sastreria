Use SastreriaV1
-- =======================================================================================================================================
----CREACION DEL IDENTIFICADOR **TRANSACCION**
-- =======================================================================================================================================
declare @temp_tabla_ta TABLE (ta_code varchar(15))
declare @transac_code varchar(15)

INSERT INTO @temp_tabla_ta (ta_code)
EXEC dbo.ultimo_codigo_transaccion;

SELECT @transac_code = ta_code from @temp_tabla_ta

insert into transaccion values
	(@transac_code, 'Alquiler', CURRENT_TIMESTAMP)
-- =======================================================================================================================================
----INSERCION DE DATOS PARA LA TABLA **ALQUILER** - GENERACION DEL ALQUILER
-- =======================================================================================================================================
declare @temp_tabla_a TABLE(a_code varchar(15))
declare	@alqui_code varchar(15)

INSERT INTO @temp_tabla_a (a_code)
EXEC dbo.ultimo_codigo_alquiler;

SELECT @alqui_code = a_code from @temp_tabla_a

INSERT INTO alquiler VALUES
	(@alqui_code, (SELECT TOP 1 id_transac FROM transaccion ORDER BY fecha_t DESC),
	'CLI-2', 'EMP-2', CURRENT_TIMESTAMP, 0, 0, 0)
-- =======================================================================================================================================
----INSERCION EN LA DE LOS PRODCTOS DE ALQUILER **DETALLE ALQUILER**
-- ======================================================================================================================================= 
INSERT INTO detalle_alquiler values
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
-- =======================================================================================================================================
----INSERCION EN LA TABLA **RECIBO**
-- =======================================================================================================================================
declare @temp_tabla_ra TABLE(ra_code varchar(15))
declare @recibo_code varchar(15)

INSERT INTO @temp_tabla_ra (ra_code)
EXEC dbo.ultimo_codigo_recibo;

SELECT @recibo_code = ra_code from @temp_tabla_ra

DECLARE @id_compro varchar(15)
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
SELECT alquiler.id_alquiler as 'ID Alquiler', id_recibo as 'ID Recibo', alquiler.id_transac as 'ID Transaccion',
	   id_empleado as 'ID Empleado', alquiler.id_cliente as 'ID Cliente', num_doc_c as 'N° Documento Cliente',
	   nombre_c as 'Cliente', nombre_com as 'Comprobante',  num_comprobante as 'N° Comprobante',fecha_a as 'Fecha',
	   precio_base_a as 'Precio Base', impuesto_a as 'Impuesto', total_a as 'Total'
FROM alquiler
INNER JOIN cliente ON alquiler.id_cliente = cliente.id_cliente
INNER JOIN recibo ON alquiler.id_transac = recibo.id_transac
INNER JOIN comprobante ON recibo.id_comprobante = comprobante.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(alquiler.id_alquiler, 3, LEN(alquiler.id_alquiler))) DESC
-- =======================================================================================================================================
-- =======================================================================================================================================
select * from transaccion ORDER BY fecha_t desc
select * from alquiler ORDER BY fecha_a desc
select * from detalle_alquiler WHERE id_alquiler = @alqui_code
select * from recibo ORDER BY fecha_recibo desc