USE SastreriaV1
-- =======================================================================================================================================
----CREACION DEL IDENTIFICADOR **TRANSACCION**
-- =======================================================================================================================================

DECLARE @detalle_alquiler_a TABLE (id_producto_a VARCHAR(15), cantidad_alquiler_a INT)

INSERT INTO @detalle_alquiler_a VALUES 
    ('PRO-1', 1),
    ('PRO-2', 1)

DECLARE @can_proceed BIT;

-- Comprobar si todas las cantidades son mayores o iguales a la cantidad disponible
SET @can_proceed = (
    CASE
        WHEN NOT EXISTS (
            SELECT 1
            FROM @detalle_alquiler_a da
            JOIN producto p ON da.id_producto_a = p.id_producto
            WHERE da.cantidad_alquiler_a > p.stock_p
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
		DECLARE @temp_tabla_ta TABLE (ta_code VARCHAR(15))
		DECLARE @transac_code VARCHAR(15)

		INSERT INTO @temp_tabla_ta (ta_code)
		EXEC dbo.ultimo_codigo_transaccion;

		SELECT @transac_code = ta_code FROM @temp_tabla_ta

		INSERT INTO transaccion VALUES
			(@transac_code, 'Alquiler', CURRENT_TIMESTAMP)
--		=======================================================================================================================================
---		-INSERCION DE DATOS PARA LA TABLA **ALQUILER** - GENERACION DEL ALQUILER
--		=======================================================================================================================================
		DECLARE @temp_tabla_a TABLE(a_code VARCHAR(15))
		DECLARE	@alqui_code VARCHAR(15)

		INSERT INTO @temp_tabla_a (a_code)
		EXEC dbo.ultimo_codigo_alquiler;

		SELECT @alqui_code = a_code FROM @temp_tabla_a

		INSERT INTO alquiler VALUES
			(@alqui_code, @transac_code, 'CLI-2', 'EMP-2', CURRENT_TIMESTAMP, 0, 0, 0)
--		=======================================================================================================================================
---		-INSERCION EN LA DE LOS PRODCTOS DE ALQUILER **DETALLE ALQUILER**
--		======================================================================================================================================= 
		INSERT INTO detalle_alquiler VALUES
			(@alqui_code, 'PRO-1', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-1'), 1),
			(@alqui_code, 'PRO-2', (SELECT precio_p FROM producto WHERE id_producto = 'PRO-2'), 1)
--		=======================================================================================================================================
---		-ACTUALIZACION DE LA TABLA **ALQUILER** CON PRECIOS DEL DETALLE ALQUILER
--		======================================================================================================================================= 
		DECLARE @precio_insertar_a NUMERIC(18,2)
		SET @precio_insertar_a = (SELECT SUM(precio_u)
								FROM detalle_alquiler
								INNER JOIN alquiler ON detalle_alquiler.id_alquiler = @alqui_code
								WHERE detalle_alquiler.id_alquiler = alquiler.id_alquiler)

		UPDATE alquiler
			SET precio_base_a = @precio_insertar_a,
				impuesto_a = @precio_insertar_a * 0.18,
				total_a = @precio_insertar_a + @precio_insertar_a * 0.18
			WHERE alquiler.id_alquiler = @alqui_code;
--		=======================================================================================================================================
---		-INSERCION EN LA TABLA **RECIBO**
--		=======================================================================================================================================
		DECLARE @temp_tabla_ra TABLE(ra_code VARCHAR(15))
		DECLARE @recibo_code VARCHAR(15)

		INSERT INTO @temp_tabla_ra (ra_code)
		EXEC dbo.ultimo_codigo_recibo;

		SELECT @recibo_code = ra_code FROM @temp_tabla_ra

		DECLARE @id_compro VARCHAR(15)
		SET @id_compro = 'CMP-2'

		INSERT INTO RECIBO VALUES
			(@recibo_code, @transac_code ,@id_compro,
			(SELECT dbo.generar_serie_comprobante(@id_compro)), CURRENT_TIMESTAMP,
			(SELECT precio_base_a FROM alquiler WHERE id_alquiler = @alqui_code),
			(SELECT impuesto_a FROM alquiler WHERE id_alquiler = @alqui_code),
			(SELECT total_a FROM alquiler WHERE id_alquiler = @alqui_code), 'Pagado')
--		=======================================================================================================================================
---		-ACTUALIZACION DE PRODUCTOS EN LA TABLA **PRODUCTO**
--		======================================================================================================================================= 
		UPDATE producto
			SET stock_p = stock_p - detalle_alquiler.cantidad_alquiler
			FROM producto
			INNER JOIN detalle_alquiler ON producto.id_producto = detalle_alquiler.id_producto
			WHERE detalle_alquiler.id_alquiler = @alqui_code
	END
--==========================================================SEPARADOR DE IF====================================================================
ELSE -- Si todas las cantidades NO son mayores o iguales, forzamos el error
	BEGIN
		RAISERROR('No se pueden alquilar productos con cantidades insuficientes.', 16, 1);
	END
--=======================================================================================================================================
----REPOSICION DE STOCK DEL PRODUCTO ALQUILADO
--=======================================================================================================================================
		DECLARE @alquiler_repuesto varchar(15)
		SET @alquiler_repuesto = @alqui_code
		UPDATE producto
			SET stock_p = stock_p + detalle_alquiler.cantidad_alquiler
			FROM producto
			INNER JOIN detalle_alquiler ON producto.id_producto = detalle_alquiler.id_producto
			WHERE detalle_alquiler.id_alquiler = @alquiler_repuesto
-- =======================================================================================================================================
-- =======================================================================================================================================
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
SELECT * FROM producto
SELECT * FROM recibo ORDER BY fecha_recibo DESC