USE SastreriaV1

--alter table detalle_alquiler
--	add precio_u numeric(18,2);

drop table factura;
drop table detalle_venta;
drop table detalle_alquiler;
drop table alquiler;
drop table venta;
drop table inferior;
drop table superior;
drop table pedido;
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
	foreign key (id_condicion) references condicion(id_condicion)
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
	telefono_c varchar(15) not null,
	email_c varchar(255),
	foreign key (id_genero) references genero(id_genero),
	foreign key (id_documento) references documento(id_documento)
)

create table empleado(
	id_empleado varchar(15) primary key,
	nombre_e varchar(50) not null,
	id_genero varchar(15) not null,
	id_documento varchar(15) not null,
	num_doc_e varchar(20) not null,
	telefono_e varchar(15) not null,
	direccion_e varchar(255) not null,
	email_e varchar(255) not null,
	contraseña_e varchar(255) not null,
	foreign key (id_genero) references genero(id_genero),
	foreign key (id_documento) references documento(id_documento)
)

create table comprobante(
	id_comprobante varchar(15) primary key,
	nombre_com varchar(50),
)

create table pedido(
	id_pedido varchar(15) primary key,
	id_cliente varchar(15) not null,
	id_empleado varchar(15) not null,
	fecha_ped datetime not null,
	saco bit not null,
	chaleco bit not null,
	pantalon bit not null,
	descrip varchar(255),
	id_comprobante varchar(15) not null,
	num_comprobante varchar(10) not null,
	precio_base_p numeric(18,2) not null,
	impuesto_p numeric(18,2) not null,
	total_p numeric(18,2) not null,
	foreign key (id_cliente) references cliente(id_cliente),
	foreign key (id_empleado) references empleado(id_empleado),
	foreign key (id_comprobante) references comprobante(id_comprobante),
)

create table superior(
	id_super varchar(15) primary key,
	id_pedido varchar(15) not null,
	cuello numeric(18,2) not null,
	longitud numeric(18,2) not null,
	hombros numeric(18,2) not null,
	sisa numeric(18,2) not null,
	biceps numeric(18,2) not null,
	pecho numeric(18,2) not null,
	brazos numeric(18,2) not null,
	largo_cha numeric(18,2) not null,
	largo_abri numeric(18,2) not null,
	foreign key (id_pedido) references pedido(id_pedido)
)
	create unique index idx_superior_id_pedido on superior(id_pedido)

create table inferior(
	id_infer varchar(15) primary key,
	id_pedido varchar(15) not null,
	caderas numeric(18,2) not null,
	largo numeric(18,2) not null,
	tiro numeric(18,2) not null,
	posicion numeric(18,2) not null,
	muslos numeric(18,2) not null,
	foreign key (id_pedido) references pedido(id_pedido),
)
	create unique index idx_inferior_id_pedido on inferior(id_pedido)

create table venta(
	id_venta varchar(15) primary key,
	id_cliente varchar(15) not null,
	id_empleado varchar(15) not null,
	id_comprobante varchar(15) not null,
	num_comprobante varchar(10) not null,
	fecha_v datetime not null,
	precio_base_v numeric(18,2) not null,
	impuesto_v numeric(18,2) not null,
	total_v numeric(18,2) not null,
	foreign key (id_cliente) references cliente(id_cliente),
	foreign key (id_empleado) references empleado(id_empleado),
	foreign key (id_comprobante) references comprobante(id_comprobante)
)

create table alquiler(
	id_alquiler varchar(15) primary key,
	id_cliente varchar(15) not null,
	id_empleado varchar(15) not null,
	id_comprobante varchar(15) not null,
	num_comprobante_a varchar(10) not null,
	fecha_a datetime not null,
	precio_base_a numeric(18,2) not null,
	impuestos_a numeric(18,2) not null,
	total_a numeric(18,2) not null,
	foreign key (id_cliente) references cliente(id_cliente),
	foreign key (id_empleado) references empleado(id_empleado),
	foreign key (id_comprobante) references comprobante(id_comprobante)
)

create table detalle_alquiler(
	id_alquiler varchar(15) not null,
	id_producto varchar(15) not null,
	nombre_p varchar(255) not null,
	precio_u numeric(18,2) not null,
	cantidad_alquiler int not null,
	foreign key (id_alquiler) references alquiler(id_alquiler),
	foreign key (id_producto) references producto(id_producto)
)

create table detalle_venta(
	id_venta varchar(15) not null,
	id_producto varchar(15) not null,
	nombre_p varchar(255) not null,
	precio_u numeric(18,2) not null,
	cantidad_venta int not null,
	foreign key (id_venta) references venta(id_venta),
	foreign key (id_producto) references producto(id_producto)
)

create table factura(
	id_factura varchar(15) primary key,
	id_venta varchar(15),
	id_alquiler varchar(15),
	id_pedido varchar(15),
	fecha_factura datetime not null,
	total_factura numeric(18,2) not null,
	estado varchar(20) not null,
	foreign key (id_venta) references venta(id_venta),
	foreign key (id_alquiler) references alquiler(id_alquiler),
	foreign key (id_pedido) references pedido(id_pedido),
)