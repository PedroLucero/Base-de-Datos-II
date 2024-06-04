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

-- Esto *5 ish
INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES(colaboradores_sequence.nextval, 'Pedro', 'Lucero', '8-973-1067', 'M', TO_DATE('2001-09-01', 'yyyy-mm-dd'), TO_DATE('2024-05-22', 'yyyy-mm-dd'), 'A', 1500);

DECLARE
v_ID Colaboradores.id_codcolaborador%TYPE;
v_estatus Colaboradores.estatus%TYPE;
v_SalarioMensual Colaboradores.salario_mensual%TYPE;

-- Crear cursor

BEGIN 

-- loopear cursor y lógica pa meterle vainas

EXCEPTION

-- Manejo de excp

END;