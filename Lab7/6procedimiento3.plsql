CREATE OR REPLACE PROCEDURE INSERTAR_PRESTAMO_APROBADO (
    P_ID_TIPO_PRESTAMO NUMBER,
    P_ID_CLIENTE NUMBER,
    P_FECHA_APRO DATE,
    P_MONTO NUMBER,
    P_LETRA NUMBER,
    P_COD_SUCURSAL NUMBER,
    P_ID_USUARIO NUMBER,
    P_FECHA_PAGO DATE
) AS
    V_MONTO_SUCURSAL NUMBER;
BEGIN
 -- Insertar el nuevo préstamo en la tabla PRESTAMO_CLIENTE
    INSERT INTO PRESTAMO_CLIENTE (
        ID_TIPO_PRESTAMO,
        ID_CLIENTE,
        FECHA_APRO,
        NUM_PRESTAMO,
        MONTO,
        LETRA,
        MONTO_PAGADO,
        FECHA_PAGO,
        COD_SUCURSAL,
        SALDOACTUAL,
        INTERESPAGADO,
        FECHAMODIFICACION,
        ID_USUARIO
    ) VALUES (
        P_ID_TIPO_PRESTAMO,
        P_ID_CLIENTE,
        P_FECHA_APRO,
        SEQ_PRESTAMO.NEXTVAL,
        P_MONTO,
        P_LETRA,
        0,
        P_FECHA_PAGO,
        P_COD_SUCURSAL,
        P_MONTO,
        0,
        SYSDATE,
        P_ID_USUARIO
    );
 -- Actualizar el monto de préstamos en la tabla SUCURSAL
    SELECT
        MONTOPRESTAMOS INTO V_MONTO_SUCURSAL
    FROM
        SUCURSAL
    WHERE
        COD_SUCURSAL = P_COD_SUCURSAL;
    UPDATE SUCURSAL
    SET
        MONTOPRESTAMOS = V_MONTO_SUCURSAL + P_MONTO
    WHERE
        COD_SUCURSAL = P_COD_SUCURSAL;
    UPDATE SUCURSAL_TIPOPRESTAMO
    SET
        PRESTAMOS_ACTIVOS = PRESTAMOS_ACTIVOS + 1 COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: La sucursal o el tipo de préstamo no existe');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un préstamo con el mismo número');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Valor de fecha inválido');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar el préstamo aprobado: '
                             || SQLERRM);
END;
/

--Bloque anonimo
DECLARE
 --Para el prestamo1
    V_ID_TIPO_PRESTAMO  NUMBER := 1; -- Préstamo Personal
    V_ID_CLIENTE        NUMBER := 1; -- Cliente con ID 1
    V_FECHA_APRO        DATE := SYSDATE; -- Fecha actual
    V_MONTO             NUMBER := 10000; -- Monto del préstamo
    V_LETRA             NUMBER := 500; -- Letra del préstamo
    V_COD_SUCURSAL      NUMBER := 1; -- Sucursal Centro
    V_ID_USUARIO        NUMBER := 1; -- Usuario con ID 1
    V_FECHA_PAGO        DATE := TO_DATE('01/07/2023', 'DD/MM/YYYY'); -- Fecha de pago
 --Para el prestamo 2
    V_ID_TIPO_PRESTAMO2 NUMBER := 2; -- Préstamo de Auto
    V_ID_CLIENTE2       NUMBER := 2; -- Cliente con ID 2
    V_FECHA_APRO2       DATE := SYSDATE; -- Fecha actual
    V_MONTO2            NUMBER := 35000; -- Monto del préstamo
    V_LETRA2            NUMBER := 550; -- Letra del préstamo
    V_COD_SUCURSAL2     NUMBER := 2; -- Sucursal Centro
    V_ID_USUARIO2       NUMBER := 1; -- Usuario con ID 1
    V_FECHA_PAGO2       DATE := TO_DATE('02/08/2023', 'DD/MM/YYYY'); -- Fecha de pago
 --Para el prestamo 3
    V_ID_TIPO_PRESTAMO3 NUMBER := 3; -- Préstamo Hipoteca
    V_ID_CLIENTE3       NUMBER := 3; -- Cliente con ID 1
    V_FECHA_APRO3       DATE := SYSDATE; -- Fecha actual
    V_MONTO3            NUMBER := 250000; -- Monto del préstamo
    V_LETRA3            NUMBER := 3000; -- Letra del préstamo
    V_COD_SUCURSAL3     NUMBER := 3; -- Sucursal Centro
    V_ID_USUARIO3       NUMBER := 1; -- Usuario con ID 1
    V_FECHA_PAGO3       DATE := TO_DATE('10/10/2023', 'DD/MM/YYYY'); -- Fecha de pago
BEGIN
 -- INSERT INTO usuario(ID_USUARIO,CEDULA_USUARIO,NOMBRE_USUARIO) VALUES(1, '8-1002-2448', 'Jose Hernadnez');
    INSERTAR_PRESTAMO_APROBADO(
        P_ID_TIPO_PRESTAMO => V_ID_TIPO_PRESTAMO,
        P_ID_CLIENTE => V_ID_CLIENTE,
        P_FECHA_APRO => V_FECHA_APRO,
        P_MONTO => V_MONTO,
        P_LETRA => V_LETRA,
        P_COD_SUCURSAL => V_COD_SUCURSAL,
        P_ID_USUARIO => V_ID_USUARIO,
        P_FECHA_PAGO => V_FECHA_PAGO
    );
    INSERTAR_PRESTAMO_APROBADO(
        P_ID_TIPO_PRESTAMO => V_ID_TIPO_PRESTAMO2,
        P_ID_CLIENTE => V_ID_CLIENTE2,
        P_FECHA_APRO => V_FECHA_APRO2,
        P_MONTO => V_MONTO2,
        P_LETRA => V_LETRA2,
        P_COD_SUCURSAL => V_COD_SUCURSAL2,
        P_ID_USUARIO => V_ID_USUARIO2,
        P_FECHA_PAGO => V_FECHA_PAGO2
    );
    INSERTAR_PRESTAMO_APROBADO(
        P_ID_TIPO_PRESTAMO => V_ID_TIPO_PRESTAMO3,
        P_ID_CLIENTE => V_ID_CLIENTE3,
        P_FECHA_APRO => V_FECHA_APRO3,
        P_MONTO => V_MONTO3,
        P_LETRA => V_LETRA3,
        P_COD_SUCURSAL => V_COD_SUCURSAL3,
        P_ID_USUARIO => V_ID_USUARIO3,
        P_FECHA_PAGO => V_FECHA_PAGO3
    );
    DBMS_OUTPUT.PUT_LINE('Préstamo aprobado e insertado correctamente.');
END;
/