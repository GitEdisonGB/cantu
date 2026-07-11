logoHeader.src = "../../images/cantu.jpeg";


$("body").append(`<div class="modal fade" id="1000MARCAS_ModalAposAddCarrinho" role="dialog">
    <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Tipo de Entrega
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>						
                </h4>
            </div>
            <div class="modal-body">
                <form id="1000MARCAS_ModalFormAposAddCarrinho">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">
                            <label class="fonte">Tipo de entrega</label>
                            
                            <select id="selectTipoEntrega" class="form-control "  >  
                                <option value="2">2 - Retira NFC-e</option>
                                <option value="5">5 - Entrega</option>
                            </select>
                            <p id="infoEntregaCd" style="color: red"></p>
                        
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer" id="buttons">
                <button id="1000MARCASBtnCustomerOrderItem" class="btn btn-success" data-dismiss="modal" >Continuar <i class="fas fa-check"></i></button>
            </div>
        </div>
    </div>
</div>`);


//Libera o botão de fechar apenas como orçamento
document.getElementById("btnBudgetType").style.display = "";
//Muda o texto da seleção do tipo da venda
$("#textSelectTypeInvoice").html("<p>Informe se deverá gerar NFC-e, NF-e ou apenas orçamento.</p>");

createModal()
createButton()

// $(document).ready(function() {
//     console.log("Hello world");
//     // Get the input element using its ID with jQuery
//     var $vendedorInput = $("#vendedor");
    
//     // Remove the readonly attribute
//     $vendedorInput.removeAttr("readonly");
    
//     // Attach an event listener to track input changes
//     $vendedorInput.on("input", function() {
//       // Check if the current input length is greater than 3
//       if ($(this).val().length > 3) {
//         // Call your desired function passing the input value
//         myFunction($(this).val());
//       }
//     });
//   });
  
//   // Define the function to be executed when the condition is met
//   function myFunction(value) {
//     console.log("chamando função");
// sqltrans = 	" Select TOP 2 * From xEmp('SA3')"; // where A3_COD = '"+cCodVend+"' 

// query={
//     "cnpj_empresa":cCnpj,
//     "query" : sqltrans
// }

// $.ajax({
//     url: url + "QUERYRESULT", 
//     type: "POST",
//     async: true,
//     data: JSON.stringify(query),
//     dataType: "json",
//     contentType: "application/json",
//     success: function (data){
//         console.log("sucesso " + data);
//     },
//     error: function (jqXhr, textStatus, errorThrown) {
//         console.log("Erro " + errorThrown);
//     }
// });
//   }

function debounce(func, delay) {
    let timeout;
    return function(...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), delay);
    };
  }
  
  $(document).ready(function() {
    var $vendedorInput = $("#vendedor");
    $vendedorInput.removeAttr("readonly");
  
    $vendedorInput.on("click", function() {
      $(this).select();
    });
  
    // Append container
    if ($("#vendedorResults").length === 0) {
        $vendedorInput.after('<div id="vendedorResults" style="border: 1px solid #ccc; display: none; position: absolute; background: #fff; z-index: 1000; width: 100%; max-height: 200px; overflow-y: auto; box-shadow: 0px 2px 8px rgba(0,0,0,0.15); border-radius: 8px; margin-top: 25px;"></div>');
    }
  
    // Debounced input
    $vendedorInput.on("input", debounce(function() {
      if ($(this).val().length > 3) {
        myFunction($(this).val());
      } else {
        $("#vendedorResults").hide();
      }
    }, 700)); 
  });
  
  function myFunction(value) {
    console.log("chamando função", value);
    let sqltrans = `Select A3_NOME, A3_COD FROM xEmp('SA3') SA3 WHERE SA3.A3_COD LIKE '%${value.toUpperCase()}%'`;
    let query = {
      "cnpj_empresa": cCnpj,
      "query": sqltrans
    };
  
    $.ajax({
      url: url + "QUERYRESULT",
      type: "POST",
      data: JSON.stringify(query),
      dataType: "json",
      contentType: "application/json",
      success: function(data) {
        console.log("sucesso", data);
        if (data.Retorno === "OK" && data.Dados) {
          let resultsHtml = "";
          data.Dados.forEach(function(item) {
            let nome = item.A3_NOME.trim();
            resultsHtml += `<div class="vendedor-item" data-cod="${item.A3_COD}" data-nome="${nome}" style="padding: 5px; cursor: pointer;">${nome}</div>`;
          });
          $("#vendedorResults").html(resultsHtml).show();
          $(".vendedor-item").on("click", function() {
            let selectedName = $(this).data("nome");
            let selectedCod = $(this).data("cod");
            $("#vendedor").val(selectedName);
            cCodVend = selectedCod;
            cNomeVend = selectedName;
            $("#vendedorResults").hide();
          });
        }
      },
      error: function(jqXhr, textStatus, errorThrown) {
        console.log("Erro", errorThrown);
      }
    });
  }
  

