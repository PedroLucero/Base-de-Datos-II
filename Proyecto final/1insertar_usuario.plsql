CREATE OR REPLACE PROCEDURE INSERTAR_USUARIO(
    p_NOMBRE CLIENTE.NOMBRE%TYPE,
    p_DIRECCION CLIENTE.DIRECCION%TYPE,
    p_TELEFONO TELEFONOFABRICANTE.TELEFONO%TYPE
) IS 
BEGIN
    INSERT INTO USUARIO(ID, NOMBRE, TELEFONO, DIRECCION)
    VALUES(SEQ_USUARIO.NEXTVAL, p_NOMBRE, p_TELEFONO, p_DIRECCION);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este usuario ya existe');
END;
/

-- Prueba
BEGIN
    INSERTAR_USUARIO('Jonatan Modesto', 'Tijeras, distrito de Boquerón', '6010-0193');
    INSERTAR_USUARIO('Reyna Carmelita', 'Bajo Boquete, distrito de Boquete', '6031-0678');
    INSERTAR_USUARIO('Ainara Olegario', 'La Garceana, distrito de Montijo', '6006-0350');
END;
/