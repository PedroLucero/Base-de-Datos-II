--CREACION DEL TRIGGER
CREATE OR REPLACE TRIGGER TRG_TRANSACCION_PRESTAMO
    AFTER INSERT ON TRANSACPAGOS
FOR EACH ROW
DECLARE
v_SALDO_ANTERIOR NUMBER;
v_SALDO_ACTUAL NUMBER;
v_TASA NUMBER;
BEGIN
    -- Se obtiene el saldo antes de hacer cambios en PRESTAMO_CLIENTE
    SELECT SALDOACTUAL
    INTO v_SALDO_ANTERIOR
    FROM PRESTAMO_CLIENTE
    WHERE ID_TIPO_PRESTAMO = :NEW.ID_TIPO_PRESTAMO AND ID_CLIENTE = :NEW.ID_CLIENTE;

    -- Se hace el cambio en PRESTAMO_CLIENTE
    -- Esto viene de la lógica de 6Procedimiento5.plsql

    SELECT TASA
    INTO V_TASA
    FROM TIPO_PRESTAMO T
    WHERE V_ID_TIPO_PRESTAMO = T.ID_TIPO_PRESTAMO;
    
    V_INTERES := CALCULAR_INTERES(v_SALDO_ACTUAL, V_TASA);
    -- restar el interés del pago o viceversa si es menor
        IF :NEW.MONTO_DEL_PAGO >= V_LETRA THEN
            V_INTERES := 0;
        END IF;
        v_SALDO_ACTUAL = MONTO - MONTO_PAGADO - :NEW.MONTO_DEL_PAGO + V_INTERES -- Acomodando el saldo para update
        UPDATE PRESTAMO_CLIENTE P
        SET
            MONTO_PAGADO = MONTO_PAGADO + :NEW.MONTO_DEL_PAGO,
            SALDOACTUAL = v_SALDO_ACTUAL;
        WHERE
            P.ID_CLIENTE = :NEW.ID_CLIENTE AND P.ID_TIPO_PRESTAMO = :NEW.ID_TIPO_PRESTAMO;
    
    INSERT INTO AUDITORIA_PRESTAMOS(AUD_ID, ID_CLIENTE, ID_TIPO_PRESTAMOS, FECHA_TRANSAC, ID_USUARIO, SALDO_ANTERIOR, MONTO_APLICADO, SALDO_ACTUAL)  VALUES (
        SEQ_AUDITORIAS.NEXTVAL,
        :NEW.ID_CLIENTE,
        :NEW.ID_TIPO_PRESTAMO,
        :NEW.FECHATRANSACCION,
        :NEW.ID_USUARIO,
        v_SALDO_ANTERIOR,
        :NEW.MONTO_DEL_PAGO,
        v_SALDO_ACTUAL
        );
END;
/
ALTER TABLE TRANSACPAGOS ENABLE ALL TRIGGERS;