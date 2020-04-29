ALTER TABLE operacion.sgat_df_proceso_cab
    ADD CONSTRAINT fk_proc_prot FOREIGN KEY ( procn_idtipoproceso )
        REFERENCES operacion.sgat_df_proceso_tipo ( protn_idtipoproceso );
