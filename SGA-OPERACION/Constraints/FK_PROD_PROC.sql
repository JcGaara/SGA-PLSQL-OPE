ALTER TABLE operacion.sgat_df_proceso_det
    ADD CONSTRAINT fk_prod_proc FOREIGN KEY ( prodn_idprocesopre )
        REFERENCES operacion.sgat_df_proceso_cab ( procn_idproceso );
