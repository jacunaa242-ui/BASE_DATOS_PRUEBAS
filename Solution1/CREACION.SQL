--Estructura Base de Datos

use master

--1. Validar existencia base de datos

if DB_ID ('TURISMOPERU_JCAA') is not null

drop database TURISMOPERU_JCAA;

print 'La base de datos TURISMOPERU_JCAA Eliminada';

go



-- 2. Crear la base de datos

CREATE DATABASE TURISMOPERU_JCAA;

print 'Base de datos TURISMOPERU_JCAA creada correctamente';

go



--3. Usar la Base de datos TURISMOPERU_JCAA

use TURISMOPERU_JCAA;

print 'Base de Datos TURISMOPERU_JCAA Seleccionada';

go



--4. Crear Esquema de Tablas

CREATE SCHEMA JCAA;

GO

print 'Se creo el Esquema JCAA';

go



--5. Crear Estructura de la Tablas

-- Verificar existencia tabla

-- Create Table JCAA.Table

-- Identificando TABLAS



--Tabla Pais

if OBJECT_ID ('JCAA.pais', 'U') is not null

begin

DROP Table JCAA.pais;

print 'Tabla pais Eliminada';

end

go



CREATE TABLE JCAA.pais (

id_pais int identity(1,1) primary key,

nombrepais nvarchar(100) not null UNIQUE,

codigo_iso char(3) not null UNIQUE--e.g PER, USA, ESP, COL 

);

print 'Tabla Pais Creada Correctamente';

GO



if OBJECT_ID('JCAA.nacionalidad', 'U') is not null

begin

Drop Table JCAA.nacionalidad;

print 'Tabla Nacionalidad eliminada correctamente';

end

go



CREATE TABLE JCAA.nacionalidad (

id_nacionalidad int primary key,

nombrenacionalidad nvarchar(100) not null UNIQUE,

--Foreign Key

id_pais int null --Solo si aplica a pais reconocido

constraint FK_paisnacionalidad

Foreign key (id_pais) References JCAA.pais(id_pais)

);

print 'Tabla Nacionalidad Creada';

go



--Crea Tabla Departamento (Region)

if OBJECT_ID('JCAA.region', 'u') is not null

begin 

drop table JCAA.region;

print 'Tabla Region eliminada ';

end

go

CREATE TABLE JCAA.region (

id_region int,

nombreregion nvarchar(100) not null,

codigo_ubigeo char(3) not null UNIQUE, --CAJ, LIM, CUS

id_pais int not null

);

print 'Tabla Region Creada';

go



--Modificar la Tabla Region (Agregar id not null)

ALTER TABLE JCAA.region

ALTER COLUMN id_region int not null

print 'id_region actualizado como not null';

go



--Agregar PK a la tabla Region

ALTER TABLE JCAA.region

ADD CONSTRAINT PK_idregion

PRIMARY KEY (id_region)

print 'PK id_region asignado';

go



--Agregar FK id_pais a tabla Region

ALTER TABLE JCAA.region

add constraint FK_paisregion

Foreign key (id_pais) References JCAA.pais(id_pais)

print 'FK id_pais enlazado a region';

go



-- Crear tabla Subregion (provincias)

if OBJECT_ID('JCAA.subregion', 'U') is not null

begin

    Drop table JCAA.subregion;

    print 'Tabla Subregion eliminada';

end

go

CREATE TABLE JCAA.subregion (

    id_subregion int identity (1,1) primary key,

    nombresubregion nvarchar(100) not null,

    codigo_ubigeo char(4) not null UNIQUE,

    id_region int not null

    constraint FK_regionsubregion

    Foreign key (id_region) References JCAA.region(id_region)

);

print 'Tabla Subregion creada correctamente';

go



--Create table ciudad o distritos

if OBJECT_ID('JCAA.ciudad', 'U') is not null

begin

drop table JCAA.ciudad;

print 'Tabla Ciudad eliminada';

end

go



CREATE TABLE JCAA.ciudad (

id_ciudad int identity(1,1) primary key,

nombreciudad nvarchar(100) not null,

codigo_ubigeo char(4) not null UNIQUE,

id_subregion int not null

constraint FK_subregionciudad

Foreign key (id_subregion) References JCAA.subregion (id_subregion)

);

print 'Tabla ciudad Creada correctamente';

go



--Crear tabla Tipo documento

