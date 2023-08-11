USE SastreriaV1

-- =======================================================================================================================================
-- QUERY PARA OBTENER RESUMEN DE LOS RECIBOS
-- =======================================================================================================================================
SELECT pedido.id_pedido AS 'ID Pedido', id_recibo AS 'ID Recibo',  pedido.id_transac AS 'ID Transaccion', id_empleado AS 'ID Empleado',
	   pedido.id_cliente AS 'ID Cliente', num_doc_c AS 'N° Documento Cliente', nombre_c AS 'Cliente', nombre_com AS 'Comprobante',
	   num_comprobante AS 'N° Comprobante', fecha_p AS 'Fecha', medida_superior AS 'M. Superior',
	   medida_inferior AS 'M. Inferior',DESCrip AS 'Descripcion', precio_base_p AS 'Precio BASe',
	   impuesto_p AS 'Impuesto', total_p AS 'Total'
FROM pedido
INNER JOIN cliente ON pedido.id_cliente = cliente.id_cliente
INNER JOIN recibo ON pedido.id_transac = recibo.id_transac
INNER JOIN comprobante ON recibo.id_comprobante = comprobante.id_comprobante
ORDER BY CONVERT(INT, SUBSTRING(pedido.id_pedido, 3, LEN(pedido.id_pedido))) DESC
-- =======================================================================================================================================
-- DEFINICION DE VARIABLES @numero_doc Y @codigo_ped
-- =======================================================================================================================================
DECLARE @numero_doc VARCHAR(10) = '12386676',
		@codigo_ped VARCHAR(15) = 'P-5'
-- =======================================================================================================================================
-- QUERY PARA OBTENER PEDIDOS POR DNI
-- =======================================================================================================================================
SELECT num_doc_c, id_pedido, pedido.id_transac, recibo.id_recibo, recibo.num_comprobante, fecha_p,
	   medida_superior, medida_inferior, descrip, precio_base_p, impuesto_p, total_p
FROM pedido 
	INNER JOIN cliente ON pedido.id_cliente = cliente.id_cliente
	INNER JOIN recibo ON pedido.id_transac = recibo.id_transac
WHERE cliente.num_doc_c = @numero_doc 
-- =======================================================================================================================================
-- QUERY PARA OBTENER LA MEDIDA SUPERIOR CON DNI Y PEDIDO
-- =======================================================================================================================================
SELECT num_doc_c AS 'Documento', pedido.id_pedido AS 'ID Pedido', nombre_c AS 'Cliente',
	   cuello, longitud, hombros, sisa, biceps, pecho, brazos, largo_cha, largo_abri
FROM superior 
	INNER JOIN pedido ON superior.id_pedido = pedido.id_pedido
	INNER JOIN cliente ON pedido.id_cliente = cliente.id_cliente
WHERE cliente.num_doc_c = @numero_doc AND pedido.id_pedido = @codigo_ped
-- =======================================================================================================================================
-- QUERY PARA OBTENER LA MEDIDA INFERIOR CON DNI Y PEDIDO
-- =======================================================================================================================================
SELECT num_doc_c AS 'Documento', pedido.id_pedido AS 'ID Pedido',
	   nombre_c AS 'Cliente', caderas, largo, tiro, posicion, muslos
FROM inferior 
	INNER JOIN pedido ON inferior.id_pedido = pedido.id_pedido
	INNER JOIN cliente ON pedido.id_cliente = cliente.id_cliente
WHERE cliente.num_doc_c = @numero_doc AND pedido.id_pedido = @codigo_ped
-- =======================================================================================================================================
-- QUERY PARA DETALLE PEDIDO POR DNI Y PEDIDO
-- =======================================================================================================================================
SELECT detalle_pedido.id_pedido, nombre_pp, descripcion_dp, precio_d_pp
FROM detalle_pedido
	INNER JOIN pedido ON detalle_pedido.id_pedido = pedido.id_pedido
	INNER JOIN cliente ON pedido.id_cliente = pedido.id_cliente
	INNER JOIN producto_pedido ON detalle_pedido.id_prod_pedi = producto_pedido.id_prod_pedi
WHERE cliente.num_doc_c = @numero_doc AND pedido.id_pedido = @codigo_ped