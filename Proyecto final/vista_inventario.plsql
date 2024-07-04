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