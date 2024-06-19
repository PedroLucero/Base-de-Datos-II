CREATE OR REPLACE TRIGGER trg_update_sucursal_tipoprestamo
AFTER INSERT OR UPDATE OR DELETE ON prestamo_cliente
FOR EACH ROW
DECLARE
    v_prestamo_activo NUMBER;
    v_monto_total_prestamos NUMBER;
BEGIN
    IF INSERTING OR UPDATING THEN
        -- Contar el número de préstamos activos de un tipo en una sucursal
        SELECT NVL(COUNT(*), 0) --Si el count es null devuelve cero
        INTO v_prestamo_activo  
        FROM prestamo_cliente
        WHERE cod_sucursal = :NEW.cod_sucursal 
          AND id_tipo_prestamo = :NEW.id_tipo_prestamo;
       
       --Calcular monto total de préstamos de ese tipo en esa sucursal
       SELECT NVL(SUM(monto), 0)
       INTO v_monto_total_prestamos
       FROM prestamo_cliente
       WHERE cod_sucursal = :NEW.cod_sucursal
          AND id_tipo_prestamo = :NEW.id_tipo_prestamo;
       
       -- Actualizar tabla sucursal_tipoprestamo
       IF 
       UPDATE sucursal_tipoprestamo(cod_sucursal, id_tipo_prestamo, prestamos_activos,monto) SET (:NEW.cod_sucursal, :NEW.id_tipo_prestamo, v_prestamo_activo, v_monto_total_prestamos);
       
       
               -- Actualizar o insertar en la tabla sucursal_tipoprestamo
        MERGE INTO sucursal_tipoprestamo st
        USING (SELECT :NEW.cod_sucursal AS cod_sucursal, :NEW.id_tipo_prestamo AS id_tipo_prestamo FROM dual) src
        ON (st.cod_sucursal = src.cod_sucursal AND st.id_tipo_prestamo = src.id_tipo_prestamo)
        WHEN MATCHED THEN
            UPDATE SET prestamo_activo = v_prestamo_activo, monto = v_monto_total_prestamos;
        WHEN NOT MATCHED THEN
            INSERT (cod_sucursal, id_tipo_prestamo, prestamo_activo, monto)
            VALUES (:NEW.cod_sucursal, :NEW.id_tipo_prestamo, v_prestamo_activo, v_monto_total_prestamos);
            