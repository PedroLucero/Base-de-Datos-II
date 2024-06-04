/* PROGRAMA 1*/
SET SERVEROUTPUT ON

DECLARE
 /* Variable de salida para almacenar los resultados de la Consulta */
    V_STUDENTID STUDENTS.STUDENTID%TYPE;
    V_FIRSTNAME STUDENTS.FIRSTNAME%TYPE;
    V_LASTNAME  STUDENTS.LAST_NAME%TYPE;
 /* Valores de acoplamiento utilizado en la consulta */
    V_MAJOR     STUDENTS.MAJOR%TYPE := 'Computer Science';
 /* Declaración del Curso */
    CURSOR C_STUDENTS IS
    SELECT
        STUDENTID,
        FIRSTNAME,
        LAST_NAME
    FROM
        STUDENTS
    WHERE
        MAJOR = V_MAJOR;
BEGIN
 /* Identificar las filas en el conjunto activo y preparar el procesamiento ulterior de los datos */
    OPEN C_STUDENTS;
    LOOP
 /* Recuperar cada fila del conjunto active y almacenarlos en las variables PL/SQL */
        FETCH C_STUDENTS INTO V_STUDENTID, V_FIRSTNAME, V_LASTNAME;
 /* SI no hay más filas que recuperar, salir del bucle */
        EXIT WHEN C_STUDENTS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_STUDENTID
                             || ' '
                             || V_FIRSTNAME
                             || ' '
                             || V_LASTNAME
                             || ' '
                             || V_MAJOR);
    END LOOP;
 /* Liberar los recursos usados para la consulta */

    CLOSE C_STUDENTS;
END;
 -- Insercion de datos para trabajar el programa 1:
INSERT INTO STUDENTS(
    STUDENTID,
    FIRSTNAME,
    LAST_NAME,
    MAJOR
) VALUES (
    1,
    'Jose',
    'Hernandez',
    'Biotechnology'
), (
    2,
    'Arantxa',
    'Coronado',
    'Psychology'
), (
    3,
    'Rafaela',
    'Candanedo',
    'Computer Science'
);
 /*PROGRAMA 2*/
 CREATE TABLE CLASSES( ROOM_ID NUMBER, DEPARTMENT VARCHAR2(25), COURSE NUMBER );
INSERT INTO CLASSES(
    ROOM_ID,
    DEPARTMENT,
    COURSE
) VALUES (
    1,
    'HIS',
    101
);
INSERT INTO CLASSES(
    ROOM_ID,
    DEPARTMENT,
    COURSE
) VALUES (
    2,
    'HIS',
    101
);
INSERT INTO CLASSES(
    ROOM_ID,
    DEPARTMENT,
    COURSE
) VALUES (
    3,
    'SCI',
    301
);
SET SERVEROUTPUT ON
DECLARE
    V_ROOMID     CLASSES.ROOM_ID%TYPE;
    V_BUILDING   ROOMS.BUILDING%TYPE;
    V_DEPARTMENT CLASSES.DEPARTMENT%TYPE;
    V_COURSE     CLASSES.COURSE%TYPE;
    CURSOR C_BUILDING IS
    SELECT
        BUILDING
    FROM
        ROOMS,
        CLASSES
    WHERE
        ROOMS.ROOM_ID = CLASSES.ROOM_ID
        AND DEPARTMENT = V_DEPARTMENT
        AND COURSE = V_COURSE;
BEGIN
 -- Asignar las variables de Acoplamiento antes de abril el cursor
    V_DEPARTMENT := 'HIS';
    V_COURSE := 101;
 -- Abril el Cursor
    OPEN C_BUILDING;
 --Añadimos el valor del cursor a nuestra variable
    FETCH C_BUILDING INTO V_BUILDING;
 -- Reasignar las variables de acoplamiento – No tienen efecto alguno, ya que el cursor esta abierto
    V_DEPARTMENT := 'XXX';
    V_COURSE := -1;
    DBMS_OUTPUT.PUT_LINE(V_BUILDING);
 /* Si el resultado da Sistemas, quiere decir que el cursor uso los valores de las variables de acoplamiento que estaban definidas
    antes de abrir el cursor
*/
END;
 /*PROGRAMA 3*/

 SET SERVEROUTPUT ON
DECLARE
    CURSOR C_ALLCLASSES IS
    SELECT
        *
    FROM
        CLASSES;
    V_CLASSESRECORD C_ALLCLASSES%ROWTYPE;
BEGIN
    OPEN C_ALLCLASSES;
 /* Esta es una orden FECH correcta, que almacena la primera fila en el registro PL/SQL con una estructura iguala a
    la lista la selección de la consulta */
    FETCH C_ALLCLASSES INTO V_CLASSESRECORD;
    DBMS_OUTPUT.PUT_LINE( V_CLASSESRECORD.ROOM_ID
                          ||' '
                          ||V_CLASSESRECORD.DEPARTMENT
                          || ' '
                          || V_CLASSESRECORD.COURSE);
END;
 /*PROGRAMA 4*/

 SET SERVEROUTPUT ON
BEGIN
    UPDATE ROOMS
    SET
        NUMBER_SEATS = 100
    WHERE
        ROOM_ID = 99980;
 -- Si la anterior orden UPDATE no se aplica a ninguna fila, inserta una nueva fila en la tabla rooms.
    IF SQL%NOTFOUND THEN
        INSERT INTO ROOMS (
            ROOM_ID,
            NUMBER_SEATS
        ) VALUES (
            99980,
            100
        );
    END IF;
END;
 /* PROGRAMA 5 */

 SET SERVEROUTPUT ON