if OBJECT_ID('JCAA.tipo_documento', 'U') is not null

begin

Drop table JCAA.tipo_documento;

print 'Tabla Tipo Documento eliminada';

end

go



CREATE TABle JCAA.tipo_documento(

id_tipo_documento int identity(1,1) primary key,

nombredoc varchar(50) not null UNIQUE,

abreviatura char(10) not null UNIQUE

);

print 'Tabla Tipo Documento Creado';

go



if OBJECT_ID('JCAA.persona', 'U') is not null

begin

Drop Table JCAA.persona;

print 'Tabla Persona Eliminada';

end

go

-- Crear Tabla Persona

CREATE TABLE JCAA.persona(

    id_persona INT IDENTITY(1,1) PRIMARY KEY,

    tipo_persona CHAR(1) NOT NULL

    CHECK(tipo_persona IN ('N','J')), -- N=Natural J=Jurídica



    nombres VARCHAR(100),

    apaterno VARCHAR(100),

    amaterno VARCHAR(100),



    razon_social VARCHAR(150) not null,

    nombre_comercial VARCHAR(150) ,



    id_tipo_documento INT NOT NULL,

    numero_documento VARCHAR(20) NOT NULL,

    telefono VARCHAR(15),

    email VARCHAR(100),

    id_nacionalidad INT NOT NULL,

    estado VARCHAR(20) DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo')),

    fecha_registro DATETIME DEFAULT GETDATE(),



    CONSTRAINT uq_persona_documento

    UNIQUE(id_tipo_documento,numero_documento),



    FOREIGN KEY(id_tipo_documento)

    REFERENCES JCAA.tipo_documento(id_tipo_documento),



    FOREIGN KEY(id_nacionalidad)

    REFERENCES JCAA.nacionalidad(id_nacionalidad)

);

print 'Tabla Persona Creada';

go



--Crear Tabla Direccion

