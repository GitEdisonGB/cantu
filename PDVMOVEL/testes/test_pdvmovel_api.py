"""Testes de contrato da API REST do PDV Movel (cantu).

Testa o CONTRATO dos endpoints por HTTP puro - sem SmartClient, sem Webapp, sem TIR.
Roda em segundos e nao depende de tela, so do servico REST publicado no ambiente.

Como rodar:
    copie config.exemplo.json para config.json, preencha, e:
    python -m unittest discover -s PDVMOVEL/testes -v

Sem config.json os testes sao PULADOS (skip), nao falham - assim rodar a suite num
lugar sem ambiente nao gera alarme falso.

===================================================================================
SAO DUAS CAMADAS DE AUTENTICACAO, NAO UMA (fonte: C:\\spool\\decisoes.md, 21/08/2026)
===================================================================================
1. HTTP Basic com usuario tecnico do Protheus (ex.: 'pdvmovel') - exigido pelo REST
   deste ambiente em TODA requisicao, inclusive no /auth. Sem ele o endpoint devolve
   401 e nem chega no codigo AdvPL.
2. Token do vendedor da Z25, no header 'X-Pdv-Token'.

Isso importa pro teste nao mentir: se a suite esquecer o Basic, os casos que esperam
401 PASSAM pelo motivo errado (falta de Basic, nao falta de token de vendedor) e o
caso de 200 falha. Por isso todo request aqui leva o Basic, e a diferenca entre os
cenarios fica so no X-Pdv-Token.

O token de vendedor NAO vai em 'Authorization: Bearer' - colidiria com o Basic, ja
que so existe um header Authorization por request. O comentario no topo do
AuthPDV.tlpp ainda diz "Bearer" e esta desatualizado.

Contrato coberto (extraido dos fontes, nao suposto):
    POST /api/pdvmovel/v1/auth             200 {vendedor,nome,filial} | 400 | 401 | 500
    GET  /api/pdvmovel/v1/cliente/:cnpjcpf 200 | 400 | 401 | 404
    erro sempre no padrao TTALK: {code, message, detailedMessage}
"""
import json
import os
import unittest

import requests
from requests.auth import HTTPBasicAuth

AQUI = os.path.dirname(os.path.abspath(__file__))
CONFIG = os.path.join(AQUI, "config.json")

AUTH = "/api/pdvmovel/v1/auth"
CLIENTE = "/api/pdvmovel/v1/cliente"
CATALOGO = "/api/pdvmovel/v1/catalogo"
ORCAMENTOS = "/api/pdvmovel/v1/orcamentos-pendentes"
VENDA = "/api/pdvmovel/v1/venda"
HEADER_TOKEN = "X-Pdv-Token"


def carrega_config():
    if not os.path.isfile(CONFIG):
        return None
    with open(CONFIG, encoding="utf-8") as fh:
        return json.load(fh)


CFG = carrega_config()
MOTIVO_SKIP = (
    "config.json ausente em PDVMOVEL/testes - copie o config.exemplo.json e preencha "
    "com o ambiente de teste"
)


@unittest.skipIf(CFG is None, MOTIVO_SKIP)
class BaseAPI(unittest.TestCase):
    """Base compartilhada: URL, Basic Auth do usuario tecnico e formato de erro."""

    @classmethod
    def setUpClass(cls):
        cls.base = CFG["base_url"].rstrip("/")
        cls.timeout = CFG.get("timeout_segundos", 30)
        cls.vendedor = CFG["vendedor"]
        cls.token = CFG["token"]
        cls.basic = HTTPBasicAuth(CFG["usuario_rest"], CFG["senha_rest"])

    def url(self, caminho):
        return self.base + caminho

    def assertErroTTALK(self, resposta, status_esperado):
        """Todo erro da API deve seguir o padrao TTALK - o app depende disso."""
        self.assertEqual(
            resposta.status_code, status_esperado,
            f"esperado {status_esperado}, veio {resposta.status_code}: {resposta.text[:300]}")
        try:
            corpo = resposta.json()
        except ValueError:
            self.fail(f"resposta de erro nao e JSON: {resposta.text[:300]}")
        for campo in ("code", "message", "detailedMessage"):
            self.assertIn(campo, corpo, f"campo '{campo}' ausente no erro: {corpo}")


