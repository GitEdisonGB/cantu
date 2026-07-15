# Consulta de Títulos em Aberto via WhatsApp — Tasks

**Design**: `.specs/features/whatsapp-titulos-abertos/design.md`
**Status**: Done (lado Protheus) — endpoint REST validado end-to-end no AppServer real, identificação por CPF/CNPJ + busca de títulos multi-empresa confirmadas funcionando (T9). T1-T7 descrevem a versão anterior (busca por telefone), superada por T8/T9.
**Escopo:** lado Protheus (endpoint REST) — **concluído e testado** (`06586594995` → título real retornado corretamente). Serviço de orquestração Python — reescrito em projeto irmão separado (`../cantu-whatsapp-ia/`, fora do repositório AdvPL/TLPP conforme design) para o fluxo CPF/CNPJ-first com memória de sessão; sintaxe validada, mas **nenhum teste real rodado ainda** contra o endpoint atualizado. Falta: o usuário rodar o setup real do WhatsApp (Meta for Developers, ngrok, `.env`) e o teste ponta a ponta completo.

---

## Execution Plan

Arquivo único (`ConsTitWA.tlpp`) — sequencial, sem paralelismo real (mesma unidade compilável).

```
T1 → T2 → T3 → T4 → T5 → T6 → T7
```

---

## Task Breakdown

### T1: Esqueleto do endpoint REST

**What**: Criar `ConsTitWA.tlpp` com includes, namespace, anotação `@Get("/api/cantu/v1/titulosabertos")` e assinatura da `User Function` principal
**Where**: `SIGAFIN/ConsTitWA.tlpp` (caminho real do cantu — não usa `Fontes_Doc/Master/Fontes/`, essa pasta não existe neste projeto; módulos ficam direto na raiz)
**Depends on**: None
**Reuses**: padrão da skill `tlpp-rest-endpoint-generator` (template GET)
**Requirement**: WATI-01..05

**Done when**:
- [x] `#include "tlpp-core.th"` como primeiro include, depois `totvs.ch`
- [x] Namespace declarado
- [x] Anotação `@Get` com o path correto
- [x] Nome da `User Function` verificado sem colisão de prefixo de 10 chars no codebase (feito: `GetTitulos...` livre)

---

### T2: Normalização de telefone

**What**: `Static Function NormalizaTelWA` — recebe telefone bruto do WhatsApp (DDI+DDD+número) e retorna DDD e número separados
**Where**: mesmo arquivo
**Depends on**: T1
**Requirement**: WATI-01

**Done when**:
- [x] Remove prefixo `55` (DDI Brasil)
- [x] Separa 2 primeiros dígitos restantes como DDD, resto como número
- [x] Tratamento defensivo para entrada vazia/mal formada (não deve estourar erro, retorna vazio)

---

### T3: Identificação do(s) cliente(s) por telefone (+ desambiguação por CNPJ)

**What**: `Static Function BuscaCliWA` — consulta SA1 por `A1_DDD`+`A1_TEL`; se retornar mais de um e `cnpj` não informado, sinaliza ambiguidade; se `cnpj` informado, filtra por `A1_CGC`
**Where**: mesmo arquivo
**Depends on**: T1, T2
**Requirement**: WATI-01, WATI-05

**Done when**:
- [x] `FWExecStatement` usado (proteção contra SQL injection)
- [x] Filtros obrigatórios `D_E_L_E_T_` e `A1_FILIAL` (`FWxFilial`)
- [x] `%NOLOCK%` na query — ausente na primeira versão gerada (esquecido apesar de estar no design), corrigido nas duas queries (SA1 e SE1) e revalidado com `advpls appre` (exit 0)
- [x] Retorna estrutura que diferencia: 0 encontrados / 1 encontrado / N encontrados sem CNPJ / 1 encontrado após filtro CNPJ

---

### T4: Títulos em aberto do cliente

**What**: `Static Function BuscaTitWA` — consulta SE1 por cliente/loja identificados, `E1_SALDO > 0`
**Where**: mesmo arquivo
**Depends on**: T1
**Requirement**: WATI-02, WATI-03

**Done when**:
- [x] `FWExecStatement`, filtros `D_E_L_E_T_`/`E1_FILIAL`, `%NOLOCK%`
- [x] Retorna lista vazia (não erro) quando não há títulos em aberto

