ALTER TABLE operacion.sgat_df_condicion_det
    ADD CONSTRAINT fk_cond_conc FOREIGN KEY ( condn_idcondicion )
        REFERENCES operacion.sgat_df_condicion_cab ( concn_idcondicion );