function createButton() {
    const valorProdElement = document.getElementById('valorprod');
    const botao = document.createElement('button');
    botao.innerText = 'Novo valor';
    botao.style.cssText = "margin-left: 23px; width: 125px; height: 32px; font-size: 14px; border-radius: 4px; border: 1px solid #169F85; background-color: #26B99A; color: #ffffff; position: absolute; margin-top: 14px;"
    botao.addEventListener('click', function () {
        $("#modalNovoValor").modal({ backdrop: "static" });
    })
    valorProdElement.insertAdjacentElement('afterend', botao);
}

function createModal() {
    const modal = document.createElement('div');
    modal.className = 'modal fade';
    modal.id = 'modalNovoValor';
    modal.setAttribute('role', 'dialog');

    const modalDialog = document.createElement('div');
    modalDialog.className = 'modal-dialog modal-lg';

    const modalContent = document.createElement('div');
    modalContent.className = 'modal-content';

    const modalHeader = document.createElement('div');
    modalHeader.className = 'modal-header';

    const modalTitle = document.createElement('h4');
    modalTitle.className = 'modal-title';
    modalTitle.textContent = 'Novo Valor Unitário';

    const closeButton = document.createElement('button');
    closeButton.type = 'button';
    closeButton.className = 'close';
    closeButton.setAttribute('data-dismiss', 'modal');
    closeButton.setAttribute('aria-label', 'Close');

    const closeSpan = document.createElement('span');
    closeSpan.setAttribute('aria-hidden', 'true');
    closeSpan.textContent = '×';

    closeButton.appendChild(closeSpan);

    modalTitle.appendChild(closeButton);

    modalHeader.appendChild(modalTitle);

    const modalBody = document.createElement('div');
    modalBody.className = 'modal-body';

    const form = document.createElement('form');
    form.id = 'formNovoValor';

    const inputGroup = document.createElement('div');
    inputGroup.className = 'input-group input-group-lg col-lg-12 col-md-12 col-sm-12 col-xs-12';

    const input = document.createElement('input');
    input.type = 'number';
    input.className = 'form-control';
    input.placeholder = 'Digite o novo valor';
    input.autocomplete = 'off';
    input.id = 'novoValor';
    input.required = true;

    inputGroup.appendChild(input);

    form.appendChild(inputGroup);

    modalBody.appendChild(form);

    const modalFooter = document.createElement('div');
    modalFooter.className = 'modal-footer';
    modalFooter.id = 'buttons';

    const confirmarButton = document.createElement('button');
    confirmarButton.id = 'btnNovoValor';
    confirmarButton.className = 'btn btn-success';
    confirmarButton.innerHTML = 'Confirmar';
    confirmarButton.addEventListener('click', function () {
        const inputValue = document.getElementById('novoValor')
        const val = parseFloat(inputValue.value)
        add(val)
    })
    confirmarButton.setAttribute('data-dismiss', 'modal');

    modalFooter.appendChild(confirmarButton);

    modalContent.appendChild(modalHeader);
    modalContent.appendChild(modalBody);
    modalContent.appendChild(modalFooter);
    modalDialog.appendChild(modalContent);
    modal.appendChild(modalDialog);

    document.body.appendChild(modal);
}

