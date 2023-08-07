use SastreriaV1

--PARA AGREGAR UN NUEVO EMPLEADO
insert into empleado values
	('EMP-90', 'Nombre', 'GEN-0', 'DOC-0', '1234567', '987654321', 'Domicilio', 'correo@yopmail.com', CONVERT(varbinary(255), 'contraseña', 0));
--   Codigo, Nombre, Genero, Documento, NumDoc, Telefono,  Direccion,    Correo,             Constraseña


--PARA MODIFICAR UN EMPLEADO
update empleado 
	set id_empleado = '',
		nombre_e = '',
		id_genero = '',
		id_documento = '',
		num_doc_e = '',
		telefono_e = '',
		direccion_e = '',
		email_e = '',
		password_e = ''
	where id_empleado = 'EMP-1';


--PARA ELIMINAR UN EMPLEADO
delete empleado where id_empleado = 'EMP-90'


--PARA VER LISTA DE EMPLEADOS
SELECT id_empleado as 'ID Empleado', nombre_e as 'Nombre', nombre_gen as 'Genero', nombre_doc as 'Documento',
	   num_doc_e as 'N° Documento', telefono_e as 'Telefono', direccion_e as 'Domicilio', email_e as 'Email'
FROM empleado
INNER JOIN genero ON empleado.id_genero = genero.id_genero
INNER JOIN documento ON empleado.id_documento = documento.id_documento
