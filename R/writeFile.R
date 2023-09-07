#' writeFile
#' @param fileName fileName
#' @param num the numbers to be saved in the file
#' @examples
#' \dontrun{
#' writeFile("./tmp.txt", 1:10)
#' }
#' @export
writeFile = function(fileName, num){
  .C("C_writeFile", as.character(fileName), as.double(num), as.integer(length(num)))
  return(fileName)
}