function PE_ANT_buscaNrOrcamento(query) {
    // Get the current date
    let currentDate = new Date();
    let formattedDate = currentDate.getFullYear() + ('0' + (currentDate.getMonth() + 1)).slice(-2) + ('0' + currentDate.getDate()).slice(-2);
    query = "SELECT SL1.L1_NUM, SL1.L1_VLRLIQ, SL1.L1_EMISSAO, SL1.L1_CLIENTE, SL1.L1_LOJA, SA1.A1_NOME, SA1.A1_CGC, SL1.L1_VEND, SL2.L2_PRODUTO, SL2.L2_DESCRI, SL2.L2_QUANT, SL2.L2_VRUNIT, SL2.L2_VLRITEM, SL2.L2_LOCAL, SL2.L2_ENTREGA FROM xEmp('SL1') SL1 JOIN xEmp('SL2') SL2 ON SL2.L2_FILIAL = SL1.L1_FILIAL AND SL2.L2_NUM = SL1.L1_NUM AND SL2.D_E_L_E_T_ <> '*' JOIN xEmp('SA1') SA1 ON SA1.A1_FILIAL = xFilial('SA1') AND SA1.A1_COD = SL1.L1_CLIENTE AND SA1.A1_LOJA = SL1.L1_LOJA AND SA1.D_E_L_E_T_ <> '*' WHERE SL1.L1_FILIAL = xFilial('SL1') AND SL1.L1_DOC = ' ' AND SL1.L1_DTLIM >= '"+ formattedDate +"' AND SL1.L1_NUMFRT = ' ' AND SL1.D_E_L_E_T_ <> '*' ORDER BY SL1.L1_NUM DESC";
    return query;
    }

function PE_GERORC_ANTES_GERORC(jsonenv) {
    //
    const typeInvoice = sessionStorage.getItem("typeInvoice");
    jsonenv.cabecalho[0].LQ_IMPNF = (typeInvoice == "1" ? ".F." : ".T."); //1=NFC-e ; 2=NF-e
    jsonenv.cabecalho[0].LQ_SITUA = 'RX'

    $(jsonorc.itens).each(function (index) {
        jsonorc.itens[index]["LR_LOCAL"] = "NACION";
        jsonorc.itens[index]["LR_FILRES"] = "04";
    });
    if (jsonenv.pagamentos.length !== 0) {
        if (jsonenv.pagamentos[0].L4_FORMA == "PX") {
            jsonenv.pagamentos[0].AUTHCODE = "";
        }
    }
    $(".list-group-item").each(function (index) {

        jsonenv.itens[index]["LR_ENTREGA"] = $(this).data("ctipoentrega").toString();

    });

    return jsonenv;
}

function PE_ANT_BUSCA_PROD(cJsonBody) {
    console.log(cJsonBody);
    cJsonBody.cTabPadrao = "777"
    return cJsonBody;
}

function PE_FECHAR_PEDIDO() {
    //Para habilitar a seleção de tipo de nota NFCe ou NFe, basta criar o ponto de entrada
    //PE_FECHAR_PEDIDO chamando o modal abaixo
    $("#modalSelectTypeInvoice").modal({ backdrop: "static" });
}

function PE_CAMPOS_FORMCLIENTE(fieldsFormCustomer, next) {
    console.log(fieldsFormCustomer);
    fieldsFormCustomer[0].divisor[0].fields.push(
        {
            name: "Codigo da Nat Financeira",
            divClass: "col-md-4 col-sm-6 col-xs-12",
            inputClass: "",
            inputStyle: "text-transform: uppercase;",
            type: "text",
            picture: "",
            required: true,
            easyId: "cli-codnatfin-cantu",
            erpId: "A1_NATUREZ"
        },
        {
            name: "Optante Simples Nacional",
            divClass: "col-md-4 col-sm-6 col-xs-12",
            inputClass: "",
            inputStyle: "",
            type: "select",
            picture: "",
            required: true,
            easyId: "cli-optsimplesnac-cantu",
            options: [
                {
                    value: "1",
                    text: "Sim"
                },
                {
                    value: "2",
                    text: "Não"
                }
            ],
            value: "",
            erpId: "A1_SIMPNAC"
        },
        {
            name: "Tipo de Pessoa",
            divClass: "col-md-4 col-sm-6 col-xs-12",
            inputClass: "",
            inputStyle: "",
            type: "select",
            picture: "",
            required: true,
            easyId: "cli-tpessoa-cantu",
            options: [
                {
                    value: "CI",
                    text: "Comercio/Industria"
                },
                {
                    value: "PF",
                    text: "Pessoa Fisica"
                },
                {
                    value: "OS",
                    text: "Prestação de Serviço"
                }
            ],
            value: "",
            erpId: "A1_TPESSOA"
        },
        {
            name: "Contribuinte do ICMS",
            divClass: "col-md-4 col-sm-6 col-xs-12",
            inputClass: "",
            inputStyle: "",
            type: "select",
            picture: "",
            required: true,
            easyId: "cli-conticms-cantu",
            options: [
                {
                    value: "1",
                    text: "Sim"
                },
                {
                    value: "2",
                    text: "Não"
                }
            ],
            value: "",
            erpId: "A1_CONTRIB"
        },
        {
            name: "Clie. Optante Simples/SC",
            divClass: "col-md-4 col-sm-6 col-xs-12",
            inputClass: "",
            inputStyle: "",
            type: "select",
            picture: "",
            required: true,
            easyId: "cli-optsimples-cantu",
            options: [
                {
                    value: "1",
                    text: "Sim"
                },
                {
                    value: "2",
                    text: "Não"
                }
            ],
            value: "",
            erpId: "A1_SIMPLES"
        },
        {
            name: "Envia Serasa",
            divClass: "col-md-4 col-sm-6 col-xs-12",
            inputClass: "",
            inputStyle: "",
            type: "select",
            picture: "",
            required: true,
            easyId: "cli-enviaserasa-cantu",
            options: [
                {
                    value: "S",
                    text: "Sim"
                },
                {
                    value: "N",
                    text: "Não"
                }
            ],
            value: "",
            erpId: "A1_X_SERAS"
        }

    );

    var posclicep = fieldsFormCustomer[0].divisor[1].fields.findIndex(x => x.easyId == "cli-cep");

    if (posclicep >= 0) {
        fieldsFormCustomer[0].divisor[1].fields[posclicep].beforeSend = function () {
            return document.getElementById("cli-cep").value.replace(/\-/g, "");
        }
    }

    if (next) {
        next();
    }
}

