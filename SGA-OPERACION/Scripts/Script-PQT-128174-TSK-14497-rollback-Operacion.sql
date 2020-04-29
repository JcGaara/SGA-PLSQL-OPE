-- Eliminar Triggers
drop trigger operacion.t_solot_au;

-- Eliminar Procedures
drop procedure operacion.p_wf_pos_actsrv;

--2.- ROLLBACK DE MOTIVO DE ACTIVACIÓN/DESACTIVACIÓN DE CANAL ADICIONAL
delete from operacion.motot
 where codmotot in
       (select t.codmotot_asigna
          from atccorp.atc_parametro_sot t
         where t.transaccion in
               ('CLAROCLUB_ACTIVACION', 'CLAROCLUB_DESACTIVACION'));
commit;