# Consulta de Títulos em Aberto via WhatsApp — Specification

## Problem Statement

Hoje, para saber os títulos em aberto (contas a receber), o cliente da cantu depende de contato manual com o financeiro. Esta é uma prova de conceito (POC) para demonstrar ao cliente que ele mesmo pode consultar essa informação sozinho, via WhatsApp, ganhando agilidade e reduzindo carga do financeiro.

## Goals

- [ ] Cliente cantu consegue perguntar via WhatsApp "quais títulos tenho em aberto?" e receber a lista com valor e vencimento
- [ ] Demonstrar o processo funcionando ponta a ponta (WhatsApp → identificação do cliente → consulta no Protheus → resposta) para validar viabilidade com o cliente

## Out of Scope

| Feature | Reason |
|---|---|
| Negociação/parcelamento de títulos | POC é somente consulta (leitura) |
| Emissão de 2ª via de boleto/PDF | Fora do escopo desta etapa |
| Produção multi-cliente / hohl | POC restrita à cantu, ambiente de demonstração |
| Autenticação multifator (CNPJ/CPF, OTP) | Decisão tomada: identificação só por telefone cadastrado no SA1 é suficiente para a POC |
| Envio proativo (cobrança automática, lembrete de vencimento) | Fluxo é reativo — cliente inicia a conversa |

---

## User Stories

### P1: Consulta de títulos em aberto ⭐ MVP

**User Story:** Como cliente da cantu, quero perguntar pelo WhatsApp quais títulos tenho em aberto, para saber minha situação financeira sem precisar ligar pro financeiro.

**Why P1:** É o núcleo da POC — sem isso não há nada para demonstrar.

**Acceptance Criteria:**

1. WHEN o cliente envia uma mensagem perguntando sobre títulos/boletos/pendências em aberto THEN o sistema SHALL identificar candidato(s) pelo número de telefone do remetente, buscando no cadastro (SA1)
2. WHEN há pelo menos um candidato pelo telefone THEN o sistema SHALL **sempre** pedir a confirmação do CPF (pessoa física) ou CNPJ (pessoa jurídica) antes de expor qualquer dado — mesmo quando o telefone corresponde a um único cadastro. A pergunta usa o termo certo (CPF ou CNPJ) baseado no tipo de pessoa do cadastro quando há só um candidato; genérico ("CNPJ ou CPF") quando há mais de um candidato
3. WHEN a confirmação do documento bate com um cadastro e há títulos em aberto (SE1, saldo > 0) THEN o sistema SHALL responder com a lista de títulos (número, vencimento, valor) formatada de forma legível
4. WHEN a confirmação do documento bate com um cadastro mas não há títulos em aberto THEN o sistema SHALL responder informando que não há pendências
5. WHEN o telefone do remetente não corresponde a nenhum cliente cadastrado, OU o documento informado não bate com nenhum candidato THEN o sistema SHALL responder de forma educada informando que não conseguiu identificar o cadastro, sem expor dados de terceiros

**Independent Test:** Enviar mensagem de um número de teste cadastrado no SA1 com títulos em aberto reais e validar que a resposta reflete os dados do SE1.

---

## Edge Cases

- WHEN o mesmo telefone está cadastrado em mais de um cliente (SA1) THEN o sistema SHALL pedir CNPJ/CPF para desambiguar (pergunta genérica, sem saber de antemão o tipo de pessoa), sem expor nomes ou dados de nenhum dos candidatos antes da confirmação
- WHEN a mensagem do cliente não é sobre títulos (ex: "oi", pergunta genérica) THEN o sistema SHALL responder de forma cordial indicando o que pode ser consultado
- WHEN o Protheus está indisponível ou retorna erro na consulta THEN o sistema SHALL responder com mensagem amigável, sem expor detalhes técnicos/stack trace

---

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
|---|---|---|---|
| WATI-01 | P1: Identificação por telefone | Design | Pending |
| WATI-02 | P1: Resposta com títulos | Design | Pending |
| WATI-03 | P1: Resposta sem pendências | Design | Pending |
| WATI-04 | P1: Telefone não identificado | Design | Pending |
| WATI-05 | P1: Desambiguação por CNPJ/CPF | Design | Pending |

**Coverage:** 5 total, 0 mapeados a tasks, 5 não mapeados ⚠️ (Tasks ainda não criado)

---

## Success Criteria

- [ ] Demo funcional ponta a ponta com pelo menos 1 número de telefone de teste real
- [ ] Resposta reflete o saldo real do SE1 no momento da consulta (sem cache desatualizado)
