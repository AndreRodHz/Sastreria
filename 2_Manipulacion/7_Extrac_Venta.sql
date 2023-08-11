-- =======================================================================================================================================
-- QUERY PARA OBTENER RESUMEN DE LOS RECIBOS
-- =======================================================================================================================================
SELECT venta.id_venta AS 'ID Venta', id_recibo AS 'ID Recibo', venta.id_transac AS 'ID Transaccion',
	   id_empleado AS 'ID Empleado', venta.id_cliente AS 'ID Cliente', num_doc_c AS 'N° Documento Cliente',
	   nombre_c AS 'Cliente', nombre_com AS 'Comprobante', num_comprobante AS 'N° Comprobante',fecha_v AS 'Fecha',
	   precio_base_v AS 'Precio BASe', impuesto_v AS 'Impuesto', total_v AS 'Total'
FROM venta
	INNER JOIN cliente ON venta.id_cliente = cliente.id_cliente
	INNER JOIN recibo ON venta.id_transac = recibo.id_transac
	INNER JOIN comprobante ON recibo.id_comprobante = comprobante.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(venta.id_venta, 3, LEN(venta.id_venta))) DESC
-- =======================================================================================================================================
-- DEFINICION DE VARIABLES @numero_doc Y @codigo_recibo
-- =======================================================================================================================================
DECLARE @numero_doc VARCHAR(10) = '12386676',
		@codigo_recibo VARCHAR(15) = 'R-14'
-- =======================================================================================================================================
-- QUERY PARA VENTAS POR DNI
-- =======================================================================================================================================
SELECT num_doc_c, id_venta, id_transac, venta.id_cliente, id_empleado, fecha_v, precio_base_v, impuesto_v, total_v
FROM venta
	INNER JOIN cliente ON venta.id_cliente = cliente.id_cliente
WHERE cliente.num_doc_c = @numero_doc
-- =======================================================================================================================================
-- QUERY PARA OBTENER VENTA POR DNI Y CODIGO RECIBO
-- =======================================================================================================================================
SELECT num_doc_c, id_venta, venta.id_transac, venta.id_cliente, id_empleado, fecha_v, precio_base_v, impuesto_v, total_v
FROM venta
	INNER JOIN cliente ON venta.id_cliente = cliente.id_cliente
	INNER JOIN recibo ON venta.id_transac = recibo.id_transac
WHERE cliente.num_doc_c = @numero_doc AND recibo.id_recibo = @codigo_recibo