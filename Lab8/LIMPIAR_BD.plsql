DELETE FROM AUDITORIA_PRESTAMOS;
DELETE FROM SUCURSAL_TIPO_PRESTAMO;
DELETE FROM TRANSACPAGOS;
DELETE FROM PRESTAMO_CLIENTE;
DELETE FROM TELEFONO_CLIENTE;
DELETE FROM EMAIL_CLIENTES;
DELETE FROM CLIENTE;
DROP TABLE TIPO_PRESTAMO;
DROP TABLE TIPO_TELEFONO;
DROP TABLE TIPO_EMAIL;
DROP TABLE PROFESION_CLIENTE;
DELETE FROM SUCURSAL;
DELETE FROM USUARIO;

DROP SEQUENCE SEQ_CLIENTE;
DROP SEQUENCE SEQ_EMAIL;
DROP SEQUENCE SEQ_TELEFONO;
DROP SEQUENCE SEQ_PRESTAMO;
DROP SEQUENCE SEQ_AUDITORIAS;
DROP SEQUENCE SEQ_TRANSACCION;
DROP SEQUENCE SEQ_USUARIO;

--OJO SOLO SI QUIERES BORRAR LOS VALORES Y NO LAS TABLAS
DELETE FROM AUDITORIA_PRESTAMOS;
DELETE FROM AUDITORIA_PRESTAMOS;
DELETE FROM SUCURSAL_TIPO_PRESTAMO;
DELETE FROM TRANSACPAGOS;
DELETE FROM PRESTAMO_CLIENTE;
DELETE FROM TELEFONO_CLIENTE;
DELETE FROM EMAIL_CLIENTES;
DELETE FROM CLIENTE;
DELETE FROM SUCURSAL;
DELETE FROM USUARIO;

--Las tablas parametricas se mantienen igual