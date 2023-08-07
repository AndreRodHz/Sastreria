Use SastreriaV1
-- =======================================================================================================================================
----CREACION DEL IDENTIFICADOR **TRANSACCION**
-- =======================================================================================================================================
declare @temp_tabla_tv TABLE (tv_code varchar(15))
declare @transac_code varchar(15)

INSERT INTO @temp_tabla_tv (tv_code)
EXEC dbo.ultimo_codigo_transaccion;

SELECT @transac_code = tv_code from @temp_tabla_tv

insert into transaccion values
	(@transac_code, 'Venta', CURRENT_TIMESTAMP)
-- =======================================================================================================================================
----INSERCION DE DATOS PARA LA TABLA **VENTA** - GENERACION DE LA VENTA
-- =======================================================================================================================================
declare @temp_tabla_v TABLE(v_code varchar(15))
DECLARE	@venta_code varchar(15)

INSERT INTO @temp_tabla_v (v_code)
EXEC dbo.ultimo_codigo_venta;

SELECT @venta_code = v_code from @temp_tabla_v	
	
INSERT INTO venta VALUES
	(@venta_code, (SELECT TOP 1 id_transac FROM transaccion ORDER BY fecha_t DESC),
	'CLI-2', 'EMP-2', CURRENT_TIMESTAMP, 0, 0, 0)
-- =======================================================================================================================================
----INSERCION EN LA DE LOS PRODCTOS DE VENTA **DETALLE VENTA**
-- ======================================================================================================================================= 
INSERT INTO detalle_venta values
	(@venta_code, 'PRO-1', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-1'), 1),
	(@venta_code, 'PRO-2', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-2'), 1)
-- =======================================================================================================================================
----ACTUALIZACION DE LA TABLA **VENTA** CON PRECIOS DEL DETALLE VENTA
-- ======================================================================================================================================= 
UPDATE venta
	SET precio_base_v =
	(
		SELECT SUM(precio_u * cantidad_venta)
		FROM detalle_venta
		WHERE detalle_venta.id_venta = venta.id_venta
	)
WHERE venta.id_venta = @venta_code;

UPDATE venta
	SET impuesto_v = (SELECT precio_base_v FROM venta WHERE id_venta = @venta_code) * 0.18,
		total_v = (SELECT precio_base_v FROM venta WHERE id_venta = @venta_code) +
				  (SELECT precio_base_v FROM venta WHERE id_venta = @venta_code) * 0.18
-- =======================================================================================================================================
----INSERCION EN LA TABLA **RECIBO**
-- ======================================================================================================================================= 
declare @temp_tabla_rv TABLE(rv_code varchar(15))
declare @recibo_code varchar(15)

INSERT INTO @temp_tabla_rv (rv_code)
EXEC dbo.ultimo_codigo_recibo;

SELECT @recibo_code = rv_code from @temp_tabla_rv

DECLARE @id_compro varchar(15)
SET @id_compro = 'CMP-1'

INSERT INTO RECIBO VALUES
	(@recibo_code, (SELECT TOP 1 id_transac FROM transaccion ORDER BY fecha_t DESC), @id_compro,
	(SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
	(SELECT precio_base_v FROM venta WHERE id_venta = (SELECT TOP 1 id_venta FROM venta ORDER BY fecha_v DESC)), 
	(SELECT impuesto_v FROM venta WHERE id_venta = (SELECT TOP 1 id_venta FROM venta ORDER BY fecha_v DESC)), 
	(SELECT total_v FROM venta WHERE id_venta = (SELECT TOP 1 id_venta FROM venta ORDER BY fecha_v DESC)), 'Pagado')
-- =======================================================================================================================================
-- SELECT PARA OBTENER MATRIZ DE CARA AL USUARIO
-- =======================================================================================================================================
SELECT venta.id_venta as 'ID Venta', id_recibo as 'ID Recibo', venta.id_transac as 'ID Transaccion',
	   id_empleado as 'ID Empleado', venta.id_cliente as 'ID Cliente', num_doc_c as 'N° Documento Cliente',
	   nombre_c as 'Cliente', nombre_com as 'Comprobante', num_comprobante as 'N° Comprobante',fecha_v as 'Fecha',
	   precio_base_v as 'Precio Base', impuesto_v as 'Impuesto', total_v as 'Total'
FROM venta
INNER JOIN cliente ON venta.id_cliente = cliente.id_cliente
INNER JOIN recibo ON venta.id_transac = recibo.id_transac
INNER JOIN comprobante ON recibo.id_comprobante = comprobante.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(venta.id_venta, 3, LEN(venta.id_venta))) DESC
-- =======================================================================================================================================
-- =======================================================================================================================================
select * from transaccion ORDER BY fecha_t desc
select * from venta ORDER BY fecha_v desc
select * from detalle_venta WHERE id_venta = @venta_code
select * from recibo ORDER BY fecha_recibo desc