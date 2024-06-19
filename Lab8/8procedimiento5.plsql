CREATE OR REPLACE FUNCTION CALCULAR_INTERES(
    MONTO NUMBER,
    TASA NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN MONTO * TASA/100;
END CALCULAR_INTERES;
/

CREATE OR REPLACE PROCEDURE RESULTADO_DE_PAGOS AS
    V_COD_SUCURSAL     TRANSACPAGOS.COD_SUCURSAL%TYPE;
    V_ID_CLIENTE       TRANSACPAGOS.ID_CLIENTE%TYPE;
    V_ID_TIPO_PRESTAMO TRANSACPAGOS.ID_TIPO_PRESTAMO%TYPE;
    V_PAGO             TRANSACPAGOS.MONTO_DEL_PAGO%TYPE;
    V_SALDO            PRESTAMO_CLIENTE.MONTO%TYPE;
    V_TASA             TIPO_PRESTAMO.TASA%TYPE;
    V_FILA_TRANSAC     TRANSACPAGOS%ROWTYPE;
    V_INTERES          NUMBER;
    V_LETRA            NUMBER;
    CURSOR C_DATOS_TRANSAC IS
    SELECT
        COD_SUCURSAL,
        ID_CLIENTE,
        ID_TIPO_PRESTAMO,
        MONTO_DEL_PAGO
    FROM
        TRANSACPAGOS;
BEGIN
    FOR V_FILA_TRANSAC IN C_DATOS_TRANSAC LOOP
        V_COD_SUCURSAL := V_FILA_TRANSAC.COD_SUCURSAL;
        V_ID_CLIENTE := V_FILA_TRANSAC.ID_CLIENTE;
        V_ID_TIPO_PRESTAMO := V_FILA_TRANSAC.ID_TIPO_PRESTAMO;
        V_PAGO := V_FILA_TRANSAC.MONTO_DEL_PAGO;
 -- conseguir el monto del préstamo
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Intentando obtener el monto del préstamo para el cliente '
                                 || V_ID_CLIENTE
                                 || ' y el tipo de préstamo '
                                 || V_ID_TIPO_PRESTAMO);
 -- Conseguir el monto del préstamo
            SELECT
                MONTO - MONTO_PAGADO,
                LETRA INTO V_SALDO,
                V_LETRA
            FROM
                PRESTAMO_CLIENTE P
            WHERE
                V_ID_CLIENTE = P.ID_CLIENTE
                AND V_ID_TIPO_PRESTAMO = P.ID_TIPO_PRESTAMO;
            DBMS_OUTPUT.PUT_LINE('Saldo actual del préstamo obtenido: '
                                 || V_SALDO);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No se encontraron datos en PRESTAMO_CLIENTE para el cliente '
                                     || V_ID_CLIENTE
                                     || ' y el tipo de préstamo '
                                     || V_ID_TIPO_PRESTAMO);
                RAISE;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error inesperado al obtener el monto del préstamo: '
                                     || SQLERRM);
                RAISE;
        END;
 -- conseguir tasa
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Intentando obtener la tasa para el tipo de préstamo '
                                 || V_ID_TIPO_PRESTAMO);
            SELECT
                TASA INTO V_TASA
            FROM
                TIPO_PRESTAMO T
            WHERE
                V_ID_TIPO_PRESTAMO = T.ID_TIPO_PRESTAMO;
            DBMS_OUTPUT.PUT_LINE('Tasa obtenida: '
                                 || V_TASA);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No se encontraron datos en TIPO_PRESTAMO para el tipo de préstamo '
                                     || V_ID_TIPO_PRESTAMO);
                RAISE;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error inesperado al obtener la tasa: '
                                     || SQLERRM);
                RAISE;
        END;

        V_INTERES := CALCULAR_INTERES(V_SALDO, V_TASA);
 -- restar el interés del pago o viceversa si es menor
        IF V_PAGO >= V_LETRA THEN
            V_INTERES := 0;
        END IF;
        UPDATE PRESTAMO_CLIENTE P
        SET
            MONTO_PAGADO = MONTO_PAGADO + V_PAGO,
            SALDOACTUAL = MONTO - MONTO_PAGADO - V_PAGO + V_INTERES -- Acomodado el saldo
        WHERE
            P.ID_CLIENTE = V_ID_CLIENTE
            AND P.ID_TIPO_PRESTAMO = V_ID_TIPO_PRESTAMO;
        UPDATE SUCURSAL S
        SET
            MONTOPRESTAMOS = MONTOPRESTAMOS + V_INTERES - V_PAGO
        WHERE
            S.COD_SUCURSAL = V_COD_SUCURSAL;
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