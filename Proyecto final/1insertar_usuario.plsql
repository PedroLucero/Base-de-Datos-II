   RETURNING ID INTO v_ID_CREDENCIALES;

    -- Insertar en USUARIO
    INSERT INTO USUARIO(ID, NOMBRE, TELEFONO, DIRECCION, ID_CREDENCIALES)
    VALUES (SEQ_USUARIO.NEXTVAL, p_NOMBRE, p_TELEFONO, p_DIRECCION, v_ID_CREDENCIALES);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este usuario ya existe');
END;
/


-- Prueba
BEGIN
    INSERTAR_USUARIO('John Doe', '1234567890', '123 Main St', 'johndoe', '123');
    INSERTAR_USUARIO('Sirius Black', '1289667890', 'b Main St', 'perro', 'pulga');
END;
/


--OJO YA NO SIRVE ESTO ↓
BEGIN
    INSERTAR_USUARIO('Jonatan Modesto', 'Tijeras, distrito de Boquerón', '6010-0193');
    INSERTAR_USUARIO('Reyna Carmelita', 'Bajo Boquete, distrito de Boquete', '6031-0678');
    INSERTAR_USUARIO('Ainara Olegario', 'La Garceana, distrito de Montijo', '6006-0350');
END;
/