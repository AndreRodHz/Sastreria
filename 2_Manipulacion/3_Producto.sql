USE SastreriaV1


--PARA AGREGAR UN NUEVO PRODUCTO
INSERT INTO producto VALUES
	('PRO-000', 'nombre', 'descripcion', 'talla', 'categoria', 'condicion', precio, stock)
  -- Codigo,  Nombre,   Descripcion,   Talla,   Categoria,   Conmdicion, Precio, Stock


--PARA MODIFICAR UN PRODUCTO
UPDATE producto 
	SET id_producto = '',
		nombre_p = '',
		descrip_p = '',
		talla = '',
		id_categoria = '',
		id_condicion = '',
		precio_p = 00,
		stock_p = 00
	WHERE id_producto = 'PRO-000';


--PARA ELIMINAR UN PRODUCTO
DELETE producto WHERE id_producto = 'PRO-000'


--PARA VER LA LISTA DE PRODUCTOS
SELECT id_producto AS 'ID Producto', nombre_p AS 'Nombre', descrip_p AS 'Descripcion', talla AS 'Talla',
	   nombre_cate AS 'Categoria', nombre_condi AS 'Condicion', precio_p AS 'Precio', stock_p AS 'Stock'
FROM producto
INNER JOIN categoria ON producto.id_categoria = categoria.id_categoria
INNER JOIN condicion ON producto.id_condicion = condicion.id_condicion