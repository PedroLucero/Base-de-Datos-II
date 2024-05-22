/*                                                      CURSORES                                                                         */


/* PROGRAMA 1*/
DECLARE
    /* Variable de salida para almacenar los resultados de la Consulta */
    v_StudentID students.id%TYPE;
    v_FirstName students.first_name%TYPE;
    v_ LastName students.last_name%TYPE;
    /* Valores de acoplamiento utilizado en la consulta */
    v_ Major students.major%TYPE := ‘Computer Science’;
    /* Declaración del Curso */
    CURSOR c_Students IS
    SELECT id, first_name, last_name
    FROM students
    WHERE major = v_Major;
BEGIN
    /* Identificar las filas en el conjunto activo y preparar el procesamiento ulterior de los datos */
    OPEN c_Students;
    LOOP
    /* Recuperar cada fila del conjunto active y almacenarlos en las variables PL/SQL */
    FETCH c_Students INTO v_StudentID, v_FirstName, v_ LastName;
    /* SI no hay más filas que recuperar, salir del bucle */
    EXIT WHEN c_Students%NOTFOUND;
    END LOOP;
    /* Liberar los recursos usados para la consulta */
    CLOSE c_Students;
END;






/*PROGRAMA 2*/


DECLARE
        v_RoomID classes.room_id%TYPE;
        v_Building rooms.buliding%TYPE;
        v_Department classes.department%TYPE;
        v_Course classes.course%TYPE;
        CURSOR c_Building IS
        SELECT building
        FROM rooms, classes
        WHERE rooms.room_id = classes.room_id
        AND department = v_Department
        AND course = v_Course;
BEGIN
    -- Asignar las variables de Acoplamiento antes de abril el cursor
    v_Department := ‘HIS’;
    v_Course _= 101;
    -- Abril el Cursor
    OPEN c_Building;
    -- Reasignar las variables de acoplamiento – No tienen efecto alguno, ya que el cursor esta abierto
    v_Department := ‘XXX’;
    v_Course := -1;
END;








/*PROGRAMA 3*/


DECLARE
    v_Department classes.department%TYPE;
    v_Course classes.course%TYPE;
    CURSOR c_AllClasses IS
    SELECT *
    FROM classes;
    v_ClassesRecord c_AllClasses%ROWTYPE;
BEGIN
    OPEN c_AllClasses;
    /* Esta es una orden FECH correcta, que almacena la primera fila en el registro PL/SQL con una estructura iguala a
    la lista la selección de la consulta */
    FETCH c_AllClasses INTO v_ClassesRecord;
    /* Esta orden FETCH es incorrecta, ya que la lista de la selección de la consulta devuelve 7 columnas de la tabla
    classes, y solo estamos almacenando en dos 2 variables: Estos dará un error de asignación de valores E-PLS-394 */
    FETCH c_AllClasses INTO v_Department, v_Course;
END;







/*PROGRAMA 4*/


BEGIN
    UPDATE rooms
    SET number_seats = 100
    WHERE room_id = 99980;
    -- Si la anterior orden UPDATE no se aplica a ninguna fila, inserta una nueva fila en la tabla rooms.
    IF SQL%NOTFOUND THEN
        INSERT INTO rooms ( room_id, number_seats)
        VALUES (99980, 100);
    END IF;
 END;








/* PROGRAMA 5 */
BEGIN
    UPDATE rooms
    SET number_seats = 100
    WHERE room_id = 99980;
    -- Si la anterior orden UPDATE no se aplica a ninguna fila, inserta una nueva fila en la tabla rooms.
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO rooms ( room_id, number_seats)
        VALUES (99980, 100);
    END IF;
 END;







/* PROGRAMA 6*/

DECLARE
 -- Registro para almacenar la información acerca de una clase.
 v_RoomData students%ROWTYPE;
BEGIN
 -- Extraer la información sobre la clase ID -1
 SELECT * INTO v_RoomData
 FROM students
 WHERE id = -1;
 /* La siguiente orden no se ejecutará nunca, ya que el control pasa inmediatamente al gestor de excepciones */
 IF SQL%NOTFOUND THEN
    INSERT INTO temp_table ( char_col) VALUES ( ‘Not Found’);
 END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    INSERT INTO temp_table ( num_col, char_col) VALUES ( 5, ‘Not Found, Excpetion Handler’);
END;






/* PROGRAMA 7*/

DECLARE
    /* Declaración de variables para almacenar información acerca de los estudiantes que cursan la especialidad de Historia */
    v_StudentID students.id%TYPE;
    v_FirstName students.first_name%TYPE;
    v_LastName students.las_name%TYPE;
    -- Cursor para recuperar la informacion sobre los estudiantes de Historia
    CURSOR c_HistoryStudents IS
    SELECT id, first_name, las_name
    FROM students
    WHERE major = ‘History’;

BEGIN
 -- Abre el cursor e inicializa el conjunto activo
