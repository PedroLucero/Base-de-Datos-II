CREATE OR REPLACE VIEW ventas_clientes AS
SELECT 
    v.num_factura,
    v.SUBTOTAL,
    v.IMPUESTO,
    v.TOTAL,
    v.fecha_VENTA,
    c.nombre AS Cliente,
    c.direccion AS Direccion,
    c.telefono AS Telefono
FROM
    VENTA v 
JOIN Cliente c ON v.id_cliente = c.id