USE SastreriaV1

--PARA AGREGAR UN NUEVO EMPLEADO
INSERT INTO empleado VALUES
	('EMP-90', 'Nombre', 'GEN-0', 'DOC-0', '1234567', '987654321', 'Domicilio', 'correo@yopmail.com', CONVERT(VARBINARY(255), 'contraseña', 0));
--   Codigo, Nombre, Genero, Documento, NumDoc, Telefono,  Direccion,    Correo,             Constraseña


--PARA MODIFICAR UN EMPLEADO
UPDATE empleado 
	SET id_empleado = '',
		nombre_e = '',
		id_genero = '',
		id_documento = '',
		num_doc_e = '',
		telefono_e = '',
		direccion_e = '',
		email_e = '',
		pASsword_e = ''
	WHERE id_empleado = 'EMP-1';


--PARA ELIMINAR UN EMPLEADO
delete empleado WHERE id_empleado = 'EMP-90'


--PARA VER LISTA DE EMPLEADOS
SELECT id_empleado AS 'ID Empleado', nombre_e AS 'Nombre', nombre_gen AS 'Genero', nombre_doc AS 'Documento',
	   num_doc_e AS 'N° Documento', telefono_e AS 'Telefono', direccion_e AS 'Domicilio', email_e AS 'Email'
FROM empleado
INNER JOIN genero ON empleado.id_genero = genero.id_genero
INNER JOIN documento ON empleado.id_documento = documento.id_documento
