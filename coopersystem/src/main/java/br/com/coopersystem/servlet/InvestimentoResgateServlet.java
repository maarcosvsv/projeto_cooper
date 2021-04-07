package br.com.coopersystem.servlet;

import java.io.IOException;

import javax.inject.Inject;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.codec.binary.Base64;
import org.json.JSONObject;

import br.com.coopersystem.entity.Investimento;
import br.com.coopersystem.service.InvestimentoService;

/**
 * InvestimentoService - 05/04/2021 Servlet responsável por redirecionar os
 * dados para resgate de investimento
 * 
 * @version 1.0
 * @author Marcos Vasconcelos
 */

@WebServlet(urlPatterns = { "/investimentoResgate" })
public class InvestimentoResgateServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Inject
	private InvestimentoService investimentoService;

	public InvestimentoResgateServlet() {
		super();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String dadosRecebidos = (String) request.getParameter("dadosInvestimento");
		String dadosInvestimento = new String(Base64.decodeBase64(dadosRecebidos.getBytes()));

		Investimento investimento = investimentoService.parseInvestimentoJson(new JSONObject(dadosInvestimento));
		request.setAttribute("investimento", investimento);

		RequestDispatcher dispatcher = request.getServletContext()
				.getRequestDispatcher("/views/resgateInvestimento.jsp");
		dispatcher.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
