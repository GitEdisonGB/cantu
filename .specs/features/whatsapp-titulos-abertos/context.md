# Consulta de Títulos em Aberto via WhatsApp — Context

**Gathered:** 2026-07-13
**Spec:** `.specs/features/whatsapp-titulos-abertos/spec.md`
**Status:** Ready for design

---

## Feature Boundary

POC de consulta (somente leitura) de títulos em aberto do cliente cantu via WhatsApp, com resposta gerada com apoio de LLM.

---

## Implementation Decisions

### Autenticação / identificação do cliente

- **Decisão final (2026-07-13):** busca por telefone (`A1_DDD`/`A1_TEL`) foi **removida por completo**. Ao primeiro contato, o bot vai direto pedir CPF/CNPJ, sem tentar identificar/validar telefone antes. Motivo dado pelo usuário: telefone de cadastro é frágil demais como filtro primário; CPF/CNPJ é o identificador confiável e mais seguro. Isso substitui as duas decisões anteriores registradas aqui (identificação por telefone com CNPJ só para desambiguação; depois, identificação por telefone + confirmação sempre de CNPJ) — ambas superadas.
- **Memória de sessão:** depois que o cliente confirma o CPF/CNPJ (documento existe no SA1 e retorna títulos), o serviço de orquestração guarda essa identidade em memória por telefone durante os próximos 15 minutos, para não pedir o documento de novo a cada mensagem na mesma conversa. Estado em memória de processo (perde ao reiniciar o serviço) — suficiente para a POC.

### Infraestrutura / orquestração

- Não existe provedor de WhatsApp Business nem serviço de orquestração pré-existente na cantu.
- Serviço de orquestração roda **na máquina do usuário** durante o desenvolvimento, com túnel HTTPS público (ngrok ou similar) para o webhook do WhatsApp alcançar o `localhost`.

### Ambiente de teste

- Cliente de teste já cadastrado no SA1 será reaproveitado (`A1_COD=065865949`, `A1_LOJA=0001`, `A1_DDD=46`, `A1_TEL=988317471` — confirmado real, sem máscara/DDI, campos separados).

### Usuário de integração REST

- Usuário dedicado criado no Configurador (SIGACFG): `iafinanceiro`. Reservado para toda integração de IA relacionada ao financeiro (não só esta POC), não reaproveita a credencial do EasyMobile.
- **Alerta de segurança levantado**: a senha inicial informada era igual ao usuário (`iafinanceiro`/`iafinanceiro`) — recomendei trocar por uma senha forte antes de usar em produção, já que esse login será compartilhado por múltiplas integrações futuras (ponto único de falha). A senha real nunca é gravada em arquivo do repositório — fica só em variável de ambiente/`.env` local (fora do Git) quando o serviço de orquestração for implementado.

### Campo de CNPJ/CPF

- Confirmado pelo usuário: `A1_CGC` é o campo correto no SA1 para desambiguação por telefone compartilhado.

### Agent's Discretion

- Escolha do provedor/SDK de WhatsApp e linguagem do serviço de orquestração (definido em Design: Meta WhatsApp Cloud API + serviço Python)
- Formato exato da mensagem de resposta (tom, estrutura)
- Nome do fonte TLPP (definido em Design: `ConsTitWA.tlpp`)

---

## Specific References

Nenhuma referência específica de produto/concorrente mencionada — aberto a abordagem padrão.

---

## Deferred Ideas

- Extensão para múltiplos clientes cantu em produção e para o hohl — fora desta etapa
