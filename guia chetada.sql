--Creación DB:
create database SistemaCocina
use SistemaCocina

-- INICIO CREACIÓN DE TABLAS --

create table Montador(
	id number primary key,
	nombre varchar2(20),
	direccion varchar2(50),
	telefono varchar2(15),
	num_cocina int
);

create table Cliente(
	id number primary key,
	nombre varchar2(20),
	direccion varchar2(50),
	telefono varchar2(15)
);

create table Distribuidor(
	id number primary key,
	nombre varchar2(20),
	direccion varchar2(50),
	fecha date
);

create table TelefonoDistribuidor(
	id_Distribuidor number,
	telefono varchar2(15),
	primary key(id_Distribuidor, telefono),
	foreign key (id_Distribuidor) references Distribuidor(id)
);

create table Fabricante(
	id number primary key,
	nombre varchar2(20),
	direccion varchar2(50),
	fecha date
);

create table TelefonoFabricante(
	id_Fabricante number,
	telefono varchar2(15),
	primary key(id_Fabricante, telefono),
	foreign key (id_Fabricante) references Fabricante(id)
);

create table Repartidor(
	id number primary key,
	nombre varchar2(20),
	correo varchar2(320),
	telefono varchar2(15)
);

create table Vehiculo(
	placa varchar2(7) primary key,
	anho number,
	tipo varchar2(20),
	capacidad number,
	modelo varchar2(20),
	marca varchar2(20)
);

create table MuebleCocina(
	id number primary key,
	color varchar2(20),
	linea varchar2(20),
	ancho decimal(3,1),
	alto decimal(3,1),
	tipo_mueble varchar2(20),
	altura decimal(10,1), --Mueble alto
	C_peso number,
	Divisiones number,
	Altura_suelo decimal(10,1), --Mueble bajo
	num_divisiones number,
	material varchar2(20), --Paneles
	t_componente varchar2(20),
	marmol bit, --Encimeras
	algomerado bit,
	ID_fabricante number,
	foreign key (ID_fabricante) references Fabricante(id)
);

create table Cocina(
	id number unique,
	numSerie number,
	primary key(id, numSerie),
	inStock number,
	nombre varchar2(20),
	numMuebles number,
	ID_repartidor number,
	ID_distribuidor number,
	foreign key (ID_repartidor) references Repartidor(id),
	foreign key (ID_distribuidor) references Distribuidor(id)
);

create table MuebleCocinaCocina(
	id_MuebleCocina number,
	id_Cocina number,
	primary key(id_MuebleCocina, id_Cocina),
	foreign key (id_MuebleCocina) references MuebleCocina(id),
	foreign key (id_Cocina) references Cocina(id)
);

create table CocinaMontador(
	id_Cocina number,
	id_Montador number,
	primary key(id_Cocina, id_Montador),
	foreign key (id_Cocina) references Cocina(id),
	foreign key (id_Montador) references Montador(id)
);

create table CocinaCliente(
	id_Cocina number,
	id_Cliente number,
	primary key(id_Cocina, id_Cliente),
	foreign key (id_Cocina) references Cocina(id),
	foreign key (id_Cliente) references Cliente(id)
);

create table VehiculoRepartidor(
	placa varchar2(7),
	id_Repartidor number,
	primary key(placa, id_Repartidor),
	foreign key (placa) references vehiculo(placa),
	foreign key (id_Repartidor) references Repartidor(id)
);

create table FabricanteDistribuidor(
	id_Fabricante number,
	id_Distribuidor number,
	primary key(id_Fabricante, id_Distribuidor),
	foreign key (id_Fabricante) references Fabricante(id),
	foreign key (id_Distribuidor) references Distribuidor(id)
);

-- FIN CREACI�N DE TABLAS --

--INICIO DE CARGA DE DATOS --

insert into Montador values(1, 'José Hernández', 'El Tecal', '6987-2323', 10);
insert into Montador values(2, 'Eloy Bárbara', 'Mogollón, distrito de Macaracas', '6038-0339', 27);
insert into Montador values(3, 'Carmina Cruz', 'Llano Grande, distrito de La Pintada', '6051-0332', 6);
insert into Montador values(4, 'Juan Clementina', 'David Este, distrito de David', '6029-0221', 17);
insert into Montador values(5, 'Laurentino Yoel', 'Metetí, distrito de Pinogana', '6067-0996', 27);
insert into Montador values(6, 'Justina Alfonso', 'Sorá, distrito de Chame', '6023-0662', 26);
insert into Montador values(7, 'Florinda Ana', 'Sabanagrande, distrito de Los Santos', '6090-0360', 18);
insert into Montador values(8, 'Rosenda Lolita', 'Monagrillo, distrito de Chitré', '6098-0751', 18);
insert into Montador values(9, 'Vito Anastacio', 'Los Asientos, distrito de Pedasí', '6046-0443', 33);
insert into Montador values(10, 'Melchor Ismael', 'Santa Ana, distrito de Los Santos', '6083-0819', 30);
insert into Montador values(11, 'Marita Ramiro', 'Mariabé, distrito de Pedasí', '6025-0705', 38);

