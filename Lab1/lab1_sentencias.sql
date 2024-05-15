create table especialidad(
    id_especialidad number not null,
    especialidad varchar2(100) not null,
    constraint especialidad_pk primary key (id_especialidad)
);

create table profesor(
    id_profesor number not null,
    cedula_profesor varchar2(20) not null,
    p_nombre varchar2(25) not null,
    p_apellido varchar2(25) not null,
    p_especialidad number not null,
    constraint profesor_pk primary key (id_profesor),
    constraint profesor_fk_especialidad foreign key (p_especialidad) references especialidad (id_especialidad)
);

create table asignatura(
    cod_asignatura number not null,
    nombre varchar2(40) not null,
    profesor number not null,
    constraint asignatura_pk primary key (cod_asignatura),
    constraint asignatura_fk_profesor foreign key (profesor) references profesor (id_profesor)
);

create table alumno(
    n_matricula number not null,
    a_nombre varchar2(25) not null,
    a_apellido varchar2(25) not null,
    f_nacimiento date not null,
    constraint alumno_pk primary key (n_matricula)
);

create table curso_escolar(
    id_curso_escolar number not null,
    anho number not null,
    semestre char not null,
    fecha_inicio date not null,
    fecha_final date not null,
    constraint curso_escolar_pk primary key (id_curso_escolar)
);

create table telefono_alumno(
    telefono number not null,
    matricula number not null,
    constraint telefono_alumno_pk primary key (telefono, matricula),
    constraint telefono_alumno_fk_alumno foreign key (matricula) references alumno (n_matricula)
);

create table telefono_profesor(
    telefono number not null,
    profesor number not null,
    constraint telefono_profesor_pk primary key (telefono, profesor),
    constraint telefono_profesor_fk_profesor foreign key (profesor) references profesor (id_profesor)
);

create table matricula(
    a_matricula number not null,
    asignatura number not null,
    curso_escolar number not null,
    nota char not null,
    constraint matricula_pk primary key (a_matricula, asignatura, curso_escolar),
    constraint matricula_fk_alumno foreign key (a_matricula) references alumno (n_matricula),
    constraint matricula_fk_asignatura foreign key (asignatura) references asignatura (cod_asignatura),
    constraint matricula_fk_curso_escolar foreign key (curso_escolar) references curso_escolar (id_curso_escolar)
);

-- INSERTOS LOQUILLETES

insert into especialidad (id_especialidad, especialidad) values(1, 'Base de Datos');
insert into especialidad (id_especialidad, especialidad) values(2, 'Matematicas');
insert into especialidad (id_especialidad, especialidad) values(3, 'Programacion');
insert into especialidad (id_especialidad, especialidad) values(4, 'Gerencia de Proyectos');

insert into profesor (id_profesor, cedula_profesor, p_nombre, p_apellido, p_especialidad) values(1, '1-111-1111', 'Henry', 'Lezcano', 1);
insert into profesor (id_profesor, cedula_profesor, p_nombre, p_apellido, p_especialidad) values(2, '2-222-2222', 'Serafin', 'Prado', 2);
insert into profesor (id_profesor, cedula_profesor, p_nombre, p_apellido, p_especialidad) values(3, '3-333-3333', 'Paulo', 'Picota', 3);
insert into profesor (id_profesor, cedula_profesor, p_nombre, p_apellido, p_especialidad) values(4, '4-444-4444', 'Nilda', 'Yanguez', 4);

insert into asignatura (cod_asignatura, nombre, profesor) values(1, 'Implementacion de Base de Datos II', 1);
insert into asignatura (cod_asignatura, nombre, profesor) values(2, 'Ecuaciones Diferenciales Ordinarias', 2);
insert into asignatura (cod_asignatura, nombre, profesor) values(3, 'Programacion II', 4);
insert into asignatura (cod_asignatura, nombre, profesor) values(4, 'Metodologia de la Investigacion', 4);

    insert into alumno (n_matricula, a_nombre, a_apellido, f_nacimiento) values(1, 'Pedro', 'Lucero', TO_DATE('2001-09-01', 'yyyy-mm-dd'));
insert into alumno (n_matricula, a_nombre, a_apellido, f_nacimiento) values(2, 'Rafaela', 'Black', TO_DATE('1996-05-23', 'yyyy-mm-dd'));
insert into alumno (n_matricula, a_nombre, a_apellido, f_nacimiento) values(3, 'Jose', 'Hernandez', TO_DATE('2003-12-08', 'yyyy-mm-dd'));
insert into alumno (n_matricula, a_nombre, a_apellido, f_nacimiento) values(4, 'Andres', 'Valdes', TO_DATE('2004-06-03', 'yyyy-mm-dd'));
insert into alumno (n_matricula, a_nombre, a_apellido, f_nacimiento) values(5, 'Arntxa', 'Coronado', TO_DATE('2003-10-20', 'yyyy-mm-dd'));

insert into curso_escolar (id_curso_escolar, anho, semestre, fecha_inicio, fecha_final) values(1, 2023, '2', TO_DATE('2023-08-15', 'yyyy-mm-dd'), TO_DATE('2023-12-17', 'yyyy-mm-dd'));
insert into curso_escolar (id_curso_escolar, anho, semestre, fecha_inicio, fecha_final) values(2, 2024, '1', TO_DATE('2024-03-25', 'yyyy-mm-dd'), TO_DATE('2024-06-30', 'yyyy-mm-dd'));

insert into telefono_alumno (telefono, matricula) values(12345, 1);
insert into telefono_alumno (telefono, matricula) values(67890, 3);

insert into telefono_profesor (telefono, profesor) values(90876, 2);
insert into telefono_profesor (telefono, profesor) values(54321, 2);

insert into matricula (a_matricula, asignatura, curso_escolar, nota) values(1, 2, 1, 'D');
insert into matricula (a_matricula, asignatura, curso_escolar, nota) values(1, 2, 2, 'A');
insert into matricula (a_matricula, asignatura, curso_escolar, nota) values(2, 1, 1, 'A');
insert into matricula (a_matricula, asignatura, curso_escolar, nota) values(3, 4, 1, 'F');
insert into matricula (a_matricula, asignatura, curso_escolar, nota) values(3, 4, 2, 'C');
insert into matricula (a_matricula, asignatura, curso_escolar, nota) values(5, 4, 2, 'A');





-- AL-N-MATRICULA , AL-NOMBRE, AL-APELLIDO, AS-ASIGNATURA, M-NOTA, CE-AÑO, CE-SEMESTRE

create view lab1 as
select 
n_matricula as "id Estudiante",
a_nombre as "Nombre",
a_apellido as "Apellido",
nombre as "Asignatura",
nota as "Nota",
anho as "Año",
semestre as "Semestre"
from ((alumno join matricula on n_matricula = a_matricula) join asignatura on cod_asignatura = asignatura) join curso_escolar on id_curso_escolar = curso_escolar
order by anho, a_apellido, a_nombre;