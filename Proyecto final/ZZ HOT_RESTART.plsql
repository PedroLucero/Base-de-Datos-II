-- drop secuencias
DROP SEQUENCE SEQ_VENTA;
DROP SEQUENCE SEQ_MONTADOR;
DROP SEQUENCE SEQ_FABRICANTE;
DROP SEQUENCE SEQ_CLIENTE;
DROP SEQUENCE SEQ_USUARIO;
DROP SEQUENCE SEQ_REPARTIDOR;
DROP SEQUENCE SEQ_VEHICULO;
DROP SEQUENCE SEQ_PRODUCTO;
DROP SEQUENCE SEQ_COMPRA;

-- drop tablas
DROP TABLE AUDITORIA_INVENTARIO;
DROP TABLE ENTREGA;
DROP TABLE DETALLE_V_MUEBLES;
DROP TABLE DETALLE_V_COCINAS;
DROP TABLE VENTA;
DROP TABLE DETALLE_COMPRA;
DROP TABLE COMPRA;
DROP TABLE VehiculoRepartidor;
DROP TABLE CocinaMontador;
DROP TABLE MuebleEnCocina;
DROP TABLE Cocina;
DROP TABLE Mueble;
DROP TABLE TIPO_MUEBLE;
DROP TABLE Vehiculo;
DROP TABLE Repartidor;
DROP TABLE TelefonoFabricante;
DROP TABLE Fabricante;
DROP TABLE Cliente;
DROP TABLE USUARIO;
DROP TABLE Montador;

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
-- CREATE SEQUENCE SEQ_MUEBLE START WITH 1;
-- CREATE SEQUENCE SEQ_COCINA START WITH 1;

