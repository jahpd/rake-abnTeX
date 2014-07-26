---------------------------------
 Bem vindo ao rake-abnTeX v 0.0.1
---------------------------------

* Nos usaremos essas informacoes para construir o documento dentro de
  padroes ABNT
* Nos nao gravaremos nenhuma informacao sensivel a sua seguranca
  pessoal
* https://www.github.com/jahpd/ruby-abnTeX
* Nos somos:
  * jahpd

# Instalando

Por enquanto essas intrucoes sao para MacOSX e Linux; estarei
trabalhando em formatos para Windows;todos comandos abaixo sao
utilizados no prompt de comando (terminal)

Assumindo que voce nao tem o Ruby,

    $ \curl -sSL https://get.rvm.io | bash -s stable

Depois de instalado, verifique se o gem Rake esta instalado:

    $ gem list
    $ rake --version

## Clonar o projeto

Assumindo que vc possui [git](http://www.git-scm.com/):

    $ git clone https://www.github.com/jahpd/rake-abnTeX.git
    $ cd rake-abnTeX

## Mostra as tarefas:

    $ rake --tasks

## Crie arquivos .yml a partir de um template:

Supondo que voce quer criar um artigo **teste.pdf**:

    $ rake cria:fontes:artigo[teste]

Edite as configuracoes de seu novo arquivo yml; ele serve de base para
gerar artigos novos:

    ---
    template: article
    versao: "0.0.1"
    titulo: teste
    autor: 
      nome: Autor
      email: autor@mail.com
      nota: "Alguma nota sobre o autor e a pesquisa"
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
    bibliografia: teste

(Entao cuidado ao usar, sempre faca backups!)

## Escreva os capitulos

Alguns arquivos foram criados de acordo com o nome das secoes; edite o
conteudo do artigo a partir deles, por exemplo:

Resumo.yml:

    ---
    Resumo: "\\blindtext"

O comando acima gera uma string `"\blindtext"` no LaTeX gerado; isso
gera uma sequencia de strings em latim; so serve para dar corpo ao
texto. De fato, nos arquivos `.yml` para compilar comandos LaTeX eh
necessario inserir dupla barra (TODO isso eh incoveniente)

Abaixo mostramos como inserir mais comandos, como citacao e textos
padrao maiores;

Introducao.yml:

    ---
    Introducao: "Escreva aqui algo sobre Introducao
    \\cite{exemplo_artigo_2014}; voc\\^e pode usar comandos  \\LaTeX e
    \\abnTeX \\cite{abntex_tutorial_2014}} com a dupla barra \\Blindtext "

### Compile os arquivos .yml em .tex

    $ rake cria:fontes:latex[teste]

## Gere o LaTex em formato ABNT ja configurado

    $ rake cria:pdf[teste]"

Se der algo errado, o que pode dar na mesma:

    $ cd latex
    $ pdflatex teste.tex
    $ bibtex teste
    $ pdflatex teste.tex
    $ pdflatex teste.tex

Verifique o arquivo .pdf para ver se esta tudo OK

# Pacotes utilizados e opcoes geradas

    \usepackage[utf8]{inputenc}		              % determina a codificação utiizada (conversão automática dos acentos)
    \usepackage[brazil]{babel}	                  % idiomas
    \usepackage{hyperref}  			              % controla a formação do índice
    \usepackage{parskip}
    \usepackage[alf]{abntex2cite}                 % Citações padrão ABNT
    \usepackage[brazilian,hyperpageref]{backref}  % indique quantas vezes e em quais páginas a citação ocorreu)
    \usepackage{draftcopy}                        % Remove this after generate ultimate version of document
    \usepackage{blindtext}                        % Remove this after
    generate with rake


  

