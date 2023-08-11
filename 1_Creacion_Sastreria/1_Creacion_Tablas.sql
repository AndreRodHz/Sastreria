USE SastreriaV1

DROP TABLE recibo;
DROP TABLE detalle_venta;
DROP TABLE detalle_alquiler;
DROP TABLE alquiler;
DROP TABLE venta;
DROP TABLE detalle_pedido;
DROP TABLE producto_pedido;
DROP TABLE inferior;
DROP TABLE superior;
DROP TABLE pedido;
DROP TABLE transaccion;
DROP TABLE comprobante;
DROP TABLE empleado;
DROP TABLE cliente;
DROP TABLE documento;
DROP TABLE genero;
DROP TABLE producto;
DROP TABLE condicion;
DROP TABLE categoria;

CREATE TABLE categoria(
	id_categoria VARCHAR(15) PRIMARY KEY,
	nombre_cate VARCHAR(35) NOT NULL,
	descrip_cate VARCHAR(255)
)

CREATE TABLE condicion(
	id_condicion VARCHAR(15) PRIMARY KEY,
	nombre_condi VARCHAR(50) NOT NULL,
	descrip_condi VARCHAR(255)
)

CREATE TABLE producto(
	id_producto VARCHAR(15) PRIMARY KEY,
	nombre_p VARCHAR(50) NOT NULL,
	descrip_p VARCHAR(255),
	talla VARCHAR(15),
	id_categoria VARCHAR(15) NOT NULL,
	id_condicion VARCHAR(15) NOT NULL,
	precio_p NUMERIC(18,2) NOT NULL,
	stock_p INT NOT NULL,
	FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
	FOREIGN KEY (id_condicion) REFERENCES condicion(id_condicion),
	CONSTRAINT CK_precio_no_negativo CHECK(precio_p >= 0),
	CONSTRAINT CK_cantidad_no_negativo CHECK(stock_p >= 0)
)
	
CREATE TABLE genero(
	id_genero VARCHAR(15) PRIMARY KEY,
	nombre_gen VARCHAR(50) NOT NULL,
)

CREATE TABLE documento(
	id_documento VARCHAR(15) PRIMARY KEY,
	nombre_doc VARCHAR(50) NOT NULL,
)

CREATE TABLE cliente(
	id_cliente VARCHAR(15) PRIMARY KEY,
	nombre_c VARCHAR(50) NOT NULL,
	id_genero VARCHAR(15) NOT NULL,
	id_documento VARCHAR(15) NOT NULL,
	num_doc_c VARCHAR(20) NOT NULL,
	telefono_c VARCHAR(15),
	email_c VARCHAR(255),
	FOREIGN KEY (id_genero) REFERENCES genero(id_genero),
	FOREIGN KEY (id_documento) REFERENCES documento(id_documento),
	CONSTRAINT UQ_num_doc_cliente UNIQUE(num_doc_c)
)

CREATE TABLE empleado(
	id_empleado VARCHAR(15) PRIMARY KEY,
	nombre_e VARCHAR(50) NOT NULL,
	id_genero VARCHAR(15) NOT NULL,
	id_documento VARCHAR(15) NOT NULL,
	num_doc_e VARCHAR(20) NOT NULL,
	telefono_e VARCHAR(15) NOT NULL,
	direccion_e VARCHAR(255),
	email_e VARCHAR(255) NOT NULL,
	password_e varbinary(255) NOT NULL,
	FOREIGN KEY (id_genero) REFERENCES genero(id_genero),
	FOREIGN KEY (id_documento) REFERENCES documento(id_documento),
	CONSTRAINT UQ_num_doc_empleado UNIQUE(num_doc_e),
	CONSTRAINT UQ_email_empleado UNIQUE(email_e)
)

CREATE TABLE comprobante(
	id_comprobante VARCHAR(15) PRIMARY KEY,
	nombre_com VARCHAR(50),
)

CREATE TABLE producto_pedido(
	id_prod_pedi VARCHAR(15) PRIMARY KEY,
	nombre_pp VARCHAR(50) NOT NULL,
	descripcion VARCHAR(255),
)

--											***********SEPARADOR*************
CREATE TABLE transaccion(
	id_transac VARCHAR(15) PRIMARY KEY,
	tipo_transac VARCHAR(25) NOT NULL,
	fecha_t DATETIME NOT NULL,
)
--											***********SEPARADOR*************
CREATE TABLE pedido(
	id_pedido VARCHAR(15) PRIMARY KEY,
	id_transac VARCHAR(15) NOT NULL,
	id_cliente VARCHAR(15) NOT NULL,
	id_empleado VARCHAR(15) NOT NULL,
	fecha_p DATETIME NOT NULL,
	medida_superior VARCHAR(2) NOT NULL,
	medida_inferior VARCHAR(2) NOT NULL,
	descrip VARCHAR(255),
	precio_base_p NUMERIC(18,2) NOT NULL,
	impuesto_p NUMERIC(18,2) NOT NULL,
	total_p NUMERIC(18,2) NOT NULL,
	FOREIGN KEY (id_transac) REFERENCES transaccion(id_transac),
	FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
	FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
	CONSTRAINT UQ_pedido_transaccion UNIQUE(id_transac)
)