insert into Cliente values(1, 'Estanislao Teresita', 'Juan Demóstenes Arosemena, distrito de Arraiján', '6057-0226');
insert into Cliente values(2, 'María de Jesús Chita', 'Unión Santeña, distrito de Chimán', '6087-0223');
insert into Cliente values(3, 'Jacinto Filiberto', 'Las Cruces, distrito de Los Santos', '6085-0742');
insert into Cliente values(4, 'Irene Alfredo', 'Llano Bonito, distrito de Chitré', '6008-0497');
insert into Cliente values(5, 'Fe Begoña', 'Los Pozos, distrito de Los Pozos', '6039-0539');
insert into Cliente values(6, 'Elías Romualdo', 'Purio, distrito de Pedasí', '6050-0246');
insert into Cliente values(7, 'Jonatan Modesto', 'Tijeras, distrito de Boquerón', '6010-0193');
insert into Cliente values(8, 'Reyna Carmelita', 'Bajo Boquete, distrito de Boquete', '6031-0678');
insert into Cliente values(9, 'Ainara Olegario', 'La Garceana, distrito de Montijo', '6006-0350');
insert into Cliente values(10, 'Odalis Hern�n', 'Santa Rosa, distrito de Bugaba', '6036-0419');

insert into Distribuidor values(1, 'Haydée Roxana', 'Las Tablas, distrito de Changuinola', '2020-3-25');
insert into Distribuidor values(2, 'Rodolfo Tere', 'Santa Ana, distrito de Los Santos', '2020-2-21');
insert into Distribuidor values(3, 'Eufemia Aitana', 'Nance de Riscó, distrito de Almirante', '2021-9-15');
insert into Distribuidor values(4, 'Rosalinda Salomón', 'Chepo, distrito de Las Minas', '2021-6-3');
insert into Distribuidor values(5, 'Ovidio Julia', 'San Martín de Porres, distrito de Las Palmas', '2020-2-1');
insert into Distribuidor values(6, 'Teodosio Mercedes', 'Finca 12, distrito de Changuinola', '2021-12-7');
insert into Distribuidor values(7, 'Anastacia Emma', 'Cochea, distrito de David', '2022-10-17');
insert into Distribuidor values(8, 'José Saúl', 'Los Algarrobos, distrito de Santiago', '2021-12-11');
insert into Distribuidor values(9, 'Nando Paulina', 'Cañazas, distrito de Cañazas', '2023-4-17');
insert into Distribuidor values(10, 'Carla Serafín', 'Cañas Gordas, distrito de Renacimiento', '2022-1-8');

insert into TelefonoDistribuidor values(4, '6085-0007');
insert into TelefonoDistribuidor values(10, '6097-0007');
insert into TelefonoDistribuidor values(1, '6003-0347');
insert into TelefonoDistribuidor values(7, '6022-0500');
insert into TelefonoDistribuidor values(10, '6017-0892');
insert into TelefonoDistribuidor values(5, '6091-0841');
insert into TelefonoDistribuidor values(8, '6028-0316');
insert into TelefonoDistribuidor values(5, '6083-0928');
insert into TelefonoDistribuidor values(8, '6098-0113');
insert into TelefonoDistribuidor values(9, '6016-0341');

insert into Fabricante values(1, 'Iván Ignacio', 'La Arena, distrito de Los Pozos', '2020-4-13');
insert into Fabricante values(2, 'Rolando Gregoria', 'La Raya de Santa María, distrito de Santiago', '2023-9-16');
insert into Fabricante values(3, 'Mayte Úrsula', 'Gobea, distrito de Donoso', '2023-1-22');
insert into Fabricante values(4, 'Arturo Miguel Ángel', 'Boca Chica, distrito de San Lorenzo', '2023-9-21');
insert into Fabricante values(5, 'Conrado Abilio', 'La Arena, distrito de Chitré', '2020-5-18');
insert into Fabricante values(6, 'Diana Flavia', 'Carlos Santana Ávila, distrito de Santiago', '2022-2-10');
insert into Fabricante values(7, 'Mauro Bruno', 'La Ensenada, distrito de Balboa', '2023-9-27');
insert into Fabricante values(8, 'Amílcar Eulogia', 'Bajo Corral, distrito de Las Tablas', '2023-11-13');
insert into Fabricante values(9, 'Toni Bernardino', 'Los Castillos, distrito de Río de Jesús', '2022-8-14');
insert into Fabricante values(10, 'Angelita Mauro', 'Don Bosco, distrito de Panamá', '2020-4-12');

