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
CREATE SEQUENCE SEQ_CLIENTE START WITH 1;
CREATE SEQUENCE SEQ_REPARTIDOR START WITH 1;
CREATE SEQUENCE SEQ_VEHICULO START WITH 1;
CREATE SEQUENCE SEQ_PRODUCTO START WITH 1;
CREATE SEQUENCE SEQ_COMPRA START WITH 1;
CREATE SEQUENCE SEQ_VENTA START WITH 1;
CREATE SEQUENCE SEQ_USUARIO START WITH 1;
CREATE SEQUENCE SEQ_CREDENCIALES START WITH 1;
-- CREATE SEQUENCE SEQ_MUEBLE START WITH 1;
-- CREATE SEQUENCE SEQ_COCINA START WITH 1;

-- Todas las tablas
-- Paramétrica
CREATE TABLE CREDENCIALES (
    ID NUMBER NOT NULL PRIMARY KEY,
    USUARIO VARCHAR2(50) NOT NULL UNIQUE,
    CONTRASENA VARCHAR2(50) NOT NULL,
    ROL VARCHAR2(20) NOT NULL CHECK (ROL IN ('CLIENTE', 'EMPLEADO'))
);

create table Usuario(
	id number not null,
	nombre VARCHAR2(25),
	telefono VARCHAR2(15),
	direccion VARCHAR2(50),
	ID_CREDENCIALES NUMBER,
	constraint usuario_pk primary key (id)
	CONSTRAINT USUARIO_FK_CREDENCIALES FOREIGN KEY (ID_CREDENCIALES) REFERENCES CREDENCIALES (ID)
);

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
	ID_CREDENCIALES NUMBER,
    constraint cliente_pk primary key (id)
	CONSTRAINT CLIENTE_FK_CREDENCIALES FOREIGN KEY (ID_CREDENCIALES) REFERENCES CREDENCIALES (ID)
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
	correo varchar2(60) not null,
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

CREATE TABLE TIPO_MUEBLE( -- 1=ALTO, 2=BAJO, 3=PANEL, 4=ENCIMERA
	ID_TIPO NUMBER NOT NULL,
	NOMBRE VARCHAR2(20) NOT NULL,
	CONSTRAINT TIPO_MUEBLE_PK PRIMARY KEY(ID_TIPO)
);

create table Mueble( -- Estos son MODELOS de mueble
	id number not null,
	cantidad number not null,
	color varchar2(20) not null,
	linea varchar2(20) not null,
	ancho decimal(3,1) not null,
	alto decimal(3,1) not null,
	precio number(6,2) not null,
	fecha_compra date,
	tipo_mueble number not null,
	altura decimal(10,1), --Mueble alto
	C_peso number, -- ← esto es, capacidad de peso
	Divisiones number,
	Altura_suelo decimal(10,1), --Mueble bajo
	num_divisiones number,
	material varchar2(20), --Paneles
	t_componente varchar2(20),
	mat_enc char, --Encimeras	
	ID_fabricante number,
    constraint mueble_pk primary key (id),
	constraint mueble_fk_tipo foreign key (tipo_mueble) references TIPO_MUEBLE (ID_TIPO),
	constraint mueble_fk_fabricante foreign key (ID_fabricante) references Fabricante (id),
	constraint check_mat_enc check (mat_enc in ('M','A'))
);

create table Cocina( -- MODELO
	id number not null,
	numSerie number not null,
	inStock number not null,
	nombre varchar2(20) not null,
	precio number(6,2) not null,
	numMuebles number not null, -- se calcula desde trigger en MuebleEnCocina
	constraint cocina_pk primary key (id)
);

