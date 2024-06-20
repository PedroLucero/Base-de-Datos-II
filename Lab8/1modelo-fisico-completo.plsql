/* BASE DE DATOS COMPLETO*/

--CREACION DE SECUENCIAS
CREATE SEQUENCE SEQ_CLIENTE START WITH 1;

CREATE SEQUENCE SEQ_EMAIL START WITH 1;

CREATE SEQUENCE SEQ_TELEFONO START WITH 1;

CREATE SEQUENCE SEQ_PRESTAMO START WITH 1;

CREATE SEQUENCE SEQ_TRANSACCION START WITH 1;

CREATE SEQUENCE SEQ_USUARIO START WITH 1;

CREATE SEQUENCE SEQ_AUDITORIAS START WITH 1;

-- 1 CREACION DE LA TABLA SUCURSAL
	CREATE TABLE SUCURSAL(
    COD_SUCURSAL NUMBER,
    NOMBRESUCURSAL VARCHAR2(50) NOT NULL,
    MONTOPRESTAMOS NUMBER NOT NULL,
    CONSTRAINT PK_SUCURSAL PRIMARY KEY (COD_SUCURSAL));
	
-- 2 CREACION DE LA TABLA PROFESION_CLIENTE
	CREATE TABLE PROFESION_CLIENTE(
    ID_PROFESION NUMBER NOT NULL,
    PROFESION VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_PROFESION_CLIENTE PRIMARY KEY (ID_PROFESION));
	
-- 3 CREACION DE LA TABLA USUARIO
	CREATE TABLE USUARIO (
    ID_USUARIO NUMBER,
    CEDULA_USUARIO VARCHAR2(20) NOT NULL UNIQUE,
    NOMBRE_USUARIO VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_USUARIO PRIMARY KEY (ID_USUARIO));
	
-- 4 CREACION DE LA TABLA CLIENTE 
	CREATE TABLE CLIENTE (
    ID_CLIENTE NUMBER PRIMARY KEY,
    CEDULA VARCHAR2(20) NOT NULL UNIQUE,
    NOMBRE VARCHAR2(50) NOT NULL,
    APELLIDO VARCHAR2(50) NOT NULL,
    SEXO CHAR(1) NOT NULL,
    FECHA_NACIMIENTO DATE NOT NULL,
    ID_PROFESION NUMBER NOT NULL,
	EDAD NUMBER NOT NULL,
	COD_SUCURSAL NUMBER  NOT NULL,
	CONSTRAINT CLIENTE_FK_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES SUCURSAL(COD_SUCURSAL),
    CONSTRAINT FK_CLIENTE_ID_PROFESION FOREIGN KEY (ID_PROFESION) REFERENCES PROFESION_CLIENTE(ID_PROFESION));

-- 5 CREACION DE LA TABLA TIPO_EMAIL
	CREATE TABLE TIPO_EMAIL(
    ID_TIPO_EMAIL NUMBER NOT NULL,
    DESCRIPCION_EMAIL VARCHAR2(25) NOT NULL,
    CONSTRAINT PK_TIPO_EMAIL PRIMARY KEY(ID_TIPO_EMAIL)
);

-- 6 CREACION DE LA TABLA EMAIL_CLIENTES
	CREATE TABLE EMAIL_CLIENTES (
    ID_TIPO_EMAIL NUMBER NOT NULL,
    ID_CLIENTE NUMBER NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_EMAIL PRIMARY KEY (ID_TIPO_EMAIL, ID_CLIENTE),
    CONSTRAINT FK_EMAIL_CLIENTES_TIPO_EMAIL FOREIGN KEY (ID_TIPO_EMAIL) REFERENCES TIPO_EMAIL(ID_TIPO_EMAIL),
    CONSTRAINT FK_EMAIL_CLIENTE_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE)
);

-- 7 CREACION DE LA TABLA TIPO_TELEFONO
CREATE TABLE TIPO_TELEFONO(
    ID_TIPO_TELEFONO NUMBER NOT NULL,
    DESCRIPCION_TELEFONO VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_TIPO_TELEFONO PRIMARY KEY(ID_TIPO_TELEFONO)
);

-- 8 CREACION DE LA TABLA TELEFONO_CLIENTE
	CREATE TABLE TELEFONO_CLIENTE (
    ID_CLIENTE NUMBER NOT NULL,
    ID_TIPO_TELEFONO NUMBER NOT NULL,
    NUM_TELEFONO VARCHAR2(20) NOT NULL,
    CONSTRAINT PK_TELEFONO PRIMARY KEY (ID_TIPO_TELEFONO, ID_CLIENTE),
    CONSTRAINT FK_TELEFONO_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    CONSTRAINT FK_TELEFONO_TIPO_TELEFONO FOREIGN KEY (ID_TIPO_TELEFONO) REFERENCES TIPO_TELEFONO(ID_TIPO_TELEFONO)
);

