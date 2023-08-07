use SastreriaV1

--drop table recibo;
--drop table detalle_venta;
--drop table detalle_alquiler;
--drop table alquiler;
--drop table venta;
--drop table detalle_pedido;
--drop table producto_pedido;
--drop table inferior;
--drop table superior;
--drop table pedido;
--drop table comprobante;
--drop table empleado;
--drop table cliente;
--drop table documento;
--drop table genero;
--drop table producto;
--drop table condicion;
--drop table categoria;

--Insercion de datos para la tabla documento
insert into documento values
	('DOC-1', 'DNI'),
	('DOC-2', 'Carnet de Extranjeria');

--Insercion de datos para la tabla genero
insert into genero values
	('GEN-1', 'Masculino'),
	('GEN-2', 'Femenino'),
	('GEN-3', 'Otro');

--Insercion de datos para la tabla condicion
insert into condicion values 
	('CDN-1', 'Nuevo', 'Producto estreno'),
	('CDN-2', 'Usado', 'Producto para alquiler');

--Insercion de datos para la tabla categoria
insert into categoria values
	('CTG-1', 'Terno Conjunto', 'Producto que se vende con el conjunto completo'),
	('CTG-2', 'Saco de Terno', 'Producto que se vende solo el saco'),
	('CTG-3', 'Camisa', 'Producto de camisa unica'),
	('CTG-4', 'Corbata', 'Producto de corbata unica'),
	('CTG-5', 'Correa', 'Producto de corbata unica'),
	('CTG-6', 'Zapato', 'Producto par de zapato');

--Insercion de datos para la tabla empleado
insert into empleado values
	('EMP-1', 'Andre Rodriguez', 'GEN-1', 'DOC-1', '72670549', '922047577', 'Av. Los Alamos 437', 'andre601@outlook.es', CONVERT(varbinary(255), 'kiro01', 0)),
	('EMP-2', 'Christian Angeles', 'GEN-1', 'DOC-1', '05497267', '757792204', 'Av. Alamos 437', 'andre520sif@outlook.es', CONVERT(varbinary(255), 'benito01', 0));

--Insercion de datos para la tabla cliente
insert into cliente values
	('CLI-1', 'Jair Lopez', 'GEN-1', 'DOC-1', '12345676', '99999999', 'lopez@gmail.com'),
	('CLI-2', 'Mercedes Pesantes', 'GEN-2', 'DOC-1', '12386676', '88888888', 'mercedes@gmail.com'),
	('CLI-3', 'Anjali Angeles', 'GEN-2', 'DOC-1', '34345676', '99977999', 'lopez626@gmail.com')

--Insercion de datos para la tabla producto
insert into producto values
	('PRO-1', 'Saco Normal', 'Saco rojo talla S', 'S','CTG-2', 'CDN-1', '300', '10'),
	('PRO-2', 'Camisa Morada Bersh', 'Morada doble cuello', 'L','CTG-3', 'CDN-1', '190', '5'),
	('PRO-3', 'Corbata Mega Azul', '', 'M','CTG-4', 'CDN-1', '87', '20'),
	('PRO-4', 'Terno azul entero', 'Usado anteriormente', 'M','CTG-3', 'CDN-2', '200', '1')

--Insercion de datos para la tabla comprobante
insert into comprobante values
	('CMP-1', 'Boleta'),
	('CMP-2', 'Factura')
--											***********SEPARADOR*************
--											***********SEPARADOR*************
insert into transaccion values
	('T-1', 'Venta', CURRENT_TIMESTAMP)
--											***********SEPARADOR*************
--Insercion de datos para la tabla venta
insert into venta values
	('V-1', 'T-1','CLI-1', 'EMP-1', CURRENT_TIMESTAMP, 50 , 50 * 0.18, 50*0.18 + 50)

--Insercion de datos para la tabla detalle_venta
insert into detalle_venta values
	('V-1', 'PRO-2', (select precio_p from producto where id_producto = 'PRO-2'), 1)

--Para modificar con los precios reales del detalle_venta hacia la tabla venta
UPDATE venta
SET precio_base_v = (
    SELECT SUM(precio_u * cantidad_venta)
    FROM detalle_venta
    WHERE detalle_venta.id_venta = venta.id_venta
)
WHERE venta.id_venta = 'V-1';

--Para modificar la columna del impuesto de la tabla venta
update venta
set impuesto_v = (select precio_base_v from venta where id_venta= 'V-1')*0.18

