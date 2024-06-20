CREATE OR REPLACE TRIGGER ACUMULACIONES_SUCURSAL
AFTER INSERT OR UPDATE OR DELETE ON PRESTAMO_CLIENTE
FOR EACH ROW
DECLARE
    v_monto_anterior NUMBER;
    v_monto_actual NUMBER;
BEGIN
    -- Obtener el monto anterior y actual después de la operación
    IF INSERTING THEN
        v_monto_anterior := 0; -- No hay monto anterior en caso de inserción
        v_monto_actual := :NEW.MONTO; -- Monto actual insertado
    ELSIF UPDATING THEN
        v_monto_anterior := :OLD.MONTO; -- Monto anterior antes de la actualización
        v_monto_actual := :NEW.MONTO; -- Monto actual después de la actualización
    ELSIF DELETING THEN
        v_monto_anterior := :OLD.MONTO; -- Monto antes de la eliminación
        v_monto_actual := 0; -- No hay monto actual después de la eliminación
    END IF;

    -- Calcular la diferencia de montos
    DECLARE
        v_diferencia NUMBER;
    BEGIN
        v_diferencia := v_monto_actual - v_monto_anterior;

        -- Actualizar la tabla SUCURSAL
        UPDATE SUCURSAL
        SET MONTOPRESTAMOS = MONTOPRESTAMOS + v_diferencia
        WHERE COD_SUCURSAL = :NEW.COD_SUCURSAL;

        -- Mostrar mensaje de éxito en la consola
        DBMS_OUTPUT.PUT_LINE('Acumulaciones de sucursal actualizadas correctamente.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al actualizar acumulaciones de sucursal: ' || SQLERRM);
    END;
END;
/
