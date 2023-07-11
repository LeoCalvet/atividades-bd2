CREATE OR REPLACE FUNCTION RegistrarPresenca(cpf_funcionario VARCHAR, presente BOOLEAN, justificativa_text TEXT) RETURNS VOID AS $$
DECLARE
    faltas_sem_justificativa INT;
BEGIN
    INSERT INTO presenca (cpf, data_presenca, justificativa) VALUES (cpf_funcionario, CURRENT_DATE, CASE WHEN presente THEN NULL ELSE justificativa_text END);

    SELECT COUNT(*) INTO faltas_sem_justificativa FROM presenca WHERE cpf = cpf_funcionario AND justificativa IS NULL;

    IF faltas_sem_justificativa >= 5 THEN
        UPDATE funcionario SET ativo = 'N' WHERE cpf = cpf_funcionario;
    END IF;
END;
$$ LANGUAGE plpgsql;
