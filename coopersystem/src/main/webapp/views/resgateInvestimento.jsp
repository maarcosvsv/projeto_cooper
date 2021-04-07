<%@ include file="../resources/jsp/header.jsp"%>
<script>
	$(document).ready(
					function() {
						//Fun��o para formatar os n�meros no modelo: R$ XXX.XX  
						var formatarNumero = function (valor){
							return parseFloat(valor).toLocaleString("pt-BR", { 
								style : "currency",
								currency : "BRL",
								minimumFractionDigits : 2,
								maximumFractionDigits : 2
							});
						}
							
						/**
						Inicializa��o - Os dados s�o recebidos pela requisi��o: investimentoResgate
						Aqui ser�o formatados e toda a valida��o de formul�rio ser� feita pelo JQuery.
						 **/

						//Vari�veis de controle para mostrar os valores totais formatados
						var investimentoSaldoTotal = $("#investimentoSaldoTotal").text();
						var saldoResgatar = $("#saldoResgatar").text();

						$("#investimentoSaldoTotal").html(formatarNumero(investimentoSaldoTotal));
						$("#saldoResgatar").html(formatarNumero(0));

						/**
						M�todo respons�vel por calcular o valor a ser resgatado, e formatar no padr�o brasileiro.
						 **/
						var recalculaSaldoResgatar = (function() {
							saldoResgatar = 0.0;

							/**
							Percorre toda a lista com os registros de a��es 
							e soma o valor preenchido no campo textual
							 **/
							$("#tabelaResgate tr:gt(0)").each(
									function() {
										var linhaAtual = $(this);
										saldoResgatar = saldoResgatar
												+
												/**
												Faz a troca da v�rgula por ponto para correta valida��o do n�mero em formato float
												 **/
												+linhaAtual.find('input').val()
														.replace(",", ";")
														.replace(".", "")
														.replace(";", ".");
									});

							$("#saldoResgatar").html(
									formatarNumero(saldoResgatar));

						});

						//Ap�s preencher a tela, os saldos acumulados de a��es ser�o formatados
						$("#tabelaResgate tr:gt(0)")
								.each(
										function() {
											var linhaAtual = $(this);
											var percentualInvestimento = $
													.trim(linhaAtual.find(
															'td:eq(3)').html());
											var saldoAcumuladoAcao = (investimentoSaldoTotal * percentualInvestimento) / 100;
											saldoAcumuladoAcao = parseFloat(
													saldoAcumuladoAcao)
													.toLocaleString("pt-BR", {
														style : "currency",
														currency : "BRL"
													});
											linhaAtual.find('td:eq(2)').html(
													saldoAcumuladoAcao);
										});

						//Toda vez que um Input, do tipo resgateAcao, for preenchido os saldo a ser resgatado ser� atualizado 
						$(".resgateAcao").keyup(function() {
							$(this).maskMoney({
								thousands : '.',
								decimal : ','
							});
							recalculaSaldoResgatar();
						});
						;

						//Redireciona para p�gina inicial
						$("#btnCancelar")
								.on(
										"click",
										function() {
											window.location.href = "${requestScope['javax.servlet.forward.context_path']}";

										});

						//Define os crit�rios de valida��o e alertas ao usu�rio
						$("#btnResgatar").on("click",function() {
							
							//Recalcula o saldo novamente
							recalculaSaldoResgatar();
							
							//Se o saldo a resgatar menor ou igual a zero o usu�rio deve informar um valor
							if (saldoResgatar <= 0) {
								$('#modal-title').html("Aten��o!");
								$('#modal-body').html("Voc� deve informar um valor para resgate!");
								$('#modal-btn-fechar').html("Fechar");
								$('#investimentoModal').modal('show');

							} else {
								//Verifica se algum resgate de a��o est� incorreto
								var erros = "";
								$("#tabelaResgate tr:gt(0)").each(function() {
									var linhaAtual = $(this);
									var percentualInvestimento = $.trim(linhaAtual.find('td:eq(3)').html());
									var saldoAcumuladoAcao = parseFloat((investimentoSaldoTotal * percentualInvestimento) / 100).toFixed(2);
									var saldoResgateInformado = linhaAtual.find('input').val().replace(",", ";").replace(".", "").replace(";", ".");
									
									if (saldoResgateInformado != null
											&& saldoResgateInformado != ""
											&& saldoResgateInformado != undefined
											&& Number(saldoResgateInformado) >  Number(saldoAcumuladoAcao)) {
											erros += "O valor informado para a a��o " + linhaAtual.find('td:eq(1)').html()
														+ " � inv�lido, o m�ximo para esta a��o �: "
														+ formatarNumero(saldoAcumuladoAcao)
														+ "<br />";
									}});
								
									//Se tem erros alerta o usu�rio
									if (erros != "") {
										$('#modal-title').html("Valores inv�lidos!");
										$('#modal-body').html(erros);
										$('#investimentoModal').modal('show');
										$('#modal-btn-fechar').html("Fechar");
									
									} else {
										$('#modal-title').html("Resgate efetuado!");
										$('#modal-body').html("Dentro de 5 dias �teis o valor estar� em sua conta.");
										$('#investimentoModal').modal('show');
										$('#modal-btn-fechar').html("NOVO RESGATE");
										$('#modal-btn-fechar').on("click", function() {
											window.location.href = "${requestScope['javax.servlet.forward.context_path']}";
										});
									}
						}
				});
		});
