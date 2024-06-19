

CREATE OR REPLACE FUNCTION calcular_edad(p_fecha_nacimiento DATE) RETURN NUMBER IS
    v_edad NUMBER;
BEGIN
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, p_fecha_nacimiento) / 12) INTO v_edad
    FROM dual;
    RETURN v_edad;
END calcular_edad;
/



-- Procedimiento para cargar clientes
CREATE OR REPLACE PROCEDURE cargar_cliente(
    p_nombre CLIENTE.NOMBRE%TYPE,
    p_apellido CLIENTE.APELLIDO%TYPE,
    p_cedula CLIENTE.CEDULA%TYPE,
    p_sexo CLIENTE.SEXO%TYPE,
    p_fecha_nacimiento CLIENTE.FECHA_NACIMIENTO%TYPE,
    p_profesion CLIENTE.ID_PROFESION%TYPE,
    p_cod_sucursal CLIENTE.COD_SUCURSAL%TYPE,
    p_email_cliente EMAIL_CLIENTES.EMAIL%TYPE,
    p_tipo_email TIPO_EMAIL.ID_TIPO_EMAIL%TYPE,
    p_tipo_telefono TIPO_TELEFONO.ID_TIPO_TELEFONO%TYPE,
    p_telefono_cliente TELEFONO_CLIENTE.NUM_TELEFONO%TYPE
)
IS
    v_edad NUMBER;
    v_profesion_cliente NUMBER;
BEGIN
    -- Validar que la profesión existe
        SELECT COUNT(*) INTO v_profesion_cliente
        FROM PROFESION_CLIENTE
        WHERE ID_PROFESION = p_profesion;
  

    -- Calcular la edad
    v_edad := calcular_edad(p_fecha_nacimiento);
    
    -- Insertar los datos del cliente
    INSERT INTO CLIENTE (ID_CLIENTE, NOMBRE, APELLIDO, CEDULA, SEXO, FECHA_NACIMIENTO, EDAD, ID_PROFESION,COD_SUCURSAL)
    VALUES (SEQ_CLIENTE.NEXTVAL, p_nombre, p_apellido, p_cedula, p_sexo, p_fecha_nacimiento, v_edad, p_profesion,p_cod_sucursal);

    --Insertar los datos del Email del cliente
    INSERT INTO EMAIL_CLIENTES(ID_TIPO_EMAIL,ID_CLIENTE,EMAIL)
    VALUES(p_tipo_email,SEQ_CLIENTE.CURRVAL,p_email_cliente);

    --Inserta los datos del telefono del cliente
    INSERT INTO TELEFONO_CLIENTE(ID_CLIENTE,ID_TIPO_TELEFONO,NUM_TELEFONO)
    VALUES(SEQ_CLIENTE.CURRVAL,p_tipo_telefono,p_telefono_cliente);


    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Llave duplicada');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Operacion inválida');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END cargar_cliente;
/

DECLARE
    v_nombre CLIENTE.NOMBRE%TYPE := 'Andres';
    v_apellido CLIENTE.APELLIDO%TYPE := 'Valdes';
    v_cedula CLIENTE.CEDULA%TYPE := '6-726-1938';
    v_sexo CLIENTE.SEXO%TYPE := 'M';
    v_fecha_nacimiento CLIENTE.FECHA_NACIMIENTO%TYPE := TO_DATE('03-06-2004', 'DD-MM-YYYY');
    v_profesion CLIENTE.ID_PROFESION%TYPE := 2;
    v_COD_SUCURSAL CLIENTE.COD_SUCURSAL%TYPE :=4;
    v_edad NUMBER;
    v_email_cliente EMAIL_CLIENTES.EMAIL%TYPE := 'andres.valdes2@utp.ac.pa';
    v_tipo_email TIPO_EMAIL.ID_TIPO_EMAIL%TYPE := 3;
    v_tipo_telefono TIPO_TELEFONO.ID_TIPO_TELEFONO%TYPE:= 1;
    v_telefono_cliente TELEFONO_CLIENTE.NUM_TELEFONO%TYPE:='6609-0485';

    
BEGIN 

    v_edad := calcular_edad(v_fecha_nacimiento);


    cargar_cliente(
        p_nombre => v_nombre,  
        p_apellido => v_apellido,
        p_cedula => v_cedula,
        p_sexo => v_sexo,
        p_fecha_nacimiento => v_fecha_nacimiento,
        p_profesion => v_profesion,
        p_cod_sucursal => v_COD_SUCURSAL,
        p_email_cliente => v_email_cliente,
        p_tipo_email => v_tipo_email,
        p_tipo_telefono => v_tipo_telefono,
        p_telefono_cliente => v_telefono_cliente
    );
    DBMS_OUTPUT.PUT_LINE('Cliente insertado correctamente');

    cargar_cliente('Jose', 'Hernandez', '8-1002-2448', 'M', TO_DATE('08-12-2003', 'DD-MM-YYYY'),3,2,'jozzepher77@gmail.com',1,1,'6723-0263');
    cargar_cliente('Pedro', 'Lucero', '8-1442-9148', 'M', TO_DATE('08-12-2003', 'DD-MM-YYYY'),5,3,'pedro.lucero@utp.ac.pa',3,1,'6997-2738');
    DBMS_OUTPUT.PUT_LINE('Cliente insertado correctamente');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Llave duplicada');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



