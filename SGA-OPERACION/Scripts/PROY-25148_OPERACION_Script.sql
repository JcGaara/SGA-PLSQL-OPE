/*Insertar parametros de incidencia*/
insert into operacion.matriz_incidence_adc (CODSUBTYPE, CODINCTYPE, CODINCDESCRIPTION, CODCHANNEL, CODTYPESERVICE, CODCASE, ESTADO)
values (2, 2, 1, null, null, null, '0');

insert into operacion.matriz_incidence_adc (CODSUBTYPE, CODINCTYPE, CODINCDESCRIPTION, CODCHANNEL, CODTYPESERVICE, CODCASE, ESTADO)
values (19, 16, 1, null, null, null, '0');

------------------------- RF 12: MENSAJE DE VALICACION PANEL DE AGENDAMIENTO-----------------------                  
insert into operacion.parametro_cab_adc(descripcion, abreviatura, estado)  
       values('VALIDACION - PANEL DE AGENDAMIENTO', 'VAL_PANAGE',0);    

insert into operacion.parametro_det_adc(id_parametro,codigon, codigoc, descripcion, abreviatura, estado)  
       values((select a.id_parametro
                 from operacion.parametro_cab_adc a
                where a.abreviatura = 'VAL_PANAGE'),
              0,
              '0000',
              '<< Seleccionar>>',
              'SEL_TIPORD',
              0);       
              
---------------------------------RF: 06 INSERT EN MATRIZ -----------------------------------------
insert into operacion.matriz_tystipsrv_tiptra_adc(tipsrv,tiptra,con_cap_v,con_cap_p,con_cap_o,gen_ot_aut,tipo_agenda,valida_mot,estado,con_cap_i,flgaobliga)
      select tabla.tipsrv, tabla.tiptra, 1, 1, 1, tabla.gen_ot_aut, 'TODOS', 0, 0,0,0
        from (select '0077' tipsrv, '485' tiptra, 'A' gen_ot_aut  from dual
               union
              select '0077' tipsrv, '498' tiptra, 'A' gen_ot_aut  from dual  
               union
              select '0077' tipsrv, '497' tiptra, 'A' gen_ot_aut  from dual  
               union
              select '0077' tipsrv, '612' tiptra, 'A' gen_ot_aut  from dual  
               union
              select '0077' tipsrv, '432' tiptra, 'M' gen_ot_aut  from dual  
               union
              select '0061' tipsrv, '409' tiptra, 'M' gen_ot_aut  from dual            
               union
              select '0061' tipsrv, '410' tiptra, 'M' gen_ot_aut  from dual         
               union
              select '0061' tipsrv, '424' tiptra, 'A' gen_ot_aut  from dual    
               union
              select '0061' tipsrv, '660' tiptra, 'A' gen_ot_aut  from dual  
               union
              select '0061' tipsrv, '705' tiptra, 'A' gen_ot_aut  from dual 
               union
              select '0061' tipsrv, '721' tiptra, 'A' gen_ot_aut  from dual 
               union
              select '0061' tipsrv, '407' tiptra, 'A' gen_ot_aut  from dual 
               union
              select '0061' tipsrv, '489' tiptra, 'A' gen_ot_aut  from dual 
               union
              select '0061' tipsrv, '678' tiptra, 'M' gen_ot_aut  from dual
               union
              select '0061' tipsrv, '727' tiptra, 'A' gen_ot_aut  from dual  ) tabla
        where not exists (select 1
                            from operacion.matriz_tystipsrv_tiptra_adc t
                           where t.tipsrv = tabla.tipsrv
                             and t.tiptra = tabla.tiptra);

-----------------------------RF: 06  MENSAJE DE VALICACION OT MANUAL Y AUTOMATICA ---------------------------  
insert into operacion.parametro_cab_adc(descripcion, abreviatura, estado)  
       values('VALIDACION DE OT MANUAL Y AUTOMATICA', 'VAL_OT_MA',0);    
                      
insert into operacion.parametro_det_adc(id_parametro,codigon, codigoc, descripcion, abreviatura, estado)  
       values((select a.id_parametro
                 from operacion.parametro_cab_adc a
                where a.abreviatura = 'VAL_OT_MA'),
              1,
              'No puede Generar Orden Manual, la fecha de la Venta/PostVenta @fecha_progra@ es Menor a la Fecha Actual, Por favor ingrese por la Opción de reagendamiento',
              'Mensaje de validacion de fecha en OT Manual y Automatica',
              'ERROR_FECHA',
              0);