</script>


<title>Resgate Investimento - ${investimento.nome}</title>

</head>

<body class="body">
	<header>
		<!-- Fixed navbar -->
		<nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
			<a class="navbar-brand" href="#"></a>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarCollapse" aria-controls="navbarCollapse"
				aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarCollapse">
				<ul class="navbar-nav mr-auto">
					<li class="nav-item"><a class="nav-link"
						href="${requestScope['javax.servlet.forward.context_path']}">P�gina
							Inicial 
					</a></li>
					<li class="nav-item active"><a class="nav-link" href="#">Resgate<span class="sr-only">(current)</span></a>
					</li>
				</ul>

			</div>
		</nav>
	</header>

	<!-- Begin page content -->

	<main role="main" class="container">

		<div class="div-main">
			<p class="lead text-center">DADOS DO INVESTIMENTO</p>

			<div class="container">
				<div class="row">
					<div class="col-sm">
						<label for="investimentoNome"><small
							class="form-text text-muted">Nome</small></label>
						<p id="investimentoNome">${investimento.nome}</p>
					</div>
					<div class="col-sm">
						<label for="investimentoObjetivo"><small
							class="form-text text-muted">Objetivo</small></label>
						<p id="investimentoObjetivo">${investimento.objetivo}</p>
					</div>
					<div class="col-sm">
						<label for="investimentoSaldoTota"><small
							class="form-text text-muted">Saldo dispon�vel</small></label>
						<p id="investimentoSaldoTotal">${investimento.saldoTotalDisponivel}</p>
					</div>
					<div class="col-sm">
						<label for="saldoResgatar"><small
							class="form-text text-muted">Saldo total a resgatar</small></label>
						<p id="saldoResgatar">0</p>
					</div>


				</div>
			</div>
		</div>
		<div class="div-content">

			<p class="lead text-center">RESGATE DO SEU JEITO</p>
			<div class="row justify-content-center">

			<table id="tabelaResgate" class="table table-sm table-striped text-center" style="max-width: 70%">
				<thead>
					<tr>
						<th scope="col">#</th>
						<th scope="col">A��O</th>
						<th scope="col">SALDO</th>
						<th scope="col">VALOR DE RESGATE</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${investimento.acoes}" var="acao">
						<tr>
							<td>${acao.id}
							<td>${acao.nome}</td>
							<td>0</td>
							<td class="none">${acao.percentual}</td>
							<td><div class="resgate-group">
									<input class="resgateAcao" data-id="${acao.id}"
										data-percentual="${acao.percentual}" type="text"
										placeholder="${acao.nome}" />
								</div></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</div>
			<div class="div-center">
				<button id="btnResgatar" type="submit" class="btn btn-primary">RESGATAR</button>
				<button id="btnCancelar" type="button" class="btn btn-danger">CANCELAR</button>
			</div>
		</div>

	</main>

	<!-- The Modal -->
	<div class="modal fade" id="investimentoModal">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
					<h4 id="modal-title" class="modal-title"></h4>
					<button type="button" class="close" data-dismiss="modal">�</button>
				</div>

				<!-- Modal body -->
				<div id="modal-body" class="modal-body"></div>

				<div class="modal-footer">
					<button id="modal-btn-fechar" type="button" class="btn btn-primary"
						data-dismiss="modal"></button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>