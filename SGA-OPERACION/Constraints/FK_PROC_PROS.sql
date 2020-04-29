ALTER TABLE operacion.sgat_df_proceso_cab
    ADD CONSTRAINT fk_proc_pros FOREIGN KEY ( procn_idservproceso )
        REFERENCES operacion.sgat_df_proceso_servidor ( prosn_idservproceso );
