CREATE OR REPLACE FUNCTION CALCULAR_INTERES(
    MONTO NUMBER,
    TASA NUMBER
) RETURN NUMBER IS
    v_interes NUMBER;
BEGIN
    -- Calcular el interés
    v_interes := MONTO * TASA / 1200; -- / 100 / 12 porque es interés anual
    RETURN v_interes;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar cualquier excepción
        DBMS_OUTPUT.PUT_LINE('Error en CALCULAR_INTERES: ' || SQLERRM);
        RETURN NULL;
END CALCULAR_INTERES;
/

CREATE OR REPLACE TRIGGER TRG_TRANSACCION_PRESTAMO
AFTER INSERT ON TRANSACPAGOS
FOR EACH ROW
DECLARE
    V_MONTO          NUMBER;
    V_LETRA          NUMBER;
    V_MONTO_PAGADO   NUMBER;
    V_SALDO_ANTERIOR NUMBER;
    V_SALDO_ACTUAL   NUMBER;
    V_TASA           NUMBER;
    V_INTERES        NUMBER;
BEGIN
    BEGIN
        -- Se obtiene el saldo antes de hacer cambios en PRESTAMO_CLIENTE
        SELECT MONTO, MONTO_PAGADO, LETRA, SALDOACTUAL
        INTO V_MONTO, V_MONTO_PAGADO, V_LETRA, V_SALDO_ANTERIOR
        FROM PRESTAMO_CLIENTE
        WHERE ID_TIPO_PRESTAMO = :NEW.ID_TIPO_PRESTAMO
          AND ID_CLIENTE = :NEW.ID_CLIENTE;

        -- Se hace el cambio en PRESTAMO_CLIENTE
        SELECT TASA
        INTO V_TASA
        FROM TIPO_PRESTAMO
        WHERE ID_TIPO_PRESTAMO = :NEW.ID_TIPO_PRESTAMO;

        -- Calcular el interés
        V_INTERES := CALCULAR_INTERES(V_SALDO_ANTERIOR, V_TASA);

        -- Restar el interés del pago o viceversa si es menor
        IF :NEW.MONTO_DEL_PAGO >= V_LETRA THEN
            V_INTERES := 0;
        END IF;

        -- Calcular el saldo actual
        V_SALDO_ACTUAL := V_MONTO - V_MONTO_PAGADO - :NEW.MONTO_DEL_PAGO + V_INTERES;

        -- Actualizar PRESTAMO_CLIENTE
        UPDATE PRESTAMO_CLIENTE
        SET MONTO_PAGADO = MONTO_PAGADO + :NEW.MONTO_DEL_PAGO,
            SALDOACTUAL = V_SALDO_ACTUAL
        WHERE ID_CLIENTE = :NEW.ID_CLIENTE
          AND ID_TIPO_PRESTAMO = :NEW.ID_TIPO_PRESTAMO;

        -- Insertar en AUDITORIA_PRESTAMOS
        INSERT INTO AUDITORIA_PRESTAMOS (
            AUD_ID, ID_TRANSACCION, ID_CLIENTE, ID_TIPO_PRESTAMOS,
            FECHA_TRANSAC, ID_USUARIO, SALDO_ANTERIOR, MONTO_APLICADO, SALDO_ACTUAL
        ) VALUES (
            SEQ_AUDITORIAS.NEXTVAL, :NEW.ID_TRANSACCION, :NEW.ID_CLIENTE, 
            :NEW.ID_TIPO_PRESTAMO, :NEW.FECHATRANSACCION, :NEW.ID_USUARIO, 
            V_SALDO_ANTERIOR, :NEW.MONTO_DEL_PAGO, V_SALDO_ACTUAL
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró el registro en PRESTAMO_CLIENTE o TIPO_PRESTAMO');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Se encontró más de un registro en PRESTAMO_CLIENTE o TIPO_PRESTAMO');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error en TRG_TRANSACCION_PRESTAMO: ' || SQLERRM);
    END;
END;
/

ALTER TABLE TRANSACPAGOS ENABLE ALL TRIGGERS;
