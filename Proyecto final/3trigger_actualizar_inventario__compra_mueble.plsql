CREATE OR REPLACE TRIGGER actualizar_inv_compra_mueble
AFTER INSERT OR UPDATE ON DETALLE_COMPRA
FOR EACH ROW
BEGIN
    UPDATE Mueble
    SET CANTIDAD = CANTIDAD + :NEW.CANTIDAD
    WHERE ID = :NEW.ID_MUEBLE;
END;
/
ALTER TABLE DETALLE_COMPRA ENABLE ALL TRIGGERS;