--use SastreriaV1

CREATE TRIGGER escritura_cliente
ON cliente
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE cliente
	SET nombre_c = UPPER(left(nombre_c, 1)) + LOWER(SUBSTRING(nombre_C, 2, LEN(nombre_c))),
	email_c =
		CASE 
			WHEN email_c IS NOT NULL AND CHARINDEX('@', email_c) > 0 THEN
				LOWER(SUBSTRING(email_c, 1, CHARINDEX('@', email_c) -1))
				+ SUBSTRING(email_c, CHARINDEX('@', email_c), LEN(email_c))
			ELSE
				email_c
		END
	FROM inserted
	WHERE cliente.id_cliente = inserted.id_cliente;
END;