CREATE TABLE detalle_pedido(
	id_pedido VARCHAR(15) NOT NULL,
	id_prod_pedi VARCHAR(15) NOT NULL,
	descripcion_dp VARCHAR(255),
	precio_d_pp NUMERIC(18,2) NOT NULL,
	FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
	FOREIGN KEY (id_prod_pedi) REFERENCES producto_pedido(id_prod_pedi)
)

CREATE TABLE superior(
	id_pedido VARCHAR(15) NOT NULL,
	cuello NUMERIC(18,2),
	longitud NUMERIC(18,2),
	hombros NUMERIC(18,2),
	sisa NUMERIC(18,2),
	biceps NUMERIC(18,2),
	pecho NUMERIC(18,2),
	brazos NUMERIC(18,2),
	largo_cha NUMERIC(18,2),
	largo_abri NUMERIC(18,2),
	FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
	CONSTRAINT UQ_superior_pedido UNIQUE(id_pedido)
)

CREATE TABLE inferior(
	id_pedido VARCHAR(15) NOT NULL,
	caderas NUMERIC(18,2),
	largo NUMERIC(18,2),
	tiro NUMERIC(18,2),
	posicion NUMERIC(18,2),
	muslos NUMERIC(18,2),
	FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
	CONSTRAINT UQ_inferior_pedido UNIQUE(id_pedido)
)

CREATE TABLE venta(
	id_venta VARCHAR(15) PRIMARY KEY,
	id_transac VARCHAR(15) NOT NULL,
	id_cliente VARCHAR(15) NOT NULL,
	id_empleado VARCHAR(15) NOT NULL,
	fecha_v DATETIME NOT NULL,
	precio_base_v NUMERIC(18,2) NOT NULL,
	impuesto_v NUMERIC(18,2) NOT NULL,
	total_v NUMERIC(18,2) NOT NULL,
	FOREIGN KEY (id_transac) REFERENCES transaccion(id_transac),
	FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
	FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
	CONSTRAINT UQ_venta_transaccion UNIQUE(id_transac)
)

CREATE TABLE alquiler(
	id_alquiler VARCHAR(15) PRIMARY KEY,
	id_transac VARCHAR(15) NOT NULL,
	id_cliente VARCHAR(15) NOT NULL,
	id_empleado VARCHAR(15) NOT NULL,
	fecha_a DATETIME NOT NULL,
	precio_base_a NUMERIC(18,2) NOT NULL,
	impuesto_a NUMERIC(18,2) NOT NULL,
	total_a NUMERIC(18,2) NOT NULL,
	FOREIGN KEY (id_transac) REFERENCES transaccion(id_transac),
	FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
	FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
	CONSTRAINT UQ_alquiler_transaccion UNIQUE(id_transac)
)

CREATE TABLE detalle_alquiler(
	id_alquiler VARCHAR(15) NOT NULL,
	id_producto VARCHAR(15) NOT NULL,
	precio_u NUMERIC(18,2) NOT NULL,
	cantidad_alquiler INT NOT NULL,
	FOREIGN KEY (id_alquiler) REFERENCES alquiler(id_alquiler),
	FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
)

CREATE TABLE detalle_venta(
	id_venta VARCHAR(15) NOT NULL,
	id_producto VARCHAR(15) NOT NULL,
	precio_u NUMERIC(18,2) NOT NULL,
	cantidad_venta INT NOT NULL,
	FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
	FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
)

CREATE TABLE recibo(
	id_recibo VARCHAR(15) PRIMARY KEY,
	id_transac VARCHAR(15) NOT NULL,
	id_comprobante VARCHAR(15) NOT NULL,
	num_comprobante VARCHAR(20) NOT NULL,
	fecha_recibo DATETIME NOT NULL,
	base_rec NUMERIC(18,2) NOT NULL,
	impuesto_rec NUMERIC(18,2) NOT NULL,
	total_rec NUMERIC(18,2) NOT NULL,
	estado varchar(20) NOT NULL,
	FOREIGN KEY (id_transac) REFERENCES transaccion(id_transac),
	FOREIGN KEY (id_comprobante) REFERENCES comprobante(id_comprobante),
	CONSTRAINT UQ_recibo_num_comprobante UNIQUE(num_comprobante),
	CONSTRAINT UQ_recibo_num_transaccion UNIQUE(id_transac)
)