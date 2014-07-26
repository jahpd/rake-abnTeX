# -*- coding: utf-8 -*-
require './abnTeX'
require 'safe_yaml'
require 'rake'

include ABNT::TeX

# Interacao no prompt de comando
def answer(msg)
  puts Time.now
  puts msg
  STDIN.gets.chomp
end

def log(msg)
  puts "#{Time.now}---> #{msg}"
end

# cria string cabecalho em LaTeX com padrao ABNT
def latex_cabecalho(yaml)
  puts yaml
  string = header(yaml["template"])
  string << packages_basic()
  string << changes(yaml["versao"], Time.now)
  string << titulo(yaml["titulo"])
  string << autor(yaml["autor"])
  string << instituicao(yaml["instituicao"])
  string << tipotrabalho(yaml["tipotrabalho"])
  string << orientador(yaml["orientador"])
  string << coorientador(yaml["coorientador"])
  string << data_atual()
  string << metadatas(yaml["palavraschave"])  
end

def latex_document(yaml)
  string = begin_document
  r = SafeYAML.load_file("src/Resumo.yml")
  if r["Resumo"]["template"]
    string << abstract("\\blindtext")
  else
    string << abstract(r["resumo"])
  end
    
  yaml["secoes"].each{|e|
    if File.exists? "./src/#{e}.yml"
      y = SafeYAML.load_file("./src/#{e}.yml")
      string << section("#{e}", y[e])
    end
  }
  string << bibliografia(yaml["bibliografia"])
  string << end_document
end

desc "leia o README"
task "readme" do
  sh "cat README.md"
end

desc "inicializa projetos LaTeX em formato ABNT"
task "cria:fontes:inicializa", :srcs do |t, args|
  args[:srcs].each{|e|
    unless File.exists? "./#{e}"
      log "creating ./#{e}"
      sh "mkdir ./#{e}"
    end
  }
end

desc "cria pasta destino para as fontes yml"
task "cria:fontes:backup" do
  ["src"].each{|e|
    unless File.exists "./backup/#{e}"
      log "Creating backup dirs"
      sh "mkdir ./backup/#{e}"
    end
    log "Creating Backup"
    sh "cp -r ./#{e} ./backup/#{e}"
  }
end

desc "cria arquivos .yml padrao para gerar o artigo (dev)"
task "cria:fontes:cabecalho:padrao", [:out, :template] do |t, args|
  File.open "src/#{args[:out]}.yml", "w" do |f|
    f.write """---
template: #{args[:template]}
versao: \"0.0.1\"
titulo: \"Artigo gerado #{args[:out]} com rake-\\\\abnTeX}\"
autor: 
  nome: \"Autor\"
  email: \"autor@mail.com\"
  nota: \"Alguma nota sobre o autor e a pesquisa\"
instituicao:
  nome: Universidade Publica
  abreviacao: UP
  faculdade:
    nome: Faculdade Publica
    abreviacao: FP
  programa: Programa de Estudos
orientador:
  aparece: Orientador
  nome: Prof. Dr. Orientador
coorientador:
  aparece: Co-Orientador
  nome: Prof. Dr. Co-Orientador
tipotrabalho: Trabalho academico
palavraschave: [palavra, chave]
secoes: [Introducao, Exemplos, Conclusao]
bibliografia: #{args[:out]}"""
    log "src/#{args[:out]}.yml criado"
    log "Edite este arquivo e execute o comando rake carrega:fontes:secoes"
    log "Pule esta estapa se nao necessitar editar"
  end
end

desc "cria arquivos .yml para gerar o artigo"

desc "Carrega arquivos das secoes do artigo"
task "cria:fontes:secoes:arquivos", :src do |t, args|  
  yaml = SafeYAML.load_file("src/#{args[:src]}.yml")
  log "Loading src/#{args[:src]}.yml"
  yaml["secoes"].each{|e|
    log "Loading #{e} Yaml file..."
    File.open "src/#{e.to_s}.yml", "w" do |f|
      f.write """---
#{e}: \"Escreva aqui algo sobre #{e} \\\\cite{exemplo_artigo_2014}; voc\\\\^e pode usar comandos \\\\LaTeX e \\\\abnTeX \\\\cite{abntex_tutorial_2014}} com a dupla barra \\\\Blindtext \""""
      log "src/#{e}.yml criado"
    end
  }
  log "Depois de editado as secoes, evite carregar este comando!"
