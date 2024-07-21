CREATE OR REPLACE TRIGGER actualizar_inv_compra_mueble
AFTER INSERT OR UPDATE ON DETALLE_COMPRA
FOR EACH ROW
DECLARE
    v_anterior_cantidad NUMBER;
    v_actual_cantidad NUMBER;
    v_usuario NUMBER;
BEGIN
    --Usuario de la Transaccion
    SELECT ID_USUARIO INTO v_usuario
    FROM  Compra
    WHERE ID_COMPRA = :NEW.ID_COMPRA;
    
    -- Obtener la cantidad actual del inventario antes de la actualización
    SELECT cantidad INTO v_anterior_cantidad FROM Mueble WHERE id = :NEW.id_mueble;
    
    UPDATE Mueble
    SET CANTIDAD = CANTIDAD + :NEW.CANTIDAD
    WHERE ID = :NEW.ID_MUEBLE;
    
    -- Cantidad nueva del inventario depues de la actualizcion
    SELECT cantidad INTO v_actual_cantidad FROM Mueble WHERE id = :NEW.id_mueble;

    INSERT INTO Auditoria_Inventario (ID_AUDITORIA, ID_PRODUCTO, ANTERIOR_CANTIDAD, ACTUAL_CANTIDAD, OPERACION, USUARIO)
    VALUES (SEQ_AUDITORIA_INVENTARIO.NEXTVAL, :NEW.id_mueble, v_anterior_cantidad, v_actual_cantidad, 'C', v_usuario);
END;
/
ALTER TABLE DETALLE_COMPRA ENABLE ALL TRIGGERS;