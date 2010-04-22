$(document).ready(function(){
    $("textarea").focus()
    $("input.copynpaste").focus()
    
    $(".blowitup").keyup(function(k){
        if (k.keyCode == 13) {
            $("textarea").val($("textarea").val().replace("\n",""))
        }
    })
})