insert into TelefonoFabricante values(10, '6073-0352');
insert into TelefonoFabricante values(5, '6097-0257');
insert into TelefonoFabricante values(6, '6057-0029');
insert into TelefonoFabricante values(4, '6054-0079');
insert into TelefonoFabricante values(10, '6093-0451');
insert into TelefonoFabricante values(1, '6056-0252');
insert into TelefonoFabricante values(9, '6009-0706');
insert into TelefonoFabricante values(8, '6011-0765');
insert into TelefonoFabricante values(9, '6005-0781');
insert into TelefonoFabricante values(9, '6092-0766');

insert into Repartidor values(1, 'Inocencio Ana', 'InocencioAna@sharklasers.com', '6008-0303');
insert into Repartidor values(2, 'Sebastián Cleto', 'SebastianCleto@yahoo.com', '6022-0074');
insert into Repartidor values(3, 'Amaro Valente', 'AmaroValente@hotmail.com', '6067-0727');
insert into Repartidor values(4, 'Fabio Sandra', 'FabioSandra@hotmail.com', '6052-0152');
insert into Repartidor values(5, 'Alexandra Eneida', 'AlexandraEneida@yahoo.com', '6048-0368');
insert into Repartidor values(6, 'Celso Mauricio', 'CelsoMauricio@utp.ac.pa', '6022-0861');
insert into Repartidor values(7, 'Evita Patricia', 'EvitaPatricia@yahoo.com', '6069-0187');
insert into Repartidor values(8, 'Manu Irene', 'ManuIrene@utp.ac.pa', '6002-0595');
insert into Repartidor values(9, 'Adelaida Gabino', 'AdelaidaGabino@hotmail.com', '6074-0854');
insert into Repartidor values(10, 'Valeria Yenny', 'ValeriaYenny@utp.ac.pa', '6034-0167');

insert into Vehiculo values('74LD0N1', '2011', 'Sedán', '5', 'Corolla','Toyota');
insert into Vehiculo values('54481X3', '2019', 'SUV', '5', 'Q3','Audi');
insert into Vehiculo values('8436183', '2020', 'SUV', '7', 'Caddy','Volkswagen');
insert into Vehiculo values('83Y0393', '2003', 'Sedán', '5', 'A4','Audi');
insert into Vehiculo values('49FF211', '2023', 'SUV', '7', 'XL7','Suzuki');
insert into Vehiculo values('831U905', '2014', 'Camioneta', '2', 'Strada','Mitsubishi');
insert into Vehiculo values('5239Z13', '2000', 'Sedán', '5', 'A4','Audi');
insert into Vehiculo values('9791964', '2007', 'Sedán', '5', 'Optima LX','Kia');
insert into Vehiculo values('10L2656', '2023', 'Motocicleta', '2', 'R3','Yamaha');
insert into Vehiculo values('J32T901', '2010', 'Motocicleta', '1', 'Piaggio','Vespa');

