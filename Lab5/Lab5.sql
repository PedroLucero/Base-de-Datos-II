create table Colaboradores(
    id_codcolaborador number primary key,
    nombre varchar2(25),
    apellido varchar2(25),
    cedula varchar2(12),
    sexo char,
    fecha_nacimiento date,
    fecha_ingreso date,
    estatus char, 
    salario_mensual number(15,2)
);

create table salario_quincenal(
    id_salario number primary key,
    id_codcolaborador number,
    fecha_pago date,
    salario_quincenal number(15,2),
    seguro_social number(15,2),
    seguro_educativo number(15,2),
    salario_neto number(15,2),
    constraint id_codcolaborador foreign key (id_codcolaborador) references Colaboradores (id_codcolaborador)
);

-- Las fechas de pago son los 15 y 30 de cada mes. La información que mantienen en la base
-- de datos incluye a colaboradores con status (A= Activo, R=Retirado y V=Vacaciones), las
-- quincenas solo son pagadas a los colaboradores que están activos.

-- Se exige que en el proceso a implementar se utilice un cursor que busque en la base de
-- datos la información de los colaboradores y que dentro del proceso a implementar cargue
-- la tabla de los salarios quincenales con la información correspondiente a los cálculos del
-- salario para cada colaborador.

-- Para calcular el seguro social, este es igual al salario * 9.75%. Para el cálculo del seguro
-- educativo este el igual salario * 1.25%. Recuerde que esta pago del salario quincenal
-- dentro del proceso.

-- Por lo menos deberá haber 5 colaboradores activos, dos de vacaciones y un retirado.
-- Las llaves infinitas deben estar controladas por una secuencia.

CREATE SEQUENCE colaboradores_sequence
start with 1
increment by 1
minvalue 0
maxvalue 100
cycle;

CREATE SEQUENCE salarios_sequence
start with 1
increment by 1
minvalue 0
maxvalue 100
cycle;

-- 5 colaboradores activos
INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'Pedro', 'Lucero', '8-973-1067', 'M', TO_DATE('2001-09-01', 'yyyy-mm-dd'), TO_DATE('2024-05-22', 'yyyy-mm-dd'), 'A', 1500);

INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'Rafaela', 'Black', '8-905-1651', 'F', TO_DATE('1996-05-23', 'yyyy-mm-dd'), TO_DATE('2024-05-21', 'yyyy-mm-dd'), 'A', 1501);

INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'Jose', 'Hernandez', '8-1002-2448', 'M', TO_DATE('2003-12-08', 'yyyy-mm-dd'), TO_DATE('2024-05-20', 'yyyy-mm-dd'), 'A', 1502);

INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'Andres', 'Valdes', '6-726-1938', 'M', TO_DATE('2004-06-03', 'yyyy-mm-dd'), TO_DATE('2024-05-19', 'yyyy-mm-dd'), 'A', 1503);

INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'Arantxa', 'Coronado', '2-752-1519', 'F', TO_DATE('2003-10-20', 'yyyy-mm-dd'), TO_DATE('2024-05-18', 'yyyy-mm-dd'), 'A', 1504);

-- 2 Colaboradores de vacaciones
INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'Juan', 'Perez', '1-111-1111', 'M', TO_DATE('2000-01-01', 'yyyy-mm-dd'), TO_DATE('2023-12-12', 'yyyy-mm-dd'), 'V', 2501);

INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'John', 'Johnson', '2-222-2222', 'M', TO_DATE('1999-02-02', 'yyyy-mm-dd'), TO_DATE('2023-11-11', 'yyyy-mm-dd'), 'V', 2500);

-- 1 Colaborador retirado
INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'Ramona', 'Gonzalez', '3-333-3333', 'F', TO_DATE('1998-03-03', 'yyyy-mm-dd'), TO_DATE('2023-10-10', 'yyyy-mm-dd'), 'R', 666);

CREATE OR REPLACE VIEW Lab5 AS
SELECT C.id_codcolaborador AS Codigo,
    nombre AS nombre,
    apellido AS apellido,
    salario_mensual AS salarioMensual,
    salario_quincenal AS salarioQuincenal,
    seguro_social AS seguroSocial,
    seguro_educativo AS seguroEducativo,
    salario_neto AS salarioNeto
FROM Colaboradores C JOIN salario_quincenal S ON c.id_codcolaborador = s.id_codcolaborador; 

DECLARE
v_ID Colaboradores.id_codcolaborador%TYPE;
v_Estatus Colaboradores.estatus%TYPE := 'A'; -- seleccionar solo Activos
v_SalarioQ Colaboradores.salario_mensual%TYPE;
v_Fecha salario_quincenal.fecha_pago%TYPE;


-- Crear cursor
CURSOR c_Colaboradores IS
SELECT id_codcolaborador, salario_mensual
FROM Colaboradores
WHERE estatus = v_Estatus;

BEGIN 
    -- determinar fecha pago:
IF TO_CHAR(sysdate, 'DD') < 30 THEN
    v_Fecha := TO_DATE(TO_CHAR(sysdate, 'YYYY') || '-' || TO_CHAR(sysdate, 'MM') || '-' || 30, 'yyyy-mm-dd');
END IF;

IF TO_CHAR(sysdate, 'DD') < 15 THEN
    v_Fecha := TO_DATE(TO_CHAR(sysdate, 'YYYY') || '-' || TO_CHAR(sysdate, 'MM') || '-' || 15, 'yyyy-mm-dd');
END IF;

-- loopear cursor
FOR v_fila IN c_Colaboradores
LOOP
    v_ID := v_fila.id_codcolaborador;
    v_SalarioQ := v_fila.salario_mensual/2;

    INSERT INTO salario_quincenal(id_salario, id_codcolaborador, fecha_pago, salario_quincenal, seguro_social,seguro_educativo, salario_neto)
        VALUES(salarios_sequence.nextval, v_ID, v_Fecha, v_SalarioQ, v_SalarioQ*0.0975, v_SalarioQ*0.0125, v_SalarioQ*0.89);

END LOOP;


EXCEPTION
-- Manejo de excp
WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('Error de valor');

END;
/