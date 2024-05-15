DECLARE
 /* Declaración de las variables que se usan en este bloque */
 v_Num1 NUMBER := 1;
 v_Num2 NUMBER := 2;
 v_String1 VARCHAR(50) := ‘Hello World!’;
 v_String2 VARCHAR(50) := ‘ –This  message  brought to you by PL/SQL!’;
 V_OutputStr VARCHAR2(50);
 BEGIN
 /* Primero inserta dos filas  en temp_table, utilizando los valores de las variable */
 INSERT INTO temp_table (num_col, char_col) VALUES (v_num1, v_String1);
 INSERT INTO temp_table (num_col, char_col) VALUES (v_num2, v_String2);
 /*Ahora consulta temp_table para las dos filas que se acaban de insertar y las presenta en pantalla utilizando el paquete 
DBMS_OUTPUT ¨/
 SELECT  char_cal INTO v_OutputStar
 From temp_table
 WHERE num_col = v_num1;
 DBMS_OUTPUT.PUT_LINE(v_OutputStar);
 /*SELECT  char_cal INTO v_OutputStar
 From temp_table
 WHERE num_col = v_num2;
 DBMS_OUTPUT.PUT_LINE(v_OutputStar); */
 END;