insert into MuebleCocina values(1, 'negro', 'Lorem', 21.0, 29.4, 'mueble bajo', NULL, NULL, NULL, 9, 4, NULL, NULL, NULL, NULL, 4);
insert into MuebleCocina values(2, 'gris', 'Aqua', 30.4, 14.3, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1);
insert into MuebleCocina values(3, 'negro', 'Lorem', 30.1, 16.9, 'mueble alto', 16.9, 259, 7, NULL, NULL, NULL, NULL, NULL, NULL, 1);
insert into MuebleCocina values(4, 'gris', 'Ambar', 17.4, 24.7, 'mueble alto', 24.7, 318, 5, NULL, NULL, NULL, NULL, NULL, NULL, 8);
insert into MuebleCocina values(5, 'verde', 'El Pollito Feliz', 16.4, 30.2, 'mueble alto', 30.2, 322, 1, NULL, NULL, NULL, NULL, NULL, NULL, 6);
insert into MuebleCocina values(6, 'azul', 'Ipsum', 16.2, 16.9, 'mueble alto', 16.9, 269, 2, NULL, NULL, NULL, NULL, NULL, NULL, 8);
insert into MuebleCocina values(7, 'negro', 'Sicilia', 15.2, 21.4, 'mueble alto', 21.4, 245, 2, NULL, NULL, NULL, NULL, NULL, NULL, 10);
insert into MuebleCocina values(8, 'verde', 'Sicilia', 16.4, 30.1, 'panel', NULL, NULL, NULL, NULL, NULL, 'vidrio', 13.5, NULL, NULL, 4);
insert into MuebleCocina values(9, 'negro', 'Ambar', 28.8, 13.2, 'mueble alto', 13.2, 269, 6, NULL, NULL, NULL, NULL, NULL, NULL, 10);
insert into MuebleCocina values(10, 'blanco', 'Ambar', 15.9, 28.1, 'mueble bajo', NULL, NULL, NULL, 7, 4, NULL, NULL, NULL, NULL, 2);
insert into MuebleCocina values(11, 'gris', 'Sicilia', 16.0, 17.2, 'panel', NULL, NULL, NULL, NULL, NULL, 'vidrio', 11.2, NULL, NULL, 1);
insert into MuebleCocina values(12, 'gris', 'Escarlata', 16.9, 23.8, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 3);
insert into MuebleCocina values(13, 'verde', 'Lorem', 27.5, 14.8, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 10);
insert into MuebleCocina values(14, 'negro', 'Ensambla', 11.2, 30.0, 'mueble bajo', NULL, NULL, NULL, 7, 5, NULL, NULL, NULL, NULL, 4);
insert into MuebleCocina values(15, 'marrón', 'Ambar', 24.0, 29.2, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 5);
insert into MuebleCocina values(16, 'verde', 'Ambar', 22.9, 14.6, 'mueble alto', 14.6, 351, 6, NULL, NULL, NULL, NULL, NULL, NULL, 7);
insert into MuebleCocina values(17, 'gris', 'El Pollito Feliz', 25.6, 30.3, 'mueble bajo', NULL, NULL, NULL, 9, 7, NULL, NULL, NULL, NULL, 6);
insert into MuebleCocina values(18, 'verde', 'Aqua', 27.8, 24.4, 'mueble alto', 24.4, 286, 6, NULL, NULL, NULL, NULL, NULL, NULL, 2);
insert into MuebleCocina values(19, 'gris', 'Sicilia', 17.1, 27.6, 'mueble bajo', NULL, NULL, NULL, 7, 6, NULL, NULL, NULL, NULL, 4);
insert into MuebleCocina values(20, 'blanco', 'Ipsum', 13.2, 24.7, 'mueble alto', 24.7, 367, 2, NULL, NULL, NULL, NULL, NULL, NULL, 9);
insert into MuebleCocina values(21, 'verde', 'Sicilia', 11.9, 15.2, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 3);
insert into MuebleCocina values(22, 'azul', 'Escarlata', 11.4, 15.8, 'mueble bajo', NULL, NULL, NULL, 5, 0, NULL, NULL, NULL, NULL, 5);
insert into MuebleCocina values(23, 'verde', 'Escarlata', 24.8, 14.9, 'mueble alto', 14.9, 379, 5, NULL, NULL, NULL, NULL, NULL, NULL, 4);
insert into MuebleCocina values(24, 'gris', 'Ambar', 20.4, 23.7, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 4);
insert into MuebleCocina values(25, 'verde', 'Lorem', 21.3, 17.1, 'mueble alto', 17.1, 391, 7, NULL, NULL, NULL, NULL, NULL, NULL, 6);
insert into MuebleCocina values(26, 'azul', 'Escarlata', 15.5, 21.3, 'mueble alto', 21.3, 278, 5, NULL, NULL, NULL, NULL, NULL, NULL, 6);
insert into MuebleCocina values(27, 'gris', 'Aqua', 26.7, 26.7, 'mueble alto', 26.7, 251, 6, NULL, NULL, NULL, NULL, NULL, NULL, 7);
insert into MuebleCocina values(28, 'negro', 'Lorem', 28.1, 23.3, 'panel', NULL, NULL, NULL, NULL, NULL, 'mármol', 21.7, NULL, NULL, 9);
insert into MuebleCocina values(29, 'negro', 'Ambar', 13.4, 10.2, 'mueble alto', 10.2, 271, 1, NULL, NULL, NULL, NULL, NULL, NULL, 8);
insert into MuebleCocina values(30, 'blanco', 'Ipsum', 10.5, 30.3, 'panel', NULL, NULL, NULL, NULL, NULL, 'madera', 14.5, NULL, NULL, 9);
insert into MuebleCocina values(31, 'marrón', 'Ensambla', 21.0, 26.0, 'mueble alto', 26.0, 272, 7, NULL, NULL, NULL, NULL, NULL, NULL, 5);
insert into MuebleCocina values(32, 'gris', 'Aqua', 12.5, 29.0, 'panel', NULL, NULL, NULL, NULL, NULL, 'madera', 7.9, NULL, NULL, 9);
insert into MuebleCocina values(33, 'verde', 'Ensambla', 30.2, 26.7, 'panel', NULL, NULL, NULL, NULL, NULL, 'madera', 17.7, NULL, NULL, 1);
insert into MuebleCocina values(34, 'azul', 'Ipsum', 23.0, 12.4, 'mueble bajo', NULL, NULL, NULL, 1, 5, NULL, NULL, NULL, NULL, 2);
insert into MuebleCocina values(35, 'blanco', 'Ambar', 22.2, 30.8, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 2);
insert into MuebleCocina values(36, 'azul', 'Ensambla', 26.7, 11.7, 'panel', NULL, NULL, NULL, NULL, NULL, 'madera', 13.4, NULL, NULL, 6);
insert into MuebleCocina values(37, 'negro', 'Ipsum', 20.1, 14.6, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 9);
insert into MuebleCocina values(38, 'gris', 'Lorem', 16.3, 21.1, 'mueble bajo', NULL, NULL, NULL, 6, 6, NULL, NULL, NULL, NULL, 3);
insert into MuebleCocina values(39, 'negro', 'El Pollito Feliz', 19.3, 19.9, 'mueble alto', 19.9, 265, 1, NULL, NULL, NULL, NULL, NULL, NULL, 3);
insert into MuebleCocina values(40, 'blanco', 'Ipsum', 21.5, 21.9, 'mueble alto', 21.9, 375, 7, NULL, NULL, NULL, NULL, NULL, NULL, 6);
insert into MuebleCocina values(41, 'gris', 'Aqua', 30.5, 11.9, 'mueble bajo', NULL, NULL, NULL, 0, 2, NULL, NULL, NULL, NULL, 7);
insert into MuebleCocina values(42, 'azul', 'Lorem', 27.3, 27.3, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1);
insert into MuebleCocina values(43, 'verde', 'Ensambla', 26.6, 25.6, 'mueble alto', 25.6, 352, 4, NULL, NULL, NULL, NULL, NULL, NULL, 1);
insert into MuebleCocina values(44, 'negro', 'El Pollito Feliz', 27.8, 12.6, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1);
insert into MuebleCocina values(45, 'negro', 'Ipsum', 22.8, 11.4, 'panel', NULL, NULL, NULL, NULL, NULL, 'porcelana', 17.3, NULL, NULL, 7);
insert into MuebleCocina values(46, 'negro', 'Aqua', 28.4, 19.1, 'panel', NULL, NULL, NULL, NULL, NULL, 'porcelana', 11.0, NULL, NULL, 8);
insert into MuebleCocina values(47, 'negro', 'Ambar', 14.3, 17.5, 'mueble bajo', NULL, NULL, NULL, 4, 6, NULL, NULL, NULL, NULL, 9);
insert into MuebleCocina values(48, 'verde', 'Lorem', 18.1, 28.4, 'mueble alto', 28.4, 334, 3, NULL, NULL, NULL, NULL, NULL, NULL, 5);
insert into MuebleCocina values(49, 'azul', 'Ensambla', 17.8, 15.7, 'mueble bajo', NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 3);
insert into MuebleCocina values(50, 'negro', 'Lorem', 14.3, 23.9, 'mueble alto', 23.9, 367, 5, NULL, NULL, NULL, NULL, NULL, NULL, 10);
insert into MuebleCocina values(51, 'marrón', 'Ipsum', 29.6, 26.6, 'mueble alto', 26.6, 358, 5, NULL, NULL, NULL, NULL, NULL, NULL, 7);
insert into MuebleCocina values(52, 'marrón', 'Lorem', 15.0, 28.4, 'mueble bajo', NULL, NULL, NULL, 5, 7, NULL, NULL, NULL, NULL, 9);
insert into MuebleCocina values(53, 'azul', 'Escarlata', 29.4, 12.3, 'panel', NULL, NULL, NULL, NULL, NULL, 'madera', 12.2, NULL, NULL, 5);
insert into MuebleCocina values(54, 'blanco', 'Ipsum', 26.6, 13.9, 'mueble bajo', NULL, NULL, NULL, 1, 6, NULL, NULL, NULL, NULL, 9);
insert into MuebleCocina values(55, 'azul', 'Aqua', 25.6, 26.4, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 7);
insert into MuebleCocina values(56, 'gris', 'Aqua', 29.1, 24.4, 'panel', NULL, NULL, NULL, NULL, NULL, 'vidrio', 9.0, NULL, NULL, 6);
insert into MuebleCocina values(57, 'marrón', 'Escarlata', 29.4, 16.8, 'mueble bajo', NULL, NULL, NULL, 1, 4, NULL, NULL, NULL, NULL, 6);
insert into MuebleCocina values(58, 'verde', 'Ensambla', 29.5, 17.3, 'encimera', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 10);
insert into MuebleCocina values(59, 'blanco', 'Ambar', 11.3, 20.1, 'panel', NULL, NULL, NULL, NULL, NULL, 'porcelana', 16.3, NULL, NULL, 2);
insert into MuebleCocina values(60, 'gris', 'Sicilia', 11.4, 25.5, 'panel', NULL, NULL, NULL, NULL, NULL, 'madera', 10.9, NULL, NULL, 9);

