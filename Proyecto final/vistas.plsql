-- vista de compras
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

-- vista de clientes
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

-- vista de inventario 
CREATE OR REPLACE VIEW vista_inventario AS
SELECT
    m.id,
    m.tipo_mueble,
    T.NOMBRE,
    m.precio,
    f.id AS ID_Fabricante,
    f.nombre AS Fabricante,
    f.direccion AS Direccion
FROM 
    MUEBLE m
JOIN Fabricante f ON M.ID_fabricante = f.id JOIN TIPO_MUEBLE T ON M.TIPO_MUEBLE = T.ID_TIPO;


-- select * from cocina where id = 6; -- se usa en conjunto con ↓
CREATE OR REPLACE VIEW DETALLES_COCINA AS
SELECT
    ID_COCINA,
    ID_MUEBLE,
    TIPO_MUEBLE,
    NOMBRE,
    ME.CANTIDAD,
    COLOR,
    LINEA,
    ANCHO,
    ALTO,
    ALTURA,
    C_PESO,
    DIVISIONES,
    ALTURA_SUELO,
    NUM_DIVISIONES,
    MATERIAL,
    T_COMPONENTE,
    MAT_ENC
FROM 
MUEBLEENCOCINA ME JOIN MUEBLE M ON M.ID = ME.ID_MUEBLE JOIN TIPO_MUEBLE T ON M.TIPO_MUEBLE = T.ID_TIPO;
-- WHERE ME.ID_COCINA = 6; -- DEBE TENER ESTE WHERE!!!