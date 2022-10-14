


create or replace PACKAGE mostrarDatos_ops AS
    --Dada una farmacia, mostrar la informaci�n de sus contratos. (tabla contratos)
    PROCEDURE mostrarcontratosfarmacia (
        m_farmaid contrato.farmacia_id%TYPE
    );
    
    --Dada una compa�ia farmaceutica, mostrar la informaci�n de sus contratos. (tabla contratos)
    PROCEDURE mostrarcontratoscompa�ia (
        m_compaid contrato.compa�iaf_id%TYPE
    );

    --Dada una compa��a farmac�utica, mostrar la lista sus medicamentos.(tabla medicamento)
    PROCEDURE mostrarmedicamentoscompa�ia (
        s_compid medicamento.compa�iaf_id%TYPE
    );

    -- Dada una farmacia, mostrar la lista de sus medicamentos junto con la compa��a farmac�utica a la que pertenecen. (tabla stock)
    PROCEDURE mostrarfmc (
        s_farmaid stock.farmacia_id%TYPE
    );

    -- Dada una farmacia, mostrar sus ventas y sus totales por cada venta (por periodo de tiempo). (tabla ventas)
    PROCEDURE mostrarventasfarmacia (
        v_farmaid venta.farmacia_id%TYPE
    );

    --Dado un paciente, mostrar sus recetas registradas. (tabla recetas)
    PROCEDURE mostrarrecetaspaciente (
        r_pacid receta.paciente_id%TYPE
    );

