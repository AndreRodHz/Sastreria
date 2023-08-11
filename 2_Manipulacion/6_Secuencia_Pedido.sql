USE SastreriaV1
-- =======================================================================================================================================
----CREACION DEL IDENTIFICADOR **TRANSACCION**
-- =======================================================================================================================================
DECLARE @temp_tabla_tp TABLE (tp_code VARCHAR(15))
DECLARE @transac_code VARCHAR(15)

INSERT INTO @temp_tabla_tp (tp_code)
EXEC dbo.ultimo_codigo_transaccion;

SELECT @transac_code = tp_code FROM @temp_tabla_tp

INSERT INTO transaccion VALUES
	(@transac_code, 'Pedido	', CURRENT_TIMESTAMP)
-- =======================================================================================================================================
----INSERCION DE DATOS PARA LA TABLA **PEDIDO** - GENERACION DEL PEDIDO
-- ======================================================================================================================================= 
DECLARE @temp_tabla TABLE(ped_code VARCHAR(15))
DECLARE	@pedido_code VARCHAR(15)

INSERT INTO @temp_tabla (ped_code)
EXEC dbo.ultimo_codigo_pedido;

SELECT @pedido_code = ped_code FROM @temp_tabla

INSERT INTO pedido VALUES
	(@pedido_code, (SELECT TOP 1 id_transac FROM transaccion ORDER BY fecha_t DESC),
	'CLI-2', 'EMP-1', CURRENT_TIMESTAMP, 'No', 'No', 'Para niño de 10 años', 0, 0, 0)
-- =======================================================================================================================================
----INSERCION DE MEDIDAS PARA LA TABLA **SUPERIOR** - GENERACION DE TABLA SUPERIOR
-- ======================================================================================================================================= 
INSERT INTO superior VALUES
	(@pedido_code, 40, 40, 40, 40, 40 ,40 ,40 ,40 ,40)
-- =======================================================================================================================================
----INSERCION DE MEDIDAS PARA LA TABLA **INFERIOR** - GENERACION DE TABLA INERIOR
-- ======================================================================================================================================= 
INSERT INTO inferior VALUES
	(@pedido_code, 40, 40, 40, 40, 40)
-- =======================================================================================================================================
----INSERCION EN LA DE LOS PRODUCTOS DE PEDIDO **DETALLE PEDIDO**
-- ======================================================================================================================================= 
INSERT INTO detalle_pedido VALUES
	(@pedido_code, 'PRP-1', 'Con cuello azul', 100),
	(@pedido_code, 'PRP-2', 'Con delantal negro', 100),
	(@pedido_code, 'PRP-3', 'Semi pitillo', 120),
	(@pedido_code, 'PRP-3', 'Holgado', 110)
-- =======================================================================================================================================
-- CONDICIONAL PARA SABER QUE MEDIDAS SE HA TOMADO
-- =======================================================================================================================================
DECLARE @verificar_super VARCHAR(2),
		@verificar_infer VARCHAR(2)

IF EXISTS (
		  SELECT 1 FROM superior
		  INNER JOIN pedido ON superior.id_pedido = pedido.id_pedido
		  WHERE superior.id_pedido = @pedido_code
		  )
	BEGIN
		SET @verificar_super = 'Si'
	END
ELSE
	BEGIN
		SET @verificar_super = 'No'
	END
--					==========================================================
IF EXISTS (
		  SELECT 1 FROM inferior
		  INNER JOIN pedido ON inferior.id_pedido = pedido.id_pedido
		  WHERE inferior.id_pedido = @pedido_code
		  )
	BEGIN
		SET @verificar_infer = 'Si'
	END
ELSE
	BEGIN
		SET @verificar_infer = 'No'
	END
-- =======================================================================================================================================
----ACTUALIZACION DE LA TABLA **PEDIDO** CON PRECIOS DEL DETALLE PEDIDO
-- ======================================================================================================================================= 
DECLARE @precio_insertar_p NUMERIC(18,2)
SET @precio_insertar_p = (SELECT SUM(precio_d_pp)
					    FROM detalle_pedido
						INNER JOIN pedido ON detalle_pedido.id_pedido = @pedido_code
						WHERE detalle_pedido.id_pedido = pedido.id_pedido)

UPDATE pedido
	SET medida_superior = @verificar_super,
		medida_inferior = @verificar_infer,
		precio_base_p = @precio_insertar_p,
		impuesto_p = @precio_insertar_p * 0.18,
		total_p = @precio_insertar_p + @precio_insertar_p * 0.18
	WHERE pedido.id_pedido = @pedido_code;
-- =======================================================================================================================================
----INSERCION EN LA TABLA **RECIBO**
-- =======================================================================================================================================
DECLARE @temp_tabla_rp TABLE(rp_code VARCHAR(15))
DECLARE @recibo_code VARCHAR(15)

INSERT INTO @temp_tabla_rp (rp_code)
EXEC dbo.ultimo_codigo_recibo;

SELECT @recibo_code = rp_code FROM @temp_tabla_rp

DECLARE @id_compro VARCHAR(15)
SET @id_compro = 'CMP-2'

INSERT INTO RECIBO VALUES
(
	@recibo_code, @transac_code,
	@id_compro, (SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
	(SELECT precio_base_p FROM pedido WHERE id_pedido = @pedido_code),
	(SELECT impuesto_p FROM pedido WHERE id_pedido = @pedido_code),
	(SELECT total_p FROM pedido WHERE id_pedido = @pedido_code), 'Pagado'
)
-- =======================================================================================================================================
-- SELECT para obtener la matriz de cara al usuario
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
-- =======================================================================================================================================
SELECT * FROM transaccion ORDER BY fecha_t DESC
SELECT * FROM pedido ORDER BY fecha_p DESC
SELECT * FROM superior WHERE id_pedido = @pedido_code
SELECT * FROM inferior WHERE id_pedido = @pedido_code
SELECT * FROM detalle_pedido WHERE id_pedido = @pedido_code
SELECT * FROM recibo ORDER BY fecha_recibo DESC