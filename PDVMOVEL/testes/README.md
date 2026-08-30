# Testes de API — PDV Móvel

Testes de **contrato** dos endpoints REST, por HTTP puro. Sem SmartClient, sem Webapp, sem TIR:
rodam em segundos e não dependem de tela nem de gravação de dado.

## Como rodar

```bash
cd "<raiz do projeto cantu>"
copy PDVMOVEL\testes\config.exemplo.json PDVMOVEL\testes\config.json   # e preencha
python -m unittest discover -s PDVMOVEL/testes -v
```

Sem o `config.json` os testes são **pulados**, não falham — rodar a suíte numa máquina sem
ambiente não gera alarme falso. O `config.json` está no `.gitignore` porque contém o token do
device em texto puro.

## O que já está coberto

| Endpoint | Casos |
|---|---|
| (camada Basic) | sem usuário técnico → 401 |
| `POST /api/pdvmovel/v1/auth` | JSON inválido → 400; campos faltando → 400; token errado → 401; credencial válida → 200 com `vendedor`/`nome`/`filial` |
| `GET /api/pdvmovel/v1/cliente/:cnpjcpf` | sem token → 401; token inválido → 401; documento inválido → 400; cliente inexistente → 404; cliente existente → 200 |

Toda resposta de erro é checada contra o padrão TTALK (`code`, `message`, `detailedMessage`),
porque o app depende desse formato.

Os casos foram extraídos **dos fontes**, não supostos — cada `setStatusResponse` dos `.tlpp`
virou uma asserção.

## Qual ambiente roda os testes

```
https://cantuoeste192543.protheus.cloudtotvs.com.br:8401/rest
```

Mesmo host do ambiente de compilação `cantu-prod-comp`, mas **porta 8401** (REST) — não a 7600,
que é a de compilação. Estava fora do ar em 30/08/2026.

Como o RPO precisa ser promovido para esse ambiente, o ciclo é: compilar → promover → rodar
os testes.

## São DUAS camadas de autenticação

1. **HTTP Basic** com usuário técnico do Protheus (`pdvmovel`) — exigido pelo REST deste
   ambiente em **toda** requisição, inclusive no `/auth`. Sem ele o endpoint devolve 401 e nem
   chega no código AdvPL.
2. **Token do vendedor** (Z25) no header `X-Pdv-Token`.

Isso importa para o teste não mentir: sem o Basic, os casos que esperam 401 passariam **pelo
motivo errado**. Por isso toda requisição da suíte leva o Basic, e a diferença entre cenários
fica só no `X-Pdv-Token`.

## Atenção ao header de autenticação

Os endpoints protegidos leem **`X-Pdv-Token`**, e não `Authorization: Bearer`. É deliberado —
o `ListCatPDV.tlpp` explica que o `Authorization` fica reservado para o Basic.

O comentário no topo do `AuthPDV.tlpp` (linha 13) diz "Authorization: Bearer" e **está
desatualizado**. Quem implementar o cliente lendo aquele comentário toma 401 em tudo.

## O que falta

- Endpoints ainda sem teste: `GET /catalogo`, `GET /orcamentos-pendentes`, `POST /cliente`,
  `POST /venda`, `GET /venda/:numero`.
- Os dois `POST` gravam dado, então precisam de estratégia de limpeza antes de virar teste
  automático — senão cada execução suja a base. Sugestão: rodar só em ambiente de teste
  dedicado e limpar por SQL no `tearDown`.
## Estado (30/08/2026)

Executada contra o ambiente real: **11 testes, 5,7s, `OK (expected failures=1)`**.

A única falha esperada é o bug de campo ausente no `AuthPDV` — está documentada dentro do teste.
Quando o fonte for corrigido, o unittest acusa "unexpected success" e o marcador pode sair.

Dois cuidados com dado de teste, aprendidos na primeira execução:

- `99999999000191` **existe** em praticamente toda base — é o cliente fictício da homologação
  da NF-e. Serve como cliente existente, nunca como inexistente.
- Para o 404, o CNPJ precisa ter dígito verificador **válido** (senão cai no 400) e ausência
  confirmada na tabela real. A SA1 do cantu é `SA1CMP`, não `SA1400`.
