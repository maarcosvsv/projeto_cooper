<%@ include file="../resources/jsp/header.jsp"%>
<script>
	$(document).ready(
					function() {
						//Função para formatar os números no modelo: R$ XXX.XX  
						var formatarNumero = function (valor){
							return parseFloat(valor).toLocaleString("pt-BR", { 
								style : "currency",
								currency : "BRL",
								minimumFractionDigits : 2,
								maximumFractionDigits : 2
							});
						}
							
						/**
						Inicialização - Os dados são recebidos pela requisição: investimentoResgate
						Aqui serão formatados e toda a validação de formulário será feita pelo JQuery.
						 **/

						//Variáveis de controle para mostrar os valores totais formatados
						var investimentoSaldoTotal = $("#investimentoSaldoTotal").text();
						var saldoResgatar = $("#saldoResgatar").text();

						$("#investimentoSaldoTotal").html(formatarNumero(investimentoSaldoTotal));
						$("#saldoResgatar").html(formatarNumero(0));

						/**
						Método responsável por calcular o valor a ser resgatado, e formatar no padrão brasileiro.
						 **/
						var recalculaSaldoResgatar = (function() {
							saldoResgatar = 0.0;

							/**
							Percorre toda a lista com os registros de ações 
							e soma o valor preenchido no campo textual
							 **/
							$("#tabelaResgate tr:gt(0)").each(
									function() {
										var linhaAtual = $(this);
										saldoResgatar = saldoResgatar
												+
												/**
												Faz a troca da vírgula por ponto para correta validação do número em formato float
												 **/
												+linhaAtual.find('input').val()
														.replace(",", ";")
														.replace(".", "")
														.replace(";", ".");
									});

							$("#saldoResgatar").html(
									formatarNumero(saldoResgatar));

						});

						//Após preencher a tela, os saldos acumulados de ações serão formatados
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

						//Toda vez que um Input, do tipo resgateAcao, for preenchido os saldo a ser resgatado será atualizado 
						$(".resgateAcao").keyup(function() {
							$(this).maskMoney({
								thousands : '.',
								decimal : ','
							});
							recalculaSaldoResgatar();
						});
						;

						//Redireciona para página inicial
						$("#btnCancelar")
								.on(
										"click",
										function() {
											window.location.href = "${requestScope['javax.servlet.forward.context_path']}";

										});

						//Define os critérios de validação e alertas ao usuário
						$("#btnResgatar").on("click",function() {
							
							//Recalcula o saldo novamente
							recalculaSaldoResgatar();
							
							//Se o saldo a resgatar menor ou igual a zero o usuário deve informar um valor
							if (saldoResgatar <= 0) {
								$('#modal-title').html("Atenção!");
								$('#modal-body').html("Você deve informar um valor para resgate!");
								$('#modal-btn-fechar').html("Fechar");
								$('#investimentoModal').modal('show');

							} else {
								//Verifica se algum resgate de ação está incorreto
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
											erros += "O valor informado para a ação " + linhaAtual.find('td:eq(1)').html()
														+ " é inválido, o máximo para esta ação é: "
														+ formatarNumero(saldoAcumuladoAcao)
														+ "<br />";
									}});
								
									//Se tem erros alerta o usuário
									if (erros != "") {
										$('#modal-title').html("Valores inválidos!");
										$('#modal-body').html(erros);
										$('#investimentoModal').modal('show');
										$('#modal-btn-fechar').html("Fechar");
									
									} else {
										$('#modal-title').html("Resgate efetuado!");
										$('#modal-body').html("Dentro de 5 dias úteis o valor estará em sua conta.");
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
						href="${requestScope['javax.servlet.forward.context_path']}">Página
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
							class="form-text text-muted">Saldo disponível</small></label>
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
						<th scope="col">AÇÃO</th>
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
					<button type="button" class="close" data-dismiss="modal">×</button>
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