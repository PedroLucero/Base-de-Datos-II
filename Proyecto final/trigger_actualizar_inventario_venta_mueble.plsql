CREATE OR REPLACE TRIGGER actualizar_inventario_venta_mueble
AFTER INSERT OR UPDATE ON DETALLE_V_MUEBLES
FOR EACH ROW
DECLARE
    v_precio NUMBER,
    v_subtotal NUMBER,
BEGIN
    UPDATE Mueble
    SET CANTIDAD = CANTIDAD - :NEW.CANTIDAD
    WHERE ID_MUEBLE = :NEW.ID_MUEBLE;

    --Ahora calculamos el subtotal de lo que hay que pagar en la venta de muebles
    SELECT precio
    INTO v_precio
    FROM Mueble
    WHERE ID_MUELBE = :NEW.ID_MUEBLE;

    v_subtotal:= v_precio * :NEW.CANTIDAD;
    --Una vez calculado entonces le hacemos UPDATE a la venta
    UPDATE VENTA
    SET SUBTOTAL = v_subtotal, IMPUESTO = (v_subtotal * 0.07), TOTAL = v_subtotal * 1.07
    WHERE NUM_FACTURA = :NEW.NUM_FACTURA;

END;




CREATE OR REPLACE TRIGGER actualizar_inventario_venta_mueble_cocina
AFTER INSERT OR UPDATE ON DETALLE_V_COCINAS
FOR EACH ROW
BEGIN
    UPDATE Mueble
    SET CANTIDAD = CANTIDAD - :NEW.CANTIDAD
    WHERE ID_MUEBLE = :NEW.ID_MUEBLE;

    --Ahora calculamos el subtotal de lo que hay que pagar en la venta de muebles
    SELECT precio
    INTO v_precio
    FROM Mueble
    WHERE ID_MUELBE = :NEW.ID_MUEBLE;

    v_subtotal:= v_precio * :NEW.CANTIDAD;
    --Una vez calculado entonces le hacemos UPDATE a la venta
    UPDATE VENTA
    SET SUBTOTAL = v_subtotal, IMPUESTO = (v_subtotal * 0.07), TOTAL = v_subtotal * 1.07
    WHERE NUM_FACTURA = :NEW.NUM_FACTURA;
END;