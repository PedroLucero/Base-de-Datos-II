CREATE OR REPLACE FUNCTION CALCULAR_INTERES(MONTO NUMBER, TASA NUMBER)
    RETURN NUMBER
    IS
    BEGIN
    RETURN MONTO * TASA/100;
END CALCULAR_INTERES;
/

CREATE OR REPLACE PROCEDURE RESULTADO_DE_PAGOS AS

    v_COD_SUCURSAL TRANSACPAGOS.COD_SUCURSAL%TYPE;
    v_ID_CLIENTE TRANSACPAGOS.ID_CLIENTE%TYPE;
    v_ID_TIPO_PRESTAMO TRANSACPAGOS.ID_TIPO_PRESTAMO%TYPE;
    v_PAGO TRANSACPAGOS.MONTO_DEL_PAGO%TYPE;
    v_SALDO PRESTAMO_CLIENTE.MONTO%TYPE;
    v_TASA TIPO_PRESTAMO.TASA%TYPE;
    v_FILA_TRANSAC TRANSACPAGOS%ROWTYPE;
    
    v_INTERES NUMBER;
    v_LETRA NUMBER;

    CURSOR C_DATOS_TRANSAC IS
    SELECT COD_SUCURSAL, ID_CLIENTE, ID_TIPO_PRESTAMO, MONTO_DEL_PAGO
    FROM TRANSACPAGOS;

BEGIN
    FOR v_FILA_TRANSAC IN C_DATOS_TRANSAC
    LOOP
        v_COD_SUCURSAL := v_FILA_TRANSAC.COD_SUCURSAL;
        v_ID_CLIENTE := v_FILA_TRANSAC.ID_CLIENTE;
        v_ID_TIPO_PRESTAMO := v_FILA_TRANSAC.ID_TIPO_PRESTAMO;
        v_PAGO := v_FILA_TRANSAC.MONTO_DEL_PAGO;
        
        -- conseguir el monto del préstamo
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Intentando obtener el monto del préstamo para el cliente ' || v_ID_CLIENTE || ' y el tipo de préstamo ' || v_ID_TIPO_PRESTAMO);
            -- Conseguir el monto del préstamo
            SELECT MONTO - MONTO_PAGADO, LETRA INTO v_SALDO, v_LETRA
            FROM PRESTAMO_CLIENTE P
            WHERE v_ID_CLIENTE = P.ID_CLIENTE AND v_ID_TIPO_PRESTAMO = P.ID_TIPO_PRESTAMO;
            DBMS_OUTPUT.PUT_LINE('Saldo actual del préstamo obtenido: ' || v_SALDO);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No se encontraron datos en PRESTAMO_CLIENTE para el cliente ' || v_ID_CLIENTE || ' y el tipo de préstamo ' || v_ID_TIPO_PRESTAMO);
                RAISE;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error inesperado al obtener el monto del préstamo: ' || SQLERRM);
                RAISE;
        END;

         -- conseguir tasa
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Intentando obtener la tasa para el tipo de préstamo ' || v_ID_TIPO_PRESTAMO);
            SELECT TASA INTO v_TASA
            FROM TIPO_PRESTAMO T
            WHERE v_ID_TIPO_PRESTAMO = T.ID_TIPO_PRESTAMO;
            DBMS_OUTPUT.PUT_LINE('Tasa obtenida: ' || v_TASA);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No se encontraron datos en TIPO_PRESTAMO para el tipo de préstamo ' || v_ID_TIPO_PRESTAMO);
                RAISE;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error inesperado al obtener la tasa: ' || SQLERRM);
                RAISE;
        END;

        v_INTERES := CALCULAR_INTERES(v_SALDO, v_TASA);

        -- restar el interés del pago o viceversa si es menor
        IF v_PAGO >= v_LETRA THEN
            v_INTERES := 0;
        END IF;

        UPDATE PRESTAMO_CLIENTE P
            SET MONTO_PAGADO = MONTO_PAGADO + v_PAGO, SALDOACTUAL = MONTO - MONTO_PAGADO - v_PAGO + v_INTERES -- Acomodado el saldo
        WHERE P.ID_CLIENTE = v_ID_CLIENTE AND P.ID_TIPO_PRESTAMO = v_ID_TIPO_PRESTAMO;

        UPDATE SUCURSAL S
            SET MONTOPRESTAMOS = MONTOPRESTAMOS + v_INTERES - v_PAGO
        WHERE S.COD_SUCURSAL = v_COD_SUCURSAL;
    END LOOP;

    -- EXCEPTION
    COMMIT;
    END RESULTADO_DE_PAGOS;
/


/*BLOQUE ANONIMO PARA PROBAR EL PROCEDIMIENTO*/


BEGIN
    RESULTADO_DE_PAGOS();
    DBMS_OUTPUT.PUT_LINE('Datos insertado correctamente');
END;
/