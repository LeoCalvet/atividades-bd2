CREATE OR REPLACE FUNCTION PromoverFuncionario(cpf_funcionario VARCHAR, nivel_promocao INT) RETURNS VOID AS $$
DECLARE
    ultimo_nivel INT;
    ultima_promocao DATE;
BEGIN
    SELECT nivel, MAX(data_promocao) INTO ultimo_nivel, ultima_promocao FROM promocoes WHERE cpf = cpf_funcionario;

    IF ultimo_nivel IS NULL OR nivel_promocao = ultimo_nivel + 1 AND (ultima_promocao IS NULL OR ultima_promocao < CURRENT_DATE - INTERVAL '3 years') THEN
        INSERT INTO promocoes (cpf, data_promocao, nivel) VALUES (cpf_funcionario, CURRENT_DATE, nivel_promocao);
        UPDATE funcionario SET nivel = nivel_promocao WHERE cpf = cpf_funcionario;
    ELSE
        RAISE EXCEPTION 'O funcionário não está elegível para promoção';
    END IF;
END;
$$ LANGUAGE plpgsql;
