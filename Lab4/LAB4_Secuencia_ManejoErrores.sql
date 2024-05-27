
PROBLEMA 1 ********************************************************************** 

CREATE TABLE employee (
    id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50)
);

SET SERVEROUTPUT ON

DECLARE
    v_lastname VARCHAR2 (15);
BEGIN
    SELECT last_name INTO v_lastname
    FROM employee
    WHERE first_name = 'john';
    DBMS_OUTPUT.PUT_LINE ('Su apellido es: ' || v_lastname);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE ('Su selección extrae más de una fila. Considere usar un cursos. ');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE (‘El registro no existe. ');
    WHEN OTHERS THEN    
        DBMS_OUTPUT.PUT_LINE (‘Error desconocido guardarlo en una tabla para análisis posterior');
END;




PROBLEMA 2 ********************************************************************** 

DECLARE
    v_invalid PLS_INTEGER;
BEGIN
    v_invalid := 100/0;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE ('Intento dividir por 0');
END;




PROBLEMA 3 **********************************************************************


CREATE TABLE departamento (
    codigo NUMBER PRIMARY KEY,
    nombre VARCHAR2(50)
);


DECLARE
    v_codigo NUMBER := 500;
    v_nombre VARCHAR2 (20) := 'Prueba';
    e_invalid_dept EXCEPTION;
BEGIN
    UPDATE departamento
        SET nombre = v_nombre
    WHERE codigo = v_codigo;
    IF SQL%NOTFOUND THEN
        RAISE e_invalid_dept;
    END IF; 
    ROLLBACK;
EXCEPTION
    WHEN e_invalid_dept THEN
        DBMS_OUTPUT.PUT_LINE ('Departamento no existe');
        DBMS_OUTPUT.PUT_LINE (SQLERRM);
        DBMS_OUTPUT.PUT_LINE (SQLCODE);
END;




PROBLEMA 4 **********************************************************************

CREATE SEQUENCE sec_numeroctas
START WITH 1
INCREMENT BY 1
MAXVALUE 99999
MINVALUE 1;




PROBLEMA 5 **********************************************************************

CREATE TABLE ahorros (
    No_cliente NUMBER PRIMARY KEY,
    sucursal VARCHAR2(25),
    No_cuenta NUMBER,
    tasa NUMBER(5,2),
    saldo_ahorro NUMBER(15,2)
);

INSERT INTO ahorros (No_cliente, sucursal, No_cuenta, tasa, saldo_ahorro) VALUES (12905, '01', sec_numeroctas.nextval, 0, 0.00);
