CREATE OR REPLACE FUNCTION CALCULAR_EDAD(
    P_FECHA_NACIMIENTO DATE
) RETURN NUMBER IS
    V_EDAD NUMBER;
BEGIN
    SELECT
        FLOOR(MONTHS_BETWEEN(SYSDATE, P_FECHA_NACIMIENTO) / 12) INTO V_EDAD
    FROM
        DUAL;
    RETURN V_EDAD;
END CALCULAR_EDAD;
/

-- Procedimiento para cargar clientes
CREATE OR REPLACE PROCEDURE CARGAR_CLIENTE(
    P_NOMBRE CLIENTE.NOMBRE%TYPE,
    P_APELLIDO CLIENTE.APELLIDO%TYPE,
    P_CEDULA CLIENTE.CEDULA%TYPE,
    P_SEXO CLIENTE.SEXO%TYPE,
    P_FECHA_NACIMIENTO CLIENTE.FECHA_NACIMIENTO%TYPE,
    P_PROFESION CLIENTE.ID_PROFESION%TYPE,
    P_COD_SUCURSAL CLIENTE.COD_SUCURSAL%TYPE,
    P_EMAIL_CLIENTE EMAIL_CLIENTES.EMAIL%TYPE,
    P_TIPO_EMAIL TIPO_EMAIL.ID_TIPO_EMAIL%TYPE,
    P_TIPO_TELEFONO TIPO_TELEFONO.ID_TIPO_TELEFONO%TYPE,
    P_TELEFONO_CLIENTE TELEFONO_CLIENTE.NUM_TELEFONO%TYPE
) IS
    V_EDAD              NUMBER;
    V_PROFESION_CLIENTE NUMBER;
BEGIN
 -- Validar que la profesión existe
    SELECT
        COUNT(*) INTO V_PROFESION_CLIENTE
    FROM
        PROFESION_CLIENTE
    WHERE
        ID_PROFESION = P_PROFESION;
 -- Calcular la edad
    V_EDAD := CALCULAR_EDAD(P_FECHA_NACIMIENTO);
 -- Insertar los datos del cliente
    INSERT INTO CLIENTE (
        ID_CLIENTE,
        NOMBRE,
        APELLIDO,
        CEDULA,
        SEXO,
        FECHA_NACIMIENTO,
        EDAD,
        ID_PROFESION,
        COD_SUCURSAL
    ) VALUES (
        SEQ_CLIENTE.NEXTVAL,
        P_NOMBRE,
        P_APELLIDO,
        P_CEDULA,
        P_SEXO,
        P_FECHA_NACIMIENTO,
        V_EDAD,
        P_PROFESION,
        P_COD_SUCURSAL
    );
 --Insertar los datos del Email del cliente
    INSERT INTO EMAIL_CLIENTES(
        ID_TIPO_EMAIL,
        ID_CLIENTE,
        EMAIL
    ) VALUES(
        P_TIPO_EMAIL,
        SEQ_CLIENTE.CURRVAL,
        P_EMAIL_CLIENTE
    );
 --Inserta los datos del telefono del cliente
    INSERT INTO TELEFONO_CLIENTE(
        ID_CLIENTE,
        ID_TIPO_TELEFONO,
        NUM_TELEFONO
    ) VALUES(
        SEQ_CLIENTE.CURRVAL,
        P_TIPO_TELEFONO,
        P_TELEFONO_CLIENTE
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Llave duplicada');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Operacion inválida');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: '
                             || SQLERRM);
END CARGAR_CLIENTE;
/

DECLARE
    V_NOMBRE           CLIENTE.NOMBRE%TYPE := 'Andres';
    V_APELLIDO         CLIENTE.APELLIDO%TYPE := 'Valdes';
    V_CEDULA           CLIENTE.CEDULA%TYPE := '6-726-1938';
    V_SEXO             CLIENTE.SEXO%TYPE := 'M';
    V_FECHA_NACIMIENTO CLIENTE.FECHA_NACIMIENTO%TYPE := TO_DATE('03-06-2004', 'DD-MM-YYYY');
    V_PROFESION        CLIENTE.ID_PROFESION%TYPE := 2;
    V_COD_SUCURSAL     CLIENTE.COD_SUCURSAL%TYPE :=4;
    V_EDAD             NUMBER;
    V_EMAIL_CLIENTE    EMAIL_CLIENTES.EMAIL%TYPE := 'andres.valdes2@utp.ac.pa';
    V_TIPO_EMAIL       TIPO_EMAIL.ID_TIPO_EMAIL%TYPE := 3;
    V_TIPO_TELEFONO    TIPO_TELEFONO.ID_TIPO_TELEFONO%TYPE:= 1;
    V_TELEFONO_CLIENTE TELEFONO_CLIENTE.NUM_TELEFONO%TYPE:='6609-0485';
BEGIN
    V_EDAD := CALCULAR_EDAD(V_FECHA_NACIMIENTO);
    CARGAR_CLIENTE(
        P_NOMBRE => V_NOMBRE,
        P_APELLIDO => V_APELLIDO,
        P_CEDULA => V_CEDULA,
        P_SEXO => V_SEXO,
        P_FECHA_NACIMIENTO => V_FECHA_NACIMIENTO,
        P_PROFESION => V_PROFESION,
        P_COD_SUCURSAL => V_COD_SUCURSAL,
        P_EMAIL_CLIENTE => V_EMAIL_CLIENTE,
        P_TIPO_EMAIL => V_TIPO_EMAIL,
        P_TIPO_TELEFONO => V_TIPO_TELEFONO,
        P_TELEFONO_CLIENTE => V_TELEFONO_CLIENTE
    );
    DBMS_OUTPUT.PUT_LINE('Cliente insertado correctamente');
    CARGAR_CLIENTE('Jose', 'Hernandez', '8-1002-2448', 'M', TO_DATE('08-12-2003', 'DD-MM-YYYY'), 3, 2, 'jozzepher77@gmail.com', 1, 1, '6723-0263');
    CARGAR_CLIENTE('Pedro', 'Lucero', '8-1442-9148', 'M', TO_DATE('08-12-2003', 'DD-MM-YYYY'), 5, 3, 'pedro.lucero@utp.ac.pa', 3, 1, '6997-2738');
    DBMS_OUTPUT.PUT_LINE('Cliente insertado correctamente');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Llave duplicada');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: '
                             || SQLERRM);
END;
/