-- Todas las tablas
-- Paramétrica
create table Usuario(
	id number not null,
	nombre VARCHAR2(25),
	telefono VARCHAR2(15),
	direccion VARCHAR2(50),
	constraint usuario_pk primary key (id)
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
    constraint cliente_pk primary key (id)
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

CREATE OR REPLACE PROCEDURE INSERTAR_CLIENTE(
    p_NOMBRE CLIENTE.NOMBRE%TYPE,
    p_DIRECCION CLIENTE.DIRECCION%TYPE,
    p_TELEFONO TELEFONOFABRICANTE.TELEFONO%TYPE
) IS 
BEGIN
    INSERT INTO CLIENTE(ID, NOMBRE, DIRECCION, TELEFONO)
    VALUES(SEQ_CLIENTE.NEXTVAL, p_NOMBRE, p_DIRECCION, p_TELEFONO);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este cliente ya existe');
END;
/

-- Prueba
BEGIN
    INSERTAR_CLIENTE('Paolo Linares', 'Carlos Santana Ávila, distrito de Santiago', '6000-0002');
    INSERTAR_CLIENTE('Irene Alfredo', 'Llano Bonito, distrito de Chitré', '6008-0497');
    INSERTAR_CLIENTE('Fe Begoña', 'Los Pozos, distrito de Los Pozos', '6039-0539');
    INSERTAR_CLIENTE('Elías Romualdo', 'Purio, distrito de Pedasí', '6050-0246');
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_FABRICANTE(
    p_NOMBRE FABRICANTE.NOMBRE%TYPE,
    p_DIRECCION FABRICANTE.DIRECCION%TYPE,
    p_TELEFONO TELEFONOFABRICANTE.TELEFONO%TYPE,
    p_FECHA FABRICANTE.FECHA%TYPE
) IS 
BEGIN
    INSERT INTO FABRICANTE(ID, NOMBRE, DIRECCION, FECHA)
    VALUES(SEQ_FABRICANTE.NEXTVAL, p_NOMBRE, p_DIRECCION, p_FECHA);

    INSERT INTO TELEFONOFABRICANTE(ID_FABRICANTE, TELEFONO)
    VALUES(SEQ_FABRICANTE.CURRVAL, p_TELEFONO);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este fabricante ya existe');
END;
/

-- Prueba
BEGIN
    INSERTAR_FABRICANTE('Constructor Hermanos', 'Boca Chica, distrito de San Lorenzo', '6123-4567', sysdate);
    INSERTAR_FABRICANTE('Iván Ignacio', 'La Arena, distrito de Los Pozos', '2020-4-13', sysdate);
    INSERTAR_FABRICANTE('Rolando Gregoria', 'La Raya de Santa María, distrito de Santiago', '2023-9-16', sysdate);
    INSERTAR_FABRICANTE('Mayte Úrsula', 'Gobea, distrito de Donoso', '2023-1-22', sysdate);
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_MONTADOR(
    p_NOMBRE MONTADOR.NOMBRE%TYPE,
    p_DIRECCION MONTADOR.DIRECCION%TYPE,
    p_TELEFONO MONTADOR.TELEFONO%TYPE,
    p_NUM_COCINA MONTADOR.NUM_COCINA%TYPE
) IS 
BEGIN
    INSERT INTO MONTADOR(ID, NOMBRE, DIRECCION, TELEFONO, NUM_COCINA)
    VALUES(SEQ_MONTADOR.NEXTVAL, p_NOMBRE, p_DIRECCION, p_TELEFONO, p_NUM_COCINA);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este montador ya existe');
END;
/

-- Prueba
BEGIN
    INSERTAR_MONTADOR('José Hernández', 'El Tecal', '6987-2323', 10);
    INSERTAR_MONTADOR('Eloy Bárbara', 'Mogollón, distrito de Macaracas', '6038-0339', 27);
    INSERTAR_MONTADOR('Carmina Cruz', 'Llano Grande, distrito de La Pintada', '6051-0332', 6);
    INSERTAR_MONTADOR('Juan Clementina', 'David Este, distrito de David', '6029-0221', 17);
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_REPARTIDOR(
    p_NOMBRE REPARTIDOR.NOMBRE%TYPE,
    p_CORREO REPARTIDOR.CORREO%TYPE,
    p_TELEFONO TELEFONOFABRICANTE.TELEFONO%TYPE
) IS 
BEGIN
    INSERT INTO REPARTIDOR(ID, NOMBRE, CORREO, TELEFONO)
    VALUES(SEQ_REPARTIDOR.NEXTVAL, p_NOMBRE, p_CORREO, p_TELEFONO);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este repartidor ya existe');
END;
/

-- Prueba
BEGIN
    INSERTAR_REPARTIDOR('Inocencio Ana', 'InocencioAna@sharklasers.com', '6008-0303');
    INSERTAR_REPARTIDOR('Sebastián Cleto', 'SebastianCleto@yahoo.com', '6022-0074');
    INSERTAR_REPARTIDOR('Amaro Valente', 'AmaroValente@hotmail.com', '6067-0727');
    INSERTAR_REPARTIDOR('Fabio Sandra', 'FabioSandra@hotmail.com', '6052-0152');
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_USUARIO(
    p_NOMBRE CLIENTE.NOMBRE%TYPE,
    p_DIRECCION CLIENTE.DIRECCION%TYPE,
    p_TELEFONO TELEFONOFABRICANTE.TELEFONO%TYPE
) IS 
BEGIN
    INSERT INTO USUARIO(ID, NOMBRE, TELEFONO, DIRECCION)
    VALUES(SEQ_USUARIO.NEXTVAL, p_NOMBRE, p_TELEFONO, p_DIRECCION);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este usuario ya existe');
END;
/

-- Prueba
BEGIN
    INSERTAR_USUARIO('Jonatan Modesto', 'Tijeras, distrito de Boquerón', '6010-0193');
    INSERTAR_USUARIO('Reyna Carmelita', 'Bajo Boquete, distrito de Boquete', '6031-0678');
    INSERTAR_USUARIO('Ainara Olegario', 'La Garceana, distrito de Montijo', '6006-0350');
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_VEHICULO(
    p_PLACA VEHICULO.PLACA%TYPE,
    p_ANHO VEHICULO.ANHO%TYPE,
    p_TIPO VEHICULO.TIPO%TYPE,
    p_CAPACIDAD VEHICULO.CAPACIDAD%TYPE,
    p_MODELO VEHICULO.MODELO%TYPE,
    p_MARCA VEHICULO.MARCA%TYPE
) IS 
BEGIN
    INSERT INTO VEHICULO(ID, PLACA, ANHO, TIPO, CAPACIDAD, MODELO, MARCA)
    VALUES(SEQ_VEHICULO.NEXTVAL,
        p_PLACA, p_ANHO, p_TIPO, p_CAPACIDAD, p_MODELO, p_MARCA);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este vehiculo ya existe');
END;
/

-- Prueba
BEGIN
    INSERTAR_VEHICULO('74LD0N1', '2011', 'Sedán', '5', 'Corolla','Toyota');
    INSERTAR_VEHICULO('54481X3', '2019', 'SUV', '5', 'Q3','Audi');
    INSERTAR_VEHICULO('8436183', '2020', 'SUV', '7', 'Caddy','Volkswagen');
    INSERTAR_VEHICULO('83Y0393', '2003', 'Sedán', '5', 'A4','Audi');
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_MUEBLE_ALTO(
    p_CANTIDAD MUEBLE.CANTIDAD%TYPE,
    p_COLOR MUEBLE.COLOR%TYPE,
    p_LINEA MUEBLE.LINEA%TYPE,
    p_ANCHO MUEBLE.ANCHO%TYPE,
    p_ALTO MUEBLE.ALTO%TYPE,
    p_PRECIO MUEBLE.PRECIO%TYPE,
    p_FECHA MUEBLE.FECHA_COMPRA%TYPE,
    p_ALTURA MUEBLE.ALTURA%TYPE,
    p_PESO MUEBLE.C_peso%TYPE,
    p_DIVISIONES MUEBLE.DIVISIONES%TYPE,
    p_FABRICANTE MUEBLE.ID_FABRICANTE%TYPE
) IS
TIPO MUEBLE.TIPO_MUEBLE%TYPE := 1;
BEGIN
    INSERT INTO MUEBLE(ID, CANTIDAD, COLOR, LINEA, ANCHO, ALTO, PRECIO, FECHA_COMPRA, TIPO_MUEBLE,
                        ALTURA, C_PESO, DIVISIONES,
                        ALTURA_SUELO, NUM_DIVISIONES,
                        MATERIAL, T_COMPONENTE,
                        MAT_ENC, ID_FABRICANTE)
    VALUES(SEQ_PRODUCTO.NEXTVAL, p_CANTIDAD, p_COLOR, p_LINEA, p_ANCHO, p_ALTO, p_PRECIO, p_FECHA, TIPO,
            p_ALTURA, p_PESO, p_DIVISIONES,
            NULL, NULL,
            NULL, NULL,
            NULL, p_FABRICANTE);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este mueble alto ya existe');
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_MUEBLE_BAJO(
    p_CANTIDAD MUEBLE.CANTIDAD%TYPE,
    p_COLOR MUEBLE.COLOR%TYPE,
    p_LINEA MUEBLE.LINEA%TYPE,
    p_ANCHO MUEBLE.ANCHO%TYPE,
    p_ALTO MUEBLE.ALTO%TYPE,
    p_PRECIO MUEBLE.PRECIO%TYPE,
    p_FECHA MUEBLE.FECHA_COMPRA%TYPE,
    p_ALTURA_SUELO MUEBLE.ALTURA_SUELO%TYPE,
    p_NUM_DIV MUEBLE.NUM_DIVISIONES%TYPE,
    p_FABRICANTE MUEBLE.ID_FABRICANTE%TYPE
) IS
TIPO MUEBLE.TIPO_MUEBLE%TYPE := 2;
BEGIN
    INSERT INTO MUEBLE(ID, CANTIDAD, COLOR, LINEA, ANCHO, ALTO, PRECIO, FECHA_COMPRA, TIPO_MUEBLE,
                        ALTURA, C_PESO, DIVISIONES,
                        ALTURA_SUELO, NUM_DIVISIONES,
                        MATERIAL, T_COMPONENTE,
                        MAT_ENC, ID_FABRICANTE)
    VALUES(SEQ_PRODUCTO.NEXTVAL, p_CANTIDAD, p_COLOR, p_LINEA, p_ANCHO, p_ALTO, p_PRECIO, p_FECHA, TIPO,
            NULL, NULL, NULL,
            p_ALTURA_SUELO, p_NUM_DIV,
            NULL, NULL,
            NULL, p_FABRICANTE);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este mueble bajo ya existe');
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_MUEBLE_PANEL(
    p_CANTIDAD MUEBLE.CANTIDAD%TYPE,
    p_COLOR MUEBLE.COLOR%TYPE,
    p_LINEA MUEBLE.LINEA%TYPE,
    p_ANCHO MUEBLE.ANCHO%TYPE,
    p_ALTO MUEBLE.ALTO%TYPE,
    p_PRECIO MUEBLE.PRECIO%TYPE,
    p_FECHA MUEBLE.FECHA_COMPRA%TYPE,
    p_MATERIAL MUEBLE.MATERIAL%TYPE, 
    p_TIP_COMP MUEBLE.T_COMPONENTE%TYPE,
    p_FABRICANTE MUEBLE.ID_FABRICANTE%TYPE
) IS
TIPO MUEBLE.TIPO_MUEBLE%TYPE := 3;
BEGIN
    INSERT INTO MUEBLE(ID, CANTIDAD, COLOR, LINEA, ANCHO, ALTO, PRECIO, FECHA_COMPRA, TIPO_MUEBLE,
                        ALTURA, C_PESO, DIVISIONES,
                        ALTURA_SUELO, NUM_DIVISIONES,
                        MATERIAL, T_COMPONENTE,
                        MAT_ENC, ID_FABRICANTE)
    VALUES(SEQ_PRODUCTO.NEXTVAL, p_CANTIDAD, p_COLOR, p_LINEA, p_ANCHO, p_ALTO, p_PRECIO, p_FECHA, TIPO,
            NULL, NULL, NULL,
            NULL, NULL,
            p_MATERIAL, p_TIP_COMP,
            NULL, p_FABRICANTE);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este panel ya existe');
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_MUEBLE_ENCIMERA(
    p_CANTIDAD MUEBLE.CANTIDAD%TYPE,
    p_COLOR MUEBLE.COLOR%TYPE,
    p_LINEA MUEBLE.LINEA%TYPE,
    p_ANCHO MUEBLE.ANCHO%TYPE,
    p_ALTO MUEBLE.ALTO%TYPE,
    p_PRECIO MUEBLE.PRECIO%TYPE,
    p_FECHA MUEBLE.FECHA_COMPRA%TYPE,
    p_MATERIAL MUEBLE.MAT_ENC%TYPE,
    p_FABRICANTE MUEBLE.ID_FABRICANTE%TYPE
) IS
TIPO MUEBLE.TIPO_MUEBLE%TYPE := 4;
BEGIN
    INSERT INTO MUEBLE(ID, CANTIDAD, COLOR, LINEA, ANCHO, ALTO, PRECIO, FECHA_COMPRA, TIPO_MUEBLE,
                        ALTURA, C_PESO, DIVISIONES,
                        ALTURA_SUELO, NUM_DIVISIONES,
                        MATERIAL, T_COMPONENTE,
                        MAT_ENC, ID_FABRICANTE)
    VALUES(SEQ_PRODUCTO.NEXTVAL, p_CANTIDAD, p_COLOR, p_LINEA, p_ANCHO, p_ALTO, p_PRECIO, p_FECHA, TIPO,
            NULL, NULL, NULL,
            NULL, NULL,
            NULL, NULL,p_MATERIAL, p_FABRICANTE);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Esta encimera ya existe');
END;
/

BEGIN
    -- Estos 4 inserts por si no están todavía
    INSERT INTO TIPO_MUEBLE VALUES(1, 'Mueble Alto');
    INSERT INTO TIPO_MUEBLE VALUES(2, 'Mueble Bajo');
    INSERT INTO TIPO_MUEBLE VALUES(3, 'Panel');
    INSERT INTO TIPO_MUEBLE VALUES(4, 'Encimera');
END;
/

-- Prueba
BEGIN
    -- También se requiere tener fabricantes
    INSERTAR_MUEBLE_ALTO(10, 'negro', 'Lorem', 30.1, 16.9, 100, SYSDATE, 16.9, 259, 7, 1);
    INSERTAR_MUEBLE_BAJO(9, 'negro', 'Lorem', 21.0, 29.4, 100, SYSDATE, 9, 4, 2);
    INSERTAR_MUEBLE_PANEL(8, 'verde', 'Sicilia', 16.4, 30.1, 100, SYSDATE, 'vidrio', 13.5, 3);
    INSERTAR_MUEBLE_ENCIMERA(7, 'gris', 'Aqua', 30.4, 14.3, 100, SYSDATE, 'A', 4);
    INSERTAR_MUEBLE_ENCIMERA(6, 'blanco', 'Shallot', 20.4, 11.3, 100, SYSDATE, 'M', 1);
END;
/

CREATE OR REPLACE PROCEDURE INSERTAR_COCINA(
    p_NUMSERIE COCINA.NUMSERIE%TYPE,
    p_INSTOCK COCINA.INSTOCK%TYPE,
    p_NOMBRE COCINA.NOMBRE%TYPE,
    p_PRECIO COCINA.PRECIO%TYPE,
    p_MUEBLES SYS.ODCINUMBERLIST,
    p_CANTIDADES SYS.ODCINUMBERLIST
) IS 
TEMP_ID NUMBER;
BEGIN
    IF p_MUEBLES.COUNT != p_CANTIDADES.COUNT THEN -- revision de buenos arreglos para inserts
        RAISE_APPLICATION_ERROR(-20001, 'Los muebles y sus cantidades no concuerdan');
    END IF;
    INSERT INTO COCINA(ID, NUMSERIE, INSTOCK, NOMBRE, PRECIO, NUMMUEBLES)
    VALUES(SEQ_PRODUCTO.NEXTVAL, p_NUMSERIE, p_INSTOCK, p_NOMBRE, p_PRECIO, 0);

    FOR i IN 1..p_MUEBLES.COUNT LOOP -- loopeamos para insertar todo lo comprado
        INSERT INTO MUEBLEENCOCINA(ID_MUEBLE, ID_COCINA, CANTIDAD)
        VALUES (p_MUEBLES(i), SEQ_PRODUCTO.CURRVAL, p_CANTIDADES(i));

        TEMP_ID := SEQ_PRODUCTO.CURRVAL;
        UPDATE COCINA -- añadimos la cantidad de muebles apropiadamente
        SET NUMMUEBLES = NUMMUEBLES + p_CANTIDADES(i)
        WHERE ID = TEMP_ID;
    END LOOP;

    COMMIT;
EXCEPTION
-- añadir excp cuando mueble no existe
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Hubo un error al crear la cocina');
END;
/

-- Prueba
DECLARE
    v_NUMSERIE COCINA.NUMSERIE%TYPE;
    v_INSTOCK COCINA.INSTOCK%TYPE;
    v_NOMBRE COCINA.NOMBRE%TYPE;
    v_PRECIO COCINA.PRECIO%TYPE;
    v_MUEBLES SYS.ODCINUMBERLIST;
    v_CANTIDADES SYS.ODCINUMBERLIST;
BEGIN
    v_NUMSERIE := 10101;
    v_INSTOCK := 10;
    v_NOMBRE := 'Dorcy';
    v_PRECIO := 1200;
    v_MUEBLES := SYS.ODCINUMBERLIST(2, 3, 4);
    v_CANTIDADES := SYS.ODCINUMBERLIST(1, 2, 1);
    
    INSERTAR_COCINA(v_NUMSERIE, v_INSTOCK, v_NOMBRE, v_PRECIO, v_MUEBLES, v_CANTIDADES);

    v_NUMSERIE := 20202;
    v_INSTOCK := 20;
    v_NOMBRE := 'Lauretta';
    v_PRECIO := 1250;
    v_MUEBLES := SYS.ODCINUMBERLIST(1, 5);
    v_CANTIDADES := SYS.ODCINUMBERLIST(5, 1);
    
    INSERTAR_COCINA(v_NUMSERIE, v_INSTOCK, v_NOMBRE, v_PRECIO, v_MUEBLES, v_CANTIDADES);
END;
/

CREATE OR REPLACE TRIGGER actualizar_inv_compra_mueble
AFTER INSERT OR UPDATE ON DETALLE_COMPRA
FOR EACH ROW
DECLARE
    v_anterior_cantidad NUMBER;
    v_actual_cantidad NUMBER;
    v_usuario NUMBER;
BEGIN
    --Usuario de la Transaccion
    SELECT ID_USUARIO INTO v_usuario
    FROM  Compra
    WHERE ID_COMPRA = :NEW.ID_COMPRA;
    
    -- Obtener la cantidad actual del inventario antes de la actualización
    SELECT cantidad INTO v_anterior_cantidad FROM Mueble WHERE id = :NEW.id_mueble;
    
    UPDATE Mueble
    SET CANTIDAD = CANTIDAD + :NEW.CANTIDAD
    WHERE ID = :NEW.ID_MUEBLE;
    
    -- Cantidad nueva del inventario depues de la actualizcion
    SELECT cantidad INTO v_actual_cantidad FROM Mueble WHERE id = :NEW.id_mueble;

    INSERT INTO Auditoria_Inventario (ID_AUDITORIA, ID_PRODUCTO, ANTERIOR_CANTIDAD, ACTUAL_CANTIDAD, OPERACION, USUARIO)
    VALUES (SEQ_AUDITORIA_INVENTARIO.NEXTVAL, :NEW.id_mueble, v_anterior_cantidad, v_actual_cantidad, 'C', v_usuario);
END;
/
ALTER TABLE DETALLE_COMPRA ENABLE ALL TRIGGERS;

CREATE OR REPLACE TRIGGER actualizar_inv_venta_mueble
AFTER INSERT OR UPDATE ON DETALLE_V_MUEBLES
FOR EACH ROW
DECLARE
    v_precio NUMBER;
    v_subtotal NUMBER;
    v_anterior_cantidad NUMBER;
    v_actual_cantidad NUMBER;
    v_usuario NUMBER;
BEGIN
    --Usuario de la Transaccion
    SELECT ID_USUARIO INTO v_usuario
    FROM VENTA
    WHERE num_factura = :NEW.num_factura;

    --Cantidad antes de insertar de la tabla mueble
    SELECT cantidad INTO v_anterior_cantidad FROM Mueble WHERE id = :NEW.id_mueble;

    UPDATE Mueble
    SET CANTIDAD = CANTIDAD - :NEW.CANTIDAD
    WHERE ID = :NEW.ID_MUEBLE;
    
    --Cantidad después de insertar en la tabla mueble
    SELECT cantidad INTO v_actual_cantidad FROM Mueble WHERE id = :NEW.id_mueble;

    -- Insertar un registro en la tabla de auditoría
    INSERT INTO Auditoria_Inventario (ID_AUDITORIA, ID_PRODUCTO, ANTERIOR_CANTIDAD, ACTUAL_CANTIDAD, OPERACION, USUARIO)
    VALUES (SEQ_AUDITORIA_INVENTARIO.NEXTVAL, :NEW.id_mueble, v_anterior_cantidad, v_actual_cantidad, 'V', v_usuario);

    --Ahora calculamos el subtotal de lo que hay que pagar en la venta de muebles
    SELECT precio
    INTO v_precio
    FROM Mueble
    WHERE ID = :NEW.ID_MUEBLE;

    v_subtotal := v_precio * :NEW.CANTIDAD;
    --Una vez calculado entonces le hacemos UPDATE a la venta
    UPDATE VENTA
    SET SUBTOTAL = SUBTOTAL + v_subtotal, IMPUESTO = IMPUESTO + (v_subtotal * 0.07), TOTAL = TOTAL + v_subtotal * 1.07
    WHERE NUM_FACTURA = :NEW.NUM_FACTURA;
    

END;
/
ALTER TABLE DETALLE_V_MUEBLES ENABLE ALL TRIGGERS;



CREATE OR REPLACE TRIGGER actualizar_inv_venta_cocina
AFTER INSERT OR UPDATE ON DETALLE_V_COCINAS
FOR EACH ROW
DECLARE
    v_precio NUMBER;
    v_subtotal NUMBER;
    v_anterior_cantidad NUMBER;
    v_actual_cantidad NUMBER;
    v_usuario NUMBER;
BEGIN
    --Usuario de la Transaccion
    SELECT ID_USUARIO INTO v_usuario
    FROM VENTA
    WHERE num_factura = :NEW.num_factura;
    --Cantidad antes de insertar de la tabla cocina
    SELECT inStock INTO v_anterior_cantidad FROM Cocina WHERE id = :NEW.id_cocina;

    UPDATE COCINA
    SET INSTOCK = INSTOCK - :NEW.CANTIDAD
    WHERE ID = :NEW.ID_COCINA;
    --Cantidad despues de insertar de la tabla cocina
    SELECT inStock INTO v_actual_cantidad FROM Cocina WHERE id = :NEW.id_cocina;
    
    -- Insertar un registro en la tabla de auditoría
    INSERT INTO Auditoria_Inventario (ID_AUDITORIA, ID_PRODUCTO, ANTERIOR_CANTIDAD, ACTUAL_CANTIDAD, OPERACION, USUARIO)
    VALUES (SEQ_AUDITORIA_INVENTARIO.NEXTVAL, :NEW.id_cocina, v_anterior_cantidad, v_actual_cantidad, 'V', v_usuario);
    
    --Ahora calculamos el subtotal de lo que hay que pagar en la venta de muebles
    SELECT precio
    INTO v_precio
    FROM COCINA
    WHERE ID = :NEW.ID_COCINA;

    v_subtotal:= v_precio * :NEW.CANTIDAD;
    --Una vez calculado entonces le hacemos UPDATE a la venta
    UPDATE VENTA
    SET SUBTOTAL = SUBTOTAL + v_subtotal, IMPUESTO = IMPUESTO + (v_subtotal * 0.07), TOTAL = TOTAL + v_subtotal * 1.07
    WHERE NUM_FACTURA = :NEW.NUM_FACTURA;
END;
/
ALTER TABLE DETALLE_V_COCINAS ENABLE ALL TRIGGERS;

CREATE OR REPLACE PROCEDURE COMPRAR_MUEBLE(
    p_USUARIO USUARIO.ID%TYPE,
    p_FACTURA_F COMPRA.FACTURA_FABRICANTE%TYPE,
    p_FABRICANTE COMPRA.ID_FABRICANTE%TYPE,
    p_MONTO COMPRA.MONTO%TYPE,
    p_MUEBLES SYS.ODCINUMBERLIST,  
    p_CANTIDADES SYS.ODCINUMBERLIST
) IS 
BEGIN
    IF p_MUEBLES.COUNT != p_CANTIDADES.COUNT THEN -- revision de buenos arreglos para inserts
        RAISE_APPLICATION_ERROR(-20001, 'Los muebles y sus cantidades no concuerdan');
    END IF;
    INSERT INTO COMPRA(ID_COMPRA, ID_USUARIO, FACTURA_FABRICANTE, ID_FABRICANTE, MONTO, FECHA)
    VALUES(SEQ_COMPRA.NEXTVAL, p_USUARIO, p_FACTURA_F, p_FABRICANTE, p_MONTO, SYSDATE);

    FOR i IN 1..p_MUEBLES.COUNT LOOP -- loopeamos para insertar todo lo comprado
        INSERT INTO DETALLE_COMPRA(ID_COMPRA, ID_MUEBLE, CANTIDAD)
        VALUES (SEQ_COMPRA.CURRVAL, p_MUEBLES(i), p_CANTIDADES(i));
    END LOOP;

    COMMIT;
EXCEPTION
-- añadir excp de fk cuando fabricante no existe
-- añadir excp cuando mueble no existe
-- maybe algo de que el id de mueble no es de ese fabricante?
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este compra ya se realizó');
END;
/

-- Prueba
DECLARE
    v_USUARIO USUARIO.ID%TYPE;
    v_FACTURA_FABRICANTE COMPRA.FACTURA_FABRICANTE%TYPE;
    v_FABRICANTE COMPRA.ID_FABRICANTE%TYPE;
    v_MONTO COMPRA.MONTO%TYPE;
    v_MUEBLES SYS.ODCINUMBERLIST;
    v_CANTIDADES SYS.ODCINUMBERLIST;
BEGIN
    v_USUARIO := 2;
    v_FACTURA_FABRICANTE := 10001;
    v_FABRICANTE := 1;
    v_MONTO := 700;
    v_MUEBLES := SYS.ODCINUMBERLIST(1, 5);
    v_CANTIDADES := SYS.ODCINUMBERLIST(12, 5);
    
    COMPRAR_MUEBLE(v_USUARIO, v_FACTURA_FABRICANTE, v_FABRICANTE, v_MONTO, v_MUEBLES, v_CANTIDADES);
END;
/

-- (ID_CLIENTE, COCINAS, C_COCINAS, MUEBLES, C_MUEBLES, ID_REPARTIDOR, MONTADOR, FECHA_ENTREGA)
CREATE OR REPLACE PROCEDURE REGISTRAR_VENTA(
    p_ID_CLIENTE VENTA.ID_CLIENTE%TYPE,
    p_ID_USUARIO VENTA.ID_USUARIO%TYPE,
    p_COCINAS SYS.ODCINUMBERLIST,
    p_C_COCINAS SYS.ODCINUMBERLIST,
    p_MUEBLES SYS.ODCINUMBERLIST,
    p_C_MUEBLES SYS.ODCINUMBERLIST,
    p_ID_REPARTIDOR REPARTIDOR.ID%TYPE,
    p_ID_MONTADOR MONTADOR.ID%TYPE,
    p_FECHA_ENTREGA ENTREGA.FECHA_ASIGNADA%TYPE
) IS
BEGIN
    -- revisiones para arreglos válidos
    IF p_MUEBLES.COUNT != p_C_MUEBLES.COUNT THEN
        RAISE_APPLICATION_ERROR(-20001, 'Los muebles y sus cantidades no concuerdan');
    END IF;
    IF p_COCINAS.COUNT != p_C_COCINAS.COUNT THEN
        RAISE_APPLICATION_ERROR(-20002, 'Las cocinas y sus cantidades no concuerdan');
    END IF;

    -- paso 1: inicializar venta
    INSERT INTO VENTA(NUM_FACTURA, SUBTOTAL, IMPUESTO, TOTAL, ID_CLIENTE, ID_USUARIO, FECHA_VENTA)
    VALUES(SEQ_VENTA.NEXTVAL, 0, 0, 0, p_ID_CLIENTE, p_ID_USUARIO, SYSDATE);

    -- paso 2: loop de cocina insertando
    FOR i IN 1..p_COCINAS.COUNT LOOP
        INSERT INTO DETALLE_V_COCINAS(NUM_FACTURA, ID_COCINA, CANTIDAD)
        VALUES (SEQ_VENTA.CURRVAL, p_COCINAS(i), p_C_COCINAS(i));
    END LOOP;

    -- paso 3: loop de mueble insertando
    FOR i IN 1..p_MUEBLES.COUNT LOOP
        INSERT INTO DETALLE_V_MUEBLES(NUM_FACTURA, ID_MUEBLE, CANTIDAD)
        VALUES (SEQ_VENTA.CURRVAL, p_MUEBLES(i), p_C_MUEBLES(i));
    END LOOP;

    -- paso 4: 
    INSERT INTO ENTREGA(NUM_FACTURA, ID_REPARTIDOR, ID_MONTADOR, FECHA_ASIGNADA)
    VALUES(SEQ_VENTA.CURRVAL, p_ID_REPARTIDOR, p_ID_MONTADOR, p_FECHA_ENTREGA);

    COMMIT;
EXCEPTION
-- añadir excp de fk cuando fabricante no existe
-- añadir excp cuando mueble no existe
-- maybe algo de que el id de mueble no es de ese fabricante?
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('HUBO FALLOS'); --corregir

    -- WHEN OTHERS THEN
        -- ROLLBACK;
END;
/

-- Prueba
DECLARE
    V_ID_CLIENTE VENTA.ID_CLIENTE%TYPE;
    V_ID_USUARIO VENTA.ID_USUARIO%TYPE;
    V_COCINAS SYS.ODCINUMBERLIST;
    V_C_COCINAS SYS.ODCINUMBERLIST;
    V_MUEBLES SYS.ODCINUMBERLIST;
    V_C_MUEBLES SYS.ODCINUMBERLIST;
    V_ID_REPARTIDOR REPARTIDOR.ID%TYPE;
    V_ID_MONTADOR MONTADOR.ID%TYPE;
    V_FECHA_ENTREGA ENTREGA.FECHA_ASIGNADA%TYPE;
BEGIN
    V_ID_CLIENTE := 3; -- fe begoña
    V_ID_USUARIO := 1; -- jonatan modesto
    V_COCINAS := SYS.ODCINUMBERLIST(); -- arreglo
    V_C_COCINAS := SYS.ODCINUMBERLIST(); -- arreglo
    V_MUEBLES := SYS.ODCINUMBERLIST(1, 5); -- arreglo
    V_C_MUEBLES := SYS.ODCINUMBERLIST(2, 2); -- arreglo
    V_ID_REPARTIDOR := 2; -- sebastián cleto
    V_ID_MONTADOR := 1; -- josé hernández
    V_FECHA_ENTREGA := sysdate + 2;
    
    REGISTRAR_VENTA(V_ID_CLIENTE, V_ID_USUARIO, V_COCINAS, V_C_COCINAS, V_MUEBLES, V_C_MUEBLES,
                    V_ID_REPARTIDOR, V_ID_MONTADOR, V_FECHA_ENTREGA);

    V_ID_CLIENTE := 2;
    V_ID_USUARIO := 2;
    V_COCINAS := SYS.ODCINUMBERLIST(6);
    V_C_COCINAS := SYS.ODCINUMBERLIST(2);
    V_MUEBLES := SYS.ODCINUMBERLIST();
    V_C_MUEBLES := SYS.ODCINUMBERLIST();
    V_ID_REPARTIDOR := 1;
    V_ID_MONTADOR := 2;
    V_FECHA_ENTREGA := sysdate + 2;
    
    REGISTRAR_VENTA(V_ID_CLIENTE, V_ID_USUARIO, V_COCINAS, V_C_COCINAS, V_MUEBLES, V_C_MUEBLES,
                    V_ID_REPARTIDOR, V_ID_MONTADOR, V_FECHA_ENTREGA);

    V_ID_CLIENTE := 1;
    V_ID_USUARIO := 3;
    V_COCINAS := SYS.ODCINUMBERLIST(6);
    V_C_COCINAS := SYS.ODCINUMBERLIST(2);
    V_MUEBLES := SYS.ODCINUMBERLIST(1);
    V_C_MUEBLES := SYS.ODCINUMBERLIST(3);
    V_ID_REPARTIDOR := 2;
    V_ID_MONTADOR := 3;
    V_FECHA_ENTREGA := sysdate + 2;
    
    REGISTRAR_VENTA(V_ID_CLIENTE, V_ID_USUARIO, V_COCINAS, V_C_COCINAS, V_MUEBLES, V_C_MUEBLES,
                    V_ID_REPARTIDOR, V_ID_MONTADOR, V_FECHA_ENTREGA);
END;
/

-- vista de compras
CREATE OR REPLACE VIEW Vista_Compras AS
SELECT 
    c.id_compra AS ID_Compra,
    f.nombre AS Nombre_Fabricante,
    c.factura_fabricante AS Factura_Fabricante,
    c.fecha AS Fecha_Transaccion,
    u.nombre AS Nombre_Usuario,
    m.id AS ID_Mueble,
    m.color AS Color,
    m.linea AS Linea,
    m.ancho AS Ancho,
    m.alto AS Alto,
    m.precio AS Precio,
    dc.cantidad AS Cantidad_Comprada,
    (m.precio * dc.cantidad) AS Total_Compra
FROM 
    compra c
JOIN 
    fabricante f ON c.id_fabricante = f.id
JOIN 
    usuario u ON c.id_usuario = u.id
JOIN 
    detalle_compra dc ON c.id_compra = dc.id_compra
JOIN 
    mueble m ON dc.id_mueble = m.id
ORDER BY 
    f.nombre, c.fecha;

-- vista de clientes
CREATE OR REPLACE VIEW ventas_clientes AS
SELECT 
    v.num_factura,
    v.SUBTOTAL,
    v.IMPUESTO,
    v.TOTAL,
    v.fecha_VENTA,
    c.nombre AS Cliente,
    c.direccion AS Direccion,
    c.telefono AS Telefono
FROM
    VENTA v 
JOIN Cliente c ON v.id_cliente = c.id;

-- vista de inventario 
CREATE OR REPLACE VIEW vista_inventario AS
SELECT
    m.id,
    m.tipo_mueble,
    T.NOMBRE,
    m.precio,
    f.id AS ID_Fabricante,
    f.nombre AS Fabricante,
    f.direccion AS Direccion
FROM 
    MUEBLE m
JOIN Fabricante f ON M.ID_fabricante = f.id JOIN TIPO_MUEBLE T ON M.TIPO_MUEBLE = T.ID_TIPO;