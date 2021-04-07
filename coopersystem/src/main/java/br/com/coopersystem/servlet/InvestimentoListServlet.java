package br.com.coopersystem.servlet;

import java.io.IOException;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.coopersystem.entity.Investimento;
import br.com.coopersystem.service.InvestimentoService;


/**
 * InvestimentoService - 05/04/2021 Servlet responsável por listar os investimentos
 * 
 * @version 2.0
 * @author Marcos Vasconcelos
 */


@WebServlet(urlPatterns = { "/investimentoList" })
public class InvestimentoListServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Inject 
	private InvestimentoService investimentoService;
	
	
	public InvestimentoListServlet() {
		super();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Investimento> investimentos =  investimentoService.listarTodosServicos(300);
		request.setAttribute("investimentos", investimentos);
		
		RequestDispatcher dispatcher = request.getServletContext().getRequestDispatcher("/views/home.jsp");
		dispatcher.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
