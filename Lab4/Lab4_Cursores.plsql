/* PROGRAMA 1*/
SET SERVEROUTPUT ON
DECLARE
    /* Variable de salida para almacenar los resultados de la Consulta */
    v_StudentID students.studentid%TYPE;
    v_FirstName students.firstname%TYPE;
    v_LastName students.last_name%TYPE;
    /* Valores de acoplamiento utilizado en la consulta */
    v_Major students.major%TYPE := 'Computer Science';
    /* Declaración del Curso */
    CURSOR c_Students IS
    SELECT studentid, firstname, last_name
    FROM students
    WHERE major = v_Major;
BEGIN
    /* Identificar las filas en el conjunto activo y preparar el procesamiento ulterior de los datos */
    OPEN c_Students;
    LOOP
    /* Recuperar cada fila del conjunto active y almacenarlos en las variables PL/SQL */
    FETCH c_Students INTO v_StudentID, v_FirstName, v_LastName;
    /* SI no hay más filas que recuperar, salir del bucle */
    EXIT WHEN c_Students%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_StudentID || ' ' || v_FirstName || ' ' || v_LastName || ' ' || v_Major);
    END LOOP;
    /* Liberar los recursos usados para la consulta */
    CLOSE c_Students;
END;

-- Insercion de datos para trabajar el programa 1:
insert into students(studentid, firstname, last_name, major) values (1, 'Jose', 'Hernandez', 'Biotechnology'), (2,'Arantxa', 'Coronado','Psychology'), (3,'Rafaela','Candanedo','Computer Science');



/*PROGRAMA 2*/


CREATE TABLE classes(
    room_id NUMBER,
    department VARCHAR2(25),
    course NUMBER
);

insert into classes(room_id, department, course) values (1, 'HIS', 101);
insert into classes(room_id, department, course) values (2, 'HIS', 101);
insert into classes(room_id, department, course) values (3, 'SCI', 301);


set serveroutput on
DECLARE
        v_RoomID classes.room_id%TYPE;
        v_Building rooms.building%TYPE;
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
    v_Department := 'HIS';
    v_Course := 101;

    -- Abril el Cursor
    OPEN c_Building;


        --Añadimos el valor del cursor a nuestra variable
        FETCH c_Building INTO v_Building;

        -- Reasignar las variables de acoplamiento – No tienen efecto alguno, ya que el cursor esta abierto
        v_Department := 'XXX';
        v_Course := -1;

        DBMS_OUTPUT.PUT_LINE(v_Building);

    /* Si el resultado da Sistemas, quiere decir que el cursor uso los valores de las variables de acoplamiento que estaban definidas
    antes de abrir el cursor
*/

    
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