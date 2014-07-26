# -*- coding: utf-8 -*-
module ABNT

  module TeX

    def header(template="article", fontSize="12pt", paper="a4paper", lang="brazil")
      """%% Template gerado com ruby-abnTeX v0.0.1
\\documentclass\[#{fontSize}, #{template}, #{paper}, #{lang}\]\{abntex2\}"""
    end

    def packages_basic
      """\\usepackage[T1]{fontenc}		      % seleção de códigos de fonte.
\\usepackage[utf8]{inputenc}		      % determina a codificação utiizada (conversão automática dos acentos)
\\usepackage[brazil]{babel}	              % idiomas
\\usepackage{hyperref}  			      % controla a formação do índice
\\usepackage{parskip}
\\usepackage[alf]{abntex2cite}                 % Citações padrão ABNT
\\usepackage[brazilian,hyperpageref]{backref}  % indique quantas vezes e em quais páginas a citação ocorreu)
\\usepackage{draftcopy}                        % Remove this after generate ultimate version of document
\\usepackage{blindtext}                        % Remove this after generate with rake

"""
    end

    def changes(version, time)
      "\\changes\{Vers\\~{a}o inicial }{dia: #{time} }{v#{version}}\n"
    end

    def titulo(titulo, thanks="\\imprimirtipotrabalho desenvolvido com \\LaTeX; formatado com \\abnTeX")
      "\\titulo{#{titulo} #{thanks(thanks)}}\n"
    end

    def thanks(msg)
      "\\thanks{#{msg}}"
    end

    def url(url)
      "\\url{#{url}}"
    end

    def autor(opt)
      nome = opt["nome"]
      u = opt["email"]
      t = opt["nota"]
      """\\autor{#{nome} #{url(u)} #{thanks(t)}}\n"""
    end

    def instituicao(opt)
      nome = opt["nome"]
      abrev = opt["abreviacao"]
      fn = opt["faculdade"]["nome"]
      fa = opt["faculdade"]["abreviacao"]
      p = opt["programa"]
      """\\instituicao{#{nome} -- #{abrev}
  \\par 
  #{fn} -- #{fa}
  \\par
  #{p}
}\n"""
    end

    def tipotrabalho(msg)
      "\\tipotrabalho{#{msg}}\n"
    end

    def orientador(opt)
      """\\orientador[#{opt["aparece"]}]{#{opt["nome"]}}\n"""
    end

    def coorientador(opt)
      """\\coorientador[#{opt["aparece"]}]{#{opt["nome"]}}\n"""
    end
   
    def data_atual
      "\\data{\\today}"
    end

    def metadatas(opt)
      s = ""
      opt.each{|e|
        s << "{#{e}}"
      }
      """\\makeatletter
\\hypersetup{
  pdftitle={\\@title},
  pdfauthor={\\@author},
  pdfsubject={\\@imprimirpreambulo},
  pdfkeywords=#{s},
  pdfcreator={\\LaTeX with \\abnTeX2},
  colorlinks=true,
  linkcolor=blue,
  citecolor=blue,
  urlcolor=blue
}
\\makeatother
\n"""
    end

    
    def begin_document
      """\\begin{document}
\\maketitle

\\imprimirinstituicao

\\imprimirorientadorRotulo \\imprimirorientador

\\imprimircoorientadorRotulo \\imprimircoorientador
\n"""
    end

    def abstract(text)
      """\\begin{abstract}
  #{text}
\\end{abstract}
\n"""
    end

    def section(title, text)
      """\\section{#{title}}
  #{text}
  \\Blindtext  %% Remova isso!!!!
\n"""
    end

    def list(type, list)
      s = "\\begin{#{type}}\n"
      list.each{|e| s << "  \\item #{e}\n"}
      s << "\\end{#{type}}"
    end

    def quote(text)
      "\\begin{quote}\n  #{text}\n\\end{quote}\n"
    end

    def bibliografia(src)
      "\\bibliography{#{src}}\n"
    end

    def end_document
      "\\end{document}\n"
    end

  end

end
