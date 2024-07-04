CREATE OR REPLACE PROCEDURE INSERTAR_VEHICULO(
    p_PLACA VEHICULO.PLACA%TYPE,
    p_ANHO VEHICULO.ANHO%TYPE,
    p_TIPO VEHICULO.TIPO%TYPE,
    p_CAPACIDAD VEHICULO.CAPACIDAD%TYPE,
    p_MODELO VEHICULO.MODELO%TYPE,
    p_MARCA VEHICULO.MARCA%TYPE
) IS 
BEGIN
    INSERT INTO VEHICULO(ID, PLACA, ANHO, TIPO, CAPACIDAD, MODELO, MARCA)
    VALUES(SEQ_VEHICULO.NEXTVAL,
        p_PLACA, p_ANHO, p_TIPO, p_CAPACIDAD, p_MODELO, p_MARCA);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Este vehiculo ya existe');
END;
/

-- Prueba
BEGIN
    INSERTAR_VEHICULO('74LD0N1', '2011', 'Sedán', '5', 'Corolla','Toyota');
    INSERTAR_VEHICULO('54481X3', '2019', 'SUV', '5', 'Q3','Audi');
    INSERTAR_VEHICULO('8436183', '2020', 'SUV', '7', 'Caddy','Volkswagen');
    INSERTAR_VEHICULO('83Y0393', '2003', 'Sedán', '5', 'A4','Audi');
END;
/   