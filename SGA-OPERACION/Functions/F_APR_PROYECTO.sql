CREATE OR REPLACE FUNCTION OPERACION.F_APR_PROYECTO(
ac_proyecto in char
)
return integer is

/************************************************************
   	NOMBRE:       		F_APR_PROYECTO
   	PROPÓSITO:    		Determina si se aprueba un Proyecto:
                      Retorna: 1 SI se aprueba, 0 NO se aprueba.
   	REVISIONES:
   	Ver        Fecha        Autor           Descripción
   	---------  ----------  ---------------  ------------------------
  	 1.0       05/05/2004  Mariella Díaz    Proyectos de Internet
     1.1       12/05/2004  Mariella Díaz    No se va a considerar los PIN.
                                            Sólo es referencial

***********************************************************/

ln_aprob  integer;
ln_tipo   integer;
ln_num    integer;

lc_codsrv char(4);
ln_plazo  number;
ln_pint   number;
ln_pintma number;
ln_pext   number;
ln_pextma number;
ln_cost   number;
ln_inst   number;
ln_porc   number;

--Tipo de Cambio
cn_tc constant decimal:= 3.51;

cursor r_proyint is
Select distinct p.codsrv, dp.tipo_vta
from vtatabslcfac p, vtadetptoenl dp
where p.numslc = ac_proyecto and
      p.numslc = dp.numslc;

--Cargo No Recurrente
cursor r_nrec is
select a.numpto, a.codsrv, a.prelis_ins PLista, a.moneda_id
from vtadetptoenl a, vtatabpspcli_v c
where (a.estcts = '0' or a.estcts is null) and
       a.numslc = c.numslc and
       a.numslc = ac_proyecto;
--Cargo recurrente
cursor r_rec is
select a.numpto, a.codsrv, a.prelis_srv PLista, a.moneda_id
from vtadetptoenl a, vtatabpspcli_v c
where (a.estcse = '0' or a.estcse is null) and
      a.numslc = c.numslc and
      a.numslc = ac_proyecto;

Begin
ln_porc   := 1;
ln_aprob  := 1;

/*I. PROYECTO DE INSTALACIÓN: Debe ser un proy. de Instal.*/
FOR r_proyecto in r_proyint loop
    if r_proyecto.tipo_vta <> 1 then
       ln_aprob := 0;
--       RAISE_APPLICATION_ERROR(-20500,'No es un Proyecto de Instalación.');
    end if;