--Para modificar la columna del total de la tabla venta
update venta
set total_v = (
	(select precio_base_v) + (select impuesto_v)
)

--Insercion de precios para la tabla recibo despues de venta
insert into recibo values
	('R-1', 'T-1', 'CMP-2', 'VVVV-VVVVVVVV', CURRENT_TIMESTAMP,
	(select total_v from venta where id_venta = 'V-1'), (select total_v from venta where id_venta = 'V-1')*0.18,
	(select total_v from venta where id_venta = 'V-1')*0.18 + (select total_v from venta where id_venta = 'V-1'), 'Pagado')

--											***********SEPARADOR*************
--											***********SEPARADOR*************
insert into transaccion values
	('T-2', 'Alquiler', CURRENT_TIMESTAMP)
--											***********SEPARADOR*************
--Insercion de datos para la tabla alquiler
insert into alquiler values
	('A-1', 'T-2','CLI-3', 'EMP-1', CURRENT_TIMESTAMP, 10, 10 * 0.18, 10 * 0.18 + 10)

--Insercion de datos para la tabla detalle_alquiler
insert into detalle_alquiler values
	('A-1', 'PRO-1', (select precio_p from producto where id_producto = 'PRO-1'), 1),
	('A-1', 'PRO-2', (select precio_p from producto where id_producto = 'PRO-2'), 1),
	('A-1', 'PRO-4', (select precio_p from producto where id_producto = 'PRO-4'), 1)

--Para modificar con los precios reales del detalle_alquiler hacia la tabla alquiler
UPDATE alquiler
SET precio_base_a = (
    SELECT SUM(precio_u * cantidad_alquiler)
    FROM detalle_alquiler
    WHERE detalle_alquiler.id_alquiler = alquiler.id_alquiler
)
WHERE alquiler.id_alquiler = 'A-1';

--Para modificar la columna del impuesto de la tabla alquiler
update alquiler
set impuesto_a = (select precio_base_a from alquiler where id_alquiler = 'A-1')*0.18

--Para modificar la columna del total de la tabla alquiler
update alquiler
set total_a = (
	(select precio_base_a) + (select impuesto_a)
)

--Insercion de datos para la tabla recibo despues de alquiler
insert into recibo values
	('R-2', 'T-2', 'CMP-2', 'AAAA-AAAAAAAA', CURRENT_TIMESTAMP,
	(select total_a from alquiler where id_alquiler = 'A-1'), (select total_a from alquiler where id_alquiler = 'A-1')*0.18,
	(select total_a from alquiler where id_alquiler = 'A-1')*0.18 + (select total_a from alquiler where id_alquiler = 'A-1'), 'Pagado')

--											***********SEPARADOR*************
--											***********SEPARADOR*************
insert into transaccion values
	('T-3', 'Pedido', CURRENT_TIMESTAMP)
--											***********SEPARADOR*************

--insercion de tipos de productos para la tabla producto_pedido
insert into producto_pedido values
	('PRP-1', 'Chaleco', 'Prenda para torso'),
	('PRP-2', 'Blazer', 'Prenda estilo abrigo formal'),
	('PRP-3', 'Pantalon', 'Prenda formal para el inferior')

--Insercion de datos para la tabla pedido
insert into pedido values
	('P-1', 'T-3','CLI-3', 'EMP-2', CURRENT_TIMESTAMP, 'Para niño de 10 años', 600, 600*0.18, 600+600*0.18)

--Insercion de datos para la tabla detalle pedido
insert into detalle_pedido values
	('P-1', 'PRP-1', 90)

--Insercion de datos para la tabla superior
insert into superior values 
	('P-1', 10, 60, 35, 19, 15, 60, 90, 100, 120)

--Insercion de datos para la tabla inferior
insert into inferior values 
	('P-1', 80, 80, 30, 30, 40)

	
--Insercion de datos para la tabla recibo despues de pedido
insert into recibo values
	('R-3', 'T-3', 'CMP-1', 'PPPP-PPPPPPPP', CURRENT_TIMESTAMP,
	(select total_p from pedido where id_pedido = 'P-1'), (select total_p from pedido where id_pedido = 'P-1')*0.18,
	(select total_p from pedido where id_pedido = 'P-1')*0.18 + (select total_p from pedido where id_pedido = 'P-1'), 'Pagado')