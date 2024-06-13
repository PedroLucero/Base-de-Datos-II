/* PRIMERA PARTE*/

-- Creación de secuencias
CREATE SEQUENCE SEQ_CLIENTE START WITH 1;

CREATE SEQUENCE SEQ_EMAIL START WITH 1;

CREATE SEQUENCE SEQ_TELEFONO START WITH 1;

CREATE SEQUENCE SEQ_PRESTAMO START WITH 1;

--Creacion de la tabla PROFESION

CREATE TABLE PROFESION_CLIENTE(
    ID_PROFESION NUMBER NOT NULL,
    PROFESION VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_PROFESION_CLIENTE PRIMARY KEY (ID_PROFESION)
);

-- Creación de tabla cliente 
CREATE TABLE CLIENTE (
    ID_CLIENTE NUMBER PRIMARY KEY,
    CEDULA VARCHAR2(20) NOT NULL UNIQUE,
    NOMBRE VARCHAR2(50) NOT NULL,
    APELLIDO VARCHAR2(50) NOT NULL,
    SEXO CHAR(1) NOT NULL,
    FECHA_NACIMIENTO DATE NOT NULL,
    ID_PROFESION NUMBER NOT NULL,
    CONSTRAINT FK_CLIENTE_ID_PROFESION FOREIGN KEY (ID_PROFESION) REFERENCES PROFESION_CLIENTE(ID_PROFESION)
);

--Creación de la tabla TIPO_EMAIL
CREATE TABLE TIPO_EMAIL(
    ID_TIPO_EMAIL NUMBER NOT NULL,
    DESCRIPCION_EMAIL VARCHAR2(25) NOT NULL,
    CONSTRAINT PK_TIPO_EMAIL PRIMARY KEY(ID_TIPO_EMAIL)
);

-- Creación de tabla email 
CREATE TABLE EMAIL_CLIENTES (
    ID_TIPO_EMAIL NUMBER NOT NULL,
    ID_CLIENTE NUMBER NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_EMAIL PRIMARY KEY (ID_TIPO_EMAIL, ID_CLIENTE),
    CONSTRAINT FK_EMAIL_CLIENTES_TIPO_EMAIL FOREIGN KEY (ID_TIPO_EMAIL) REFERENCES TIPO_EMAIL(ID_TIPO_EMAIL),
    CONSTRAINT FK_EMAIL_CLIENTE_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE)
);

--Creacion de la tabla TIPO_TELEFONO
CREATE TABLE TIPO_TELEFONO(
    ID_TIPO_TELEFONO NUMBER NOT NULL,
    DESCRIPCION_TELEFONO VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_TIPO_TELEFONO PRIMARY KEY(ID_TIPO_TELEFONO)
);

-- Creación de tabla telefono 
CREATE TABLE TELEFONO_CLIENTE (
    ID_CLIENTE NUMBER NOT NULL,
    ID_TIPO_TELEFONO NUMBER NOT NULL,
    NUM_TELEFONO VARCHAR2(20) NOT NULL,
    CONSTRAINT PK_TELEFONO PRIMARY KEY (ID_TIPO_TELEFONO, ID_CLIENTE),
    CONSTRAINT FK_TELEFONO_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    CONSTRAINT FK_TELEFONO_TIPO_TELEFONO FOREIGN KEY (ID_TIPO_TELEFONO) REFERENCES TIPO_TELEFONO(ID_TIPO_TELEFONO)
);

--Creación de la tabla TIPO_PRESTAMO
CREATE TABLE TIPO_PRESTAMO(
    ID_TIPO_PRESTAMO NUMBER NOT NULL,
    DESCRIPCION_PRESTAMO VARCHAR2(50) NOT NULL,
    TASA NUMBER(3, 2) NOT NULL,
    CONSTRAINT PK_TIPO_PRESTAMO PRIMARY KEY (ID_TIPO_PRESTAMO)
);

 -- Creación de tabla prestamo
CREATE TABLE PRESTAMO_CLIENTE(
    ID_TIPO_PRESTAMO NUMBER NOT NULL,
    ID_CLIENTE NUMBER NOT NULL,
    FECHA_APRO DATE NOT NULL,
    NUM_PRESTAMO NUMBER  NOT NULL,
    MONTO NUMBER(10, 2) NOT NULL,
    LETRA NUMBER(10, 2) NOT NULL,
    MONTO_PAGADO NUMBER(10, 2),
    FECHA_PAGO DATE,
    CONSTRAINT FK_PRESTAMO_CLIENTE FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    CONSTRAINT FK_PRESTAMO_TIPO_PRESTAMO FOREIGN KEY (ID_TIPO_PRESTAMO) REFERENCES TIPO_PRESTAMO(ID_TIPO_PRESTAMO)
);

CREATE TABLE SUCURSAL_TIPO_PRESTAMO(



)