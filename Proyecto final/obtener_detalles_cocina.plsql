CREATE OR REPLACE PROCEDURE obtener_detalles_cocina (
    p_id_cocina IN NUMBER,
    p_num_serie IN NUMBER
) AS
    CURSOR c_cocina IS
        SELECT 
            c.id AS cocina_id,
            c.numSerie AS num_serie,
            c.inStock AS en_stock,
            c.nombre AS cocina_nombre,
            c.numMuebles AS num_muebles
        FROM 
            Cocina c
        WHERE 
            c.id = p_id_cocina AND c.numSerie = p_num_serie;

    CURSOR c_muebles IS
        SELECT 
            m.id AS mueble_id,
            m.color AS mueble_color,
            m.linea AS mueble_linea,
            m.ancho AS mueble_ancho,
            m.alto AS mueble_alto,
            tm.NOMBRE AS tipo_mueble,
            m.altura AS mueble_altura,
            m.C_peso AS capacidad_peso,
            m.Divisiones AS num_divisiones,
            m.Altura_suelo AS altura_suelo,
            m.material AS material,
            m.t_componente AS tipo_componente,
            m.mat_enc AS material_encimera,
            f.nombre AS fabricante_nombre,
            f.direccion AS fabricante_direccion,
            f.fecha AS fabricante_fecha
        FROM 
            MuebleEnCocina mc
        JOIN 
            Mueble m ON mc.id_mueble = m.id
        JOIN 
            Fabricante f ON m.ID_fabricante = f.id
        JOIN 
            TIPO_MUEBLE tm ON m.tipo_mueble = tm.ID_TIPO
        WHERE 
            mc.id_cocina = p_id_cocina;
    
    -- Variables para almacenar los resultados de la cocina
    v_cocina_id NUMBER;
    v_num_serie NUMBER;
    v_en_stock NUMBER;
    v_cocina_nombre VARCHAR2(100);
    v_num_muebles NUMBER;

    -- Variables para almacenar los resultados de los muebles
    v_mueble_id NUMBER;
    v_mueble_color VARCHAR2(50);
    v_mueble_linea VARCHAR2(50);
    v_mueble_ancho NUMBER;
    v_mueble_alto NUMBER;
    v_tipo_mueble VARCHAR2(50);
    v_mueble_altura NUMBER;
    v_capacidad_peso NUMBER;
    v_num_divisiones NUMBER;
    v_altura_suelo NUMBER;
    v_material VARCHAR2(50);
    v_tipo_componente VARCHAR2(50);
    v_mat_enc char;
    v_fabricante_nombre VARCHAR2(100);
    v_fabricante_direccion VARCHAR2(100);
    v_fabricante_fecha DATE;
BEGIN
    -- Obtener los detalles de la cocina
    OPEN c_cocina;
    FETCH c_cocina INTO
        v_cocina_id, v_num_serie, v_en_stock, v_cocina_nombre, v_num_muebles;
    CLOSE c_cocina;

    -- Imprimir los detalles de la cocina
    DBMS_OUTPUT.PUT_LINE('Cocina ID: ' || v_cocina_id || ', Número de Serie: ' || v_num_serie);
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_cocina_nombre || ', En Stock: ' || v_en_stock);
    DBMS_OUTPUT.PUT_LINE('Número de Muebles: ' || v_num_muebles);

    -- Obtener y imprimir los detalles de los muebles
    OPEN c_muebles;
    LOOP
        FETCH c_muebles INTO
            v_mueble_id, v_mueble_color, v_mueble_linea, v_mueble_ancho, v_mueble_alto, v_tipo_mueble,
            v_mueble_altura, v_capacidad_peso, v_num_divisiones, v_altura_suelo, v_material, v_tipo_componente,
            v_mat_enc, v_fabricante_nombre, v_fabricante_direccion, v_fabricante_fecha;
        EXIT WHEN c_muebles%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Mueble ID: ' || v_mueble_id || ', Color: ' || v_mueble_color || ', Línea: ' || v_mueble_linea);
        DBMS_OUTPUT.PUT_LINE('Ancho: ' || v_mueble_ancho || ', Alto: ' || v_mueble_alto || ', Tipo: ' || v_tipo_mueble);
        DBMS_OUTPUT.PUT_LINE('Altura: ' || v_mueble_altura || ', Capacidad Peso: ' || v_capacidad_peso || ', Divisiones: ' || v_num_divisiones);
        DBMS_OUTPUT.PUT_LINE('Altura Suelo: ' || v_altura_suelo || ', Material: ' || v_material || ', Tipo Componente: ' || v_tipo_componente);
        DBMS_OUTPUT.PUT_LINE('Material de encimera: ' || v_mat_enc);
        DBMS_OUTPUT.PUT_LINE('Fabricante: ' || v_fabricante_nombre || ', Dirección: ' || v_fabricante_direccion || ', Fecha: ' || v_fabricante_fecha);
        DBMS_OUTPUT.PUT_LINE('---');
    END LOOP;
    CLOSE c_muebles;
END obtener_detalles_cocina;
/

--USAR
BEGIN
    obtener_detalles_cocina(6, 10101);
END;
/