class TestCamadaBasic(BaseAPI):
    """A camada de usuario tecnico existe e barra quem nao a satisfaz."""

    def test_sem_basic_auth_o_rest_recusa(self):
        r = requests.post(self.url(AUTH),
                          json={"vendedor": self.vendedor, "token": self.token},
                          timeout=self.timeout)
        self.assertEqual(r.status_code, 401,
                         "esperava 401 sem Basic Auth do usuario tecnico; "
                         f"veio {r.status_code}: {r.text[:200]}")


class TestAutenticacaoVendedor(BaseAPI):
    """Com Basic Auth valido, testa a autenticacao de vendedor da Z25."""

    def test_body_json_invalido_retorna_400(self):
        r = requests.post(self.url(AUTH), data="isto nao e json", auth=self.basic,
                          headers={"Content-Type": "application/json"}, timeout=self.timeout)
        self.assertErroTTALK(r, 400)

    def test_campos_vazios_retorna_400(self):
        """Chave presente com valor vazio: a validacao funciona."""
        r = requests.post(self.url(AUTH), json={"vendedor": "", "token": ""},
                          auth=self.basic, timeout=self.timeout)
        self.assertErroTTALK(r, 400)

    @unittest.expectedFailure
    def test_campos_ausentes_deveria_retornar_400(self):
        """BUG CONHECIDO (confirmado no ambiente em 30/08/2026, AuthPDV.tlpp:42).

        Quando a chave esta AUSENTE do JSON (e nao apenas vazia), a guarda
        `If Empty(AllTrim(cVend)) .Or. Empty(cToken)` nao dispara: o GetJsonText de
        chave inexistente nao devolve algo que o Empty() reconheca. O fluxo segue pra
        consulta na Z25 e devolve 401 "Vendedor ou token invalido" em vez de 400.

        Impacto: quem integra recebe "falha de autenticacao" quando o problema real e
        requisicao malformada - diagnostico errado e tempo perdido. Alem disso o valor
        nao-vazio inesperado segue pro SHA256() e pra query.

        Marcado como expectedFailure pra suite nao ficar vermelha por um bug ja
        conhecido. Quando o fonte for corrigido, este teste vira "unexpected success"
        e o proprio unittest avisa que da pra remover o marcador.
        """
        for corpo in ({}, {"vendedor": self.vendedor}, {"token": self.token}):
            with self.subTest(corpo=corpo):
                r = requests.post(self.url(AUTH), json=corpo, auth=self.basic,
                                  timeout=self.timeout)
                self.assertErroTTALK(r, 400)

    def test_token_de_vendedor_invalido_retorna_401(self):
        r = requests.post(self.url(AUTH), auth=self.basic,
                          json={"vendedor": self.vendedor, "token": "token-que-nao-existe-xyz"},
                          timeout=self.timeout)
        self.assertErroTTALK(r, 401)

    def test_credencial_valida_retorna_200_com_dados_do_vendedor(self):
        r = requests.post(self.url(AUTH), auth=self.basic,
                          json={"vendedor": self.vendedor, "token": self.token},
                          timeout=self.timeout)
        self.assertEqual(r.status_code, 200, f"falhou: {r.text[:300]}")
        corpo = r.json()
        for campo in ("vendedor", "nome", "filial"):
            self.assertIn(campo, corpo, f"campo '{campo}' ausente na resposta: {corpo}")
        self.assertEqual(corpo["vendedor"], self.vendedor.strip())
        self.assertTrue(corpo["nome"].strip(), "nome do vendedor veio vazio")


