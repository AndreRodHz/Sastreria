use SastreriaV1


--PARA AGREGAR UN NUEVO PRODUCTO
insert into producto values
	('PRO-000', 'nombre', 'descripcion', 'talla', 'categoria', 'condicion', precio, stock)
  -- Codigo,  Nombre,   Descripcion,   Talla,   Categoria,   Conmdicion, Precio, Stock


--PARA MODIFICAR UN PRODUCTO
update producto 
	set id_producto = '',
		nombre_p = '',
		descrip_p = '',
		talla = '',
		id_categoria = '',
		id_condicion = '',
		precio_p = 00,
		stock_p = 00
	where id_producto = 'PRO-000';


--PARA ELIMINAR UN PRODUCTO
delete producto where id_producto = 'PRO-000'


--PARA VER LA LISTA DE PRODUCTOS
SELECT id_producto as 'ID Producto', nombre_p as 'Nombre', descrip_p as 'Descripcion', talla as 'Talla',
	   nombre_cate as 'Categoria', nombre_condi as 'Condicion', precio_p as 'Precio', stock_p as 'Stock'
FROM producto
INNER JOIN categoria ON producto.id_categoria = categoria.id_categoria
INNER JOIN condicion ON producto.id_condicion = condicion.id_condicion