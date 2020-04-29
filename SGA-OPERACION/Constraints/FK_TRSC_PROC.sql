ALTER TABLE operacion.sgat_df_transaccion_cab
    ADD CONSTRAINT fk_trsc_proc FOREIGN KEY ( trscn_idprocesoejec )
        REFERENCES operacion.sgat_df_proceso_cab ( procn_idproceso );
