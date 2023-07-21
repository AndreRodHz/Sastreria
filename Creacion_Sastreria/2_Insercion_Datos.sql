use SastreriaV1

--delete from documento where id_documento = 'd01'
--delete from documento where id_documento = 'd02'
--delete from genero where id_genero = 'g01'
--delete from genero where id_genero = 'g02'
--delete from genero where id_genero = 'g03'

--drop table factura;
--drop table detalle_venta;
--drop table detalle_alquiler;
--drop table alquiler;
--drop table venta;
--drop table pedido;
--drop table inferior;
--drop table superior;
--drop table comprobante;
--drop table empleado;
--drop table cliente;
--drop table documento;
--drop table genero;
--drop table producto;
--drop table condicion;
--drop table categoria;

--truncate table factura;
--truncate table detalle_venta;
--truncate table detalle_alquiler;
--truncate table alquiler;
--truncate table venta;
--truncate table pedido;
--truncate table inferior;
--truncate table superior;
--truncate table comprobante;
--truncate table empleado;
--truncate table cliente;
--truncate table documento;
--truncate table genero;
--truncate table producto;
--truncate table condicion;
--truncate table categoria;


--Insercion de datos para la tabla documento
insert into documento values
	('D1', 'DNI'),
	('D2', 'Carnet de Extranjeria');

--Insercion de datos para la tabla genero
insert into genero values
	('G1', 'Masculino'),
	('G2', 'Femenino'),
	('G3', 'Otro');

--Insercion de datos para la tabla condicion
insert into condicion values 
	('Con1', 'Nuevo', 'Producto estreno'),
	('Con2', 'Usado', 'Producto para alquiler');

--Insercion de datos para la tabla categoria
insert into categoria values
	('Cate1', 'Terno Conjunto', 'Producto que se vende con el conjunto completo'),
	('Cate2', 'Saco de Terno', 'Producto que se vende solo el saco'),
	('Cate3', 'Camisa', 'Producto de camisa unica'),
	('Cate4', 'Corbata', 'Producto de corbata unica'),
	('Cate5', 'Correa', 'Producto de corbata unica'),
	('Cate6', 'Zapato', 'Producto par de zapato');

--Insercion de datos para la tabla empleado
insert into empleado values
	('E1', 'Andre Rodriguez', 'G1', 'D1', '72670549', '922047577', 'Av. Los Alamos 437', 'andre601@outlook.es', 'kiro01'),
	('E2', 'Christian Angeles', 'G1', 'D1', '05497267', '757792204', 'Av. Alamos 437', 'andre520sif@outlook.es', 'benito01');

--Insercion de datos para la tabla cliente
insert into cliente values
	--('C1', 'Jair Lopez', 'G1', 'D1', '12345676', '99999999', 'lopez@gmail.com'),
	--('C2', 'Mercedes Pesantes', 'G2', 'D1', '12386676', '88888888', 'mercedes@gmail.com'),
	--('C3', 'Anjali Angeles', 'G2', 'D1', '34345676', '99977999', 'lopez626@gmail.com')
	('C4', 'ANDrE rODRIGUEZ', 'G1', 'D1', '7356384', '922028423', 'andre67_LM@GMAIL.COM')

	delete from cliente where id_cliente = 'C4'

--Insercion de datos para la tabla producto
insert into producto values
	('P1', 'Saco Normal', 'Saco rojo talla S', 'S','Cate2', 'Con1', '300', '10'),
	('P2', 'Camisa Morada Bersh', 'Morada doble cuello', 'L','Cate3', 'Con1', '190', '5'),
	('P3', 'Corbata Mega Azul', '', 'M','Cate4', 'Con1', '87', '20'),
	('P4', 'Terno azul entero', 'Usado anteriormente', 'M','Cate3', 'Con2', '200', '1')

--Insercion de datos para la tabla comprobante
insert into comprobante values
	('Co1', 'Boleta'),
	('Co2', 'Factura')

--Insercion de datos para la tabla venta
insert into venta values
	('V1', 'C1', 'E2', 'Co1', '000000001', CURRENT_TIMESTAMP,
	(select precio_p from producto where id_producto = 'P2') , (select precio_p from producto where id_producto = 'P2')*0.18,
	(select precio_p from producto where id_producto = 'P2')*0.18+(select precio_p from producto where id_producto = 'P2'))

--Insercion de datos para la tabla detalle_venta
insert into detalle_venta values
	('V1', 'P2', (select nombre_p from producto where id_producto = 'P2'), (select precio_p from producto where id_producto = 'P2'), 1)

--Insercion de datos para la tabla factura despues de venta
insert into factura values
	((select num_comprobante from venta where id_venta = 'V1'), 'V1',null,null, CURRENT_TIMESTAMP,
	(select total_v from venta where id_venta = 'V1'), 'Pagado')

--Insercion de datos para la tabla alquiler
insert into alquiler values
	('A1', 'C3', 'E1', 'Co2', '29447HG72U', CURRENT_TIMESTAMP, 1000, 1000*0.18, 1000*0.18+1000)

--Insercion de datos para la tabla detalle_alquiler
insert into detalle_alquiler values
	('A1', 'P1', (select nombre_p from producto where id_producto = 'P1'), (select precio_p from producto where id_producto = 'P1'), 1),
	('A1', 'P2',(select nombre_p from producto where id_producto = 'P2'), (select precio_p from producto where id_producto = 'P2'), 1),
	('A1', 'P4',(select nombre_p from producto where id_producto = 'P4'), (select precio_p from producto where id_producto = 'P4'), 1)

--Para modificar con los precios reales del detalle_alquiler hacia la tabla alquiler
UPDATE alquiler
SET precio_base_a = (
    SELECT SUM(precio_u * cantidad_alquiler)
    FROM detalle_alquiler
    WHERE detalle_alquiler.id_alquiler = alquiler.id_alquiler
)
WHERE alquiler.id_alquiler = 'A1';

--Para modificar la columna del impuesto de la tabla alquiler
update alquiler
set impuestos_a = (select precio_base_a from alquiler where id_alquiler = 'A1')*0.18

--Para modificar la columna del total de la tabla alquiler
update alquiler
set total_a = (
	(select precio_base_a) + (select impuestos_a)
)

--Insercion de datos para la tabla factura despues de alquiler
insert into factura values
	((select num_comprobante_a from alquiler where id_alquiler = 'A1'), null, 'A1', null, CURRENT_TIMESTAMP,
	(select total_a from alquiler where id_alquiler = 'A1'), 'Pagado')

--Insercion de datos para la tabla pedido
insert into pedido values
	('Ped1', 'C2', 'E1', CURRENT_TIMESTAMP, 1, 1, 1, 'Para niño de 10 años', 'Co1', '000000002', 600, 600*0.18, 600+600*0.18)

--Insercion de datos para la tabla superior
insert into superior values 
	('Super1', 'Ped1', 10, 60, 35, 19, 15, 60, 90, 100, 120)

--Insercion de datos para la tabla inferior
insert into inferior values 
	('infer1', 'Ped1', 80, 80, 30, 30, 40)