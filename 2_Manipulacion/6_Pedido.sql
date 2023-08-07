Use SastreriaV1
-- =======================================================================================================================================
----CREACION DEL IDENTIFICADOR **TRANSACCION**
-- =======================================================================================================================================
declare @temp_tabla_tp TABLE (tp_code varchar(15))
declare @transac_code varchar(15)

INSERT INTO @temp_tabla_tp (tp_code)
EXEC dbo.ultimo_codigo_transaccion;

SELECT @transac_code = tp_code from @temp_tabla_tp

insert into transaccion values
	(@transac_code, 'Pedido	', CURRENT_TIMESTAMP)
-- =======================================================================================================================================
----INSERCION DE DATOS PARA LA TABLA **PEDIDO** - GENERACION DEL PEDIDO
-- ======================================================================================================================================= 
declare @temp_tabla TABLE(ped_code varchar(15))
declare	@pedido_code varchar(15)

INSERT INTO @temp_tabla (ped_code)
EXEC dbo.ultimo_codigo_pedido;

SELECT @pedido_code = ped_code from @temp_tabla

insert into pedido values
	(@pedido_code, (SELECT TOP 1 id_transac FROM transaccion ORDER BY fecha_t DESC),
	'CLI-2', 'EMP-1', CURRENT_TIMESTAMP, 'Para niño de 10 años', 0, 0, 0)
-- =======================================================================================================================================
----INSERCION EN LA DE LOS PRODUCTOS DE PEDIDO **DETALLE PEDIDO**
-- ======================================================================================================================================= 
INSERT INTO detalle_pedido values
	(@pedido_code, 'PRP-1', 100),
	(@pedido_code, 'PRP-2', 265),
	(@pedido_code, 'PRP-3', 130)
-- =======================================================================================================================================
----ACTUALIZACION DE LA TABLA **PEDIDO** CON PRECIOS DEL DETALLE PEDIDO
-- ======================================================================================================================================= 
UPDATE pedido
	SET precio_base_p =
	(
		SELECT SUM(precio_d_pp)
		FROM detalle_pedido
		WHERE detalle_pedido.id_pedido = pedido.id_pedido
	)
WHERE pedido.id_pedido = @pedido_code;

UPDATE pedido
	SET impuesto_p = (SELECT precio_base_p FROM pedido WHERE id_pedido = @pedido_code) * 0.18,
		total_p = (SELECT precio_base_p FROM pedido WHERE id_pedido = @pedido_code) +
				  (SELECT precio_base_p FROM pedido WHERE id_pedido = @pedido_code) * 0.18
-- =======================================================================================================================================
----INSERCION EN LA TABLA **RECIBO**
-- =======================================================================================================================================
declare @temp_tabla_rp TABLE(rp_code varchar(15))
declare @recibo_code varchar(15)

INSERT INTO @temp_tabla_rp (rp_code)
EXEC dbo.ultimo_codigo_recibo;

SELECT @recibo_code = rp_code from @temp_tabla_rp

DECLARE @id_compro varchar(15)
SET @id_compro = 'CMP-1'

INSERT INTO RECIBO VALUES
(
	@recibo_code, (SELECT TOP 1 id_transac FROM transaccion ORDER BY fecha_t DESC),
	@id_compro, (SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
	(SELECT precio_base_p FROM pedido WHERE id_pedido = (SELECT TOP 1 id_pedido FROM pedido ORDER BY fecha_p DESC)),
	(SELECT impuesto_p FROM pedido WHERE id_pedido = (SELECT TOP 1 id_pedido FROM pedido ORDER BY fecha_p DESC)),
	(SELECT total_p FROM pedido WHERE id_pedido = (SELECT TOP 1 id_pedido FROM pedido ORDER BY fecha_p DESC)), 'Pagado'
)
-- =======================================================================================================================================
-- SELECT para obtener la matriz de cara al usuario
-- =======================================================================================================================================
SELECT pedido.id_pedido as 'ID Pedido', id_recibo as 'ID Recibo',  pedido.id_transac as 'ID Transaccion', id_empleado as 'ID Empleado',
	   pedido.id_cliente as 'ID Cliente', num_doc_c as 'N° Documento Cliente', nombre_c as 'Cliente', nombre_com as 'Comprobante',
	   num_comprobante as 'N° Comprobante', fecha_p as 'Fecha', descrip as 'Descripcion', precio_base_p as 'Precio Base',
	   impuesto_p as 'Impuesto', total_p as 'Total'
FROM pedido
INNER JOIN cliente ON pedido.id_cliente = cliente.id_cliente
INNER JOIN recibo ON pedido.id_transac = recibo.id_transac
INNER JOIN comprobante ON recibo.id_comprobante = comprobante.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(pedido.id_pedido, 3, LEN(pedido.id_pedido))) DESC
-- =======================================================================================================================================
-- =======================================================================================================================================
select * from transaccion ORDER BY fecha_t desc
select * from pedido ORDER BY fecha_p desc
select * from detalle_pedido WHERE id_pedido = @pedido_code
select * from recibo ORDER BY fecha_recibo desc