/* 

Detalles que estoy considerando para nomenclatura:
Esto es más que nada para el workflow que mostraremos

Paramétrico: algo que se setea de backend, están llenas de antemano y podrían tener procedimientos para más

De negocio: tablas que se llenan respecto se usa la BD, pueden empezar vacías

Transacción: literalmente transacciones, compra y venta

*/
-- Secuencias para las tablas
CREATE SEQUENCE SEQ_MONTADOR START WITH 1;
CREATE SEQUENCE SEQ_FABRICANTE START WITH 1;
CREATE SEQUENCE SEQ_DISTRIBUIDOR START WITH 1;
CREATE SEQUENCE SEQ_CLIENTE START WITH 1;
CREATE SEQUENCE SEQ_REPARTIDOR START WITH 1;
CREATE SEQUENCE SEQ_MUEBLE START WITH 1;
CREATE SEQUENCE SEQ_COCINA START WITH 1;

-- Todas las tablas
-- Paramétrica
create table Montador(
	id number not null,
	nombre varchar2(20) not null,
	direccion varchar2(50) not null,
	telefono varchar2(15) not null,
	num_cocina number not null,
    constraint montador_pk primary key (id)
);

-- Negocio
create table Cliente(
	id number not null,
	nombre varchar2(20) not null,
	direccion varchar2(50) not null,
	telefono varchar2(15) not null,
    constraint cliente_pk primary key (id)
);

-- Paramétrica
create table Distribuidor(
	id number not null,
	nombre varchar2(20) not null,
	direccion varchar2(50) not null,
    constraint distribuidor_pk primary key (id)
);

create table TelefonoDistribuidor(
	id_Distribuidor number not null,
	telefono varchar2(15) not null,
	constraint telefonodistribuidor_pk primary key (id_Distribuidor, telefono),
	constraint teldist_fk_dist foreign key (id_Distribuidor) references Distribuidor (id)
);

-- Paramétrica
create table Fabricante(
	id number not null,
	nombre varchar2(20) not null,
	direccion varchar2(50) not null,
	fecha date not null,
    constraint fabricante_pk primary key(id)
);

create table TelefonoFabricante(
	id_Fabricante number not null,
	telefono varchar2(15) not null,
	constraint telefonofabricante_pk primary key (id_Fabricante, telefono),
	constraint telfabr_fk_fabr foreign key (id_Fabricante) references Fabricante (id)
);

-- Negocio
create table Repartidor(
	id number not null,
	nombre varchar2(20) not null,
	correo varchar2(320) not null,
	telefono varchar2(15) not null,
    constraint repartidor_pk primary key (id)
);

-- Paramétrica
create table Vehiculo(
	id number not null,
	placa varchar2(7) not null unique,
	anho number not null,
	tipo varchar2(20) not null,
	capacidad number not null,
	modelo varchar2(20) not null,
	marca varchar2(20) not null,
    constraint vehiculo_pk primary key (id)
);

create table Mueble( -- Estos son TIPOS de mueble
	id number not null,
	color varchar2(20) not null,
	linea varchar2(20) not null,
	ancho decimal(3,1) not null,
	alto decimal(3,1) not null,
	tipo_mueble varchar2(20) not null,
	altura decimal(10,1), --Mueble alto
	C_peso number,
	Divisiones number,
	Altura_suelo decimal(10,1), --Mueble bajo
	num_divisiones number,
	material varchar2(20), --Paneles
	t_componente varchar2(20),
	marmol number(1,0), --Encimeras
	aglomerado number(1,0),
	ID_fabricante number,
    constraint mueble_pk primary key (id),
	constraint mueble_fk_fabricante foreign key (ID_fabricante) references Fabricante (id),
	constraint check_marmol check (marmol in (1,0)),
	constraint check_aglom check (aglomerado in (1,0))
);

create table Cocina(
	id number unique not null,
	numSerie number not null,
	inStock number not null,
	nombre varchar2(20) not null,
	numMuebles number not null,
	ID_repartidor number not null,
	ID_distribuidor number not null,
	fecha_compra date,
	constraint cocina_pk primary key (id, numSerie),
	constraint cocina_fk_repartidor foreign key (ID_repartidor) references Repartidor (id),
	constraint cocina_fk_distribuidor foreign key (ID_distribuidor) references Distribuidor (id)
);

create table MuebleEnCocina(
	id_mueble number not null,
	id_cocina number not null,
	constraint mueblecocina_pk primary key(id_mueble, id_cocina),
	constraint mueblecocina_fk_mueble foreign key (id_mueble) references Mueble (id),
	constraint mueblecocina_fk_cocina foreign key (id_cocina) references Cocina (id)
);

create table CocinaMontador(
	id_cocina number not null,
	id_montador number not null,
	constraint cocinamontador_pk primary key(id_cocina, id_montador),
	constraint cocinamontador_fk_cocina foreign key (id_cocina) references Cocina (id),
	constraint cocinamontador_fk_mueble foreign key (id_montador) references Montador (id)
);

create table VehiculoRepartidor(
	placa varchar2(7) not null,
	id_Repartidor number not null,
	constraint vehirep_pk primary key (placa, id_Repartidor),
	constraint vehirep_fk_vehi foreign key (placa) references Vehiculo (placa),
	constraint vehirep_fk_rep foreign key (id_Repartidor) references Repartidor(id)
);

create table FabricanteDistribuidor(
	id_Fabricante number not null,
	id_Distribuidor number not null,
	constraint fabrdist_pk primary key (id_Fabricante, id_Distribuidor),
	constraint fabrdist_fk_fabr foreign key (id_Fabricante) references Fabricante (id),
	constraint fabrdist_fk_dist foreign key (id_Distribuidor) references Distribuidor(id)
);

-- Tablas de Transaccion:
create table VentaCocina(
	num_factura number not null,
	id_cocina number not null,
	id_cliente number not null,
	fecha date not null,
	constraint cocinacliente_pk primary key(num_factura),
	constraint cocinacliente_fk_cocina foreign key (id_cocina) references Cocina (id),
	constraint cocinacliente_fk_cliente foreign key (id_cliente) references Cliente (id)
);

-- Falta añadir COMPRA_COCINA
-- Realmente creo que no, por la regla de 1 dist para cada cocina