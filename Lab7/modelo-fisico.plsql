-- Creación de secuencias
CREATE SEQUENCE seq_cliente START WITH 1;
CREATE SEQUENCE seq_email START WITH 1;
CREATE SEQUENCE seq_telefono START WITH 1;
CREATE SEQUENCE seq_prestamo START WITH 1;

-- Creación de tabla cliente
CREATE TABLE cliente (
    id_cliente NUMBER DEFAULT seq_cliente.NEXTVAL PRIMARY KEY,
    cedula VARCHAR2(20) NOT NULL UNIQUE,
    nombre VARCHAR2(50) NOT NULL,
    apellido VARCHAR2(50) NOT NULL,
    sexo CHAR(1) NOT NULL,
    fecha_nacimiento DATE NOT NULL
    profesion VARCHAR2(50)
);

-- Creación de tabla email
CREATE TABLE email (
    email VARCHAR2(50) NOT NULL,
    id_cliente NUMBER NOT NULL,
    tipo_email VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_email PRIMARY KEY (email, id_cliente),
    CONSTRAINT fk_email_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT chk_tipo_email CHECK (tipo_email IN ('Personal', 'Laboral', 'Academico'))
);

-- Creación de tabla telefono
CREATE TABLE telefono (
    id_telefono NUMBER DEFAULT seq_telefono.NEXTVAL,
    num_telefono VARCHAR2(20) NOT NULL,
    id_cliente NUMBER NOT NULL,
    tipo_telefono VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_telefono PRIMARY KEY (num_telefono, id_cliente),
    CONSTRAINT fk_telefono_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT chk_tipo_telefono CHECK (Tipo_telefono IN ('Celular', 'Residencia', 'Familiar', 'Conyuge'))
);

-- Creación de tabla prestamo
CREATE TABLE prestamo (
    id_prestamo NUMBER DEFAULT seq_prestamo.NEXTVAL PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    num_prestamo NUMBER NOT NULL,
    fecha_apro DATE NOT NULL,
    monto NUMBER(10,2) NOT NULL,
    tasa NUMBER(5,2) NOT NULL,
    letra NUMBER(10,2) NOT NULL,
    monto_pagado NUMBER(10,2),
    fecha_pago DATE,
    CONSTRAINT fk_prestamo_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT chk_tipo_prestamo CHECK (num_prestamo IN (1, 2, 3, 4))
);
