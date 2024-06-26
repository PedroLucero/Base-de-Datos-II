--Adicion de edad a tabla CLIENTES
ALTER TABLE CLIENTE ADD EDAD NUMBER NOT NULL;

--Creacion de la tabla sucursal
CREATE TABLE SUCURSAL(
    COD_SUCURSAL NUMBER,
    NOMBRESUCURSAL VARCHAR2(50) NOT NULL,
    MONTOPRESTAMOS NUMBER NOT NULL,
    CONSTRAINT PK_SUCURSAL PRIMARY KEY (COD_SUCURSAL)
);

--Adicion de cod_sucursal a tabla CLIENTES
ALTER TABLE CLIENTE ADD COD_SUCURSAL NUMBER NOT NULL;

--Declaracion de constraint fk cod_sucursal en tabla CLIENTES
ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_FK_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES SUCURSAL(COD_SUCURSAL);

--Adicion de cod_sucursal a tabla PRESTAMO_CLIENTE
ALTER TABLE PRESTAMO_CLIENTE ADD COD_SUCURSAL NUMBER NOT NULL;

--Declaracion de constraint fk cod_sucursal en tabla PRESTAMO_CLIENTE
ALTER TABLE PRESTAMO_CLIENTE ADD CONSTRAINT PRESTAMO_CLIENTE_FK_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES SUCURSAL(COD_SUCURSAL);

--Creacion de la tabla USUARIO
CREATE TABLE USUARIO (
    ID_USUARIO NUMBER,
    CEDULA_USUARIO VARCHAR2(20) NOT NULL UNIQUE,
    NOMBRE_USUARIO VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_USUARIO PRIMARY KEY (ID_USUARIO)
);

--Adicion de atributos a la tabla PRESTAMO_CLIENTE
ALTER TABLE PRESTAMO_CLIENTE ADD (SALDOACTUAL NUMBER(15, 2) NOT NULL, INTERESPAGADO NUMBER(15, 2), FECHAMODIFICACION DATE NOT NULL, ID_USUARIO NUMBER NOT NULL);

--Declaracion de constraint fk id_usuario en tabla PRESTAMO_CLIENTE
ALTER TABLE PRESTAMO_CLIENTE ADD CONSTRAINT PRESTAMO_CLIENTE_FK_USUARIO FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO(ID_USUARIO);

-- Creación de tabla TRANSACPAGOS
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

CREATE TABLE SUCURSAL_TIPO_PRESTAMO(
	COD_SUCURSAL NUMBER NOT NULL,
	ID_TIPO_PRESTAMO NUMBER NOT NULL,
	PRESTAMOS_ACTIVOS NUMBER,--calculada
	CONSTRAINT PK_SUCURSAL_TIPOPRESTAMO PRIMARY KEY (COD_SUCURSAL, ID_TIPO_PRESTAMO),
	CONSTRAINT FK_SUCURSAL_TIPOPRESTAMO_TIPO FOREIGN KEY (ID_TIPO_PRESTAMO) REFERENCES TIPO_PRESTAMO(ID_TIPO_PRESTAMO),
	CONSTRAINT FK_SUCURSAL_TPRESTAMO_SUCURSAL FOREIGN KEY (COD_SUCURSAL) REFERENCES SUCURSAL(COD_SUCURSAL)
);


ALTER TABLE PRESTAMO_CLIENTE ADD CONSTRAINT PK_PRESTAMO_CLIENTE PRIMARY KEY (ID_TIPO_PRESTAMO,ID_CLIENTE);