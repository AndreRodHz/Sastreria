use SastreriaV1


--PARA AGREGAR UN NUEVO CLIENTE
insert into cliente values
	('CLI-90', 'Nombre', 'GEN-0', 'DOC-0', '1234567', '987654321', 'correo@yopmail.com')
  -- Codigo, Nombre, Genero, Documento, NumeroDoc, Telefono, Correo


--PARA MODIFICAR UN CLIENTE
update cliente 
	set id_cliente = '',
		nombre_c = '',
		id_genero = '',
		id_documento = '',
		num_doc_c = '',
		telefono_c = '',
		email_c = ''
	where id_cliente = 'CLI-90';


--PARA ELIMINAR UN CLIENTE
delete cliente where id_cliente = 'CLI-90'


--PARA VER LA LISTA DE CLIENTES
SELECT id_cliente as 'ID Cliente', nombre_c as 'Nombre', nombre_gen as 'Genero', nombre_doc as 'Documento',
	   num_doc_c as 'N° Documento', telefono_c as 'Telefono', email_c as 'Email'
FROM cliente
INNER JOIN genero ON cliente.id_genero = genero.id_genero
INNER JOIN documento ON cliente.id_documento = documento.id_documento
