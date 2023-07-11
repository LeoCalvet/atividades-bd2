CREATE OR REPLACE FUNCTION verificar_faltas() RETURNS TRIGGER AS $$
DECLARE
    faltas_sem_justificativa INT;
BEGIN
    SELECT COUNT(*) INTO faltas_sem_justificativa FROM presenca WHERE cpf = NEW.cpf AND justificativa IS NULL;

    IF faltas_sem_justificativa >= 5 THEN
        UPDATE funcionario SET ativo = 'N' WHERE cpf = NEW.cpf;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
