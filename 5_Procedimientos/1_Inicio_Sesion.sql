use SastreriaV1

select * from empleado

delete empleado where id_empleado like 'E4'

insert into empleado values
	('E3', 'ALEJANDro', 'G1', 'D1', '384873', '483722', 'Av. Torre 1', 'asAFFSas@HotMaiL.Ez', CONVERT(varbinary(255),'OrizONhshD', 0))
	--('E4', 'AlbertAA', 'G2', 'D1', '38442873', '412183722', 'Av. Solar 5', 'SolUYUw_@HotMaiL.ZzZ', CONVERT(varbinary(255),'gst4546rff', 0));


--drop trigger seguridad_contrase
--drop trigger entrada_cliente
--drop trigger entrada_empleado


--select CONVERT(varchar(255), password_e) from empleado


DECLARE @email varchar(255);
SET @email = 'asAFFSas@HotMaiL.Ez'

DECLARE @contrasena varchar(255);
SET @contrasena = 'OrizONhshD';

DECLARE	@valor varbinary(255);
SET @valor = CONVERT(varbinary(255), @contrasena, 0);

DECLARE @hash varbinary(255);
SET @hash = HASHBYTES('SHA2_512', @valor);

IF (select password_e from empleado where email_e = @email) like @hash
	BEGIN
		PRINT 'Bienvenido Señor';
	END
ELSE
	BEGIN
		PRINT 'Atras Intruso';
	END


--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 
--DECLARE @cadena nvarchar(100);
--SET @cadena = 'Miiii';

--DECLARE @hash varbinary(255);
--SET @hash = HASHBYTES('SHA2_512', @cadena);

--select @hash;