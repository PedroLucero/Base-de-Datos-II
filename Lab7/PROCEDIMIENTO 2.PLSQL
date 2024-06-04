

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
    p_profesion CLIENTE.ID_PROFESION%TYPE
)
IS
    v_edad NUMBER;
BEGIN
    -- Validar que la profesión existe
    DECLARE
        v_profesion_cliente NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_profesion_cliente
        FROM PROFESION_CLIENTE
        WHERE ID_PROFESION = p_profesion;
    END;

    -- Calcular la edad
    v_edad := calcular_edad(p_fecha_nacimiento);
    
    -- Insertar los datos del cliente
    INSERT INTO CLIENTE (ID_CLIENTE, NOMBRE, APELLIDO, CEDULA, SEXO, FECHA_NACIMIENTO, EDAD, ID_PROFESION)
    VALUES (SEQ_CLIENTE.NEXTVAL, p_nombre, p_apellido, p_cedula, p_sexo, p_fecha_nacimiento, v_edad, p_profesion);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Llave duplicada');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Operacion inválida');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END cargar_cliente;
/


--CARGA DE PRUEBA
INSERT INTO PROFESION_CLIENTE (ID_PROFESION, PROFESIO)
VALUES (1, 'Ingeniero en Refrigeracion y Empuje');


BEGIN
    cargar_cliente('Andres','Valdes','6-726-1938','M',TO_DATE('03-06-2004', 'DD-MM-YYYY'),1);
END;


