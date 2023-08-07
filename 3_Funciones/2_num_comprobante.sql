-- =======================================================================================================================================
-- SELECT para obtener la matriz de cara al usuario
-- =======================================================================================================================================
CREATE FUNCTION dbo.num_comprobante (@inputString VARCHAR(5))
RETURNS VARCHAR(15)
AS
BEGIN
	declare @input_num_comp varchar(20),
			@primera varchar(4),
			@segunda varchar(8),
			@seg_num int,
			@seg_salida varchar(8),
			@pri_salida_pos varchar(3),
			@letra varchar(1),
			@pri_digito int,
			@return varchar(13)

	set @input_num_comp = (SELECT MAX(num_comprobante) FROM recibo where num_comprobante like ('%'+@inputString+'%'))
	set	@primera = substring(@input_num_comp, 1, len(@input_num_comp)-9)
	set @segunda = SUBSTRING(@input_num_comp, 6, len(@input_num_comp)-5)
	set @seg_num = CONVERT(int,@segunda, 0)

	IF @seg_num + 1 = 100000000
		BEGIN
			set @letra = SUBSTRING(@primera, 1, 1)
			set @pri_digito = CONVERT(int,(SUBSTRING(@primera, 2, 3)), 0)
			set @pri_salida_pos = (SELECT RIGHT(REPLICATE('0', 3-LEN(@pri_digito)) + CONVERT(varchar(3), @pri_digito + 1), 3))
			set @seg_salida = (SELECT RIGHT(REPLICATE('0', 8) + CONVERT(varchar(8), 1), 8))
			set @return = @letra + @pri_salida_pos + '-' + @seg_salida
		END
	ELSE
		BEGIN
			set @seg_salida = (SELECT RIGHT(REPLICATE('0', 8) + CONVERT(varchar(8), @seg_num + 1), 8))
			set @return = @primera + '-' + @seg_salida
		END		
RETURN @return;
END;
--aaaaaaa

--SELECT dbo.num_comprobante('F')

--DROP FUNCTION dbo.num_comprobante