package br.com.coopersystem.entity;

import java.util.List;

import org.apache.tomcat.util.codec.binary.Base64;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * InvestimentoService - 05/04/2021 Modelagem de dados do Investimento
 * 
 * @version 1.0
 * @author Marcos Vasconcelos
 */

public class Investimento {

	private String nome;
	private String objetivo;
	private Double saldoTotalDisponivel;
	private Boolean indicadorCarencia;
	private List<Acao> acoes;
	
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getObjetivo() {
		return objetivo;
	}
	public void setObjetivo(String objetivo) {
		this.objetivo = objetivo;
	}
	public Double getSaldoTotalDisponivel() {
		return saldoTotalDisponivel;
	}
	public void setSaldoTotalDisponivel(Double saldoTotalDisponivel) {
		this.saldoTotalDisponivel = saldoTotalDisponivel;
	}
	public Boolean getIndicadorCarencia() {
		return indicadorCarencia;
	}
	public void setIndicadorCarencia(Boolean indicadorCarencia) {
		this.indicadorCarencia = indicadorCarencia;
	}
	public List<Acao> getAcoes() {
		return acoes;
	}
	public void setAcoes(List<Acao> acoes) {
		this.acoes = acoes;
	}
	
	public String getInvestimentoJson() {
		JSONObject dadosInvestimento = new JSONObject();
		dadosInvestimento.put("nome", this.nome);
		dadosInvestimento.put("objetivo", this.objetivo);
		dadosInvestimento.put("saldoTotalDisponivel", this.saldoTotalDisponivel);
		dadosInvestimento.put("indicadorCarencia", this.indicadorCarencia);
		
		JSONArray acoesArray = new JSONArray();
		
		if(this.acoes != null && !this.acoes.isEmpty()) {
			for(Acao acaoObject : this.acoes) {
				JSONObject acaoJson = new JSONObject();
				acaoJson.put("id", acaoObject.getId());
				acaoJson.put("nome", acaoObject.getNome());
				acaoJson.put("percentual", acaoObject.getPercentual());
				acoesArray.put(acaoJson);
			}
		}
		dadosInvestimento.put("acoes", acoesArray);
		
		return  Base64.encodeBase64String(dadosInvestimento.toString().getBytes());
			
	}

	
}