COMMIT;
/

declare
   type array_t is varray(10) of number;
   type array_s is varray(4) of varchar2(10);
   type array_m is varray(4) of number;
   type array_n is varray(1) of varchar2(10);
   array array_t := array_t(407, 408, 448, 480, 489, 671, 770);
   array_s1 array_s := array_s('0004', '0006', '0061', '0062');
   array_m1 array_m := array_m(497, 498, 612, 727);
   array_n1 array_n := array_n('0077');
   
   m        number;
   l        number;
   n        number;
   o        number;
   ll_count number;
begin
   for m in 1..array_s1.count loop
    for l in 1..array.count loop
        select count(*)
          into ll_count
          from operacion.matriz_tystipsrv_tiptra_adc
         where TIPSRV = array_s1(m)
           and TIPTRA = array(l);
               
        If ll_count < 1 then
          if array(l) = 448 then
            insert into operacion.matriz_tystipsrv_tiptra_adc (TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO, CON_CAP_I, FLGAOBLIGA)
            values (array_s1(m), array(l), 1, 1, 1, 'M', 'TODOS', 0, 0, 1, 0);
          else
            insert into operacion.matriz_tystipsrv_tiptra_adc (TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO, CON_CAP_I, FLGAOBLIGA)
            values (array_s1(m), array(l), 1, 1, 1, 'A', 'TODOS', 0, 0, 1, 0);
          end if;
        End If;   
     end loop; 
   end loop;
   commit;
   
   for n in 1..array_n1.count loop
    for o in 1..array_m1.count loop
        select count(*)
          into ll_count
          from operacion.matriz_tystipsrv_tiptra_adc
         where TIPSRV = array_n1(n)
           and TIPTRA = array_m1(o);
               
        If ll_count < 1 then
            insert into operacion.matriz_tystipsrv_tiptra_adc (TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO, CON_CAP_I, FLGAOBLIGA)
            values (array_n1(n), array_m1(o), 1, 1, 1, 'A', 'TODOS', 0, 0, 1, 0);
        END IF;
     end loop; 
   end loop;
   commit;
end;
/
----------------------------RF: 06 ACTUALIZACION DEL TIPTRABAJO---------------------------------------------
declare
   type array_tra is varray(25) of number;
   type array_tip is varray(25) of varchar2(10);
   array_tra1 array_tra := array_tra(485,498,497,612,409,410,424,660,678,705,
                                     721,407,489,432,727,407,408,448,480,489,
                                     497,498,612,671,770);
   array_tip1 array_tip := array_tip('DTHI','DTHM','DTHP','DTHM','HFCP','HFCP','HFCP','HFCP','HFCP','HFCP',
                                     'HFCP','HFCM','HFCM','CAND','DTHM','HFCM','CANH','CANH','HFCM','HFCM',
                                     'DTHP','DTHM','DTHM','HFCM','HFCM');                             
begin
   for m in 1..array_tra1.count loop              
       BEGIN
          update operacion.tiptrabajo T
             set t.id_tipo_orden = (select a.id_tipo_orden
                                      from operacion.tipo_orden_adc a
                                     where a.cod_tipo_orden = array_tip1(m)),
                 t.num_reagenda = nvl(t.num_reagenda,3),
                 t.fecusu = sysdate,
                 t.codusu = user
           where t.tiptra = array_tra1(m)
             and t.id_tipo_orden is null ;

       EXCEPTION
         WHEN NO_DATA_FOUND then
           null;
       END;  
   end loop;   
                
   update operacion.TIPTRABAJO t 
      set t.num_reagenda = 3,
          t.fecusu = sysdate,
          t.codusu = user
    where t.tiptra in ('407','409','410','424','432','485','489','497',
                       '498','612','660','678','705','721','727')
      and t.num_reagenda is null;             
           
   commit;
end;  
/
----------------------------------------MODIFICACION DE TABLA ---------------------------------------------- 			  
ALTER TABLE operacion.parametro_vta_pvta_adc ADD PVAD_FLAG_PRIO CHAR(1) DEFAULT 0;
COMMENT ON COLUMN operacion.parametro_vta_pvta_adc.PVAD_FLAG_PRIO is 'FLAG DE ORDEN PRIORIZADA  0 : DEFAUL ; 1 : PRIORIZADO'; 
/
