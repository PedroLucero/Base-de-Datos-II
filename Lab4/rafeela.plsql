/*PROGRAMA 3*/

CREATE OR REPLACE PROCEDURE ModeTest (
    p_InParameter IN NUMBER,
    p_OutParameter OUT NUMBER,
    p_InOutParameter IN OUT NUMBER) IS
    v_LocalVariable NUMBER;
BEGIN
    v_LocalVariable := p_InParameter;
    DBMS_OUTPUT.PUT_LINE('p_InParameter: '||p_InParameter);
    p_OutParameter := 7;
    v_LocalVariable := p_OutParameter;
    v_LocalVariable := p_InOutParameter;
    p_InOutParameter := 7;
END ModeTest;

--Invocación
DECLARE
 v_Variable1 NUMBER;
 v_Variable2 NUMBER;
BEGIN
 v_Variable2 := 11;
 ModeTest(12, v_Variable1, v_Variable2);
 DBMS_OUTPUT.PUT_LINE('v_Variable1: '||v_Variable1);
 DBMS_OUTPUT.PUT_LINE('v_Variable2: '||v_Variable2);
END;

/*PROGRAMA 5*/

CREATE OR REPLACE PROCEDURE ParameterLength (
    p_Parameter1 IN OUT VARCHAR2,
    p_Parameter2 IN OUT NUMBER) AS
BEGIN
    p_Parameter1 := 'abcdefghijklm';
    p_Parameter2 := 12.3;
END ParameterLength;

--Invocación
DECLARE
 v_Variable1 VARCHAR2(40);
 v_Variable2 NUMBER;
BEGIN
 ParameterLength(v_Variable1, v_Variable2);
 DBMS_OUTPUT.PUT_LINE('v_Variable1: '||v_Variable1);
 DBMS_OUTPUT.PUT_LINE('v_Variable2: '||v_Variable2);
END;

/* PROGRAMA 7 */

CREATE OR REPLACE PROCEDURE AddNewStudent (
    p_FirstName students.first_name%TYPE ,
    p_LastName students.last_name%TYPE ,
    p_Major students.major%TYPE DEFAULT ‘Economic’) AS
BEGIN
    -- Inserta una nueva fila en la tabla students. Usa student_sequence
    -- para generar el nuevo valor ID del estudiante y asigna el valor 0
    -- a current_credits
    INSERT INTO students (id, first_name, last_name, current_credits, major) VALUES (student_sequence.nextval, p_FirstName, p_LastName, 0,p_Major);
END AddNewStudent;

--Creacion de la secuencia
CREATE SEQUENCE student_sequence
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 99999
    MINVALUE 1;

-- Invocación No.1 – Notacion Posicional
BEGIN
AddNewStudent('Barbara', 'Blues');
END;

-- Invocación No.2 – Con Notacion nominal
BEGIN
 AddNewStudent( p_Firstname => 'Bruno',
 p_LastName => 'Alves');
END;