create table MuebleEnCocina(
	id_mueble number not null,
	id_cocina number not null,
	cantidad number not null, -- cuantos de x mueble tenemos en y cocina
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

-- Tablas de Transaccion:
CREATE TABLE COMPRA(
	ID_COMPRA NUMBER NOT NULL,
	ID_USUARIO NUMBER NOT NULL,
	FACTURA_FABRICANTE NUMBER NOT NULL, -- esto es lo que mantiene el fabricante
	ID_FABRICANTE NUMBER NOT NULL,
	MONTO NUMBER (6,2) NOT NULL,
	FECHA DATE NOT NULL,
	CONSTRAINT COMPRA_PK PRIMARY KEY (ID_COMPRA),
	constraint compra_fk_usuario foreign key (ID_USUARIO) references USUARIO (id),
	CONSTRAINT COMPRA_FK_FABR FOREIGN KEY (ID_FABRICANTE) REFERENCES FABRICANTE (ID)
);

CREATE TABLE DETALLE_COMPRA(
	ID_COMPRA NUMBER NOT NULL,
	ID_MUEBLE NUMBER NOT NULL,
	CANTIDAD NUMBER NOT NULL,
	CONSTRAINT DET_COMPRA_PK PRIMARY KEY (ID_COMPRA, ID_MUEBLE),
	CONSTRAINT DET_COMPRA_FK_COMPRA FOREIGN KEY (ID_COMPRA) REFERENCES COMPRA (ID_COMPRA),
	CONSTRAINT DET_COMPRA_FK_MUEBLE FOREIGN KEY (ID_MUEBLE) REFERENCES MUEBLE (ID)
);

create table VENTA(
	num_factura number not null,
	SUBTOTAL NUMBER(6,2) NOT NULL,
	IMPUESTO NUMBER(6,2) NOT NULL,
	TOTAL NUMBER(6,2) NOT NULL,
	id_cliente number not null,
	ID_USUARIO NUMBER NOT NULL,
	fecha_VENTA date not null,
	constraint ventacocina_pk primary key(num_factura),
	constraint ventacocina_fk_usuario foreign key (ID_USUARIO) references USUARIO (id),
	constraint ventacocina_fk_cliente foreign key (id_cliente) references Cliente (id)
);

-------- fin de T's
CREATE TABLE DETALLE_V_MUEBLES(
	NUM_FACTURA NUMBER NOT NULL,
	ID_MUEBLE NUMBER NOT NULL,
	CANTIDAD NUMBER NOT NULL,
	CONSTRAINT DET_M_PK PRIMARY KEY (NUM_FACTURA, ID_MUEBLE),
	CONSTRAINT DET_M_FK_FAC FOREIGN KEY (NUM_FACTURA) REFERENCES VENTA (NUM_FACTURA),	
	CONSTRAINT DET_M_FK_M FOREIGN KEY (ID_MUEBLE) REFERENCES MUEBLE (ID)
);

CREATE TABLE DETALLE_V_COCINAS(
	NUM_FACTURA NUMBER NOT NULL,
	ID_COCINA NUMBER NOT NULL,
	CANTIDAD NUMBER NOT NULL,
	CONSTRAINT DET_C_PK PRIMARY KEY (NUM_FACTURA, ID_COCINA),
	CONSTRAINT DET_C_FK_FAC FOREIGN KEY (NUM_FACTURA) REFERENCES VENTA (NUM_FACTURA),
	CONSTRAINT DET_C_FK_C FOREIGN KEY (ID_COCINA) REFERENCES COCINA (ID)
);

CREATE TABLE ENTREGA(
	NUM_FACTURA NUMBER NOT NULL,
	ID_REPARTIDOR NUMBER NOT NULL,
	ID_MONTADOR NUMBER NOT NULL,
	FECHA_ASIGNADA DATE NOT NULL,
	constraint ENTREGAS_PK primary key(NUM_FACTURA, ID_REPARTIDOR),
	CONSTRAINT ENTREGAS_FK_VENTA FOREIGN KEY (NUM_FACTURA) REFERENCES VENTA (NUM_FACTURA),
	CONSTRAINT ENTREGAS_FK_REP FOREIGN KEY (ID_REPARTIDOR) REFERENCES REPARTIDOR (ID),
	CONSTRAINT ENTREGAS_FK_MONT FOREIGN KEY (ID_MONTADOR) REFERENCES MONTADOR (ID)
);
--Secuencia para auditoria
CREATE SEQUENCE SEQ_AUDITORIA_INVENTARIO START WITH 1;

--Tabla de Auditoria_Inventario
CREATE TABLE Auditoria_Inventario (
    ID_AUDITORIA NUMBER PRIMARY KEY,
    ID_PRODUCTO NUMBER NOT NULL,
    ANTERIOR_CANTIDAD NUMBER NOT NULL,
    ACTUAL_CANTIDAD NUMBER NOT NULL,
    OPERACION CHAR(1) NOT NULL, -- 'C' para compras, 'V' para ventas
    USUARIO NUMBER NOT NULL,
    FECHA TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PROCEDIMIENTO DE REGISTRAR VENTA: (ID_CLIENTE, COCINAS, C_COCINAS, MUEBLES, C_MUEBLES, ID_REPARTIDOR, MONTADOR, FECHA_ENTREGA)

-- Falta añadir COMPRA_COCINA
-- Realmente creo que no, por la regla de 1 dist para cada cocina
