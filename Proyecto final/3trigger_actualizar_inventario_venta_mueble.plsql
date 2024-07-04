CREATE OR REPLACE TRIGGER actualizar_inv_venta_mueble
AFTER INSERT OR UPDATE ON DETALLE_V_MUEBLES
FOR EACH ROW
DECLARE
    v_precio NUMBER;
    v_subtotal NUMBER;
BEGIN
    UPDATE Mueble
    SET CANTIDAD = CANTIDAD - :NEW.CANTIDAD
    WHERE ID = :NEW.ID_MUEBLE;

    --Ahora calculamos el subtotal de lo que hay que pagar en la venta de muebles
    SELECT precio
    INTO v_precio
    FROM Mueble
    WHERE ID = :NEW.ID_MUEBLE;

    v_subtotal := v_precio * :NEW.CANTIDAD;
    --Una vez calculado entonces le hacemos UPDATE a la venta
    UPDATE VENTA
    SET SUBTOTAL = SUBTOTAL + v_subtotal, IMPUESTO = IMPUESTO + (v_subtotal * 0.07), TOTAL = TOTAL + v_subtotal * 1.07
    WHERE NUM_FACTURA = :NEW.NUM_FACTURA;

END;
/
ALTER TABLE DETALLE_V_MUEBLES ENABLE ALL TRIGGERS;



CREATE OR REPLACE TRIGGER actualizar_inv_venta_cocina
AFTER INSERT OR UPDATE ON DETALLE_V_COCINAS
FOR EACH ROW
DECLARE
    v_precio NUMBER;
    v_subtotal NUMBER;
BEGIN
    UPDATE COCINA
    SET INSTOCK = INSTOCK - :NEW.CANTIDAD
    WHERE ID = :NEW.ID_COCINA;

    --Ahora calculamos el subtotal de lo que hay que pagar en la venta de muebles
    SELECT precio
    INTO v_precio
    FROM COCINA
    WHERE ID = :NEW.ID_COCINA;

    v_subtotal:= v_precio * :NEW.CANTIDAD;
    --Una vez calculado entonces le hacemos UPDATE a la venta
    UPDATE VENTA
    SET SUBTOTAL = SUBTOTAL + v_subtotal, IMPUESTO = IMPUESTO + (v_subtotal * 0.07), TOTAL = TOTAL + v_subtotal * 1.07
    WHERE NUM_FACTURA = :NEW.NUM_FACTURA;
END;
/
ALTER TABLE DETALLE_V_COCINAS ENABLE ALL TRIGGERS;