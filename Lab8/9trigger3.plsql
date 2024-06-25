CREATE OR REPLACE TRIGGER TRG_SUCURSAL_TIPO_PRESTAMO AFTER
    INSERT OR UPDATE OR DELETE ON PRESTAMO_CLIENTE FOR EACH ROW
DECLARE
    V_PRESTAMO_ACTIVO NUMBER;
    V_SALDO           NUMBER;
    V_DIFERENCIA      NUMBER;
BEGIN
    IF INSERTING THEN
 -- Contar el número de préstamos activos de un tipo en una sucursal

 /*SELECT NVL(COUNT(*), 0)
        INTO v_prestamo_activo
        FROM prestamo_cliente
        WHERE cod_sucursal = :NEW.cod_sucursal
            AND id_tipo_prestamo = :NEW.id_tipo_prestamo;*/
 -- Al insertar se suma a la columna prestamos_activos y el saldo en la columna saldo
        MERGE INTO SUCURSAL_TIPO_PRESTAMO ST USING (
            SELECT
                :NEW.COD_SUCURSAL     AS COD_SUCURSAL,
                :NEW.ID_TIPO_PRESTAMO AS ID_TIPO_PRESTAMO
            FROM
                DUAL
        ) SRC ON (ST.COD_SUCURSAL = SRC.COD_SUCURSAL
        AND ST.ID_TIPO_PRESTAMO = SRC.ID_TIPO_PRESTAMO) WHEN MATCHED THEN
            UPDATE
            SET
                PRESTAMOS_ACTIVOS = PRESTAMOS_ACTIVOS + 1,
                SALDO = SALDO + :NEW.SALDOACTUAL WHEN NOT MATCHED THEN INSERT (
                    COD_SUCURSAL,
                    ID_TIPO_PRESTAMO,
                    PRESTAMOS_ACTIVOS,
                    SALDO
                ) VALUES (
                    :NEW.COD_SUCURSAL,
                    :NEW.ID_TIPO_PRESTAMO,
                    1,
                    :NEW.SALDOACTUAL
                );
        ELSIF UPDATING THEN
            V_DIFERENCIA := :NEW.SALDOACTUAL - :OLD.SALDOACTUAL;
 -- Actualizar saldo en sucursal_tipo_prestamo
            UPDATE SUCURSAL_TIPO_PRESTAMO
            SET
                SALDO = SALDO + V_DIFERENCIA
            WHERE
                COD_SUCURSAL = :NEW.COD_SUCURSAL
                AND ID_TIPO_PRESTAMO = :NEW.ID_TIPO_PRESTAMO;
        ELSIF DELETING THEN
 -- Al eliminar se resta prestamos_activos y el saldo en la columna saldo
            MERGE INTO SUCURSAL_TIPO_PRESTAMO ST USING (
                SELECT
                    :OLD.COD_SUCURSAL     AS COD_SUCURSAL,
                    :OLD.ID_TIPO_PRESTAMO AS ID_TIPO_PRESTAMO
                FROM
                    DUAL
            ) SRC ON (ST.COD_SUCURSAL = SRC.COD_SUCURSAL
            AND ST.ID_TIPO_PRESTAMO = SRC.ID_TIPO_PRESTAMO) WHEN MATCHED THEN
                UPDATE
                SET
                    PRESTAMOS_ACTIVOS = PRESTAMOS_ACTIVOS - 1,
                    SALDO = SALDO - :OLD.SALDOACTUAL;
 -- Eliminar el registro si no hay préstamos activos
                DELETE FROM SUCURSAL_TIPO_PRESTAMO
                WHERE
                    COD_SUCURSAL = :OLD.COD_SUCURSAL
                    AND ID_TIPO_PRESTAMO = :OLD.ID_TIPO_PRESTAMO
                    AND PRESTAMOS_ACTIVOS = 0;
            END IF;
        END;
/

ALTER TABLE PRESTAMO_CLIENTE ENABLE ALL TRIGGERS;