class TestEndpointProtegido(BaseAPI):
    """GET de cliente como representante do comportamento de todo endpoint protegido."""

    def cnpj(self):
        return CFG.get("cnpj_cliente_existente") or "12345678000199"

    def test_sem_token_de_vendedor_retorna_401(self):
        # Basic Auth presente de proposito: isola a falta do X-Pdv-Token como causa.
        r = requests.get(self.url(f"{CLIENTE}/{self.cnpj()}"), auth=self.basic,
                         timeout=self.timeout)
        self.assertErroTTALK(r, 401)

    def test_token_de_vendedor_invalido_retorna_401(self):
        r = requests.get(self.url(f"{CLIENTE}/{self.cnpj()}"), auth=self.basic,
                         headers={HEADER_TOKEN: "token-que-nao-existe-xyz"}, timeout=self.timeout)
        self.assertErroTTALK(r, 401)

    def test_documento_invalido_retorna_400(self):
        r = requests.get(self.url(f"{CLIENTE}/123"), auth=self.basic,
                         headers={HEADER_TOKEN: self.token}, timeout=self.timeout)
        self.assertErroTTALK(r, 400)

    def test_cliente_inexistente_retorna_404(self):
        """CNPJ com digito verificador valido (senao cairia no 400) e ausente da base.

        NAO usar 99999999000191 aqui: e o cliente ficticio da homologacao da NF-e
        ("NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO"), que EXISTE em praticamente toda
        base Protheus - conferido na SA1CMP em 30/08/2026. Ele serve como cliente
        EXISTENTE, nao como inexistente.

        Ausencia de 11222333000181 confirmada na tabela fisica real da SA1.
        """
        r = requests.get(self.url(f"{CLIENTE}/11222333000181"), auth=self.basic,
                         headers={HEADER_TOKEN: self.token}, timeout=self.timeout)
        self.assertErroTTALK(r, 404)

    @unittest.skipIf(CFG is None or not CFG.get("cnpj_cliente_existente"),
                     "cnpj_cliente_existente nao configurado")
    def test_cliente_existente_retorna_200(self):
        r = requests.get(self.url(f"{CLIENTE}/{CFG['cnpj_cliente_existente']}"), auth=self.basic,
                         headers={HEADER_TOKEN: self.token}, timeout=self.timeout)
        self.assertEqual(r.status_code, 200, f"falhou: {r.text[:300]}")
        self.assertIn("codigo", r.json())


class TestCatalogo(BaseAPI):
    """GET /catalogo - carga completa ou delta pelo parametro 'desde'."""

    def test_sem_token_retorna_401(self):
        r = requests.get(self.url(CATALOGO), auth=self.basic, timeout=self.timeout)
        self.assertErroTTALK(r, 401)

    def test_carga_completa_retorna_200(self):
        r = requests.get(self.url(CATALOGO), auth=self.basic,
                         headers={HEADER_TOKEN: self.token}, timeout=self.timeout)
        self.assertEqual(r.status_code, 200, f"falhou: {r.text[:300]}")
        self.assertIsInstance(r.json(), dict)

    def test_desde_fora_do_formato_retorna_400(self):
        for valor in ("2026", "abc", "20260830123", "2026-08-30"):
            with self.subTest(desde=valor):
                r = requests.get(self.url(CATALOGO), auth=self.basic,
                                 headers={HEADER_TOKEN: self.token},
                                 params={"desde": valor}, timeout=self.timeout)
                self.assertErroTTALK(r, 400)

    def test_desde_valido_retorna_200(self):
        r = requests.get(self.url(CATALOGO), auth=self.basic,
                         headers={HEADER_TOKEN: self.token},
                         params={"desde": "20260101000000"}, timeout=self.timeout)
        self.assertEqual(r.status_code, 200, f"falhou: {r.text[:300]}")


class TestOrcamentosPendentes(BaseAPI):
    """GET /orcamentos-pendentes - orcamentos nao faturados do vendedor."""

    def test_sem_token_retorna_401(self):
        r = requests.get(self.url(ORCAMENTOS), auth=self.basic, timeout=self.timeout)
        self.assertErroTTALK(r, 401)

    def test_com_token_retorna_200_com_lista(self):
        r = requests.get(self.url(ORCAMENTOS), auth=self.basic,
                         headers={HEADER_TOKEN: self.token}, timeout=self.timeout)
        self.assertEqual(r.status_code, 200, f"falhou: {r.text[:300]}")
        corpo = r.json()
        self.assertIn("orcamentos", corpo)
        self.assertIsInstance(corpo["orcamentos"], list)


