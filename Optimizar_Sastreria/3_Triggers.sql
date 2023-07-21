--use SastreriaV1

CREATE TRIGGER escritura_cliente
ON cliente
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE cliente
	SET nombre_c = UPPER(left(inserted.nombre_c, 1)) + LOWER(SUBSTRING(inserted.nombre_C, 2, LEN(inserted.nombre_c))),
		email_c =
			CASE 
				WHEN inserted.email_c IS NOT NULL AND CHARINDEX('@', inserted.email_c) > 0 THEN
					LOWER(SUBSTRING(inserted.email_c, 1, CHARINDEX('@', inserted.email_c) -1))
					+ SUBSTRING(inserted.email_c, CHARINDEX('@', inserted.email_c), LEN(inserted.email_c))
				ELSE
					inserted.email_c
			END
	FROM inserted
	WHERE cliente.id_cliente = inserted.id_cliente;
END;