OPEN c_HistoryStudents;
    LOOP
        -- Recupera la información del siguiente estudiante
        FETCH c_HistoryStudents INTO v_StudentID, v_FirstName, v_LastName ;
        -- Salida del bucle cuando no hay más filas por recuperar
        EXIT WHEN c_HistoryStudents%NOTFOUND ;
        /* Procesa las filas recuperadas. En este caso matricula a cada estudiante en Historia 301, insertándolo en la tabla registered_students.
        Registra también el nombre y el apellido en la tabla temp_table */
        INSERT INTO registered_students ( students_id, deparment, course)
        VALUES ( v_StudentID, ‘HIS’, 301);
        INSERT INTO temp_table ( num_col, char_col)
        VALUES ( v_studentID, v_FirstName || ‘ ‘|| v_LastName);
    END LOOP;
 -- Libera los recursos utilizados por el curso
 CLOSE c_HistoryStudents;
-- Confirmamos el trabajo
---COMMIT;
END;

/* PROGRAMA  8 */
DECLARE
    /* Declaración de variables para almacenar información acerca de los estudiantes que cursan la especialidad de Historia */
    v_StudentID students.id%TYPE;
    v_FirstName students.first_name%TYPE;
    v_LastName students.last_name%TYPE;
    -- Cursor para recuperar la información sobre los estudiantes de Historia
    CURSOR c_HistoryStudents IS
    SELECT id, first_name, last_name
    FROM students
    WHERE major = ‘History’;
BEGIN
 -- Abre el cursor e inicializa el conjunto activo
    OPEN c_HistoryStudents;
        LOOP
            -- Recupera la información del siguiente estudiante
            FETCH c_HistoryStudents INTO v_StudentID, v_FirstName, v_LastName ;
            /* Procesa las filas recuperadas. En este caso matricula a cada estudiante en Historia 301, insertándolo en la tabla registered_students.
            Registra también el nombre y el apellido en la tabla temp_table */
            INSERT INTO registered_students ( students_id, department, course)
            VALUES ( v_StudentID, ‘HIS’, 301);
            INSERT INTO temp_table ( numcol, char_col)
            VALUES ( v_studentID, v_FirstName || ‘ ‘|| v_LastName);
            -- Salida del bucle cuando no hay más filas por recuperar
            EXIT WHEN c_HistoryStudents%NOTFOUND ;
        END LOOP;
 -- Libera los recursos utilizados por el curso
 CLOSE c_HistoryStudents;
-- Confirmamos el trabajo
COMMIT;
END;




/* PROGRAMA 9 */

DECLARE
    -- Cursor para recuperar la información sobre los estudiantes de Historia
    CURSOR c_HistoryStudents IS
    SELECT id, first_name, last_name
    FROM students
    WHERE major = ‘History’;
    -- Declaración el registro para almacenar información extraída
    v_StudentData c_HistoryStudents%ROWTYPE;
BEGIN
 -- Abre el cursor e inicializa el conjunto activo
OPEN c_HistoryStudents;
    -- Recupera la información del siguiente estudiante
    FETCH c_HistoryStudents INTO v_StudentData;
    -- El bucle continua mientras haya mas filas que extraer
    WHILE c_HistoryStudents%FOUND LOOP
        /* Procesa las filas recuperadas. En este caso matricula a cada estudiante en Historia 301, insertándolo en la tabla
        registered_students. Registra también el nombre y el apellido en la tabla temp_table */
        INSERT INTO registered_students( students_id, department, course)
        VALUES ( v_StudentData.ID, ‘HIS’, 301);
        INSERT INTO temp_table ( numcol, char_col)
        VALUES ( v_StudentData.ID, v_StudentData.first_name || ‘ ‘|| v_StudentData.last_name);
        -- Recuperar la fila siguiente. La condición %FOUND se comprobara antes de que el bucle continúe
        FETCH c_HistoryStudents INTO v_StudentData;
    END LOOP;
    -- Libera los recursos utilizados por el curso
 CLOSE c_HistoryStudents;
-- Confirmamos el trabajo
COMMIT;
END;


/* PROGRAMA 10 */

DECLARE
    -- Cursor para recuperar la información sobre los estudiantes de Historia
    CURSOR c_HistoryStudents IS
    SELECT id, first_name, last_name
    FROM students
    WHERE major = ‘History’;