BEGIN
    UPDATE ROOMS
    SET
        NUMBER_SEATS = 100
    WHERE
        ROOM_ID = 99980;
 -- Si la anterior orden UPDATE no se aplica a ninguna fila, inserta una nueva fila en la tabla rooms.
    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO ROOMS (
            ROOM_ID,
            NUMBER_SEATS
        ) VALUES (
            99980,
            100
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ya existe una fila con ese ID');
    END IF;
END;
 /* PROGRAMA 6*/

 DECLARE
 -- Registro para almacenar la información acerca de una clase.
    V_ROOMDATA STUDENTS%ROWTYPE;
BEGIN
 -- Extraer la información sobre la clase ID -1
    SELECT
        * INTO V_ROOMDATA
    FROM
        STUDENTS
    WHERE
        STUDENTID = -1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO TEMP_TABLE (
            NUM_COL,
            CHAR_COL
        ) VALUES (
            5,
            'Not Found, Excpetion Handler'
        );
END;
 /* PROGRAMA 7*/

 CREATE TABLE REGISTERED_STUDENTS( STUDENTS_ID NUMBER, DEPARTMENT VARCHAR2(25), COURSE VARCHAR2(50) );
INSERT INTO STUDENTS(
    STUDENTID,
    FIRSTNAME,
    LAST_NAME,
    MAJOR
) VALUES(
    4,
    'Jesus',
    'Connolly',
    'History'
);
INSERT INTO STUDENTS(
    STUDENTID,
    FIRSTNAME,
    LAST_NAME,
    MAJOR
) VALUES(
    5,
    'Jorge',
    'Gonzalez',
    'History'
);
DECLARE
 /* Declaración de variables para almacenar información acerca de los estudiantes que cursan la especialidad de Historia */
    V_STUDENTID STUDENTS.STUDENTID%TYPE;
    V_FIRSTNAME STUDENTS.FIRSTNAME%TYPE;
    V_LASTNAME  STUDENTS.LAST_NAME%TYPE;
 -- Cursor para recuperar la informacion sobre los estudiantes de Historia
    CURSOR C_HISTORYSTUDENTS IS
    SELECT
        STUDENTID,
        FIRSTNAME,
        LAST_NAME
    FROM
        STUDENTS
    WHERE
        MAJOR = ('History');
BEGIN
 -- Abre el cursor e inicializa el conjunto activo
    OPEN C_HISTORYSTUDENTS;
    LOOP
 -- Recupera la información del siguiente estudiante
        FETCH C_HISTORYSTUDENTS INTO V_STUDENTID, V_FIRSTNAME, V_LASTNAME;
 -- Salida del bucle cuando no hay más filas por recuperar
        EXIT WHEN C_HISTORYSTUDENTS%NOTFOUND;
 /* Procesa las filas recuperadas. En este caso matricula a cada estudiante en Historia 301, insertándolo en la tabla registered_students.
        Registra también el nombre y el apellido en la tabla temp_table */
        INSERT INTO REGISTERED_STUDENTS (
            STUDENTS_ID,
            DEPARTMENT,
            COURSE
        ) VALUES (
            V_STUDENTID,
            'HIS',
            301
        );
        INSERT INTO TEMP_TABLE (
            NUM_COL,
            CHAR_COL
        ) VALUES (
            V_STUDENTID,
            V_FIRSTNAME
            || ''
            || V_LASTNAME
        );
    END LOOP;
 -- Libera los recursos utilizados por el curso
    CLOSE C_HISTORYSTUDENTS;
 -- Confirmamos el trabajo
 ---COMMIT;
END;
 /* PROGRAMA  8 */

 DECLARE
 /* Declaración de variables para almacenar información acerca de los estudiantes que cursan la especialidad de Historia */
    V_STUDENTID STUDENTS.STUDENTID%TYPE;
    V_FIRSTNAME STUDENTS.FIRSTNAME%TYPE;
    V_LASTNAME  STUDENTS.LAST_NAME%TYPE;
 -- Cursor para recuperar la información sobre los estudiantes de Historia
    CURSOR C_HISTORYSTUDENTS IS
    SELECT
        STUDENTID,
        FIRSTNAME,
        LAST_NAME
    FROM
        STUDENTS
    WHERE
        MAJOR = 'History';
BEGIN
 -- Abre el cursor e inicializa el conjunto activo
    OPEN C_HISTORYSTUDENTS;
    LOOP
 -- Recupera la información del siguiente estudiante
        FETCH C_HISTORYSTUDENTS INTO V_STUDENTID, V_FIRSTNAME, V_LASTNAME;
 /* Procesa las filas recuperadas. En este caso matricula a cada estudiante en Historia 301, insertándolo en la tabla registered_students.
            Registra también el nombre y el apellido en la tabla temp_table */
        INSERT INTO REGISTERED_STUDENTS (
            STUDENTS_ID,
            DEPARTMENT,
            COURSE
        ) VALUES (
            V_STUDENTID,
            'HIS',
            301
        );
        INSERT INTO TEMP_TABLE (
            NUM_COL,
            CHAR_COL
        ) VALUES (
            V_STUDENTID,
            V_FIRSTNAME
            || ' '
            || V_LASTNAME
        );
 -- Salida del bucle cuando no hay más filas por recuperar
        EXIT WHEN C_HISTORYSTUDENTS%NOTFOUND;
    END LOOP;
 -- Libera los recursos utilizados por el curso
    CLOSE C_HISTORYSTUDENTS;
 -- Confirmamos el trabajo
    COMMIT;
END;