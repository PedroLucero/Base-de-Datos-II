-- (ID_CLIENTE, COCINAS, C_COCINAS, MUEBLES, C_MUEBLES, ID_REPARTIDOR, MONTADOR, FECHA_ENTREGA)
CREATE OR REPLACE PROCEDURE REGISTRAR_VENTA(
    p_ID_CLIENTE VENTA.ID_CLIENTE%TYPE,
    p_ID_USUARIO VENTA.ID_USUARIO%TYPE,
    p_COCINAS SYS.ODCINUMBERLIST,
    p_C_COCINAS SYS.ODCINUMBERLIST,
    p_MUEBLES SYS.ODCINUMBERLIST,
    p_C_MUEBLES SYS.ODCINUMBERLIST,
    p_ID_REPARTIDOR REPARTIDOR.ID%TYPE,
    p_ID_MONTADOR MONTADOR.ID%TYPE,
    p_FECHA_ENTREGA ENTREGA.FECHA_ASIGNADA%TYPE
) IS 
BEGIN
    -- revisiones para arreglos válidos
    IF p_MUEBLES.COUNT != p_C_MUEBLES.COUNT THEN
        RAISE_APPLICATION_ERROR(-20001, 'Los muebles y sus cantidades no concuerdan');
    END IF;
    IF p_COCINAS.COUNT != p_C_COCINAS.COUNT THEN
        RAISE_APPLICATION_ERROR(-20002, 'Las cocinas y sus cantidades no concuerdan');
    END IF;

    -- paso 1: inicializar venta
    INSERT INTO VENTA(NUM_FACTURA, SUBTOTAL, IMPUESTO, TOTAL, ID_CLIENTE, ID_USUARIO, FECHA_VENTA)
    VALUES(SEQ_VENTA.NEXTVAL, 0, 0, 0, p_ID_CLIENTE, p_ID_USUARIO, SYSDATE);

    -- paso 2: loop de cocina insertando
    FOR i IN 1..p_COCINAS.COUNT LOOP
        INSERT INTO DETALLE_V_COCINAS(NUM_FACTURA, ID_COCINA, CANTIDAD)
        VALUES (SEQ_VENTA.CURRVAL, p_COCINAS(i), p_C_COCINAS(i));
    END LOOP;

    -- paso 3: loop de mueble insertando
    FOR i IN 1..p_MUEBLES.COUNT LOOP
        INSERT INTO DETALLE_V_MUEBLES(NUM_FACTURA, ID_MUEBLE, CANTIDAD)
        VALUES (SEQ_VENTA.CURRVAL, p_MUEBLES(i), p_C_MUEBLES(i));
    END LOOP;

    -- paso 4: 
    INSERT INTO ENTREGA(NUM_FACTURA, ID_REPARTIDOR, ID_MONTADOR, FECHA_ASIGNADA)
    VALUES(SEQ_VENTA.CURRVAL, p_ID_REPARTIDOR, p_ID_MONTADOR, p_FECHA_ENTREGA);

    -- COMMIT;
EXCEPTION
-- añadir excp de fk cuando fabricante no existe
-- añadir excp cuando mueble no existe
-- maybe algo de que el id de mueble no es de ese fabricante?
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('HUBO FALLOS'); --corregir

    -- WHEN OTHERS THEN
        -- ROLLBACK;
END;
/

-- Prueba
DECLARE
    V_ID_CLIENTE VENTA.ID_CLIENTE%TYPE;
    V_ID_USUARIO VENTA.ID_USUARIO%TYPE;
    V_COCINAS SYS.ODCINUMBERLIST;
    V_C_COCINAS SYS.ODCINUMBERLIST;
    V_MUEBLES SYS.ODCINUMBERLIST;
    V_C_MUEBLES SYS.ODCINUMBERLIST;
    V_ID_REPARTIDOR REPARTIDOR.ID%TYPE;
    V_ID_MONTADOR MONTADOR.ID%TYPE;
    V_FECHA_ENTREGA ENTREGA.FECHA_ASIGNADA%TYPE;
BEGIN
    V_ID_CLIENTE := 3; -- fe begoña
    V_ID_USUARIO := 1; -- jonatan modesto
    V_COCINAS := SYS.ODCINUMBERLIST(); -- arreglo
    V_C_COCINAS := SYS.ODCINUMBERLIST(); -- arreglo
    V_MUEBLES := SYS.ODCINUMBERLIST(1, 5); -- arreglo
    V_C_MUEBLES := SYS.ODCINUMBERLIST(2, 2); -- arreglo
    V_ID_REPARTIDOR := 2; -- sebastián cleto
    V_ID_MONTADOR := 1; -- josé hernández
    V_FECHA_ENTREGA := sysdate + 2;
    
    REGISTRAR_VENTA(V_ID_CLIENTE, V_ID_USUARIO, V_COCINAS, V_C_COCINAS, V_MUEBLES, V_C_MUEBLES,
                    V_ID_REPARTIDOR, V_ID_MONTADOR, V_FECHA_ENTREGA);

    V_ID_CLIENTE := 2;
    V_ID_USUARIO := 2;
    V_COCINAS := SYS.ODCINUMBERLIST(1);
    V_C_COCINAS := SYS.ODCINUMBERLIST(2);
    V_MUEBLES := SYS.ODCINUMBERLIST();
    V_C_MUEBLES := SYS.ODCINUMBERLIST();
    V_ID_REPARTIDOR := 1;
    V_ID_MONTADOR := 2;
    V_FECHA_ENTREGA := sysdate + 2;
    
    REGISTRAR_VENTA(V_ID_CLIENTE, V_ID_USUARIO, V_COCINAS, V_C_COCINAS, V_MUEBLES, V_C_MUEBLES,
                    V_ID_REPARTIDOR, V_ID_MONTADOR, V_FECHA_ENTREGA);

    V_ID_CLIENTE := 1;
    V_ID_USUARIO := 3;
    V_COCINAS := SYS.ODCINUMBERLIST(1);
    V_C_COCINAS := SYS.ODCINUMBERLIST(2);
    V_MUEBLES := SYS.ODCINUMBERLIST(1);
    V_C_MUEBLES := SYS.ODCINUMBERLIST(3);
    V_ID_REPARTIDOR := 2;
    V_ID_MONTADOR := 3;
    V_FECHA_ENTREGA := sysdate + 2;
    
    REGISTRAR_VENTA(V_ID_CLIENTE, V_ID_USUARIO, V_COCINAS, V_C_COCINAS, V_MUEBLES, V_C_MUEBLES,
                    V_ID_REPARTIDOR, V_ID_MONTADOR, V_FECHA_ENTREGA);
END;
/