insert into Cocina values(1, 757, 27, 'Custodia', 3, 9, 4);
insert into Cocina values(2, 672, 8, 'Cristiana', 7, 2, 6);
insert into Cocina values(3, 269, 10, 'Narciso', 9, 3, 2);
insert into Cocina values(4, 823, 28, 'Denisse', 3, 10, 8);
insert into Cocina values(5, 635, 21, 'Dorsitte', 10, 1, 1);
insert into Cocina values(6, 553, 11, 'Eau duardo', 6, 5, 8);
insert into Cocina values(7, 203, 4, 'Ensamblat', 7, 3, 8);
insert into Cocina values(8, 291, 26, 'Serafín', 7, 5, 4);
insert into Cocina values(9, 230, 14, 'Aqua Lola', 6, 2, 2);
insert into Cocina values(10, 239, 13, 'Virtudes', 8, 10, 6);

insert into MuebleCocinaCocina values(24, 10);
insert into MuebleCocinaCocina values(21, 8);
insert into MuebleCocinaCocina values(42, 1);
insert into MuebleCocinaCocina values(56, 2);
insert into MuebleCocinaCocina values(52, 7);
insert into MuebleCocinaCocina values(15, 1);
insert into MuebleCocinaCocina values(43, 6);
insert into MuebleCocinaCocina values(19, 6);
insert into MuebleCocinaCocina values(51, 6);
insert into MuebleCocinaCocina values(42, 5);
insert into MuebleCocinaCocina values(42, 8);
insert into MuebleCocinaCocina values(24, 1);
insert into MuebleCocinaCocina values(37, 1);
insert into MuebleCocinaCocina values(30, 7);
insert into MuebleCocinaCocina values(55, 7);
insert into MuebleCocinaCocina values(60, 3);
insert into MuebleCocinaCocina values(20, 2);
insert into MuebleCocinaCocina values(5, 9);
insert into MuebleCocinaCocina values(47, 5);
insert into MuebleCocinaCocina values(42, 8);
insert into MuebleCocinaCocina values(39, 6);
insert into MuebleCocinaCocina values(58, 10);
insert into MuebleCocinaCocina values(4, 10);
insert into MuebleCocinaCocina values(29, 1);
insert into MuebleCocinaCocina values(57, 6);
insert into MuebleCocinaCocina values(33, 2);
insert into MuebleCocinaCocina values(7, 9);
insert into MuebleCocinaCocina values(47, 1);
insert into MuebleCocinaCocina values(46, 6);
insert into MuebleCocinaCocina values(44, 6);
insert into MuebleCocinaCocina values(11, 10);
insert into MuebleCocinaCocina values(3, 4);
insert into MuebleCocinaCocina values(17, 1);
insert into MuebleCocinaCocina values(6, 10);
insert into MuebleCocinaCocina values(7, 3);
insert into MuebleCocinaCocina values(39, 6);
insert into MuebleCocinaCocina values(35, 2);
insert into MuebleCocinaCocina values(28, 9);
insert into MuebleCocinaCocina values(16, 6);
insert into MuebleCocinaCocina values(10, 10);
insert into MuebleCocinaCocina values(53, 3);
insert into MuebleCocinaCocina values(2, 4);
insert into MuebleCocinaCocina values(17, 4);
insert into MuebleCocinaCocina values(23, 9);
insert into MuebleCocinaCocina values(38, 2);
insert into MuebleCocinaCocina values(33, 7);
insert into MuebleCocinaCocina values(57, 7);
insert into MuebleCocinaCocina values(7, 6);
insert into MuebleCocinaCocina values(32, 3);
insert into MuebleCocinaCocina values(31, 5);
insert into MuebleCocinaCocina values(33, 10);
insert into MuebleCocinaCocina values(35, 3);
insert into MuebleCocinaCocina values(16, 9);
insert into MuebleCocinaCocina values(27, 5);
insert into MuebleCocinaCocina values(46, 1);
insert into MuebleCocinaCocina values(43, 2);
insert into MuebleCocinaCocina values(37, 1);
insert into MuebleCocinaCocina values(24, 4);
insert into MuebleCocinaCocina values(56, 2);
insert into MuebleCocinaCocina values(8, 1);
insert into MuebleCocinaCocina values(51, 8);
insert into MuebleCocinaCocina values(12, 5);
insert into MuebleCocinaCocina values(41, 8);
insert into MuebleCocinaCocina values(54, 6);
insert into MuebleCocinaCocina values(26, 6);
insert into MuebleCocinaCocina values(59, 5);
insert into MuebleCocinaCocina values(21, 1);
insert into MuebleCocinaCocina values(20, 3);
insert into MuebleCocinaCocina values(23, 10);
insert into MuebleCocinaCocina values(31, 5);
insert into MuebleCocinaCocina values(19, 10);
insert into MuebleCocinaCocina values(20, 6);
insert into MuebleCocinaCocina values(33, 4);
insert into MuebleCocinaCocina values(36, 6);
insert into MuebleCocinaCocina values(18, 6);
insert into MuebleCocinaCocina values(26, 7);
insert into MuebleCocinaCocina values(45, 3);
insert into MuebleCocinaCocina values(31, 5);
insert into MuebleCocinaCocina values(47, 1);
insert into MuebleCocinaCocina values(51, 1);
insert into MuebleCocinaCocina values(37, 1);
insert into MuebleCocinaCocina values(9, 6);
insert into MuebleCocinaCocina values(10, 7);
insert into MuebleCocinaCocina values(34, 10);
insert into MuebleCocinaCocina values(27, 9);
insert into MuebleCocinaCocina values(53, 6);
insert into MuebleCocinaCocina values(12, 1);
insert into MuebleCocinaCocina values(30, 2);
insert into MuebleCocinaCocina values(50, 8);
insert into MuebleCocinaCocina values(15, 2);
insert into MuebleCocinaCocina values(23, 2);
insert into MuebleCocinaCocina values(46, 5);
insert into MuebleCocinaCocina values(60, 1);
insert into MuebleCocinaCocina values(7, 4);
insert into MuebleCocinaCocina values(56, 9);
insert into MuebleCocinaCocina values(19, 2);
insert into MuebleCocinaCocina values(18, 4);
insert into MuebleCocinaCocina values(26, 4);
insert into MuebleCocinaCocina values(25, 5);
insert into MuebleCocinaCocina values(43, 1);

