$(document).ready(function() {
    $("#export_csv").click(function() {
        var q = "";
        if($("#user").val())
            q = "?user="+$("#user").val();
        if($("#date_ini").val() && $("#date_fin").val())
            var dates = "date_ini="+$("#date_ini").val()+"&date_fin="+$("#date_fin").val();
            if(q)
                q += "&"+dates;
            else
                q = "?"+dates;
        location.href = "/"+$("#locale").val()+"/admin/records/export.csv"+q
    })
})
