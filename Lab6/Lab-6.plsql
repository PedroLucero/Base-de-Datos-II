-- Procedimiento para cargar colaboradores
CREATE OR REPLACE PROCEDURE cargar_colaboradores(
    p_nombre Colaboradores.nombre%TYPE,
    p_apellido Colaboradores.apellido%TYPE,
    p_cedula Colaboradores.cedula%TYPE,
    p_sexo Colaboradores.sexo%TYPE,
    p_fecha_nacimiento Colaboradores.fecha_nacimiento%TYPE,
    p_fecha_ingreso Colaboradores.fecha_ingreso%TYPE,
    p_estatus Colaboradores.estatus%TYPE,
    p_salario_mensual Colaboradores.salario_mensual%TYPE
)
IS
BEGIN
    INSERT INTO Colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, estatus, salario_mensual)
    VALUES (colaboradores_sequence.NEXTVAL, p_nombre, p_apellido, p_cedula, p_sexo, p_fecha_nacimiento, p_fecha_ingreso, p_estatus, p_salario_mensual);
    COMMIT;
END cargar_colaboradores;

-- Función para calcular seguro social
CREATE OR REPLACE FUNCTION calcular_seguro_social(p_salario_mensual NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN p_salario_mensual * 0.0975;
END calcular_seguro_social;

-- Función para calcular seguro educativo
CREATE OR REPLACE FUNCTION calcular_seguro_educativo(p_salario_mensual NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN p_salario_mensual * 0.0125;
END calcular_seguro_educativo;

-- Procedimiento para calcular y cargar salarios quincenales
CREATE OR REPLACE PROCEDURE procesar_salarios_quincenales(p_estatus Colaboradores.estatus%TYPE)
IS
    v_fecha_pago DATE;
    v_salario_quincenal NUMBER;
    v_salario_mensual NUMBER;
    v_seguro_social NUMBER;
    v_seguro_educativo NUMBER;
    v_salario_neto NUMBER;

    CURSOR c_colaboradores IS
        SELECT id_codcolaborador, salario_mensual
        FROM Colaboradores
        WHERE estatus = p_estatus;
BEGIN
    -- Determinar fecha de pago
    IF TO_CHAR(SYSDATE, 'DD') < 30 THEN
        v_fecha_pago := TO_DATE(TO_CHAR(SYSDATE, 'YYYY') || '-' || TO_CHAR(SYSDATE, 'MM') || '-' || 30, 'YYYY-MM-DD');
    ELSIF TO_CHAR(SYSDATE, 'DD') < 15 THEN
        v_fecha_pago := TO_DATE(TO_CHAR(SYSDATE, 'YYYY') || '-' || TO_CHAR(SYSDATE, 'MM') || '-' || 15, 'YYYY-MM-DD');
    END IF;

    OPEN c_colaboradores;
    LOOP
        FETCH c_colaboradores INTO v_salario_mensual;
        EXIT WHEN c_colaboradores%NOTFOUND;

        v_salario_quincenal := v_salario_mensual / 2;
        v_seguro_social := calcular_seguro_social(v_salario_mensual);
        v_seguro_educativo := calcular_seguro_educativo(v_salario_mensual);
        v_salario_neto := v_salario_quincenal - v_seguro_social - v_seguro_educativo;

        INSERT INTO salario_quincenal (id_salario, id_codcolaborador, fecha_pago, salario_quincenal, seguro_social, seguro_educativo, salario_neto)
        VALUES (salarios_sequence.NEXTVAL, c_colaboradores%ROWID, v_fecha_pago, v_salario_quincenal, v_seguro_social, v_seguro_educativo, v_salario_neto);
    END LOOP;
    CLOSE c_colaboradores;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END procesar_salarios_quincenales;