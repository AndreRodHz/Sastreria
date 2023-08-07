USE SastreriaV1

--alter table detalle_alquiler
--	add precio_u numeric(18,2);

drop table recibo;
drop table detalle_venta;
drop table detalle_alquiler;
drop table alquiler;
drop table venta;
drop table detalle_pedido;
drop table producto_pedido;
drop table inferior;
drop table superior;
drop table pedido;
drop table transaccion;
drop table comprobante;
drop table empleado;
drop table cliente;
drop table documento;
drop table genero;
drop table producto;
drop table condicion;
drop table categoria;

create table categoria(
	id_categoria varchar(15) primary key,
	nombre_cate varchar(50) not null,
	descrip_cate varchar(255)
)

create table condicion(
	id_condicion varchar(15) primary key,
	nombre_condi varchar(50) not null,
	descrip_condi varchar(255)
)

create table producto(
	id_producto varchar(15) primary key,
	nombre_p varchar(50) not null,
	descrip_p varchar(255),
	talla varchar(15),
	id_categoria varchar(15) not null,
	id_condicion varchar(15) not null,
	precio_p numeric(18,2) not null,
	stock_p int not null,
	foreign key (id_categoria) references categoria(id_categoria),
	foreign key (id_condicion) references condicion(id_condicion),
)

create table genero(
	id_genero varchar(15) primary key,
	nombre_gen varchar(50) not null,
)

create table documento(
	id_documento varchar(15) primary key,
	nombre_doc varchar(50) not null,
)

create table cliente(
	id_cliente varchar(15) primary key,
	nombre_c varchar(50) not null,
	id_genero varchar(15) not null,
	id_documento varchar(15) not null,
	num_doc_c varchar(20) not null,
	telefono_c varchar(15),
	email_c varchar(255),
	foreign key (id_genero) references genero(id_genero),
	foreign key (id_documento) references documento(id_documento),
	constraint UQ_num_doc_cliente unique(num_doc_c)
)

create table empleado(
	id_empleado varchar(15) primary key,
	nombre_e varchar(50) not null,
	id_genero varchar(15) not null,
	id_documento varchar(15) not null,
	num_doc_e varchar(20) not null,
	telefono_e varchar(15) not null,
	direccion_e varchar(255),
	email_e varchar(255) not null,
	password_e varbinary(255) not null,
	foreign key (id_genero) references genero(id_genero),
	foreign key (id_documento) references documento(id_documento),
	constraint UQ_num_doc_empleado unique(num_doc_e),
	constraint UQ_email_empleado unique(email_e)
)

create table comprobante(
	id_comprobante varchar(15) primary key,
	nombre_com varchar(50),
)

create table producto_pedido(
	id_prod_pedi varchar(15) primary key,
	nombre_pp varchar(50) not null,
	descripcion varchar(255),
)

--											***********SEPARADOR*************
create table transaccion(
	id_transac varchar(15) primary key,
	tipo_transac varchar(25) not null,
	fecha_t datetime not null,
)
--											***********SEPARADOR*************
create table pedido(
	id_pedido varchar(15) primary key,
	id_transac varchar(15) not null,
	id_cliente varchar(15) not null,
	id_empleado varchar(15) not null,
	fecha_p datetime not null,
	descrip varchar(255),
	precio_base_p numeric(18,2) not null,
	impuesto_p numeric(18,2) not null,
	total_p numeric(18,2) not null,
	foreign key (id_transac) references transaccion(id_transac),
	foreign key (id_cliente) references cliente(id_cliente),
	foreign key (id_empleado) references empleado(id_empleado),
	constraint UQ_pedido_transaccion unique(id_transac)
)

create table detalle_pedido(
	id_pedido varchar(15) not null,
	id_prod_pedi varchar(15) not null,
	precio_d_pp numeric(18,3) not null,
	foreign key (id_pedido) references pedido(id_pedido),
	foreign key (id_prod_pedi) references producto_pedido(id_prod_pedi)
)

create table superior(
	id_pedido varchar(15),
	cuello numeric(18,2),
	longitud numeric(18,2),
	hombros numeric(18,2),
	sisa numeric(18,2),
	biceps numeric(18,2),
	pecho numeric(18,2),
	brazos numeric(18,2),
	largo_cha numeric(18,2),
	largo_abri numeric(18,2),
	foreign key (id_pedido) references pedido(id_pedido),
	constraint UQ_superior_pedido unique(id_pedido)
)

create table inferior(
	id_pedido varchar(15),
	caderas numeric(18,2),
	largo numeric(18,2),
	tiro numeric(18,2),
	posicion numeric(18,2),
	muslos numeric(18,2),
	foreign key (id_pedido) references pedido(id_pedido),
	constraint UQ_inferior_pedido unique(id_pedido)
)

create table venta(
	id_venta varchar(15) primary key,
	id_transac varchar(15) not null,
	id_cliente varchar(15) not null,
	id_empleado varchar(15) not null,
	fecha_v datetime not null,
	precio_base_v numeric(18,2) not null,
	impuesto_v numeric(18,2) not null,
	total_v numeric(18,2) not null,
	foreign key (id_transac) references transaccion(id_transac),
	foreign key (id_cliente) references cliente(id_cliente),
	foreign key (id_empleado) references empleado(id_empleado),
	constraint UQ_venta_transaccion unique(id_transac)
)

create table alquiler(
	id_alquiler varchar(15) primary key,
	id_transac varchar(15) not null,
	id_cliente varchar(15) not null,
	id_empleado varchar(15) not null,
	fecha_a datetime not null,
	precio_base_a numeric(18,2) not null,
	impuesto_a numeric(18,2) not null,
	total_a numeric(18,2) not null,
	foreign key (id_transac) references transaccion(id_transac),
	foreign key (id_cliente) references cliente(id_cliente),
	foreign key (id_empleado) references empleado(id_empleado),
	constraint UQ_alquiler_transaccion unique(id_transac)
)

create table detalle_alquiler(
	id_alquiler varchar(15) not null,
	id_producto varchar(15) not null,
	precio_u numeric(18,2) not null,
	cantidad_alquiler int not null,
	foreign key (id_alquiler) references alquiler(id_alquiler),
	foreign key (id_producto) references producto(id_producto)
)

create table detalle_venta(
	id_venta varchar(15) not null,
	id_producto varchar(15) not null,
	precio_u numeric(18,2) not null,
	cantidad_venta int not null,
	foreign key (id_venta) references venta(id_venta),
	foreign key (id_producto) references producto(id_producto)
)

create table recibo(
	id_recibo varchar(15) primary key,
	id_transac varchar(15) not null,
	id_comprobante varchar(15) not null,
	num_comprobante varchar(20) not null,
	fecha_recibo datetime not null,
	base_rec numeric(18,2) not null,
	impuesto_rec numeric(18,2) not null,
	total_rec numeric(18,2) not null,
	estado varchar(20) not null,
	foreign key (id_transac) references transaccion(id_transac),
	foreign key (id_comprobante) references comprobante(id_comprobante),
	constraint UQ_recibo_num_comprobante unique(num_comprobante),
	constraint UQ_recibo_num_transaccion unique(id_transac)
)