END mostrarDatos_ops;
/
create or replace PACKAGE BODY mostrarDatos_ops AS

    --Dada una farmacia, mostrar la informaci�n de sus contratos. 
    PROCEDURE mostrarcontratosfarmacia (
        m_farmaid contrato.farmacia_id%TYPE
    ) AS
        CURSOR farma_contrato IS
        SELECT
            f.nombre              AS farma,
            c.nombre              AS compa�ia,
            t.fechainicio         AS inicio,
            t.fechafin            AS fin,
            t.texto               AS text,
            t.nombre_supervisor   AS super
        FROM
            farmacia                f,
            compa�ia_farmaceutica   c,
            contrato                t
        WHERE
            t.farmacia_id = m_farmaid
            AND f.farmacia_id = t.farmacia_id
            AND c.compa�iaf_id = t.compa�iaf_id;

    BEGIN
        FOR fc IN farma_contrato LOOP
            dbms_output.put_line('la farmacia '
                                 || fc.farma
                                 || ' tiene contrato la compa�ia '
                                 || fc.compa�ia
                                 || ', Fecha Inicial-> '
                                 || fc.inicio
                                 || ', Fecha Final-> '
                                 || fc.fin
                                 || ', Descripcion-> '
                                 || fc.text
                                 || ', Supervisor-> '
                                 || fc.super);
        END LOOP;
    END mostrarcontratosfarmacia;
    

    --Dada una compa�ia farmaceutica, mostrar la informaci�n de sus contratos. (tabla contratos)
    PROCEDURE mostrarcontratoscompa�ia (
        m_compaid contrato.compa�iaf_id%TYPE
    ) AS
        CURSOR compa_contrato IS
        SELECT
            f.nombre              AS farma,
            c.nombre              AS compa�ia,
            t.fechainicio         AS inicio,
            t.fechafin            AS fin,
            t.texto               AS text,
            t.nombre_supervisor   AS super
        FROM
            farmacia                f,
            compa�ia_farmaceutica   c,
            contrato                t
        WHERE
            c.compa�iaf_id = m_compaid
            AND f.farmacia_id = t.farmacia_id
            AND c.compa�iaf_id = t.compa�iaf_id;

    BEGIN
        FOR fc IN compa_contrato LOOP
            dbms_output.put_line('La Compa�ia Farmaceutica '
                                 || fc.compa�ia
                                 || ' tiene contrato la Farmacia '
                                 || fc.farma
                                 || ', Fecha Inicial-> '
                                 || fc.inicio
                                 || ', Fecha Final-> '
                                 || fc.fin
                                 || ', Descripcion-> '
                                 || fc.text
                                 || ', Supervisor-> '
                                 || fc.super);
        END LOOP;
    END mostrarcontratoscompa�ia;
    

    --Dada una compa��a farmac�utica, mostrar la lista sus medicamentos.(tabla medicamento)
    PROCEDURE mostrarmedicamentoscompa�ia (
        s_compid medicamento.compa�iaf_id%TYPE
    ) AS

        CURSOR compa�ia_medicamento IS
        SELECT
            c.nombre,
            m.nombrecomercial
        FROM
            compa�ia_farmaceutica   c,
            medicamento             m
        WHERE
            m.compa�iaf_id = s_compid
            AND c.compa�iaf_id = m.compa�iaf_id;
    BEGIN
        FOR a IN compa�ia_medicamento LOOP
            dbms_output.put_line('La Compa�ia Farmaceutica '
                                 || a.nombre
                                 || ' produce el medicamento-> '
                                 || a.nombrecomercial);
        END LOOP;
    END mostrarmedicamentoscompa�ia;


    --Dada una farmacia, mostrar la lista de sus medicamentos junto con la compa��a farmac�utica a la que pertenecen. (tabla stock)
    PROCEDURE mostrarfmc (
        s_farmaid stock.farmacia_id%TYPE
    ) AS

        CURSOR farmamedicomp IS
        SELECT
            f.nombre            AS farma,
            c.nombre            AS compa�ia,
            s.nombrecomercial   AS ncomer
        FROM
            farmacia                f,
            compa�ia_farmaceutica   c,
            stock                   s
        WHERE
            s.farmacia_id = s_farmaid
            AND f.farmacia_id = s.farmacia_id
            AND c.compa�iaf_id = s.compa�iaf_id;

    BEGIN
        FOR a IN farmamedicomp LOOP
            dbms_output.put_line('La Farmacia '
                                 || a.farma
                                 || ' tiene el medicamento '
                                 || a.ncomer
                                 || ' de la Compa�ia Farmaceutica '
                                 || a.compa�ia);
        END LOOP;
    END mostrarfmc;


    --Dada una farmacia, mostrar sus ventas y sus totales por cada venta (por periodo de tiempo). (tabla ventas)

    PROCEDURE mostrarventasfarmacia (
        v_farmaid venta.farmacia_id%TYPE
    ) AS

        CURSOR venta_farmacia IS
        SELECT
            l.venta_id AS nrovntas,
           SUM (l.cntvendida) AS totalvntas,
            v.fecha AS fecha
        FROM
            venta        v,
            lineaventa   l
        WHERE
            v.farmacia_id= v_farmaid
            AND v.venta_id = l.venta_id
        GROUP BY l.venta_id,v.fecha;
    BEGIN
        FOR con IN venta_farmacia LOOP
            dbms_output.put_line('IdVenta-> '
                                 || con.nrovntas
                                 || ' Total de Ventas-> '
                                 || con.totalvntas
                                 || ' Fecha-> '
                                 || con.fecha);
        END LOOP;
    END mostrarventasfarmacia;


    --Dado un paciente, mostrar sus recetas registradas. (tabla recetas)
    PROCEDURE mostrarrecetaspaciente (
        r_pacid receta.paciente_id%TYPE
    ) AS

        CURSOR recetas_paciente IS
        SELECT
            p.nombre            AS pnombre,
            r.nombrecomercial   AS noc,
            r.fecha             AS fechacompra,
            r.cantidad          AS cant
        FROM
            paciente   p,
            receta     r
        WHERE
            r.paciente_id = r_pacid
            AND p.paciente_id = r.paciente_id;

    BEGIN
        FOR pac IN recetas_paciente LOOP
            dbms_output.put_line('el paciente  '
                                 || pac.pnombre
                                 || ' compro '
                                 || pac.cant
                                 || ' unidades del medicamento '
                                 || pac.noc
                                 || ' Fecha-> '
                                 || pac.fechacompra);
        END LOOP;
    END mostrarrecetaspaciente;

END mostrarDatos_ops;