insert into CocinaMontador values(6, 2);
insert into CocinaMontador values(10, 1);
insert into CocinaMontador values(7, 11);
insert into CocinaMontador values(5, 3);
insert into CocinaMontador values(10, 11);
insert into CocinaMontador values(1, 6);
insert into CocinaMontador values(7, 2);
insert into CocinaMontador values(2, 9);
insert into CocinaMontador values(5, 1);
insert into CocinaMontador values(5, 2);
insert into CocinaMontador values(7, 10);
insert into CocinaMontador values(9, 3);
insert into CocinaMontador values(3, 6);
insert into CocinaMontador values(8, 8);
insert into CocinaMontador values(3, 9);
insert into CocinaMontador values(5, 4);
insert into CocinaMontador values(1, 3);
insert into CocinaMontador values(8, 10);
insert into CocinaMontador values(7, 7);
insert into CocinaMontador values(3, 3);
insert into CocinaMontador values(6, 1);
insert into CocinaMontador values(5, 4);
insert into CocinaMontador values(5, 1);
insert into CocinaMontador values(1, 4);
insert into CocinaMontador values(2, 8);

insert into CocinaCliente values(8, 9);
insert into CocinaCliente values(7, 2);
insert into CocinaCliente values(2, 10);
insert into CocinaCliente values(4, 1);
insert into CocinaCliente values(10, 2);
insert into CocinaCliente values(1, 10);
insert into CocinaCliente values(2, 6);
insert into CocinaCliente values(4, 5);
insert into CocinaCliente values(7, 5);
insert into CocinaCliente values(3, 1);
insert into CocinaCliente values(10, 10);
insert into CocinaCliente values(9, 4);
insert into CocinaCliente values(3, 2);
insert into CocinaCliente values(5, 4);
insert into CocinaCliente values(9, 7);
insert into CocinaCliente values(10, 3);
insert into CocinaCliente values(8, 8);
insert into CocinaCliente values(4, 4);
insert into CocinaCliente values(3, 5);
insert into CocinaCliente values(8, 1);
insert into CocinaCliente values(8, 2);
insert into CocinaCliente values(9, 8);
insert into CocinaCliente values(8, 5);
insert into CocinaCliente values(8, 3);
insert into CocinaCliente values(4, 7);
insert into CocinaCliente values(10, 7);
insert into CocinaCliente values(7, 8);
insert into CocinaCliente values(2, 3);
insert into CocinaCliente values(2, 7);
insert into CocinaCliente values(10, 1);
insert into CocinaCliente values(8, 10);
insert into CocinaCliente values(4, 8);
insert into CocinaCliente values(8, 4);
insert into CocinaCliente values(4, 3);
insert into CocinaCliente values(2, 9);
insert into CocinaCliente values(6, 6);
insert into CocinaCliente values(6, 8);
insert into CocinaCliente values(4, 6);
insert into CocinaCliente values(9, 1);
insert into CocinaCliente values(4, 9);
insert into CocinaCliente values(5, 5);
insert into CocinaCliente values(3, 6);