function PE_NEWCLIENTE_ANTES(json) {

    json.A1_DDD = json.A1_TEL.substring(3, 1);

    return json;
}

function PE_DEPOIS_ADD_PRODUTO(item, divCarrinho, next) {
    nQtditemCarrinhoEntrega = 0;

    $("#1000MARCAS_ModalAposAddCarrinho").modal({ backdrop: "static" });
    document.getElementById("1000MARCASBtnCustomerOrderItem").onclick = function () {
        aposFornecerPedidoEItemDoCliente(item, divCarrinho, next);

        // $(".list-group-item").each(function() {
        //     if ($(this).data("ctipoentrega") == 3){
        //         nQtditemCarrinhoEntrega++;
        //     }

        // });
        // if (nQtditemCarrinhoEntrega > 0){
        //     if (nQtditemCarrinhoEntrega <=2){ //Valor minimo de frete sempre ser� duas vezes o valor do nValFrete
        //         nQtditemCarrinhoEntrega = 2;
        //     }

        //     //nValFrete = (nValPadraoFrete*nQtditemCarrinhoEntrega);
        //     document.getElementById("valorfrete").innerHTML= ((nValFrete).toFixed(2).toString().toLocaleString());
        // }
        somatorio();//Executa a atualiza��o dos totais

    }

}

