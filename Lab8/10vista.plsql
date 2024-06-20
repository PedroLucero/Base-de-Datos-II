--VISTA 1 PENDIENTE
--VISTA 2 TRIGGER
CREATE OR REPLACE VIEW vw_sucursal AS
SELECT
    s.cod_sucursal,
    s.montoprestamos,
    pc.id_cliente,
    pc.id_tipo_prestamo,
    pc.monto,
    pc.saldoactual
FROM
    sucursal s
LEFT JOIN
    prestamo_cliente pc
ON
    s.cod_sucursal = pc.cod_sucursal;

--VISTA TRIGGER 3
CREATE OR REPLACE VIEW vw_stp AS
SELECT
    stp.cod_sucursal,
    stp.id_tipo_prestamo,
    stp.prestamos_activos,
    stp.saldo,
    pc.id_cliente,
    pc.saldoactual
FROM
    sucursal_tipoprestamo stp
LEFT JOIN
    prestamo_cliente pc
ON
    stp.cod_sucursal = pc.cod_sucursal
    AND stp.id_tipo_prestamo = pc.id_tipo_prestamo;

