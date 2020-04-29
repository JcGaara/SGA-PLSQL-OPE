ALTER TABLE operacion.sgat_df_proceso_det
    ADD CONSTRAINT fk_prod_procv2 FOREIGN KEY ( prodn_idprocesopost )
        REFERENCES operacion.sgat_df_proceso_cab ( procn_idproceso );
