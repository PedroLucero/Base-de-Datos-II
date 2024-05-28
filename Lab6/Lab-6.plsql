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
    -- COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: Llave duplicada');
    WHEN VALUE_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('Esta operacion inválida');
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
    v_fila_cursor colaboradores%ROWTYPE;
    v_salario_mensual NUMBER;
    v_seguro_social NUMBER;
    v_seguro_educativo NUMBER;
    v_salario_neto NUMBER;

    CURSOR c_colaboradores IS
        SELECT *
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
        FETCH c_colaboradores INTO v_fila_cursor;
        EXIT WHEN c_colaboradores%NOTFOUND;

        v_salario_mensual := v_fila_cursor.salario_mensual;

        v_salario_quincenal := v_salario_mensual / 2; /*CONVERTIR ESTO A UNA FUNCION*/
        v_seguro_social := calcular_seguro_social(v_salario_mensual);
        v_seguro_educativo := calcular_seguro_educativo(v_salario_mensual);
        v_salario_neto := v_salario_quincenal - v_seguro_social - v_seguro_educativo; /*CONVERTIR ESTO A UNA FUNCION*/

        INSERT INTO salario_quincenal (id_salario, id_codcolaborador, fecha_pago, salario_quincenal, seguro_social, seguro_educativo, salario_neto)
        VALUES (salarios_sequence.NEXTVAL, v_fila_cursor.id_codcolaborador, v_fecha_pago, v_salario_quincenal, v_seguro_social, v_seguro_educativo, v_salario_neto);
    END LOOP;
    CLOSE c_colaboradores;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: Llave duplicada');
    WHEN VALUE_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('Esta operacion inválida');
END procesar_salarios_quincenales;
/* BLOQUE ANONIMOOOOOO*/
BEGIN


    -- Cargar colaborador
    cargar_colaboradores('Jose','Hernandez','8-1002-2448','M',TO_DATE('08-12-2003', 'DD-MM-YYYY'),TO_DATE('28-05-2024', 'DD-MM-YYYY'),'A',15000.00);

    cargar_colaboradores('Andres','Valdes','6-726-1938','M',TO_DATE('05-05-2003', 'DD-MM-YYYY'),TO_DATE('28-05-2024', 'DD-MM-YYYY'),'A', 25000);

    cargar_colaboradores('Rafaela', 'Black', '8-905-1651', 'F', TO_DATE('1996-05-23', 'yyyy-mm-dd'), TO_DATE('2024-05-21', 'yyyy-mm-dd'), 'A', 1501);

    cargar_colaboradores('Pedro', 'Lucero', '8-973-1067', 'M', TO_DATE('2001-09-01', 'yyyy-mm-dd'), TO_DATE('2024-05-22', 'yyyy-mm-dd'), 'A', 1500);
    
    cargar_colaboradores('Arantxa', 'Coronado', '2-752-1519', 'F', TO_DATE('2003-10-20', 'yyyy-mm-dd'), TO_DATE('2024-05-18', 'yyyy-mm-dd'), 'A', 1504);
    
    cargar_colaboradores('John', 'Johnson', '2-222-2222', 'M', TO_DATE('1999-02-02', 'yyyy-mm-dd'), TO_DATE('2023-11-11', 'yyyy-mm-dd'), 'V', 2500);

    cargar_colaboradores('Ramona', 'Gonzalez', '3-333-3333', 'F', TO_DATE('1998-03-03', 'yyyy-mm-dd'), TO_DATE('2023-10-10', 'yyyy-mm-dd'), 'V', 666);

    cargar_colaboradores('Juan', 'Perez', '1-111-1111', 'M', TO_DATE('2000-01-01', 'yyyy-mm-dd'), TO_DATE('2023-12-12', 'yyyy-mm-dd'), 'V', 2501);

    -- Procesar salarios quincenales para colaboradores activos
    procesar_salarios_quincenales('A'); --Aquí hay que ver si es insertado por consola

    DBMS_OUTPUT.PUT_LINE('Colaborador cargado y salarios quincenales calculados.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
