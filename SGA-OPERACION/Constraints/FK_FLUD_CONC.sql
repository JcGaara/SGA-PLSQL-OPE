ALTER TABLE operacion.sgat_df_flujo_det
    ADD CONSTRAINT fk_flud_conc FOREIGN KEY ( fludn_idcondicion )
        REFERENCES operacion.sgat_df_condicion_cab ( concn_idcondicion );
