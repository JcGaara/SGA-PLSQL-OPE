ALTER TABLE operacion.sgat_df_transaccion_det
    ADD CONSTRAINT fk_trsd_fluc FOREIGN KEY ( trsdn_idproceso )
        REFERENCES operacion.sgat_df_proceso_cab ( procn_idproceso );
