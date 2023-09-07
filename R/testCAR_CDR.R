#' test CAR and CDR macros in C
#' @param a first parameter
#' @param b second parameter
#' @param c third parameter
#' @param d fourth parameter
#' @param e fifth parameter
#' @param ... the rest parameters
#' @export
#' @examples
#' \dontrun{
#' testCAR_CDR(1,2,3,4,5)
#'
#' testCAR_CDR(1,2,3,4,5,6,7,8)
#' }
#'
testCAR_CDR_ext = function(a, b){
  .External("C_testCAR_CDR", a, b)
  # .Call("C_testCAR_CDR_Call", a, b)

  # .External("showArgs", a, b)
}

#' @export

testCAR_CDR_call = function(a, b){
  # .External("C_testCAR_CDR", a, b)
  .Call("C_testCAR_CDR_Call", a, b)

  # .External("showArgs", a, b)
}
