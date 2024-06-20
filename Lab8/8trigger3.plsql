CREATE OR REPLACE TRIGGER trg_update_sucursal_tipoprestamo
AFTER INSERT OR UPDATE OR DELETE ON prestamo_cliente
FOR EACH ROW
DECLARE
    v_prestamo_activo NUMBER;
    v_saldo NUMBER;
    v_diferencia NUMBER;
BEGIN
    IF INSERTING THEN
        -- Contar el número de préstamos activos de un tipo en una sucursal
        /*SELECT NVL(COUNT(*), 0)
        INTO v_prestamo_activo
        FROM prestamo_cliente
        WHERE cod_sucursal = :NEW.cod_sucursal
            AND id_tipo_prestamo = :NEW.id_tipo_prestamo;*/

        -- Al insertar se suma a la columna prestamos_activos y el saldo en la columna saldo
        MERGE INTO sucursal_tipoprestamo st
        USING (SELECT :NEW.cod_sucursal AS cod_sucursal, :NEW.id_tipo_prestamo AS id_tipo_prestamo FROM dual) src
        ON (st.cod_sucursal = src.cod_sucursal AND st.id_tipo_prestamo = src.id_tipo_prestamo)
        WHEN MATCHED THEN
            UPDATE SET prestamos_activos = prestamos_activos + 1,
                       saldo = saldo + :NEW.saldoactual
        WHEN NOT MATCHED THEN
            INSERT (cod_sucursal, id_tipo_prestamo, prestamos_activos, saldo)
            VALUES (:NEW.cod_sucursal, :NEW.id_tipo_prestamo, 1, :NEW.saldoactual);

    ELSIF UPDATING THEN
        v_diferencia := :NEW.saldoactual - :OLD.saldoactual;

        -- Actualizar saldo en sucursal_tipoprestamo
        UPDATE sucursal_tipoprestamo
        SET saldo = saldo + v_diferencia
        WHERE cod_sucursal = :NEW.cod_sucursal
          AND id_tipo_prestamo = :NEW.id_tipo_prestamo;

    ELSIF DELETING THEN
        -- Al eliminar se resta prestamos_activos y el saldo en la columna saldo
        MERGE INTO sucursal_tipoprestamo st
        USING (SELECT :OLD.cod_sucursal AS cod_sucursal, :OLD.id_tipo_prestamo AS id_tipo_prestamo FROM dual) src
        ON (st.cod_sucursal = src.cod_sucursal AND st.id_tipo_prestamo = src.id_tipo_prestamo)
        WHEN MATCHED THEN
            UPDATE SET prestamos_activos = prestamos_activos - 1,
                       saldo = saldo - :OLD.saldoactual;

        -- Eliminar el registro si no hay préstamos activos
        DELETE FROM sucursal_tipoprestamo
        WHERE cod_sucursal = :OLD.cod_sucursal
          AND id_tipo_prestamo = :OLD.id_tipo_prestamo
          AND prestamos_activos = 0;
    END IF;
END;