---

### T5: Montagem da resposta e handler principal

**What**: Implementar o corpo da `User Function` principal — lê query params (`telefone`, `cnpj` opcional), chama T2→T3→T4, monta os 3 formatos de resposta (encontrado / ambíguo / não encontrado), trata erros
**Where**: mesmo arquivo
**Depends on**: T2, T3, T4
**Requirement**: WATI-01..05

**Done when**:
- [x] `Try-Catch` envolvendo acesso a dados
- [x] Erros logados via `FWLogMsg` (nunca `ConOut`)
- [x] Resposta de ambiguidade não expõe nomes/dados dos clientes candidatos
- [x] `Content-Type: application/json` no header de resposta
- [x] Status HTTP correto por cenário (200 / 400 / 500 conforme TTALK)
- [x] Sem `IIF()` — só `If/Else/EndIf`

---

### T6: Conversão de encoding

**What**: Converter o `.tlpp` gerado de UTF-8 para CP-1252 (skill `utf8-to-cp1252-conversion`), obrigatório após geração de código
**Where**: mesmo arquivo
**Depends on**: T5

**Done when**:
- [x] Arquivo final em CP-1252, sem caracteres corrompidos — verificado: conteúdo é ASCII puro (sem acentuação nos comentários), byte-idêntico em UTF-8/CP-1252, sem BOM. Conversão formal não foi necessária.

---

### T7: Validação de sintaxe

**What**: Rodar `advpls appre` para validar sintaxe local sem AppServer
**Where**: N/A (validação)
**Depends on**: T6

**Done when**:
- [x] Sem erros de compilação reportados — `advpls appre` exit code 0, sem `.errtlpp`. Precisou copiar 4 includes (`tlpp-core.th`, `tlpp-object.th`, `tlpp-probat.th`, `tlpp-rest.th`) do projeto hohl pro cantu, já que este é o primeiro fonte `.tlpp` do cantu e esses includes nunca existiram na pasta local
- [x] **Compilação real confirmada pelo usuário (2026-07-13, `[SUCCESS]` no secure compile do TDS-VSCode contra `CO9W3L_PROD_COMP`)** — passou por 3 rodadas de erro real antes de compilar: (1) `TCQuery ... New Alias` inventado, corrigido para `DBUseArea`/`TCGenQry` do template da skill; (2) troca preventiva de `While` por `Do While` (não era a causa, mas mudança segura); (3) causa raiz real: parâmetro `cFilial` em `BuscaTitWA` colidindo com a variável de sistema reservada — renomeado para `cFilAux`. `advpls appre` não pegou nenhum dos 3 problemas (ver [[reference-advpls-appre-syntax-check]] e [[feedback-grep-forbidden-before-entregar]])

**Tests**: nenhum teste automatizado (TIR é orientado a tela SmartClient/Webapp, não se aplica a endpoint REST puro). Compilação real confirmada **para a versão com busca por telefone** (ver T8 para o redesenho posterior).
**Gate**: sintaxe (`advpls appre`) + compilação real — **ambos concluídos para essa versão, superada por T8**

---

### T8: Redesenho — remoção da busca por telefone, identificação só por CPF/CNPJ

**What**: Decisão final do usuário (2026-07-13): abandonar de vez a busca/filtro por telefone (`A1_DDD`/`A1_TEL`) em favor de identificação direta e exclusiva por `A1_CGC`. Reescrita de `BuscaCliWA` (remove parâmetro de telefone, filtra só por `cnpj`), remoção de `NormalizaTelWA` (T2, não é mais necessária), simplificação do handler principal (só 2 status possíveis: `found`/`not_found`, não mais `ambiguous`). Lado Python (`cantu-whatsapp-ia/`) reescrito em conjunto: `conversation_state.py` (nova classe `Sessoes` com memória de identidade confirmada por 15 min), `protheus_client.py` (`consulta_titulos(cnpj)`, sem mais parâmetro de telefone), `main.py` (fluxo: pede documento no primeiro contato → confirma e memoriza na sessão → reusa a identidade confirmada nas mensagens seguintes)
**Where**: `SIGAFIN/ConsTitWA.tlpp` + `../cantu-whatsapp-ia/{conversation_state,protheus_client,main}.py`
**Depends on**: T1-T7 (substituindo o comportamento de T2 e parte de T3/T5)
**Requirement**: WATI-01, WATI-05 (revisados)

