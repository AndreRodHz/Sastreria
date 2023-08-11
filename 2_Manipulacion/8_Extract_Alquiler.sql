-- =======================================================================================================================================
-- QUERY PARA OBTENER RESUMEN DE LOS RECIBOS
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
-- DEFINICION DE VARIABLES @numero_doc Y @codigo_recibo
-- =======================================================================================================================================
DECLARE @numero_doc VARCHAR(10) = '12386676',
		@codigo_recibo VARCHAR(15) = 'R-15'
-- =======================================================================================================================================
-- QUERY PARA ALQUILER POR DNI
-- =======================================================================================================================================
SELECT num_doc_c, id_alquiler, id_transac, alquiler.id_cliente, id_empleado, fecha_a, precio_base_a, impuesto_a, total_a
FROM alquiler
	INNER JOIN cliente ON alquiler.id_cliente = cliente.id_cliente
WHERE cliente.num_doc_c = @numero_doc
-- =======================================================================================================================================
-- QUERY PARA OBTENER ALQUILER POR DNI Y CODIGO RECIBO
-- =======================================================================================================================================
SELECT num_doc_c, id_alquiler, alquiler.id_transac, alquiler.id_cliente, id_empleado, fecha_a, precio_base_a, impuesto_a, total_a
FROM alquiler
	INNER JOIN cliente ON alquiler.id_cliente = cliente.id_cliente
	INNER JOIN recibo ON alquiler.id_transac = recibo.id_transac
WHERE cliente.num_doc_c = @numero_doc AND recibo.id_recibo = @codigo_recibo