function aposFornecerPedidoEItemDoCliente(item, divCarrinho, next) {
    var SinalS = 'font-weight: bold; size="2" ';
    var tamanho = 'size="5"';
    var Som1 = "somatorio";
    var Som2 = "somatorio";
    var nItem = 0;
    var cItem = '';
    //var dropdownGarantia = document.getElementById("1000MARCASCustomerOrder");
    //var content= dropdownGarantia.options[dropdownGarantia.selectedIndex].text;
    cCodigoProd = $("#codigo").data("codigo")
    nQuantidade = (parseFloat($("#qtde").val()))
    cCliente = $("#cliente").data("codigo")
    cLoja = $("#cliente").data("loja")
    //var valprod =  parseFloat($("#codigo").data("valor").replace(/\./g, "").replace(/\,/g, "."));
    var valprod = converterParaNumerico($(item + divCarrinho + '</a>').data("valor"));//converterParaNumerico($("#codigo").data("valor"));//parseFloat($("#codigo").data("valor"));

    //var precoNegociado =parseFloat($("#1000MarcasPrecoNegociado").val().replace(/\./g, "").replace(/\,/g, "."));

    //nQuantidade = parseInt($("#qtde").val());
    cDesconto = ((valprod * nQuantidade) * (parseFloat(cPercentual) / 100)).toFixed(2)//$("#reais").val()
    //nValUnitCDesc = (parseFloat($("#codigo").data("valor")-($('#reais').val())))-(parseFloat($("#codigo").data("valor")-($('#reais').val())))*(cPercentual/100).toFixed(2).toString()
    nValUnitCDesc = ((valprod) * (nQuantidade) - (parseFloat(cDesconto)))//.toFixed(2).toString().replace(/\./g, ",").replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1.")
    //nValorDesconto= ($("#reais").val() == "" ? 0 : parseFloat($("#reais").val().replace(/\./g, "").replace(/\,/g, "."))) //(parseFloat($("#codigo").data("valor")-($('#reais').val())))*(cPercentual/100).toFixed(2).toString()
    //nValorDesconto= ($("#reais").val() == "" ? 0 : (parseFloat($("#codigo").data("valor").replace(/\./g, "").replace(/\,/g, ".")))*(cPercentual/100))
    nValorDesconto = (($('#reais').val()))

    //var nValorDescontoUnitario = round(valprod*(parseFloat(cPercentual)/100),2);
    var nValorComDescontoUnitario = valprod;//(valprod - nValorDescontoUnitario);
    var nValorComDescontoTotal = nValorComDescontoUnitario * nQuantidade;


    // if (cPercentual == '' || cPercentual == '0,00' || cPercentual == '0.00'){
    //     cPercentual 	=  data.Dados.DESCONTO;//Agrega desconto no item conforme regra de desconto varejo.
    //     nValUnitCDesc 	= (parseFloat(nValUnitCDesc.replace(/\./g, "").replace(/\,/g, ".")) - parseFloat(nValUnitCDesc.replace(/\./g, "").replace(/\,/g, "."))*(cPercentual/100)).toFixed(2).toString().replace(/\./g, ",").replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1.");//menos valor de desconto.
    //     nValorDesconto	= (parseFloat($("#codigo").data("valor").replace(/\./g, "").replace(/\,/g, ".")))*(cPercentual/100) //((parseFloat($("#codigo").data("valor").replace(/\./g, "").replace(/\,/g, ".")))*(cPercentual/100)).toFixed(2).toString().replace(/\./g, ",").replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1.")
    // }
    // LR_VRUNIT = valor
    // LR_VLRITEM = valort
    // LR_PRCTAB = valor
    if ($("#1000MARCASCustomerOrder").val() != '') {
        $(".list-group-item").each(function (index) {
            nItem++
        });
        if (nItem == 0) {
            nItem = 1;
        } else {
            nItem += 1;
        }

    }

    cTipoEntrega = $("#selectTipoEntrega").val()

    cValsemDescont = $(item + divCarrinho + '</a>').data("valor")//$("#codigo").data("valor");
    cCodProduto = $("#codigo").data("codigo");
    cDescricaoProd = $("#codigo").val();
    cQtdEstoque = $("#codigo").data("estoque");
    if ($("#1000MARCASCustomerOrder").val() != '') {
        cItem = (nItem + 1).toString();
    } else {
        cItem = (0).toString();
    }
    //arrumado valort e valor, colocando o valor sem desconto
    //pois estava acusando erro de o LR_VALDESC(descontoreais) ser maior que o valor do item
    var item = '<a data-acessorio="acessorio"' +
        ' data-percent="' + cPercentual.toString() + '"' +
        ' data-descontoreais="' + nValorDesconto + '"' +
        ' data-codigo="' + cCodProduto + '"' +
        //' data-valort="'			+ nValorComDescontoTotal.toFixed(2) + '"' +
        //' data-valor="'				+ nValorComDescontoUnitario.toFixed(2) + '"' +
        ' data-valort="' + nValorComDescontoTotal.toString() + '"' +
        ' data-valor="' + nValorComDescontoUnitario.toString() + '"' +
        //' data-valort="'			+ nValUnitCDesc + '"' +
        //' data-valor="'				+ cValsemDescont + '"' +
        ' data-desc="' + cDescricaoProd + '"' +
        ' data-qtde="' + nQuantidade + '"' +
        ' data-reais="' + cDesconto + '"' +
        ' data-estoque="' + cQtdEstoque + '"' +
        ' data-itempro="' + cItem + '"' +
        ' data-ctipoentrega="' + cTipoEntrega + '"' +
        '" href="javascript:void(0);" class="list-group-item" ' + 'ondblclick="deleta(this);" onclick="selline(this);" id="itens"';

    var divCarrinho = '<div class="row" style="font-size: 12px;">' +
        '<div class="col-lg-4 " style="' + tamanho + '" >' + cCodProduto + ' - ' + cDescricaoProd + '</div>' +
        '<div class="col-lg-1 " align="center">' + nQuantidade + '</div>' +
        '<div class="col-lg-3 " align="left"  " >' + cValsemDescont + '</div>' +
        '<div class="col-lg-1 percentual" align="right"> ' + (parseFloat(cPercentual)).toFixed(2).toString() + '</div>' +
        '<div class="col-lg-3 somatorio" align="right" " style="' + SinalS + '" > ' + converterParaCaracter(nValUnitCDesc) + '</div>' +
        '</div>';

    if (parseFloat($("#codigo").data("estoque")) == 0.00) {
        divCarrinho += '<div class="row"><div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" align="center"><span class="style_indisponivel">&nbsp;&nbsp;&nbsp;Indisponn�vel em estoque.&nbsp;&nbsp;&nbsp;</span></div></div>';
    }

    item = item + '>' + divCarrinho + '</a>';
    //$("#1000MarcasPrecoNegociado").val("");
    //$("#1000MARCASCustomerOrderItem").val("");
    next(item)

}

