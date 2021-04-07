<%@ include file="../resources/jsp/header.jsp" %>
<script>
$(document).ready(function(){
	
	// Formata os valores na tabela: tabelaInvestimentos
	$("#tabelaInvestimentos tr:gt(0)").each(function () {
	  var linhaAtual = $(this);
	  var saldoTotalDisponivel = $.trim(linhaAtual.find('td:eq(2)').html());
	  var saldoTotalDisponivelFormatado = parseFloat(saldoTotalDisponivel).toLocaleString("pt-BR", { style: "currency" , currency:"BRL"});
	  linhaAtual.find('td:eq(2)').html(saldoTotalDisponivelFormatado);
       
    });
	
			
});
</script>

<title>Página Inicial</title>

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
					<li class="nav-item active"><a class="nav-link"
						href="${requestScope['javax.servlet.forward.context_path']}">Página
							Inicial <span class="sr-only">(current)</span>
					</a></li>
					<li class="nav-item"><a class="nav-link disabled" href="#">Resgate</a>
					</li>
				</ul>
				
			</div>
		</nav>
	</header>

	<!-- Begin page content -->

	<main role="main" class="container">
		<div class="div-main">
			<p class="lead">Olá! Seja bem vindo, para iniciar o resgate de um
				investimento selecione-o na listagem abaixo.</p>
				
			<table id="tabelaInvestimentos" class="table table-margin-top">
				<thead>
					<tr>
						<th scope="col">Nome</th>
						<th scope="col">Objetivo</th>
						<th scope="col">Saldo total disponível</th>
						<th scope="col">Resgate</th>

					</tr>
				</thead>
				<tbody>
					<c:set var="investimentos" value="${investimentos}" />


					<c:forEach items="${investimentos}" var="investimento">
						<c:if test="${investimento.indicadorCarencia == false}">
							<tr>
								<td>${investimento.nome}</td>
								<td>${investimento.objetivo}</td>
								<td id="saldoTotalDisponivel">${investimento.saldoTotalDisponivel}</td>

								<td>
									<form action="/coopersystem/investimentoResgate" method="GET">
										<input type="hidden" name="dadosInvestimento"
											value="${investimento.getInvestimentoJson()}" />
										<button type="submit" class="btn btn-primary">Resgatar</button>
									</form>
							</tr>
						</c:if>
					</c:forEach>
			</tbody>
			</table>

		</div>
	</main>
</body>
</html>