end

desc "Carrega arquivo para o resumo do trabalho"
task "cria:fontes:secoes:resumo" do
  File.open "src/Resumo.yml", "w" do |f|
     f.write """---
Resumo:
  template: loremipsum
  palavras: 500"""
       log "src/Resumo.yml created"
  end
end

desc "cria arquivos .yml a partir das secoes indicadas no yml principal"
task "cria:fontes:secoes", :src do |t, args|
   Rake::Task["cria:fontes:secoes:resumo"].invoke()
   Rake::Task["cria:fontes:secoes:arquivos"].invoke(args[:src])
end

desc "Carrega os arquivos .yml em src e cria um arquivo latex"
task "cria:fontes:latex:arquivo", :src do |t, args|
  yaml = SafeYAML.load_file("src/#{args[:src]}.yml")
  string = latex_cabecalho yaml
  string << latex_document(yaml)
  File.open "#{args[:src]}.tex", "w" do |f|
    f.write string
    log "#{args[:src]} criado"
    log "Sugiro Criar um arquivo #{args[:src]}.bib com o Zotero, e inserir na pasta ./ e executar o comando rake cria:pdf[#{args[:src]}]" 
  end
end

desc "Carrega as informacoes contidas em src/ e compila um arquivo .tex em latex/"
task "cria:fontes:latex", :src do |t, args|
  if File.exists? "latex/#{args[:src]}.tex"
    if answer("#{args[:src]}.tex ja existe; vc deseja refazer?") == "s"
      Rake::Task["cria:fontes:latex:arquivo"].invoke(args[:src])
    end
  else
    Rake::Task["cria:fontes:latex:arquivo"].invoke(args[:src])
  end
end

desc 'constroi um arquivo template a partir de diversas informacoes'
task "cria:fontes:artigo", :arquivo do |t, args|
  Rake::Task["cria:fontes:inicializa"].invoke([:src, :backup])
  Rake::Task["cria:fontes:cabecalho:padrao"].invoke(args[:arquivo], "article")
  Rake::Task["cria:fontes:secoes"].invoke(args[:arquivo])
  Rake::Task["cria:fontes:latex"].invoke(args[:arquivo])
  sh "cat #{args[:arquivo]}.tex"
end

desc "Cria arquivo de bibliografia"
task "cria:pdf:arquivo:bib", :src do |t, args| 
  log "Voce precisa criar um arquivo .bib antes"
  a = answer "Voce pode criar: (1) uma bibliografia a partir do zotero ou (2) criar um padrao agora; o que voce quer?"
  if a == "1"
    log "Veja esse link: https://www."
  elsif a == "2"
    File.open "#{args[:src]}.bib", "w" do |f|
      f.write """@BOOK{abntex_tutorial_2014,
  title={A classe abntex2:Documentos técnicos e científicos brasileiros compatíveis com as normas ABNT}, %% Titulo do Livro
  author={Araujo, Lucas Cesar},  %% Segundo nome seguido do primeiro
  year={2014},                                                                         %% Ano
  name = {Lucas Cesar Araujo}
  editor={Equipe \\abnTeX \\url{http:\/\/abntex2.googlecode.com\/}},               %% Editora
  place={?},                                                                           %% Cidade, estado Pais
  pages={37}                                                                           %% Paginas
}
"""
      log "#{args[:src]}.bib criado"
    end
  else
    log "Digite 1 ou 2"
    Rake::Task["cria:pdf:arquivo:bib"].invoke(args[:arquivo])
  end
end

desc "Cria arquivo pdf a partir das fontes latex"
task "cria:pdf", :arquivo do |t, args|
  if File.exists? "latex/#{args[:arquivo]}.bib"
    sh "pdflatex latex/#{args[:arquivo]}.tex --output-dir=./latex/"
  else
    Rake::Task["cria:pdf:arquivo:bib"].invoke(args[:arquivo])
  end  
end