function converterParaNumerico(selector) {
    // Obter o valor do data attribute
    var valorString = "";
    var valorNumerico = 0;
    if (typeof selector === "string") {

        valorString = selector;

        // Substituir a v�rgula por um ponto
        valorNumerico = parseFloat(valorString.replace(',', '.'));
    } else {
        valorNumerico = selector;
    }


    return valorNumerico;
}

function converterParaCaracter(value) {
    return value.toFixed(2).replace('.', ',');
}

/**
 * foi criado a função somatorio devido um erro na linha somatorio += parseFloat(this.innerText);
 * o sistema está trazendo valor incorreto na totalização e, para não impactar em todos os clientes em produção
 * realizarmos a troca para um fonte personalizado.
 */
function somatorio() {
    var somatorio = 0;
    var nQtdItem = 0;


    $(".somatorio").each(function () {
        var valorAtual = 0;

        if (this.innerText.includes(',')) {
            valorAtual = parseFloat(this.innerText.replace("R$ ", "").replace(/\./g, "").replace(",", "."));
        } else {
            valorAtual = parseFloat(this.innerText);
        }

        somatorio += valorAtual;
        nQtdItem++;
    });



    document.getElementById("valortotal").innerHTML = somatorio.toFixed(2).toString().replace(/\./g, ",").replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1.");
    document.getElementById("qtditens").innerHTML = nQtdItem.toString(); // adiciona item
};

/**
 * Customização feita por:
 * 
 * Matheus Okamoto Soós - Plentech LTDA.
 */

// Cria o campo observações no formulário
$(document).ready(function () {
    const divInputClienteHtml = `
        <div id="divInputObservacoes" class="row">
            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <label id="labelObservacoes" class="fonte" for="observacoes">Observacoes</label>
                <span id="spanObservacoes" style="color: red;font-size: small"></span>
                <div class="input-group input-group-lg clearable">
                    <input type="text" class="form-control clearableInput ui-autocomplete-input" autocomplete="off" placeholder="Informe as observacoes" name="nome" id="observacoes">
                    <i class="clearable__clear">×</i>
                    <span class="input-group-addon"></span>
                </div>
                <span id="lblcliente" class="span-erro"></span>
            </div>
        </div>`;

    const $divQuantidade = $('#divQuantidade');

    $(divInputClienteHtml).insertAfter($divQuantidade);
});

// Acrescenta os dados no cabecalho
$('#divAddProd button').on('click', function () {
    const observacoes = $('#observacoes').val();

    jsonorc.cabecalho[0].LQ_MENNOTA = observacoes;

    if (typeof PE_GERORC_ANTES_GERORC === 'function') {
        PE_GERORC_ANTES_GERORC(jsonorc);
    }
});

function PE_ANTES_PAGARORCAMENTO(orcamentosSelecionados) {
    const observacoes = JSON.parse(atob($(orcamentosSelecionados).data("orcamento")))[0].L1_MENNOTA.trim();
    $('#observacoes').val(observacoes);
    jsonorc.cabecalho[0].LQ_MENNOTA = observacoes;
}