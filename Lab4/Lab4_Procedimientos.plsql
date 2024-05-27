/*PROGRAMA 1*/

CREATE OR REPLACE PROCEDURE AddNewStudent (
    p_StudentID students.studentid%TYPE,
    p_CurrentCredits students.current_credits%TYPE;
    p_FirstName students.firstname%TYPE,
    p_LastName students.last_name%TYPE,
    p_Major students.major%TYPE ) AS
BEGIN
    -- Inserta una nueva fila en la tabla students. Usa
    -- student_sequience para generar el nuevo ID del estudiante y
    -- asigna el valor 0 a current_credits.
    INSERT INTO students (studentid, current_credits, firstname, last_name , major)
    VALUES ( student_sequence.next, p_CurrentCredits, p_FirstName, p_LastName, p_Major);
COMMIT;
END AddNewStudent;

BEGIN
    AddNewStudent('Jose', 'Hernandez','Software Engineering');
END;