BEGIN
    /* Inicio del bucle. Aquí se ejecuta una orden OPEN
    implícita sobre c_HistoryStudents */
    FOR v_StudentData IN c_HistoryStudents LOOP
        -- Aquí se ejecuta una orden FETCH implícita
        /* Procesa las filas recuperadas. En este caso matricula a cada estudiante en Historia 301, insertándolo en la tabla
        registered_students. Registra también el nombre y el apellido en la tabla temp_table */
        INSERT INTO registered_students( students_id, department, course)
        VALUES ( v_StudentData.ID, ‘HIS’, 301);
        INSERT INTO temp_table ( numcol, char_col)
        VALUES ( v_StudentData.ID, v_StudentData.first_name || ‘ ‘|| v_StudentData.last_name);
        -- Antes de continuar con el bucle, aquí se hace una comprobacion implícita de c_HistoryStudents %NOTFOUND.
    END LOOP;
    -- Ahora el bucle ha terminado, se hace cierre implícito del cursor c_HistoryStudents
    -- Confirmamos el trabajo
    COMMIT;
END;


/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*********************************************************************************************************************************************************/
/*                                                      PROCEDIMIENTOS                                                                                    */





/*PROGRAMA 1*/

CREATE OR REPLACE PROCEDURE AddNewStudent (
    p_StudentID students.id%TYPE,
    p_FirstName students.first_name%TYPE,
    p_LastName students.last_name%TYPE
    p_Major students.major%TYPE ) AS
BEGIN
    -- Inserta una nueva fila en la tabla students. Usa
    -- student_sequience para generar el nuevo ID del estudiante y
    -- asigna el valor 0 a current_credits.
    INSERT INTO students (ID, first_name, last_name , major, current_credits)
    VALUES ( student_sequence.next, p_FirstName, p_LastName, p_Major, 0 );
COMMIT;
END AddNewStudent;


/* PROGRAMA 2*/

DECLARE
    -- Variables que describen al nuevo estudiante
    v_NewFirstName students.first_name%TYPE := ‘Margaret’;
    v_NewLastName students.last_name%TYPE := ‘Mason’;
    v_NewMajor students.major%TYPE := ‘History’;
BEGIN
    -- Añade Margaret Mason a la Base de Datos
    AddNewStudent (v_NewFirstName, v_NewLastName, v_NewMajor );
END;


/*PROGRAMA 3*/

CREATE OR REPLACE PROCEDURE ModeTest (
    p_InParameter IN NUMBER,
    p_OutParameter OUT NUMBER,
    p_InOutParamter IN OUT NUMBER) IS
    v_LocalVariable Number ;
BEGIN
    v_LocalVariable := p_InParameter;
    p_InParameter := 7;
    p_OutParameter := 7;
    v_LocalVariable := p_OutParameter;
    v_LocalVariable := p_InOutParameter;
    p_InOutParameter := 7;
END ModeTest;


/*PROGRAMA 4 */

CREATE OR REPLACE PROCEDURE ModeTest (
    p_InParameter IN NUMBER,
    p_OutParameter OUT NUMBER,
    p_InOutParamter IN OUT NUMBER) IS
    v_LocalVariable Number ;
BEGIN
    v_LocalVariable := p_InParameter;
    p_InParameter := 7;
    p_OutParameter := 7;
    v_LocalVariable := p_OutParameter;
    v_LocalVariable := p_InOutParameter;
    p_InOutParameter := 7;
END ModeTest;

-- Invocación No.1
DECLARE
 v_Variable1 NUMBER,
 v_Variable2 NUMBER,
BEGIN
 ModeTest(12, v_Variable1, v_variable2);
END;

--Invocación No. 2
DECLARE
 v_Variable1 NUMBER,
 v_Variable2 NUMBER,
BEGIN
 ModeTest(12, v_Variable1, 11);
END;


/*PROGRAMA 5*/

CREATE OR REPLACE PROCEDURE ParameterLength (
    p_Parameter1 IN OUT VARCHAR2,
    p_Parameter2 IN OUT NUMBER) AS
BEGIN
    p_Parameter1 := ‘abcdefghijklm;
    p_Parameter2 := 12.3;
END ParameterLength;



/* PROGRAMA 6 */

CREATE OR REPLACE PROCEDURE ParameterLength (
    p_Parameter1 IN OUT VARCHAR2,
    p_Parameter2 IN OUT NUMBER) AS
BEGIN
    p_Parameter1 := ‘abcdefghijklm;
    p_Parameter2 := 12.3;
END ParameterLength;


-- Invocación No.1
DECLARE
 v_Variable1 VARCHAR2(40);
 v_Variable2 NUMBER(3,4);
BEGIN
 ParameterLength(v_Variable1, v_variable2);
END;

-- Invocación No.2
DECLARE
 v_Variable1 VARCHAR2(10);
 v_Variable2 NUMBER(3,4);
BEGIN
 ParameterLength(v_Variable1, v_variable2);
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
    INSERT INTO students VALUES (student_sequence.nextval, p_FirstName, p_LastName, 0);
END AddNewStudent ;

-- Invocación No.1 – Notacion Posicional
BEGIN
AddNewStudent(‘Barbara’, ‘Blues’);
END;

-- Invocación No.2 – Con Notacion nominal
BEGIN
 AddNewStudent( p_Firstname => ‘Barbara’,
 p_LastName => ‘Blues’);
END;