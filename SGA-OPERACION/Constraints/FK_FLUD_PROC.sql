ALTER TABLE operacion.sgat_df_flujo_det
    ADD CONSTRAINT fk_flud_proc FOREIGN KEY ( fludn_idproceso )
        REFERENCES operacion.sgat_df_proceso_cab ( procn_idproceso );
