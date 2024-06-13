CREATE OR REPLACE PROCEDURE cargar_transacpagos(

    p_ID_TRANSACCION IN TRANSACPAGOS.ID_TRANSACCION%TYPE,
    p_COD_SUCURSAL   IN  TRANSACPAGOS.COD_SUCURSAL%TYPE,
    p_ID_CLIENTE IN TRANSACPAGOS.ID_CLIENTE%TYPE,
    p_ID_TIPO_PRESTAMO IN TRANSACPAGOS.ID_TIPO_PRESTAMO%TYPE,
    p_FECHATRANSACCION IN TRANSACPAGOS.FECHATRANSACCION%TYPE,
    p_MONTO_DEL_PAGO IN TRANSACPAGOS.MONTO_DEL_PAGO%TYPE,
    p_FECHAINSERCION IN TRANSACPAGOS.FECHAINSERCION%TYPE,
    p_ID_USUARIO IN TRANSACPAGOS.ID_USUARIO%TYPE) AS

    BEGIN
        INSERT INTO TRANSACPAGOS(ID_TRANSACCION,COD_SUCURSAL,ID_CLIENTE,ID_TIPO_PRESTAMO,FECHATRANSACCION,MONTO_DEL_PAGO,FECHAINSERCION,ID_USUARIO)
        VALUES (p_ID_TRANSACCION,p_COD_SUCURSAL,p_ID_CLIENTE,p_ID_TIPO_PRESTAMO,p_FECHATRANSACCION,p_MONTO_DEL_PAGO,p_FECHAINSERCION,p_ID_USUARIO);
    COMMIT;
END cargar_transacpagos;
/

/*Bloque anonimo para ejecutar el procedimiento*/

INSERT INTO usuario(ID_USUARIO,CEDULA_USUARIO,NOMBRE_USUARIO) VALUES(1, '8-1002-2448', 'Jose Hernadnez');
BEGIN
    
    
    cargar_transacpagos(1021,1,1,1,TO_DATE('24-07-2022', 'DD-MM-YYYY'),500.00, TO_DATE('24-07-2022 19:10:54', 'DD-MM-YYYY hh24:mi:ss'),1);
    cargar_transacpagos(1022,2,2,2,TO_DATE('06-04-2024', 'DD-MM-YYYY'),1200.40, TO_DATE('06-04-2024 2:54:25', 'DD-MM-YYYY hh24:mi:ss'),1);
    cargar_transacpagos(1023,3,3,3,TO_DATE('10-05-2023', 'DD-MM-YYYY'),400.00, TO_DATE('10-05-2023 15:30:09', 'DD-MM-YYYY hh24:mi:ss'),1);
    
END;
/