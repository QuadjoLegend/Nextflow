#!/usr/bin/env nextflow

/*
 * Use echo to print 'Hello World!' to standard out
 * Define a default parameter greeting to be used as input
 */

params.greeting = "greetings.csv"

process sayHello {
// use publishDir to direct output outside the work directory
    publishDir 'results', mode: 'copy'

// Add input definition block
    input:
        val greeting

    output:
        path "$greeting-output.txt"

// edit the script block to use the greeting variable
    script:
    """
    echo '$greeting' > '$greeting-output.txt'
    """
}

// Add a process to convert output to upper case
process convertToUpper {

    publishDir 'results', mode: 'copy'

    input:
    path input_file

    output:
    path "UPPER-${input_file}"

    script:
    """
    cat $input_file | tr '[a-z]' '[A-Z]' > UPPER-${input_file}
    """

}

workflow {
// include channel definition
// use params to pass input from the command line
greeting_ch = Channel.fromPath(params.greeting)
                 .splitCsv()
                 .view{ "After splitCsv: $it" }
                 .flatten()
                 .view{ "After flatten: $it" }
    // channel as input to the process
    sayHello(greeting_ch)

    // convert greeting to upper case
    convertToUpper(sayHello.out)
}
