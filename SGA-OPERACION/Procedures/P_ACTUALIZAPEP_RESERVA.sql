CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZAPEP_RESERVA(v_numslc number,v_codsolot number)
as
result long;
n_linea_Proy number;
n_linea_Pep number;
begin
        update z_ps_proyectos
        set procesado = 'N'
        where procesado <> 'S' and numslc = v_numslc;
        commit;

        update z_ps_elementospep
        set procesado = 'N'
        where procesado <> 'S' and codsolot = v_codsolot;
        commit;

        update z_ps_asignapep_proginv
        set procesado = 'N'
        where procesado <> 'S' and codsolot = v_codsolot;
        commit;

        update z_ps_presupuesto
        set procesado = 'N'
        where procesado <> 'S' and codsolot = v_codsolot;
        commit;

        select id_linea into n_linea_Proy from z_ps_proyectos where numslc = v_numslc;
        select id_linea into n_linea_Pep from z_ps_elementospep where nivel = 2 and codsolot = v_codsolot;

        result := sgasap.pq_sap_interface.ps_crea_proy(n_linea_Proy);
        commit;

        result := sgasap.pq_sap_interface.ps_crea_pep2(n_linea_Pep);
        commit;

        result := sgasap.pq_sap_interface.ps_crea_pep3(v_codsolot);
        commit;

        result := sgasap.pq_sap_interface.ps_crea_planifica(v_codsolot);
        commit;

        result := sgasap.pq_sap_interface.ps_asigna_pep(v_codsolot);
        commit;

        result := sgasap.pq_sap_interface.ps_dist_presu(v_codsolot);
        commit;
end;
/


