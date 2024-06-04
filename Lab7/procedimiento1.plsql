CREATE OR REPLACE PROCEDURE tablas_parametricas AS

    BEGIN   

        /*INSERCIÓN DE LA TABLA Tipo_Telefono*/

        INSERT INTO Tipo_Telefono (ID_TIPO_TELEFONO, DESCRIPCION_TELEFONO) VALUES (1, "Personal");
        INSERT INTO Tipo_Telefono (ID_TIPO_TELEFONO, DESCRIPCION_TELEFONO) VALUES (2, "Hogar");
        INSERT INTO Tipo_Telefono (ID_TIPO_TELEFONO, DESCRIPCION_TELEFONO) VALUES (3, "Cónyugues");
        INSERT INTO Tipo_Telefono (ID_TIPO_TELEFONO, DESCRIPCION_TELEFONO) VALUES (4, "Familiar");
        INSERT INTO Tipo_Telefono (ID_TIPO_TELEFONO, DESCRIPCION_TELEFONO) VALUES (5, "Trabajo");

        /* INSERCIÓN DE LA TABLA Tipo_Email*/
        INSERT INTO Tipo_Email(ID_TIPO_EMAIL, DESCRIPCION_EMAIL) VALUES(1, "Personal");
        INSERT INTO Tipo_Email(ID_TIPO_EMAIL, DESCRIPCION_EMAIL) VALUES(2, "Trabajo");
        INSERT INTO Tipo_Email(ID_TIPO_EMAIL, DESCRIPCION_EMAIL) VALUES(3, "Institucional");

        /* INSERCIÓN DE LA TABLA PROFESIONES*/

        INSERT INTO Profesion_Cliente(ID_Profesion,Profesion) VALUES (1, "Médico");
        INSERT INTO Profesion_Cliente(ID_Profesion,Profesion) VALUES (2, "Profesor");
        INSERT INTO Profesion_Cliente(ID_Profesion,Profesion) VALUES (3, "Policía");
        INSERT INTO Profesion_Cliente(ID_Profesion,Profesion) VALUES (4, "Bombero");
        INSERT INTO Profesion_Cliente(ID_Profesion,Profesion) VALUES (5, "Experto en DBA");
        INSERT INTO Profesion_Cliente(ID_Profesion,Profesion) VALUES (6, "Otro");

        /* INSERCION DE LA TABLA Sucursal*/


        INSERT INTO Sucursal()


        /*INSERCION DE LA TABLA Tipo_Prestamo*/

        INSERT INTO Tipo_Prestamo(ID_TIPO_PRESTAMO, DESCRIPCION,TASA) VALUES(1, "Personal", 9.25);
        INSERT INTO Tipo_Prestamo(ID_TIPO_PRESTAMO, DESCRIPCION,TASA) VALUES(2, "Auto", 7.5);
        INSERT INTO Tipo_Prestamo(ID_TIPO_PRESTAMO, DESCRIPCION,TASA) VALUES(3, "Hipoteca", 5.25);
        INSERT INTO Tipo_Prestamo(ID_TIPO_PRESTAMO, DESCRIPCION,TASA) VALUES(4, "Garantizado con ahorros", 3.45);


    COMMIT;
    END tablas_parametricas;
