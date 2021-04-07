package br.com.coopersystem.entity;

/**
 * InvestimentoService - 05/04/2021 Modelagem dos dados da Acao
 * 
 * @version 1.0
 * @author Marcos Vasconcelos
 */

public class Acao {

	private Integer id;
	private String nome;
	private Double percentual;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public Double getPercentual() {
		return percentual;
	}
	public void setPercentual(Double percentual) {
		this.percentual = percentual;
	}
	
}