-- 9 CREACION DE LA TABLA TIPO_PRESTAMO
	CREATE TABLE TIPO_PRESTAMO(
    ID_TIPO_PRESTAMO NUMBER NOT NULL,
    DESCRIPCION_PRESTAMO VARCHAR2(50) NOT NULL,
    TASA NUMBER(3, 2) NOT NULL,
    CONSTRAINT PK_TIPO_PRESTAMO PRIMARY KEY (ID_TIPO_PRESTAMO)
);

 -- 8 CREACION DE LA TABLA PRESTAMO_CLIENTE
	CREATE TABLE PRESTAMO_CLIENTE(
    ID_TIPO_PRESTAMO NUMBER NOT NULL,
    ID_CLIENTE NUMBER NOT NULL,
    FECHA_APRO DATE NOT NULL,
    NUM_PRESTAMO NUMBER  NOT NULL,
    MONTO NUMBER(10, 2) NOT NULL,
    LETRA NUMBER(10, 2) NOT NULL,
    MONTO_PAGADO NUMBER(10, 2),
    FECHA_PAGO DATE,
	SALDOACTUAL NUMBER(15, 2) NOT NULL,
	INTERESPAGADO NUMBER(15, 2),
	FECHAMODIFICACION DATE NOT NULL,
	COD_SUCURSAL NUMBER,
	ID_USUARIO NUMBER NOT NULL,
    CONSTRAINT FK_PRESTAMO_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    CONSTRAINT FK_PRESTAMO_TIPO_PRESTAMO FOREIGN KEY (ID_TIPO_PRESTAMO) REFERENCES TIPO_PRESTAMO(ID_TIPO_PRESTAMO),
	CONSTRAINT PRESTAMO_CLIENTE_FK_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES SUCURSAL(COD_SUCURSAL),
	CONSTRAINT PRESTAMO_CLIENTE_FK_USUARIO FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO(ID_USUARIO),
	CONSTRAINT PK_PRESTAMO_CLIENTE PRIMARY KEY (ID_TIPO_PRESTAMO,ID_CLIENTE)
);

-- 9 CREACION DE TABLA DE LA TRANSCACPAGOS
	CREATE TABLE TRANSACPAGOS (
    ID_TRANSACCION NUMBER,
    COD_SUCURSAL NUMBER NOT NULL,
    ID_CLIENTE NUMBER NOT NULL,
    ID_TIPO_PRESTAMO NUMBER NOT NULL,
    FECHATRANSACCION DATE NOT NULL,
    MONTO_DEL_PAGO NUMBER(15, 2) NOT NULL,
    FECHAINSERCION DATE NOT NULL,
    ID_USUARIO NUMBER NOT NULL,
    CONSTRAINT PK_TRANSACPAGOS PRIMARY KEY (ID_TRANSACCION),
    CONSTRAINT TRANSACPAGOS_FK_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES SUCURSAL(COD_SUCURSAL),
    CONSTRAINT TRANSACPAGOS_FK_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    CONSTRAINT TRANSACPAGOS_FK_TIPO_PRESTAMO FOREIGN KEY (ID_TIPO_PRESTAMO) REFERENCES TIPO_PRESTAMO(ID_TIPO_PRESTAMO),
    CONSTRAINT TRANSACPAGOS_FK_USUARIO FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO(ID_USUARIO)
);

-- 10 CREACION DE LA TABLA SUCURSAL_TIPOPRESTAMO
	CREATE TABLE SUCURSAL_TIPO_PRESTAMO(
	COD_SUCURSAL NUMBER NOT NULL,
	ID_TIPO_PRESTAMO NUMBER NOT NULL,
	PRESTAMOS_ACTIVOS NUMBER,--calculada
	SALDO NUMBER(15,2),
	CONSTRAINT PK_SUCURSAL_TIPOPRESTAMO PRIMARY KEY (COD_SUCURSAL, ID_TIPO_PRESTAMO),
	CONSTRAINT FK_STP_TP FOREIGN KEY (ID_TIPO_PRESTAMO) REFERENCES TIPO_PRESTAMO(ID_TIPO_PRESTAMO),
	CONSTRAINT FK_STP_SUC FOREIGN KEY (COD_SUCURSAL) REFERENCES SUCURSAL(COD_SUCURSAL));

-- 11 CREACION DE LA TABLA DE AUDITORIA
CREATE TABLE AUDITORIA_PRESTAMOS(
    AUD_ID NUMBER, 
    ID_CLIENTE NUMBER, 
    ID_TIPO_PRESTAMOS NUMBER,
    FECHA_TRANSAC DATE, 
    ID_USUARIO NUMBER,
    SALDO_ANTERIOR NUMBER,
    MONTO_APLICADO NUMBER,
    SALDO_ACTUAL NUMBER,
    CONSTRAINT PK_AUDITORIA_PRESTAMOS PRIMARY KEY (AUD_ID)
);