insert into VehiculoRepartidor values('J32T901', 7);
insert into VehiculoRepartidor values('8436183', 4);
insert into VehiculoRepartidor values('54481X3', 6);
insert into VehiculoRepartidor values('9791964', 10);
insert into VehiculoRepartidor values('74LD0N1', 9);
insert into VehiculoRepartidor values('10L2656', 7);
insert into VehiculoRepartidor values('9791964', 3);
insert into VehiculoRepartidor values('J32T901', 1);
insert into VehiculoRepartidor values('J32T901', 5);
insert into VehiculoRepartidor values('831U905', 1);
insert into VehiculoRepartidor values('831U905', 8);
insert into VehiculoRepartidor values('J32T901', 9);
insert into VehiculoRepartidor values('54481X3', 8);
insert into VehiculoRepartidor values('10L2656', 5);
insert into VehiculoRepartidor values('10L2656', 6);
insert into VehiculoRepartidor values('831U905', 7);
insert into VehiculoRepartidor values('74LD0N1', 3);
insert into VehiculoRepartidor values('10L2656', 4);
insert into VehiculoRepartidor values('J32T901', 8);
insert into VehiculoRepartidor values('J32T901', 4);

insert into FabricanteDistribuidor values(9, 2);
insert into FabricanteDistribuidor values(1, 9);
insert into FabricanteDistribuidor values(10, 4);
insert into FabricanteDistribuidor values(10, 10);
insert into FabricanteDistribuidor values(1, 6);
insert into FabricanteDistribuidor values(10, 8);
insert into FabricanteDistribuidor values(8, 5);
insert into FabricanteDistribuidor values(6, 3);
insert into FabricanteDistribuidor values(9, 7);
insert into FabricanteDistribuidor values(1, 1);
insert into FabricanteDistribuidor values(9, 1);
insert into FabricanteDistribuidor values(7, 3);
insert into FabricanteDistribuidor values(10, 6);
insert into FabricanteDistribuidor values(7, 2);
insert into FabricanteDistribuidor values(6, 7);
insert into FabricanteDistribuidor values(2, 7);
insert into FabricanteDistribuidor values(10, 3);
insert into FabricanteDistribuidor values(8, 3);
insert into FabricanteDistribuidor values(10, 9);
insert into FabricanteDistribuidor values(6, 2);
insert into FabricanteDistribuidor values(7, 4);
insert into FabricanteDistribuidor values(4, 5);
insert into FabricanteDistribuidor values(2, 5);
insert into FabricanteDistribuidor values(6, 10);
insert into FabricanteDistribuidor values(3, 3);
insert into FabricanteDistribuidor values(3, 8);
insert into FabricanteDistribuidor values(10, 1);

