CREATE OR REPLACE TRIGGER ACUMULACIONES_SUCURSAL
AFTER INSERT OR DELETE ON PRESTAMO_CLIENTE
FOR EACH ROW
DECLARE
    v_diferencia NUMBER;
BEGIN
    IF INSERTING THEN
        -- Para inserciones, la diferencia es el monto del nuevo préstamo
        v_diferencia := :NEW.MONTO;
        
        UPDATE SUCURSAL
        SET MONTOPRESTAMOS = MONTOPRESTAMOS + v_diferencia
        WHERE COD_SUCURSAL = :NEW.COD_SUCURSAL;
        
    ELSIF DELETING THEN
        -- Para eliminaciones, la diferencia es negativa y es el monto del préstamo eliminado
        v_diferencia := - :OLD.MONTO;
        
        UPDATE SUCURSAL
        SET MONTOPRESTAMOS = MONTOPRESTAMOS + v_diferencia
        WHERE COD_SUCURSAL = :OLD.COD_SUCURSAL;
    END IF;
    
    -- Mostrar mensaje de éxito en la consola
    DBMS_OUTPUT.PUT_LINE('Acumulaciones de sucursal actualizadas correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al actualizar acumulaciones de sucursal: ' || SQLERRM);
END;
/