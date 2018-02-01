task gtask  {
  File rscript
  File fin

  command  {
    /local/bin/Rscript ${rscript} ${fin} 
  }

# runtime  {
#   docker: "rocker/r-base"
# }

  output  {
    File outputFile = stdout()
  }

}

task collect  {
  Array[File] results

  command  {
    cat ${sep=" " results}
  }

  output  {
    File resFile = stdout()
  }

}

workflow wf  {

  File inputFiles
  Array[Array[String]] infiles = read_tsv(inputFiles)

  scatter(files in infiles)  {
    call gtask {input: fin=files[0]}
  }

  call collect{input: results=gtask.outputFile}
  call gtask as gtask2{input: fin=collect.resFile}

}