end loop;
/*Si cumple (I), seguimos..*/
If ln_aprob = 1 then
     /*Obtenemos el Plazo del Proyecto, ver tabla tipo_calificación*/
     Select p.plazo_srv into ln_plazo
     from Vtatabslcfac p
     where p.numslc = ac_proyecto;
     if ln_plazo not in (0,10) then
        ln_porc := 0.93; --Dcto = 7%
     End if;

     /*Definiendo Tipo = 1 -> IAR
            = 2 -> AR             */
     select count(*) into ln_num
     from vtadetptoenl dp,
          vtatabpspcli_v c
     where (dp.estcts = '0' or dp.estcts is null) and
            dp.numslc = c.numslc and
            dp.numslc = ac_proyecto;
     If ln_num > 0 then
          ln_tipo := 1;
     else
          ln_tipo := 2;
     end if;

     /*Obtengo el Servicio asociado al Proyecto*/
     Select count(*) into ln_num
     from matrizaprob ma, vtadetptoenl def
	   where ma.codsrv = def.codsrv and
		      numslc = ac_proyecto and
		      tipo = ln_tipo;
     If ln_num = 1 then
        Select def.codsrv into lc_codsrv
    	  from matrizaprob ma, vtadetptoenl def
    	  where ma.codsrv = def.codsrv and
    		      numslc = ac_proyecto and
    		      tipo = ln_tipo;
     else
        ln_aprob := 0;
     end if;
     /*Si encontró Servicio del Proyecto...*/
     If ln_aprob = 1 then
        /*II. ESTUDIO FACTIBILIDAD: MATRIZ DE APROBACIÓN*/
        /*1 .- VALORES DEL PROYECTO*/
        /*Obtenemos Costo Planta Externa <= PEX*/
        Select sum(decode(moneda_id, 1, total/cn_tc, total) ) into ln_pext
        from (
            --Total Actividad (mano de Obra)
            Select 'ACT' tipo, moneda_id, sum(cantidad*costo) total
            from efptoetaact efact,
    			       etapaxarea ea
            where efact.codeta = ea.codeta and
    			        ea.area in (10,11,12,13,14,80) and
    			        efact.codef = ac_proyecto
            group by moneda_id
            union all
            --Total Materiales
            Select 'MAT' tipo, mat.moneda_id, sum(efmat.cantidad * efmat.costo) total
            from efptoetamat efmat,
    			       matope mat,
    			       etapaxarea ea
            where efmat.codeta = ea.codeta and
    		          efmat.codmat = mat.codmat and
    			        ea.area in (10,11,12,13,14,80) and
    			        efmat.codef = ac_proyecto
            group by mat.moneda_id
        );

        /*Obtenermos Costo Planta Interma <= PIN*/
    	  Select sum(total) into ln_pint
    	  from (
    		     Select sum(costo*cantidad) total
        	   from efptoequ
        	   where codef = ac_proyecto and
    		  	       costear = 1
    		     union all
        	   Select nvl(sum(b.costo * b.cantidad * a.cantidad),0) total
        	   from efptoequ a, efptoequcmp b
       		   where a.codef = ac_proyecto  and
    		 	         b.costear = 1 and
    		 	         a.codef = b.codef  and
             	     a.punto = b.punto and
    		 	         a.orden = b.orden
        );

        /*2 .- VALORES DE COMPARACIÓN*/
        Select costo_pin, costo_pex into ln_pintma, ln_pextma
        from matrizaprob ma
        where ma.codsrv = lc_codsrv
        and ma.tipo = ln_tipo ;

        /*3 .- HACEMOS LA COMPARACIÓN */
        /* Versión 1.1
        If (ln_pintma < ln_pint) then
           ln_aprob :=0;
        end if;*/
        If (ln_pextma < ln_pext) then
           ln_aprob :=0;
        end if;

        /*Si cumple (II), seguimos...*/
        If ln_aprob = 1 then
            /*III. ORDEN COMERCIAL: Para Cargo No Recurrente: ServicioInstalación*/
            FOR r_cnrec in r_nrec loop
                Select count(*) into ln_num
                from Matrizprecio mp
                where mp.servicio_codsrv =  r_cnrec.codsrv and
                      mp.tipo = ln_tipo;
                If ln_num = 1 then
    			         Select mp.servicio_instalacion
                   into ln_inst
                   from Matrizprecio mp
                   where mp.codsrv = lc_codsrv and
                         mp.servicio_codsrv =  r_cnrec.codsrv and
                         mp.tipo = ln_tipo;
                   If round(ln_inst,2) <> round(r_cnrec.PLista,2) then
                      ln_aprob := 0;
                   End if;
                End if;
            End loop;

            /*Si cumple (III), seguimos...*/
            If ln_aprob = 1 then
                /*IV. ORDEN COMERCIAL: Para Cargo Recurrente: ServicioCosto*/
    	        FOR r_crec in r_rec loop
                    Select count(*) into ln_num
                    from Matrizprecio mp
                    where mp.codsrv = lc_codsrv and
                          mp.servicio_codsrv =  r_crec.codsrv and
                          mp.tipo = ln_tipo;
    	              If ln_num = 1 then
                       Select mp.servicio_costo
                       into ln_cost
                       from Matrizprecio mp
                       where mp.codsrv = lc_codsrv and
                             mp.servicio_codsrv =  r_crec.codsrv and
                             mp.tipo = ln_tipo;
                       ln_cost := ln_cost * ln_porc;
                       If round(ln_cost,2) <> round(r_crec.PLista,2) then
                          ln_aprob := 0;
                       End if;
                    End if;
              End loop;
            End if;

        End if;

     End if;

End if;

Return(ln_aprob);
end F_APR_PROYECTO;
/


