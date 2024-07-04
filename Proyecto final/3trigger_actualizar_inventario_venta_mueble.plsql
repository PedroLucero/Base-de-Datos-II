CREATE OR REPLACE TRIGGER actualizar_inv_venta_mueble
AFTER INSERT OR UPDATE ON DETALLE_V_MUEBLES
FOR EACH ROW
DECLARE
    v_precio NUMBER;
    v_subtotal NUMBER;
    v_anterior_cantidad NUMBER;
    v_actual_cantidad NUMBER;
    v_usuario NUMBER;
BEGIN
    --Usuario de la Transaccion
    SELECT ID_USUARIO INTO v_usuario
    FROM VENTA
    WHERE num_factura = :NEW.num_factura;

    --Cantidad antes de insertar de la tabla mueble
    SELECT cantidad INTO v_anterior_cantidad FROM Mueble WHERE id = :NEW.id_mueble;

    UPDATE Mueble
    SET CANTIDAD = CANTIDAD - :NEW.CANTIDAD
    WHERE ID = :NEW.ID_MUEBLE;
    
    --Cantidad después de insertar en la tabla mueble
    SELECT cantidad INTO v_actual_cantidad FROM Mueble WHERE id = :NEW.id_mueble;

    -- Insertar un registro en la tabla de auditoría
    INSERT INTO Auditoria_Inventario (ID_AUDITORIA, ID_PRODUCTO, ANTERIOR_CANTIDAD, ACTUAL_CANTIDAD, OPERACION, USUARIO)
    VALUES (SEQ_AUDITORIA_INVENTARIO.NEXTVAL, :NEW.id_mueble, v_anterior_cantidad, v_actual_cantidad, 'V', v_usuario);

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
    v_anterior_cantidad NUMBER;
    v_actual_cantidad NUMBER;
    v_usuario NUMBER;
BEGIN
    --Usuario de la Transaccion
    SELECT ID_USUARIO INTO v_usuario
    FROM VENTA
    WHERE num_factura = :NEW.num_factura;
    --Cantidad antes de insertar de la tabla cocina
    SELECT inStock INTO v_actual_cantidad FROM Cocina WHERE id = :NEW.id_cocina;

    UPDATE COCINA
    SET INSTOCK = INSTOCK - :NEW.CANTIDAD
    WHERE ID = :NEW.ID_COCINA;
    --Cantidad despues de insertar de la tabla cocina
    SELECT inStock INTO v_actual_cantidad FROM Cocina WHERE id = :NEW.id_cocina;
    
    -- Insertar un registro en la tabla de auditoría
    INSERT INTO Auditoria_Inventario (ID_AUDITORIA, ID_PRODUCTO, ANTERIOR_CANTIDAD, ACTUAL_CANTIDAD, OPERACION, USUARIO)
    VALUES (SEQ_AUDITORIA_INVENTARIO.NEXTVAL, :NEW.id_cocina, v_anterior_cantidad, v_actual_cantidad, 'V', v_usuario);
    
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