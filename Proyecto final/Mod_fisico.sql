create table Montador(
	id number not null,
	nombre varchar2(20) not null,
	direccion varchar2(50) not null,
	telefono varchar2(15) not null,
	num_cocina number not null,
    constraint montador_pk primary key (id)
);

create table Cliente(
	id number not null,
	nombre varchar2(20) not null,
	direccion varchar2(50) not null,
	telefono varchar2(15) not null,
    constraint cliente_pk primary key (id)
);

create table Distribuidor(
	id number not null,
	nombre varchar2(20) not null,
	direccion varchar2(50) not null,
	fecha date not null,
    constraint distribuidor_pk primary key (id)
);

create table TelefonoDistribuidor(
	id_Distribuidor number not null,
	telefono varchar2(15) not null,
	constraint telefonodistribuidor_pk primary key (id_Distribuidor, telefono),
	constraint telefonodistribuidor_fk_distribuidor foreign key (id_Distribuidor) references Distribuidor (id)
);

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
	constraint telefonofabricante_fk_fabricante foreign key (id_Fabricante) references Fabricante (id)
);

create table Repartidor(
	id number not null,
	nombre varchar2(20) not null,
	correo varchar2(320) not null,
	telefono varchar2(15) not null,
    constraint repartidor_pk primary key (id)
);

create table Vehiculo(
	placa varchar2(7) not null,
	anho number not null,
	tipo varchar2(20) not null,
	capacidad number not null,
	modelo varchar2(20) not null,
	marca varchar2(20) not null,
    constraint vehiculo_pk primary key (id)
);

create table Mueble(
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
	marmol bit, --Encimeras
	algomerado bit,
	ID_fabricante number,
    constraint mueble_pk primary key (id),
	constraint mueble_fk_fabricante foreign key (ID_fabricante) references Fabricante (id)
);

create table Cocina(
	id number unique not null,
	numSerie number not null,
	inStock number not null,
	nombre varchar2(20) not null,
	numMuebles number not null,
	ID_repartidor number not null,
	ID_distribuidor number not null,
	constraint cocina_pk primary key (id, numSerie),
	constraint cocina_fk_repartidor foreign key (ID_repartidor) references Repartidor (id),
	constraint cocina_fk_distribuidor foreign key (ID_distribuidor) references Distribuidor (id)
);

create table MuebleEnCocina(
	id_Mueble number not null,
	id_Cocina number not null,
	constraint mueblecocina_pk primary key(id_Mueble, id_Cocina),
	constraint mueblecocina_fk_mueble foreign key (id_Mueble) references Mueble (id),
	constraint mueblecocina_fk_cocina foreign key (id_Cocina) references Cocina (id)
);

create table CocinaMontador(
	id_Cocina number not null,
	id_Montador number not null,
	constraint cocinamontador_pk primary key(id_Mueble, id_Cocina),
	constraint cocinamontador_fk_cocina foreign key (id_Cocina) references Cocina (id),
	constraint cocinamontador_fk_mueble foreign key (id_Montador) references Montador (id)
);

create table CocinaCliente(
	id_Cocina number not null,
	id_Cliente number not null,
	constraint cocinacliente_pk primary key(id_Mueble, id_Cocina),
	constraint cocinacliente_fk_cocina foreign key (id_Cocina) references Cocina (id),
	constraint cocinacliente_fk_cliente foreign key (id_Cliente) references Cliente (id)
);

create table VehiculoRepartidor(
	placa varchar2(7) not null,
	id_Repartidor number not null,
	constraint vehiculorepartidor_pk primary key (placa, id_Repartidor),
	constraint vehiculorepartidor_fk_vehiculo foreign key (placa) references Vehiculo (placa),
	constraint vehiculorepartidor_fk_repartidor foreign key (id_Repartidor) references Repartidor(id)
);

create table FabricanteDistribuidor(
	id_Fabricante number not null,
	id_Distribuidor number not null,
	constraint fabricantedistribuidor_pk primary key (id_Fabricante, id_Distribuidor),
	constraint fabricantedistribuidor_fk_fabricante foreign key (id_Fabricante) references Fabricante (id),
	constraint fabricantedistribuidor_fk_distribuidor foreign key (id_Distribuidor) references Distribuidor(id)
);