-- FIN DE CARGA DE DATOS

-- INICIO DE CONSULTAS --

	-- Encontrar los vehiculos no usados
select * from Vehiculo where placa not in (select placa from VehiculoRepartidor);

	-- Repartidores sin vehiculo asignado
select * from Repartidor where id not in (select id_Repartidor from VehiculoRepartidor);

	-- Cocina menos vendida
select * from cocina where id in (SELECT top 1 id_cocina FROM CocinaCliente GROUP BY id_Cocina ORDER BY count(id_Cocina));

	-- Los 5 muebles m�s populares (en m�s cocinas)
select * from MuebleCocina where id in (select top 5  id_MuebleCocina from MuebleCocinaCocina group by id_MuebleCocina order by count(id_MuebleCocina) desc)

	-- Quien - o quienes - manejan la vespa, adem�s de sus datos?
select R.nombre, R.correo, R.telefono from Vehiculo V join VehiculoRepartidor VR on VR.placa = V.placa join Repartidor R on VR.id_Repartidor = R.id where marca = 'Vespa'

	-- M�s m�rmol o aglomerado?
select sum(cast(marmol as INT)) cantidadMarmol, sum(cast(algomerado as INT)) cantidadAglomerado from MuebleCocina where tipo_mueble = 'encimera'

	-- L�nea m�s popular de muebles
select top 2 linea MasPopular from MuebleCocina group by linea order by count(linea) desc --Hay empate!

	-- Cuantos muebles tiene El Pollito Feliz
select count(linea) cantidadPollito from MuebleCocina where linea = 'El Pollito Feliz'

-- FIN DE CONSULTAS--