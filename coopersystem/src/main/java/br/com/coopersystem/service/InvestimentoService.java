package br.com.coopersystem.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Named;

import org.json.JSONArray;
import org.json.JSONObject;

import br.com.coopersystem.entity.Acao;
import br.com.coopersystem.entity.Investimento;

@Named
public class InvestimentoService {

	/**
	 * InvestimentoService - 05/04/2021 Classe responsável por realizar o CRUD dos
	 * dados de Investimento.
	 * 
	 * @version 1.0
	 * @author Marcos Vasconcelos
	 */

	public static String urlServico = "http://www.mocky.io/";

	/**
	 * SRV /v2/5e76797e2f0000f057986099
	 */

	public List<Investimento> listarTodosServicos(int timeout) {
		List<Investimento> investimentos;

		HttpURLConnection connection = null;
		try {
			URL url = new URL(urlServico + "v2/5e76797e2f0000f057986099");
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setRequestProperty("Content-length", "0");
			connection.setConnectTimeout(timeout);
			connection.setReadTimeout(timeout);
			connection.connect();

			int respondeCode = connection.getResponseCode();

			switch (respondeCode) {
			case 200:
			case 201:
				BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
				StringBuilder sb = new StringBuilder();
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line + "\n");
				}
				br.close();

				JSONObject retornoDadosServico = new JSONObject(sb.toString());
				if (retornoDadosServico != null && retornoDadosServico.has("response")) {
					investimentos = new ArrayList<Investimento>();

					JSONArray investimentosRetornoServico = retornoDadosServico.getJSONObject("response")
							.getJSONObject("data").getJSONArray("listaInvestimentos");
					for (int i = 0; i < investimentosRetornoServico.length(); i++) {
						Investimento investimento = new Investimento();
						investimento.setNome(investimentosRetornoServico.getJSONObject(i).getString("nome"));
						investimento.setObjetivo(investimentosRetornoServico.getJSONObject(i).getString("objetivo"));
						investimento.setSaldoTotalDisponivel(
								investimentosRetornoServico.getJSONObject(i).getDouble("saldoTotalDisponivel"));

						if (investimentosRetornoServico.getJSONObject(i).getString("indicadorCarencia").equals("S")) {
							investimento.setIndicadorCarencia(true);
						} else {
							investimento.setIndicadorCarencia(false);
						}
						List<Acao> acoesInvestimento = new ArrayList<Acao>();

						JSONArray acoesArray = investimentosRetornoServico.getJSONObject(i).getJSONArray("acoes");

						for (int ar = 0; ar < acoesArray.length(); ar++) {
							Acao acaoInvestimento = new Acao();
							acaoInvestimento.setId(acoesArray.getJSONObject(ar).getInt("id"));
							acaoInvestimento.setNome(acoesArray.getJSONObject(ar).getString("nome"));
							acaoInvestimento.setPercentual(acoesArray.getJSONObject(ar).getDouble("percentual"));
							acoesInvestimento.add(acaoInvestimento);
						}
						investimento.setAcoes(acoesInvestimento);
						investimentos.add(investimento);

					}
					return investimentos;
				}

				break;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.disconnect();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}

	public Investimento parseInvestimentoJson(JSONObject jsonInvestimento) {
		try {

			Investimento investimento = new Investimento();
			investimento.setNome(jsonInvestimento.getString("nome"));
			investimento.setObjetivo(jsonInvestimento.getString("objetivo"));
			investimento.setSaldoTotalDisponivel(jsonInvestimento.getDouble("saldoTotalDisponivel"));
			investimento.setIndicadorCarencia(jsonInvestimento.getBoolean("indicadorCarencia"));

			List<Acao> acoesInvestimento = new ArrayList<Acao>();

			if(jsonInvestimento.has("acoes")) {
				JSONArray acoesArray = jsonInvestimento.getJSONArray("acoes");

				for (int ar = 0; ar < acoesArray.length(); ar++) {
					Acao acaoInvestimento = new Acao();
					acaoInvestimento.setId(acoesArray.getJSONObject(ar).getInt("id"));
					acaoInvestimento.setNome(acoesArray.getJSONObject(ar).getString("nome"));
					acaoInvestimento.setPercentual(acoesArray.getJSONObject(ar).getDouble("percentual"));
					acoesInvestimento.add(acaoInvestimento);
				}
				investimento.setAcoes(acoesInvestimento);
			}
			
			return investimento;

		} catch (Exception e) {
			e.printStackTrace();
		} 
		return null;
	}
}
