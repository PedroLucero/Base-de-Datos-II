CREATE OR REPLACE PROCEDURE COMPRAR_MUEBLE(
    p_USUARIO USUARIO.ID%TYPE,
    p_FACTURA_F COMPRA.FACTURA_FABRICANTE%TYPE,
    p_FABRICANTE COMPRA.ID_FABRICANTE%TYPE,
    p_MONTO COMPRA.MONTO%TYPE,
    p_MUEBLES SYS.ODCINUMBERLIST,  
    p_CANTIDADES SYS.ODCINUMBERLIST
) IS 
BEGIN
    IF p_MUEBLES.COUNT != p_CANTIDADES.COUNT THEN -- revision de buenos arreglos para inserts
        RAISE_APPLICATION_ERROR(-20001, 'Los muebles y sus cantidades no concuerdan');
    END IF;
    INSERT INTO COMPRA(ID_COMPRA, ID_USUARIO, FACTURA_FABRICANTE, ID_FABRICANTE, MONTO, FECHA)
    VALUES(SEQ_COMPRA.NEXTVAL, p_USUARIO, p_FACTURA_F, p_FABRICANTE, p_MONTO, SYSDATE);

    FOR i IN 1..p_MUEBLES.COUNT LOOP -- loopeamos para insertar todo lo comprado
        INSERT INTO DETALLE_COMPRA(ID_COMPRA, ID_MUEBLE, CANTIDAD)
        VALUES (SEQ_COMPRA.CURRVAL, p_MUEBLES(i), p_CANTIDADES(i));
    END LOOP;

    -- COMMIT;
EXCEPTION
-- añadir excp de fk cuando fabricante no existe
-- añadir excp cuando mueble no existe
-- maybe algo de que el id de mueble no es de ese fabricante?
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este compra ya se realizó');
END;
/

-- Prueba
DECLARE
    v_USUARIO USUARIO.ID%TYPE;
    v_FACTURA_FABRICANTE COMPRA.FACTURA_FABRICANTE%TYPE;
    v_FABRICANTE COMPRA.ID_FABRICANTE%TYPE;
    v_MONTO COMPRA.MONTO%TYPE;
    v_MUEBLES SYS.ODCINUMBERLIST;
    v_CANTIDADES SYS.ODCINUMBERLIST;
BEGIN
    v_USUARIO := 2;
    v_FACTURA_FABRICANTE := 10001;
    v_FABRICANTE := 1;
    v_MONTO := 700;
    v_MUEBLES := SYS.ODCINUMBERLIST(1, 5);
    v_CANTIDADES := SYS.ODCINUMBERLIST(12, 5);
    
    COMPRAR_MUEBLE(v_USUARIO, v_FACTURA_FABRICANTE, v_FABRICANTE, v_MONTO, v_MUEBLES, v_CANTIDADES);
END;
/