#' testPointerAddress
#' @param data data
#' @export
testPointerAddress = function(data){
  .C("testPointerAddress", res = as.double(data))$res
}
