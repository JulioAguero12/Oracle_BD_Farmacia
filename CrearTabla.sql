create table farmacia
(
    farmacia_ID INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY CHECK(farmacia_ID > 0),
    nombre varchar2(50) not null,
    direccion varchar2(100) not null,
    telefono varchar2(9),

    CONSTRAINT farmacia_id 
    PRIMARY KEY(farmacia_ID)
);
create unique index FARMACIA_UX_FARM_NOMBRE on FARMACIA(nombre);
create unique index FARMACIA_UX_FARM_DIRECCION on FARMACIA(direccion);
create unique index FARMACIA_UX_FARM_NUMTELEF on FARMACIA(telefono);

create table medico
(
    medico_id INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY CHECK(medico_id > 0),
    nombre varchar2(50) not null,
    especialidad varchar2(50) not null,
    años_experiencia INTEGER NOT NULL check(años_experiencia > 0),
    
    CONSTRAINT medico_id 
    PRIMARY KEY(medico_id)
);

create table paciente
(
    paciente_ID INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY CHECK(paciente_ID > 0),
    medico_id INTEGER NOT NULL,
    nombre varchar2(50) not null,
    direccion varchar2(100) not null,
    edad INTEGER NOT NULL CHECK(edad between 1 and 115),
    
    CONSTRAINT paciente_id 
    PRIMARY KEY(paciente_id),
    
    CONSTRAINT medico_id_fk 
    FOREIGN KEY(medico_id) 
    REFERENCES medico(medico_id) 
    on delete cascade
);

create table compañia_farmaceutica
(
    compañiaF_id INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY CHECK(compañiaF_id > 0),
    nombre varchar2(50) not null,
    telefono varchar2(9),
    
    CONSTRAINT compañia_id_pk 
    PRIMARY KEY(compañiaF_id)
);
create unique index COMPAÑIA_FARMACEUTICA_UX_COMPFARM_NOMBRE on compañia_farmaceutica(nombre);
create unique index compañia_farmaceutica_UX_telefono on compañia_farmaceutica(telefono);

create table contrato
(
	CompañiaF_ID number(10) not null,
	Farmacia_ID number(10) not null,
	fechainicio Date Default SYSDATE,
	fechafin Date Default SYSDATE,
	texto varchar2(1000),
	nombre_supervisor varchar2(50) not null,
	
    	CONSTRAINT Contratos_CH_Contr_FechaFinal_Contr_FechaIni 
    	CHECK(fechafin > fechainicio),
                
	CONSTRAINT compfarmPK  
    	PRIMARY KEY (CompañiaF_ID, Farmacia_ID),
    
	CONSTRAINT compañiaFK 
    	FOREIGN KEY(CompañiaF_ID) 
    	REFERENCES compañia_farmaceutica(compañiaF_id) 
    	on delete cascade,
    
    	CONSTRAINT farmaciaFK 
    	FOREIGN KEY(Farmacia_ID) 
    	REFERENCES farmacia(farmacia_ID) 
    	on delete cascade
);

create table medicamento
(
	CompañiaF_ID INTEGER not null,
	NombreComercial varchar2(50) not null,
	formula varchar2(50) not null,

	CONSTRAINT nombrecomerPK  
    PRIMARY KEY (CompañiaF_ID, NombreComercial),
    
	CONSTRAINT compFK 
    FOREIGN KEY(CompañiaF_ID) 
    REFERENCES  compañia_farmaceutica(compañiaF_id) 
    on delete cascade
);
create unique index Medicamentos_UX_MEDICAM_NOMBCOMERCIAL on medicamento(NombreComercial);

create table Venta
( 
    venta_id INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY,  
    Farmacia_ID number(10) not null,
    fecha Date Default SYSDATE,
    Paciente_ID number(10),
    
    CONSTRAINT venta_id_farmacia_id_pk 
    PRIMARY KEY(venta_id,farmacia_ID),
    
    CONSTRAINT farmacia_fk 
    FOREIGN KEY (Farmacia_ID)
    REFERENCES farmacia(farmacia_ID) 
    on delete cascade,
    
    CONSTRAINT pacientefk  
    FOREIGN KEY (Paciente_ID) 
    REFERENCES paciente(paciente_ID) 
    on delete cascade
);


create table stock
(
	Stock_Id INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY,  
    Farmacia_ID INTEGER not null,
	NombreComercial varchar2(50) not null,
	CompañiaF_ID INTEGER not null,
    precio number(4,2) not null,
	cantidad integer not null CHECK(cantidad > -1), 

	CONSTRAINT farmaFK 
    FOREIGN KEY (Farmacia_ID) 
    REFERENCES farmacia(farmacia_ID)
    on delete cascade,
    
	CONSTRAINT nomComFK 
    FOREIGN KEY (CompañiaF_ID,NombreComercial ) 
    REFERENCES medicamento(CompañiaF_ID,NombreComercial) 
    on delete cascade,
    
    CONSTRAINT contratoFK 
    FOREIGN KEY (farmacia_ID, CompañiaF_ID) 
    REFERENCES contrato(farmacia_ID, CompañiaF_ID) 
    on delete cascade,
    
    CONSTRAINT stockPK  
    PRIMARY KEY (Stock_Id,NombreComercial, CompañiaF_ID,precio,Farmacia_ID) 
    
);


create table Receta
(
	Receta_Id INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY,  
    Medico_ID number(10) not null,
	Paciente_ID number(10) not null,
	NombreComercial varchar2(50) not null,
	CompañiaF_ID number(10) not null,
	fecha DATE DEFAULT SYSDATE,
	cantidad INTEGER NOT NULL check (cantidad between 1 and 500),
	
	CONSTRAINT recetaPK  
    	PRIMARY KEY (Receta_Id),

	CONSTRAINT medFK 
    	FOREIGN KEY (Medico_ID) 
    	REFERENCES medico ( medico_id) 
    	on delete cascade,
    
	CONSTRAINT pacFK 
    	FOREIGN KEY (Paciente_ID) 
    	REFERENCES paciente ( paciente_ID) 
    	on delete cascade,
    
	CONSTRAINT comerNombreCompaFK 
    	FOREIGN KEY (NombreComercial, CompañiaF_ID) 
    	REFERENCES medicamento ( NombreComercial, compañiaF_id) 
    	on delete cascade
);

create table LineaVenta
(
    nrolineaventa INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY,  
    STOCK_ID INTEGER,
    venta_id INTEGER,
    FARMACIA_ID INTEGER,
    Nombrecomercial varchar2(50),
    CompañiaF_ID number(10) ,
    precio number(4,2),
    cntvendida INTEGER NOT NULL CHECK(cntvendida > 0),
    
    CONSTRAINT nombrecomCompañfk 
    FOREIGN KEY (nombrecomercial, CompañiaF_ID) 
    REFERENCES Medicamento(NombreComercial, CompañiaF_ID) 
    on delete cascade,
    
    CONSTRAINT ventaFK 
    FOREIGN KEY(venta_id,FARMACIA_ID) 
    REFERENCES Venta(venta_id,FARMACIA_ID)
    on delete cascade,
    
    CONSTRAINT stockFK 
    FOREIGN KEY (STOCK_ID,NombreComercial, CompañiaF_ID,precio,FARMACIA_ID) 
    REFERENCES STOCK(STOCK_ID,NombreComercial, CompañiaF_ID,precio,FARMACIA_ID)
    on delete cascade,
    
    CONSTRAINT lineaventapk
    PRIMARY KEY(nrolineaventa,venta_id)
);