class TestVendaValidacoes(BaseAPI):
    """POST /venda - SO os caminhos de validacao, que NAO gravam nada.

    O caminho feliz gravaria orcamento/pedido/NFC-e de verdade na base. Fica de fora
    ate existir estrategia de limpeza - teste que suja base a cada execucao vira lixo
    acumulado e some com a confianca no resultado.
    """

    def corpo_valido(self, **troca):
        base = {"cliente": CFG.get("cnpj_cliente_existente"),
                "tipo": "ORCAMENTO",
                "itens": [{"codigo": "000001", "quantidade": 1}]}
        base.update(troca)
        return base

    def test_sem_token_retorna_401(self):
        r = requests.post(self.url(VENDA), auth=self.basic, json=self.corpo_valido(),
                          timeout=self.timeout)
        self.assertErroTTALK(r, 401)

    def test_json_invalido_retorna_400(self):
        r = requests.post(self.url(VENDA), auth=self.basic, data="nao e json",
                          headers={HEADER_TOKEN: self.token, "Content-Type": "application/json"},
                          timeout=self.timeout)
        self.assertErroTTALK(r, 400)

    def test_cliente_ausente_retorna_400(self):
        r = requests.post(self.url(VENDA), auth=self.basic,
                          headers={HEADER_TOKEN: self.token},
                          json=self.corpo_valido(cliente=""), timeout=self.timeout)
        self.assertErroTTALK(r, 400)
        self.assertIn("cliente", r.json()["message"].lower())

    def test_tipo_invalido_retorna_400(self):
        r = requests.post(self.url(VENDA), auth=self.basic,
                          headers={HEADER_TOKEN: self.token},
                          json=self.corpo_valido(tipo="BOLETO"), timeout=self.timeout)
        self.assertErroTTALK(r, 400)
        self.assertIn("tipo", r.json()["message"].lower())

    def test_documento_invalido_retorna_400(self):
        r = requests.post(self.url(VENDA), auth=self.basic,
                          headers={HEADER_TOKEN: self.token},
                          json=self.corpo_valido(cliente="123"), timeout=self.timeout)
        self.assertErroTTALK(r, 400)

    def test_sem_itens_retorna_400(self):
        r = requests.post(self.url(VENDA), auth=self.basic,
                          headers={HEADER_TOKEN: self.token},
                          json=self.corpo_valido(itens=[]), timeout=self.timeout)
        self.assertErroTTALK(r, 400)
        self.assertIn("iten", r.json()["message"].lower())

    def test_cliente_nao_cadastrado_retorna_400(self):
        # CNPJ valido e ausente da base: a venda para antes de gravar qualquer coisa.
        r = requests.post(self.url(VENDA), auth=self.basic,
                          headers={HEADER_TOKEN: self.token},
                          json=self.corpo_valido(cliente="11222333000181"), timeout=self.timeout)
        self.assertErroTTALK(r, 400)
        self.assertIn("cadastrad", r.json()["message"].lower())


class TestConsultaVenda(BaseAPI):
    """GET /venda/:numero - situacao da venda."""

    def test_sem_token_retorna_401(self):
        r = requests.get(self.url(f"{VENDA}/000001"), auth=self.basic, timeout=self.timeout)
        self.assertErroTTALK(r, 401)

    def test_numero_inexistente_retorna_404(self):
        r = requests.get(self.url(f"{VENDA}/ZZZ999"), auth=self.basic,
                         headers={HEADER_TOKEN: self.token}, timeout=self.timeout)
        self.assertErroTTALK(r, 404)


class TestCadastroClienteValidacoes(BaseAPI):
    """POST /cliente - SO validacao e conflito, que nao gravam nada."""

    def test_sem_token_retorna_401(self):
        r = requests.post(self.url(CLIENTE), auth=self.basic,
                          json={"documento": "11222333000181"}, timeout=self.timeout)
        self.assertErroTTALK(r, 401)

    def test_campos_obrigatorios_ausentes_retorna_400(self):
        r = requests.post(self.url(CLIENTE), auth=self.basic,
                          headers={HEADER_TOKEN: self.token},
                          json={"documento": "11222333000181"}, timeout=self.timeout)
        self.assertErroTTALK(r, 400)
        self.assertIn("obrigatorios", r.json()["message"].lower())

    def test_cliente_ja_cadastrado_retorna_409(self):
        """Conflito e detectado ANTES da gravacao - nada e criado por este teste."""
        corpo = {"documento": CFG.get("cnpj_cliente_existente"), "nome": "TESTE AUTOMATIZADO",
                 "tipoPessoa": "PF", "endereco": "RUA TESTE, 1", "bairro": "CENTRO",
                 "municipio": "CASCAVEL", "uf": "PR", "cep": "85800000", "ddd": "45",
                 "telefone": "999999999", "naturezaFinanceira": "1"}
        r = requests.post(self.url(CLIENTE), auth=self.basic,
                          headers={HEADER_TOKEN: self.token}, json=corpo, timeout=self.timeout)
        self.assertErroTTALK(r, 409)


if __name__ == "__main__":
    unittest.main(verbosity=2)
