CREATE OR REPLACE VIEW vista_inventario AS
SELECT
    m.id,
    m.nombre,
    m.tipo_mueble,
    m.descripcion,
    m.precio,
    f.id AS ID_Fabricante,
    f.nombre AS Fabricante,
    f.direccion AS Direccion
FROM 
    MUEBLE m
JOIN Fabricante f ON v.ID_fabricante = f.id

