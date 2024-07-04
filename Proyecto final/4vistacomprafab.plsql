CREATE OR REPLACE VIEW Vista_Compras AS
SELECT 
    c.id_compra AS ID_Compra,
    f.nombre AS Nombre_Fabricante,
    c.factura_fabricante AS Factura_Fabricante,
    c.fecha AS Fecha_Transaccion,
    u.nombre AS Nombre_Usuario,
    m.id AS ID_Mueble,
    m.color AS Color,
    m.linea AS Linea,
    m.ancho AS Ancho,
    m.alto AS Alto,
    m.precio AS Precio,
    dc.cantidad AS Cantidad_Comprada,
    (m.precio * dc.cantidad) AS Total_Compra
FROM 
    compra c
JOIN 
    fabricante f ON c.id_fabricante = f.id
JOIN 
    usuario u ON c.id_usuario = u.id
JOIN 
    detalle_compra dc ON c.id_compra = dc.id_compra
JOIN 
    mueble m ON dc.id_mueble = m.id
ORDER BY 
    f.nombre, c.fecha;