**Done when**:
- [x] `ConsTitWA.tlpp` reescrito sem `NormalizaTelWA`/telefone em nenhuma query
- [x] `advpls appre` limpo (exit 0), sem `cFilial`, sem `nolock`, ASCII puro/sem BOM
- [x] Python: `conversation_state.py`, `protheus_client.py`, `main.py` reescritos e com sintaxe validada (`ast.parse`)
- [x] Recompilado `ConsTitWA.tlpp` contra o AppServer real (`CO9W3L_PROD_COMP`), RPO promovido, REST reiniciado
- [x] Teste via curl (`?cnpj=`) confirmando `found`/`not_found` contra dado real — inclusive validação de CPF/CNPJ zerado sendo rejeitado (ver T9)
- [x] `TEMP DEBUG` no `Catch` revertido pra mensagem genérica após confirmação final
- [ ] **Pendente**: teste ponta a ponta real via WhatsApp (responsabilidade do usuário — Meta for Developers, ngrok, `.env`)

**Tests**: mesma observação de T7 (sem TIR aplicável). Teste real via curl confirmado (ver T9).
**Gate**: sintaxe local ok; compilação real e teste funcional **concluídos** (T9)

---

### T9: Validação de CPF/CNPJ + consulta multi-empresa

**What**: Durante a validação em produção, dois problemas reais surgiram e foram corrigidos:
1. **Segurança de dados**: `cnpj=00000000000000` batia com um cliente real (`CIA CHILENA MEDICION S/A`, provável placeholder de estrangeiro sem CNPJ) — qualquer pessoa mandando zeros no WhatsApp seria identificada como esse cliente. Corrigido com validação real de dígito verificador (módulo 11) de CPF/CNPJ + rejeição de sequências repetidas, antes de consultar o SA1 (`ValidaDocWA`/`ValCpfWA`/`ValCnpjWA`/`DigVerifWA`/`DocRepetWA`)
2. **Multi-empresa**: o usuário identificou que a busca de títulos (SE1) não podia se limitar à filial do cliente identificado — o ambiente tem várias empresas, cada uma com sua própria tabela física de SE1, e títulos do mesmo cliente podem estar em qualquer uma delas. `RpcSetEnv` (único padrão real já usado no cantu pra iterar empresas) é proibido em REST pela regra SonarQube BG1000 (risco de vazar contexto de empresa entre requisições concorrentes). Reescrito `BuscaTitWA` pra usar `FWLoadSM0()` + `UNION ALL` sobre `SE1<empresa>0` por empresa, sem trocar ambiente
**Where**: `SIGAFIN/ConsTitWA.tlpp`
**Depends on**: T8
**Requirement**: WATI-02, WATI-03 (revisados), segurança de identificação

**Done when**:
- [x] Validação de CPF/CNPJ (dígito verificador + rejeição de repetidos) implementada e testada (`00000000000000` agora retorna `400`)
- [x] `BuscaTitWA` reescrito para multi-empresa via `FWLoadSM0()`, sem `RpcSetEnv`, sem filtro de `E1_FILIAL`
- [x] 3 bugs reais corrigidos nesta rodada: `SM0_CODIGO` (constante inexistente no include do `.tlpp`, trocado por índice `[1]`), `DToC()` falhando em `E1_VENCTO` de query `UNION ALL` (corrigido com `DtVencWA()` defensivo via `ValType()`)
- [x] Teste end-to-end confirmado com CPF real (`06586594995`): `status: "found"`, cliente `EDISON GRESKI BARBIERI`, 1 título retornado corretamente formatado
- [x] `TEMP DEBUG` (reativado 2x pra diagnosticar os bugs acima) revertido definitivamente

**Tests**: sem TIR aplicável. Testado via curl contra `CO9W3L_PROD_COMP` real, múltiplas rodadas (documento inválido, zerado, CPF real com título).
**Gate**: **concluído** — endpoint funcional ponta a ponta no lado Protheus
