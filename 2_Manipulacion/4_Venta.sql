USE SastreriaV1
-- =======================================================================================================================================
----CREACION DEL VERIFICADOR CON RESPECTO AL **STOCK DE LOS PRODUCTOS**
-- =======================================================================================================================================
DECLARE @detalle_venta_v TABLE (id_producto_v VARCHAR(15), cantidad_venta_v INT)

INSERT INTO @detalle_venta_v VALUES 
    ('PRO-2', 1),
    ('PRO-3', 1),
	('PRO-4', 1)

DECLARE @can_proceed BIT;

-- Comprobar si todas las cantidades son mayores o iguales a la cantidad disponible
SET @can_proceed = (
    CASE
        WHEN NOT EXISTS (
            SELECT 1
            FROM @detalle_venta_v dv
            JOIN producto p ON dv.id_producto_v = p.id_producto
            WHERE dv.cantidad_venta_v > p.stock_p
        ) THEN 1
        ELSE 0
    END
);

-- Si todas las cantidades son mayores o iguales, iniciar la secuencia de venta
IF @can_proceed = 1
	BEGIN
--		=======================================================================================================================================
---		-CREACION DEL IDENTIFICADOR **TRANSACCION**
--		=======================================================================================================================================
		DECLARE @temp_tabla_tv TABLE (tv_code VARCHAR(15))
		DECLARE @transac_code VARCHAR(15)

		INSERT INTO @temp_tabla_tv (tv_code)
		EXEC dbo.ultimo_codigo_transaccion;

		SELECT @transac_code = tv_code FROM @temp_tabla_tv

		INSERT INTO transaccion VALUES
			(@transac_code, 'Venta', CURRENT_TIMESTAMP)
--		=======================================================================================================================================
---		-INSERCION DE DATOS PARA LA TABLA **VENTA** - GENERACION DE LA VENTA
--		=======================================================================================================================================
		DECLARE @temp_tabla_v TABLE(v_code VARCHAR(15))
		DECLARE	@venta_code VARCHAR(15)

		INSERT INTO @temp_tabla_v (v_code)
		EXEC dbo.ultimo_codigo_venta;

		SELECT @venta_code = v_code FROM @temp_tabla_v	
	
		INSERT INTO venta VALUES
			(@venta_code, @transac_code, 'CLI-2', 'EMP-2', CURRENT_TIMESTAMP, 0, 0, 0)
--		=======================================================================================================================================
---		-INSERCION EN LA DE LOS PRODCTOS DE VENTA **DETALLE VENTA**
--		======================================================================================================================================= 
		INSERT INTO detalle_venta VALUES
			(@venta_code, 'PRO-2', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-2'), 1),
			(@venta_code, 'PRO-3', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-3'), 1),
			(@venta_code, 'PRO-4', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-4'), 1)
--		=======================================================================================================================================
---		-ACTUALIZACION DE LA TABLA **VENTA** CON PRECIOS DEL DETALLE VENTA
--		======================================================================================================================================= 
		DECLARE @precio_insertar_v NUMERIC(18,2)
		SET @precio_insertar_v = (SELECT SUM(precio_u)
								FROM detalle_venta
								INNER JOIN venta ON detalle_venta.id_venta = @venta_code
								WHERE detalle_venta.id_venta = venta.id_venta)

		UPDATE venta
			SET precio_base_v = @precio_insertar_v,
				impuesto_v = @precio_insertar_v * 0.18,
				total_v = @precio_insertar_v + @precio_insertar_v * 0.18
			WHERE venta.id_venta = @venta_code;
--		=======================================================================================================================================
---		-INSERCION EN LA TABLA **RECIBO**
--		======================================================================================================================================= 
		DECLARE @temp_tabla_rv TABLE(rv_code VARCHAR(15))
		DECLARE @recibo_code VARCHAR(15)

		INSERT INTO @temp_tabla_rv (rv_code)
		EXEC dbo.ultimo_codigo_recibo;

		SELECT @recibo_code = rv_code FROM @temp_tabla_rv

		DECLARE @id_compro VARCHAR(15)
		SET @id_compro = 'CMP-2'

		INSERT INTO RECIBO VALUES
			(@recibo_code, @transac_code, @id_compro,
			(SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
			(SELECT precio_base_v FROM venta WHERE id_venta = @venta_code), 
			(SELECT impuesto_v FROM venta WHERE id_venta = @venta_code), 
			(SELECT total_v FROM venta WHERE id_venta = @venta_code), 'Pagado')
--		=======================================================================================================================================
---		-ACTUALIZACION DE PRODUCTOS EN LA TABLA **PRODUCTO**
--		======================================================================================================================================= 
		UPDATE producto
			SET stock_p = stock_p - detalle_venta.cantidad_venta
			FROM producto
			INNER JOIN detalle_venta ON producto.id_producto = detalle_venta.id_producto
			WHERE detalle_venta.id_venta = @venta_code
	END
--==========================================================SEPARADOR DE IF====================================================================
ELSE -- Si todas las cantidades NO son mayores o iguales, forzamos el error
	BEGIN
		RAISERROR('No se pueden vender productos con cantidades insuficientes.', 16, 1);
	END
-- =======================================================================================================================================
-- SELECT PARA OBTENER MATRIZ DE CARA AL USUARIO
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
-- =======================================================================================================================================
SELECT * FROM transaccion ORDER BY fecha_t DESC
SELECT * FROM venta ORDER BY fecha_v DESC
SELECT * FROM detalle_venta WHERE id_venta = @venta_code
SELECT * FROM producto
SELECT * FROM recibo ORDER BY fecha_recibo DESC