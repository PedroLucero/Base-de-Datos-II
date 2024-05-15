DECLARE
    TYPE nombre_array IS VARRAY(5) OF VARCHAR2(50);
    TYPE cumple_array IS VARRAY(5) OF DATE;

    v_identificacion NUMBER;
    v_nombres nombre_array := nombre_array('', '', '', '', '');
    v_cumples cumple_array := cumple_array('', '', '', '', '');

BEGIN
    -- DBMS_OUTPUT.PUT_LINE('Recuerde que todas las fechas son en formato DD-MM-YYYY');

    v_nombres(1) := '&captura_nombre';
    v_cumples(1) := TO_DATE('&captura_dia_cumple', 'DD-MM-YYYY');

    v_nombres(2) := '&captura_nombre';
    v_cumples(2) := TO_DATE('&captura_dia_cumple', 'DD-MM-YYYY');

    v_nombres(3) := '&captura_nombre';
    v_cumples(3) := TO_DATE('&captura_dia_cumple', 'DD-MM-YYYY');

    v_nombres(4) := '&captura_nombre';
    v_cumples(4) := TO_DATE('&captura_dia_cumple', 'DD-MM-YYYY');

    v_nombres(5) := '&captura_nombre';
    v_cumples(5) := TO_DATE('&captura_dia_cumple', 'DD-MM-YYYY');

    FOR i IN 1..v_nombres.COUNT LOOP
        INSERT INTO cumpleanos (id, nombre, cumple)
        VALUES (i, v_nombres(i), v_cumples(i));
    END LOOP;

    -- Consultar la tabla cumpleanos
    v_identificacion := '&captura_identificacion';

    SELECT nombre, cumple
        INTO v_nombres(1), v_cumples(1)
        FROM cumpleanos
        WHERE id = v_identificacion;

    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombres(1) || ', Fecha de cumpleaños: ' || v_cumples(1));

EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Se ingresaron datos inválidos a la tabla');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el registro con la identificación ' || v_identificacion);
END;
/