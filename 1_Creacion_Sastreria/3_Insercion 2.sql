USE SastreriaV1

--DROP TABLE producto_pedido;
--DROP TABLE comprobante;
--DROP TABLE empleado;
--DROP TABLE cliente;
--DROP TABLE documento;
--DROP TABLE genero;
--DROP TABLE producto;
--DROP TABLE condicion;
--DROP TABLE categoria;

--Insercion de datos para la tabla documento
INSERT INTO documento VALUES
	('DOC-1', 'DNI'),
	('DOC-2', 'Carnet de Extranjeria');

--Insercion de datos para la tabla genero
INSERT INTO genero VALUES
	('GEN-1', 'Masculino'),
	('GEN-2', 'Femenino'),
	('GEN-3', 'Otro');

--Insercion de datos para la tabla condicion
INSERT INTO condicion VALUES 
	('CDN-1', 'Nuevo', 'Producto estreno'),
	('CDN-2', 'Usado', 'Producto para alquiler');

--Insercion de datos para la tabla categoria
INSERT INTO categoria VALUES
	('CTG-1', 'Terno Conjunto', 'Producto que se vende con el conjunto completo'),
	('CTG-2', 'Saco de Terno', 'Producto que se vende solo el saco'),
	('CTG-3', 'Camisa', 'Producto de camisa unica'),
	('CTG-4', 'Corbata', 'Producto de corbata unica'),
	('CTG-5', 'Correa', 'Producto de corbata unica'),
	('CTG-6', 'Zapato', 'Producto par de zapato');

--Insercion de datos para la tabla empleado
INSERT INTO empleado VALUES
	('EMP-1', 'Andre Rodriguez', 'GEN-1', 'DOC-1', '72670549', '922047577', 'Av. Los Alamos 437', 'andre601@outlook.es', CONVERT(varbinary(255), 'kiro01', 0)),
	('EMP-2', 'Christian Angeles', 'GEN-1', 'DOC-1', '05497267', '757792204', 'Av. Alamos 437', 'andre520sif@outlook.es', CONVERT(varbinary(255), 'benito01', 0));

--Insercion de datos para la tabla cliente
INSERT INTO cliente VALUES
	('CLI-1', 'Jair Lopez', 'GEN-1', 'DOC-1', '12345676', '99999999', 'lopez@gmail.com'),
	('CLI-2', 'Mercedes Pesantes', 'GEN-2', 'DOC-1', '12386676', '88888888', 'mercedes@gmail.com'),
	('CLI-3', 'Anjali Angeles', 'GEN-2', 'DOC-1', '34345676', '99977999', 'lopez626@gmail.com')

--Insercion de datos para la tabla producto
INSERT INTO producto VALUES
	('PRO-1', 'Saco Normal', 'Saco rojo talla S', 'S','CTG-2', 'CDN-1', 300, 10),
	('PRO-2', 'Camisa Morada Bersh', 'Morada doble cuello', 'L','CTG-3', 'CDN-1', 190, 10),
	('PRO-3', 'Corbata Mega Azul', '', 'M','CTG-4', 'CDN-1', 87, 10),
	('PRO-4', 'Terno azul entero', 'Usado anteriormente', 'M','CTG-3', 'CDN-2', 200, 10)

--Insercion de datos para la tabla comprobante
INSERT INTO comprobante VALUES
	('CMP-1', 'Boleta'),
	('CMP-2', 'Factura')

--insercion de tipos de productos para la tabla producto_pedido
INSERT INTO producto_pedido VALUES
	('PRP-1', 'Chaleco', 'Prenda para torso'),
	('PRP-2', 'Blazer', 'Prenda estilo abrigo formal'),
	('PRP-3', 'Pantalon', 'Prenda formal para el inferior')