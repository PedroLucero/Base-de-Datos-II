CREATE OR REPLACE PROCEDURE insertar_prestamo_aprobado
(
    p_id_tipo_prestamo NUMBER,
    p_id_cliente NUMBER,
    p_fecha_apro DATE,
    p_monto NUMBER,
    p_letra NUMBER,
    p_cod_sucursal NUMBER,
    p_id_usuario NUMBER,
    p_fecha_pago DATE
)
AS
    v_monto_sucursal NUMBER;
BEGIN
    -- Insertar el nuevo préstamo en la tabla PRESTAMO_CLIENTE
    INSERT INTO PRESTAMO_CLIENTE
    (
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
    )
    VALUES
    (
        p_id_tipo_prestamo,
        p_id_cliente,
        p_fecha_apro,
        SEQ_PRESTAMO.NEXTVAL,
        p_monto,
        p_letra,
        0,
        p_fecha_pago,
        p_cod_sucursal,
        p_monto,
        0,
        SYSDATE,
        p_id_usuario
    );

    -- Actualizar el monto de préstamos en la tabla SUCURSAL
    SELECT MONTOPRESTAMOS INTO v_monto_sucursal
    FROM SUCURSAL
    WHERE COD_SUCURSAL = p_cod_sucursal;

    UPDATE SUCURSAL
    SET MONTOPRESTAMOS = v_monto_sucursal + p_monto
    WHERE COD_SUCURSAL = p_cod_sucursal;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: La sucursal o el tipo de préstamo no existe');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ya existe un préstamo con el mismo número');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Valor de fecha inválido');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar el préstamo aprobado: ' || SQLERRM);
END;
/
--Bloque anonimo
DECLARE
    v_id_tipo_prestamo NUMBER := 1; -- Préstamo Personal
    v_id_cliente NUMBER := 1; -- Cliente con ID 1
    v_fecha_apro DATE := SYSDATE; -- Fecha actual
    v_monto NUMBER := 10000; -- Monto del préstamo
    v_letra NUMBER := 500; -- Letra del préstamo
    v_cod_sucursal NUMBER := 1; -- Sucursal Centro
    v_id_usuario NUMBER := 1; -- Usuario con ID 1
    v_fecha_pago DATE := TO_DATE('01/07/2023', 'DD/MM/YYYY'); -- Fecha de pago
BEGIN
    insertar_prestamo_aprobado(
        p_id_tipo_prestamo => v_id_tipo_prestamo,
        p_id_cliente => v_id_cliente,
        p_fecha_apro => v_fecha_apro,
        p_monto => v_monto,
        p_letra => v_letra,
        p_cod_sucursal => v_cod_sucursal,
        p_id_usuario => v_id_usuario,
        p_fecha_pago => v_fecha_pago
    );
    DBMS_OUTPUT.PUT_LINE('Préstamo aprobado e insertado correctamente.');
END;
/