task gtask  {
  String fin

  command {
    gsutil cp gs://cromwell-bucket/tiny.R /cromwell_root/tiny.R
    gsutil cp gs://cromwell-bucket/${fin} /cromwell_root/${fin}
    Rscript /cromwell_root/tiny.R /cromwell_root/${fin}
  }

  runtime  {
    docker: "spollack/gcloud-r"
  }

  output  {
    File outputFile = stdout()
  }

}

task collect  {
  Array[File] results

  command  {
    cat ${sep=" " results}
  }

  runtime  {
    docker: "spollack/gcloud-r"
  }

  output  {
    File resFile = stdout()
  }

}

task finalize  {
  String fin

  command {
    gsutil cp gs://cromwell-bucket/tiny.R /cromwell_root/tiny.R
    gsutil cp ${fin} /cromwell_root/tiny.final.in
    Rscript /cromwell_root/tiny.R /cromwell_root/tiny.final.in
  }

  runtime  {
    docker: "spollack/gcloud-r"
  }

  output  {
    File outputFile = stdout()
  }

}

workflow wf  {

  File inputFiles
  Array[Array[String]] infiles = read_tsv(inputFiles)

  scatter(files in infiles)  {
    call gtask {input: fin=files[0]}
  }

  call collect{input: results=gtask.outputFile}
  call finalize{input: fin=collect.resFile}

}