IF OBJECT_ID('JCAA.direccion', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.direccion;

    PRINT 'Tabla direccion eliminada.';

END

GO



CREATE TABLE JCAA.direccion (

    id_direccion int primary key identity(1,1),

id_ciudad int not null,

calle nvarchar(200), --e.g. Av. Atahualpa

numero nvarchar(20), --e.g. 1050

referencia TEXT, --e.g. Frente Capac Ñan

codigo_postal VARCHAR(10)

--Restriccion check

constraint chk_zip check (len(codigo_postal) between 5 and 10), --e.g. 06001

latitud DECIMAL(10,8),

    longitud DECIMAL(11,8),

    altitud DECIMAL(8,2),

    constraint FK_direccionciudad

foreign key (id_ciudad) references JCAA.ciudad(id_ciudad)

);

print 'Tabla Direccion Creada';

GO



--Crear tabla Cliente

if OBJECT_ID('JCAA.cliente', 'U') is not null

begin

Drop Table JCAA.cliente;

print 'Tabla Cliente Eliminada';

end

go

CREATE TABLE JCAA.cliente(

    id_persona INT PRIMARY KEY,

    fecha_nacimiento DATE,

    FOREIGN KEY(id_persona)

    REFERENCES JCAA.persona(id_persona)

);

print 'Tabla Cliente Creada';

go



--Crear tabla Direccion_Cliente

if OBJECT_ID('JCAA.direccion_cliente', 'U') is not null

begin

Drop Table JCAA.direccion_cliente;

print 'Tabla Direccion_cliente Eliminada';

end

go

CREATE TABLE JCAA.direccion_cliente(

    id_persona INT not null,

    id_direccion int not null,

    tipo_direccion VARCHAR(20)

    CHECK(tipo_direccion IN ('Casa','Trabajo','Facturacion','Entrega')),

    es_principal BIT DEFAULT 0,

    primary key (id_persona, id_direccion),

    FOREIGN KEY(id_persona)

    REFERENCES JCAA.cliente(id_persona),

    FOREIGN KEY(id_direccion)

    REFERENCES JCAA.direccion(id_direccion)

);

print 'Tabla Direccion Cliente Creada';

go



-- Cargos

IF OBJECT_ID('JCAA.cargo', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.cargo;

    PRINT 'Tabla cargo eliminada.';

END

GO

CREATE TABLE JCAA.cargo (

    id_cargo INT IDENTITY(1,1) PRIMARY KEY,

    nombre VARCHAR(50) NOT NULL UNIQUE,

    descripcion TEXT,

    salario_base DECIMAL(10,2) NOT NULL

);

print 'Tabla Cargo Creada';

GO



-- Empleado

IF OBJECT_ID('JCAA.empleado', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.empleado;

    PRINT 'Tabla empleado eliminada.';

END

GO

CREATE TABLE JCAA.empleado(

    id_persona INT PRIMARY KEY,

    id_cargo INT NOT NULL,

    fecha_contratacion DATE NOT NULL,

    salario DECIMAL(10,2) NOT NULL,

    FOREIGN KEY(id_persona)

    REFERENCES JCAA.persona(id_persona),

    FOREIGN KEY(id_cargo)

    REFERENCES JCAA.cargo(id_cargo)

);

print 'Tabla Empleado Creada';

GO



--Crear tabla Direccion_Empleado

if OBJECT_ID('JCAA.direccion_empleado', 'U') is not null

begin

Drop Table JCAA.direccion_empleado;

print 'Tabla direccion_empleado Eliminada';

end

go

CREATE TABLE JCAA.direccion_empleado(

    id_persona INT not null,

    id_direccion int not null,

    tipo_direccion VARCHAR(20)

    CHECK(tipo_direccion IN ('Casa','Trabajo','Facturacion','Entrega')),

    es_principal BIT DEFAULT 0,

    primary key (id_persona, id_direccion),

    FOREIGN KEY(id_persona)

    REFERENCES JCAA.empleado(id_persona),

    FOREIGN KEY(id_direccion)

    REFERENCES JCAA.direccion(id_direccion)

);

print 'Tabla Direccion Empleado Creada';

go



-- Categorías de Proveedor

IF OBJECT_ID('JCAA.categoria_proveedor', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.categoria_proveedor;

    PRINT 'Tabla categoria_proveedor eliminada.';

END

GO

CREATE TABLE JCAA.categoria_proveedor (

    id_categoria INT IDENTITY(1,1) PRIMARY KEY,

    nombrecategoriaproveedor VARCHAR(50) NOT NULL UNIQUE,

    descripcion TEXT

);

print 'Tabla Categoria_Proveedor Creada';

GO



-- Proveedor

IF OBJECT_ID('JCAA.proveedor', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.proveedor;

    PRINT 'Tabla Proveedor eliminada.';

END

GO

CREATE TABLE JCAA.proveedor(

    id_persona INT PRIMARY KEY,

    id_categoria INT NOT NULL,

    contacto_principal VARCHAR(100),

    calificacion DECIMAL(3,2) DEFAULT 0,

    FOREIGN KEY(id_persona)

    REFERENCES JCAA.persona(id_persona),

    FOREIGN KEY(id_categoria)

    REFERENCES JCAA.categoria_proveedor(id_categoria)

);

print 'Tabla Proveedor Creada';

GO



--Crear tabla Direccion_Proveedor

if OBJECT_ID('JCAA.direccion_proveedor', 'U') is not null

begin

Drop Table JCAA.direccion_proveedor;

print 'Tabla direccion_proveedor Eliminada';

end

go

CREATE TABLE JCAA.direccion_proveedor(

    id_persona INT not null,

    id_direccion int not null,

    tipo_direccion VARCHAR(20) NOT NULL

    CHECK (tipo_direccion IN ('Fiscal', 'Envio', 'Fisica', 'Correspondencia','Pago')),

    es_principal BIT DEFAULT 0,

    primary key (id_persona, id_direccion),

    FOREIGN KEY(id_persona)

    REFERENCES JCAA.proveedor(id_persona),

    FOREIGN KEY(id_direccion)

    REFERENCES JCAA.direccion(id_direccion)

);

print 'Tabla Direccion Proveedor Creada';

go



-- Tabla tipos alojamiento

IF OBJECT_ID('JCAA.tipo_alojamiento', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.tipo_alojamiento;

    PRINT 'Tabla Tipo_alojamiento eliminada.';

END

GO

CREATE TABLE JCAA.tipo_alojamiento (

    id_tipoalojamiento INT PRIMARY KEY IDENTITY(1,1),

    Nombre_Tipo VARCHAR(50) NOT NULL UNIQUE, -- 'Hotel', 'Casa de Campo', 'Hostal', 'Cabaña', 'Bed & Breakfast', 'Glamping', 'Apartamento'

    Descripcion TEXT,

    Icono_URL VARCHAR(255) -- Para mostrarlo en la web

);

print 'Tabla Tipo Alojamiento Creada';

GO



-- Tabla alojamiento 

IF OBJECT_ID('JCAA.alojamiento', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.alojamiento;

    PRINT 'Tabla Alojamiento eliminada.';

END

GO

CREATE TABLE JCAA.alojamiento (

    id_alojamiento INT PRIMARY KEY IDENTITY(1,1),

    id_tipoalojamiento INT NOT NULL,

    FOREIGN KEY (id_tipoalojamiento) REFERENCES JCAA.tipo_alojamiento(id_tipoalojamiento),

    

    Nombre VARCHAR(100) NOT NULL,

    Telefono VARCHAR(20),

    Email VARCHAR(100),

    Categoria_Estrellas TINYINT

    CHECK (Categoria_Estrellas BETWEEN 1 AND 5), -- Aplica solo a hoteles, pero puede ser NULL para otros

);



---

--Crear tabla Direccion_Alojamiento

if OBJECT_ID('JCAA.direccion_alojamiento', 'U') is not null

begin

Drop Table JCAA.direccion_alojamiento;

print 'Tabla direccion_alojamiento Eliminada';

end

go

CREATE TABLE JCAA.direccion_alojamiento(

    id_alojamiento INT not null,

    id_direccion int not null,

    tipo_direccion VARCHAR(20) not null DEFAULT 'Fisica' 

    CHECK (tipo_direccion IN ('Fisica', 'Referencia', 'Zona', 'Acceso_Principal', 'Acceso_Servicio')),

    Punto_Referencia TEXT,

    es_principal BIT DEFAULT 0,

    primary key (id_alojamiento, id_direccion),

    FOREIGN KEY(id_alojamiento)

    REFERENCES JCAA.alojamiento(id_alojamiento),

    FOREIGN KEY(id_direccion)

    REFERENCES JCAA.direccion(id_direccion)

);

print 'Tabla Direccion Alojamiento Creada';

go



--Tabla Proveedor Alojamiento

if OBJECT_ID('JCAA.proveedor_alojamiento', 'U') is not null

begin

Drop Table JCAA.proveedor_alojamiento;

print 'Tabla proveedor_alojamiento Eliminada';

end

go

CREATE TABLE JCAA.proveedor_alojamiento (

    id_proveedoralojamiento INT PRIMARY KEY IDENTITY(1,1),

    id_persona INT NOT NULL,

    id_alojamiento INT NOT NULL,

    FOREIGN KEY(id_alojamiento)

    REFERENCES JCAA.alojamiento(id_alojamiento),

    FOREIGN KEY(id_persona)

    REFERENCES JCAA.proveedor(id_persona),

);

print 'Tabla proveedor_alojamiento Creada';

go



-- Tipos de Habitación

IF OBJECT_ID('JCAA.tipo_habitacion', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.tipo_habitacion;

    PRINT 'Tabla tipo_habitacion eliminada.';

END

GO

CREATE TABLE JCAA.tipo_habitacion (

    id_tipo_habitacion INT IDENTITY(1,1) PRIMARY KEY,

    nombrehabitacion VARCHAR(50) NOT NULL UNIQUE,

    capacidad_personas INT NOT NULL,

    descripcion TEXT

);

print 'Tabla Tipo_Habitacion Creada';

GO



-- Habitaciones

IF OBJECT_ID('JCAA.habitacion', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.habitacion;

    PRINT 'Tabla habitacion eliminada.';

END

GO

CREATE TABLE JCAA.habitacion (

    id_habitacion INT IDENTITY(1,1) PRIMARY KEY,

    id_persona INT NOT NULL,

    id_alojamiento INT NOT NULL,

    numero_habitacion VARCHAR(10) NOT NULL,

    id_tipo_habitacion INT NOT NULL,

    precio_noche DECIMAL(10,2) NOT NULL,

    estado VARCHAR(20) DEFAULT 'Disponible' CHECK (estado IN ('Disponible', 'Ocupado', 'Mantenimiento', 'Fuera_servicio')),

    descripcion TEXT,

    CONSTRAINT unique_habitacion UNIQUE (id_persona, numero_habitacion, id_alojamiento),

    FOREIGN KEY (id_persona) REFERENCES JCAA.proveedor(id_persona),

    FOREIGN KEY (id_alojamiento) REFERENCES JCAA.alojamiento(id_alojamiento),

    FOREIGN KEY (id_tipo_habitacion) REFERENCES JCAA.tipo_habitacion(id_tipo_habitacion)

);

print 'Tabla Habitacion Creada';

GO



-- Lugares Turísticos

IF OBJECT_ID('JCAA.lugar_turistico', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.lugar_turistico;

    PRINT 'Tabla lugar_turistico eliminada.';

END

GO

CREATE TABLE JCAA.lugar_turistico (

    id_lugarturistico INT IDENTITY(1,1) PRIMARY KEY,

    nombre VARCHAR(150) NOT NULL,

    descripcion TEXT,

    precio_entrada DECIMAL(10,2) DEFAULT 0.00,

    horario_apertura TIME,

    horario_cierre TIME,

    calificacion DECIMAL(3,2) DEFAULT 0.00,

    estado VARCHAR(25) DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo', 'temporalmente_cerrado'))

);

print 'Tabla Lugar Turistico Creada';

GO



--Crear tabla Direccion_LugarTuristico

if OBJECT_ID('JCAA.direccion_lugarturistico', 'U') is not null

begin

Drop Table JCAA.direccion_lugarturistico;

print 'Tabla direccion_lugarturistico Eliminada';

end

go

CREATE TABLE JCAA.direccion_lugarturistico(

    id_lugarturistico INT not null,

    id_direccion int not null,

    tipo_direccion VARCHAR(20) not null DEFAULT 'Fisica' 

    CHECK (tipo_direccion IN ('Fisica', 'Referencia', 'Zona', 'Acceso_Principal', 'Acceso_Servicio')),

    Punto_Referencia TEXT,

    es_principal BIT DEFAULT 0,

    primary key (id_lugarturistico, id_direccion),

    FOREIGN KEY(id_lugarturistico)

    REFERENCES JCAA.lugar_turistico(id_lugarturistico),

    FOREIGN KEY(id_direccion)

    REFERENCES JCAA.direccion(id_direccion)

);

print 'Tabla Direccion Lugar Turistico Creada';

go



-- Tipos de Transporte

IF OBJECT_ID('JCAA.tipo_transporte', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.tipo_transporte;

    PRINT 'Tabla tipo_transporte eliminada.';

END

GO

CREATE TABLE JCAA.tipo_transporte (

    id_tipo_transporte INT IDENTITY(1,1) PRIMARY KEY,

    nombre VARCHAR(50) NOT NULL UNIQUE,

    descripcion TEXT

);

print 'Tabla Tipo_Transporte Creada';

GO



-- Vehículos

IF OBJECT_ID('JCAA.vehiculo', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.vehiculo;

    PRINT 'Tabla vehiculo eliminada.';

END

GO

CREATE TABLE JCAA.vehiculo (

    id_vehiculo INT IDENTITY(1,1) PRIMARY KEY,

    id_proveedor INT NOT NULL,

    placa VARCHAR(10) NOT NULL UNIQUE,

    id_tipo_transporte INT NOT NULL,

    marca VARCHAR(50),

    modelo VARCHAR(50),

    capacidad_pasajeros INT NOT NULL,

    año_fabricacion INT CONSTRAINT CHK_ANIO CHECK (año_fabricacion BETWEEN 1900 and YEAR(GETDATE())),

    precio_por_km DECIMAL(10,2),

    precio_por_hora DECIMAL(10,2),

    estado VARCHAR(20) DEFAULT 'Disponible' CHECK (estado IN ('Disponible', 'En_servicio', 'En_mantenimiento', 'Fuera_servicio')),

    FOREIGN KEY (id_proveedor) REFERENCES JCAA.proveedor(id_persona),

    FOREIGN KEY (id_tipo_transporte) REFERENCES JCAA.tipo_transporte(id_tipo_transporte)

);

print 'Tabla Vehiculo Creada';

GO



-- Tipos de Paquete

IF OBJECT_ID('JCAA.tipo_paquete', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.tipo_paquete;

    PRINT 'Tabla tipo_paquete eliminada.';

END

GO

CREATE TABLE JCAA.tipo_paquete (

    id_tipo_paquete INT IDENTITY(1,1) PRIMARY KEY,

    nombre VARCHAR(50) NOT NULL UNIQUE,

    descripcion TEXT

);

print 'Tabla Tipo_Paquete Creada';

GO



-- Paquetes

IF OBJECT_ID('JCAA.paquete', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.paquete;

    PRINT 'Tabla paquete eliminada.';

END

GO

CREATE TABLE JCAA.paquete (

    id_paquete INT IDENTITY(1,1) PRIMARY KEY,

    nombre VARCHAR(200) NOT NULL,

    descripcion TEXT,

    id_tipo_paquete INT NOT NULL,

    duracion_dias INT NOT NULL,

    duracion_noches INT NOT NULL,

    precio_base DECIMAL(10,2) NOT NULL,

    precio_por_persona_adicional DECIMAL(10,2) DEFAULT 0.00,

    capacidad_minima INT DEFAULT 1,

    capacidad_maxima INT DEFAULT 10,

    incluye_hospedaje BIT DEFAULT 0,

    incluye_transporte BIT DEFAULT 0,

    incluye_alimentacion BIT DEFAULT 0,

    incluye_guia BIT DEFAULT 0,

    estado VARCHAR(20) DEFAULT 'Activo' CHECK (estado IN ('Activo', 'Inactivo', 'Promocion')),

    fecha_creacion DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (id_tipo_paquete) REFERENCES JCAA.tipo_paquete(id_tipo_paquete)

);

print 'Tabla Paquete Creada';

GO



-- Medios de Pago

IF OBJECT_ID('JCAA.medio_pago', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.medio_pago;

    PRINT 'Tabla medio_pago eliminada.';

END

GO

CREATE TABLE JCAA.medio_pago (

    id_medio_pago INT IDENTITY(1,1) PRIMARY KEY,

    nombre VARCHAR(50) NOT NULL UNIQUE,

    tipo VARCHAR(30) NOT NULL CHECK (tipo IN ('Efectivo', 'Tarjeta', 'Transferencia', 'Billetera_digital')),

    comision_porcentaje DECIMAL(5,2) DEFAULT 0.00,

    estado VARCHAR(10) DEFAULT 'activo' CHECK (estado IN ('Activo', 'Inactivo'))

);

print 'Tabla Medio_Pago Creada';

GO



-- Estados de Reserva

IF OBJECT_ID('JCAA.estado_reserva', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.estado_reserva;

    PRINT 'Tabla estado_reserva eliminada.';

END

GO

CREATE TABLE JCAA.estado_reserva (

    id_estado_reserva INT IDENTITY(1,1) PRIMARY KEY,

    nombre VARCHAR(30) NOT NULL UNIQUE,

    descripcion text

);

print 'Tabla Estado_Reserva Creada';

GO



-- Reservas

IF OBJECT_ID('JCAA.reserva', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.reserva;

    PRINT 'Tabla reserva eliminada.';

END

GO

CREATE TABLE JCAA.reserva (

    id_reserva INT IDENTITY(1,1) PRIMARY KEY,

    codigo_reserva VARCHAR(20) NOT NULL UNIQUE,

    id_cliente INT NOT NULL,

    id_paquete INT NOT NULL,

    id_empleado INT NOT NULL,

    id_alojamiento INT NOT NULL,

    id_habitacion INT NOT NULL,

    fecha_reserva DATETIME DEFAULT GETDATE(),

    fecha_inicio DATE NOT NULL,

    fecha_fin DATE NOT NULL,

    numero_personas INT NOT NULL,

    precio_total DECIMAL(10,2) NOT NULL,

    adelanto DECIMAL(10,2) DEFAULT 0.00,

    saldo_pendiente DECIMAL(10,2) NOT NULL,

    id_estado_reserva INT NOT NULL,

    observaciones VARCHAR(500),

    FOREIGN KEY (id_cliente) REFERENCES JCAA.cliente(id_persona),

    FOREIGN KEY (id_paquete) REFERENCES JCAA.paquete(id_paquete),

    FOREIGN KEY (id_empleado) REFERENCES JCAA.empleado(id_persona),

    FOREIGN KEY (id_alojamiento) REFERENCES JCAA.alojamiento(id_alojamiento),

    FOREIGN KEY (id_habitacion) REFERENCES JCAA.habitacion(id_habitacion),

    FOREIGN KEY (id_estado_reserva) REFERENCES JCAA.estado_reserva(id_estado_reserva)

);

print 'Tabla Reserva Creada';

GO



-- Pagos

IF OBJECT_ID('JCAA.pago', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.pago;

    PRINT 'Tabla pago eliminada.';

END

GO

CREATE TABLE JCAA.pago (

    id_pago INT IDENTITY(1,1) PRIMARY KEY,

    id_reserva INT NOT NULL,

    id_medio_pago INT NOT NULL,

    monto DECIMAL(10,2) NOT NULL,

    fecha_pago DATETIME DEFAULT GETDATE(),

    numero_operacion VARCHAR(50),

    comprobante VARCHAR(100),

    estado VARCHAR(15) DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Confirmado', 'Rechazado', 'Anulado')),

    FOREIGN KEY (id_reserva) REFERENCES JCAA.reserva (id_reserva),

    FOREIGN KEY (id_medio_pago) REFERENCES JCAA.medio_pago(id_medio_pago)

);

print 'Tabla Pago Creada';

GO



-- Relación: paquete_lugares

IF OBJECT_ID('JCAA.paquete_lugar', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.paquete_lugar;

    PRINT 'Tabla paquete_lugar eliminada.';

END

GO

CREATE TABLE JCAA.paquete_lugar (

    id_paquete INT NOT NULL,

    id_lugarturistico INT NOT NULL,

    orden_visita INT DEFAULT 1,

    tiempo_visita_horas DECIMAL(4,2) DEFAULT 2.00,

    PRIMARY KEY (id_paquete, id_lugarturistico),

    FOREIGN KEY (id_paquete) REFERENCES JCAA.paquete(id_paquete) ON DELETE CASCADE,

    FOREIGN KEY (id_lugarturistico) REFERENCES JCAA.lugar_turistico(id_lugarturistico) ON DELETE CASCADE

);

print 'Tabla Paquete_Lugar Creada';

GO



-- Relación: paquete_hospedaje

IF OBJECT_ID('JCAA.paquete_hospedaje', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.paquete_hospedaje;

    PRINT 'Tabla paquete_hospedaje eliminada.';

END

GO

CREATE TABLE JCAA.paquete_hospedaje (

    id_paquete INT NOT NULL,

    id_proveedor INT NOT NULL,

    noches INT NOT NULL,

    precio_noche DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_paquete, id_proveedor),

    FOREIGN KEY (id_paquete) REFERENCES JCAA.paquete(id_paquete) ON DELETE CASCADE,

    FOREIGN KEY (id_proveedor) REFERENCES JCAA.proveedor(id_persona) ON DELETE CASCADE

);

print 'Tabla Paquete_Hospedaje Creada';

GO



-- Relación: reserva_habitaciones

IF OBJECT_ID('JCAA.reserva_habitacion', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.reserva_habitacion;

    PRINT 'Tabla reserva_habitacion eliminada.';

END

GO

CREATE TABLE JCAA.reserva_habitacion (

    id_reserva INT NOT NULL,

    id_habitacion INT NOT NULL,

    fecha_checkin DATE NOT NULL,

    fecha_checkout DATE NOT NULL,

    precio_noche DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_reserva, id_habitacion),

    FOREIGN KEY (id_reserva) REFERENCES JCAA.reserva(id_reserva) ON DELETE CASCADE,

    FOREIGN KEY (id_habitacion) REFERENCES JCAA.habitacion(id_habitacion) ON DELETE CASCADE

);

print 'Tabla Reserva_Habitacion Creada';

GO



-- Relación: reserva_transporte

IF OBJECT_ID('JCAA.reserva_transporte', 'U') IS NOT NULL

BEGIN

    DROP TABLE JCAA.reserva_transporte;

    PRINT 'Tabla reserva_transporte eliminada.';

END

GO

CREATE TABLE JCAA.reserva_transporte (

    id_reserva INT NOT NULL,

    id_vehiculo INT NOT NULL,

    fecha_servicio DATE NOT NULL,

    hora_inicio TIME NOT NULL,

    hora_fin TIME,

    punto_recojo VARCHAR(200),

    punto_destino VARCHAR(200),

    precio DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_reserva, id_vehiculo, fecha_servicio),

    FOREIGN KEY (id_reserva) REFERENCES JCAA.reserva(id_reserva) ON DELETE CASCADE,

    FOREIGN KEY (id_vehiculo) REFERENCES JCAA.vehiculo(id_vehiculo) ON DELETE CASCADE

);

print 'Tabla Reserva_Transporte Creada';

GO